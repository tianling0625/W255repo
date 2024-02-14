resource "local_file" "team_yamls" {
  for_each = toset(local.team_names)
  content  = <<-EOT
    apiVersion: v1
    kind: Namespace
    metadata:
      name: ${each.key}
      labels:
        istio-injection: enabled
    ---
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${each.key}-full-access
      namespace: ${each.key}
    rules:
    - apiGroups: ["", "extensions", "apps", "networking.istio.io", "autoscaling"]
      resources: ["*"]
      verbs: ["*"]
    - apiGroups: ["batch"]
      resources:
      - jobs
      - cronjobs
      verbs: ["*"]
    ---
    kind: Certificate
    apiVersion: cert-manager.io/v1
    metadata:
      name: ${each.key}-cert
      namespace: istio-ingress
    spec:
      secretName: ${each.key}-cert
      commonName: ${each.key}.mids255.com
      dnsNames:
      - ${each.key}.mids255.com
      issuerRef:
        name: letsencrypt-prod
        kind: ClusterIssuer
    ---
    kind: Gateway
    apiVersion: networking.istio.io/v1beta1
    metadata:
      name: ${each.key}-gateway
      namespace: istio-ingress
    spec:
      selector:
        istio: ingress
      servers:
      - port:
          number: 443
          name: https
          protocol: HTTPS
        tls:
          mode: SIMPLE
          credentialName: istio-ingress/${each.key}-cert
        hosts:
        - ${each.key}.mids255.com
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - ${each.key}.mids255.com
        tls:
          httpsRedirect: true
    EOT
  filename = "yamls/teams/${each.key}.yaml"
}


resource "local_file" "team_rolebinding_yamls" {
  for_each = local.team_role_list
  content  = <<-EOT
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${split("--", each.key)[0]}--${lower(replace(replace(split("@", split("--", each.key)[1])[0], ".", ""), "_", "-"))}-user-access
      namespace: ${split("--", each.key)[0]}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: ${split("--", each.key)[0]}-full-access
    subjects:
    - kind: User
      namespace: ${split("--", each.key)[0]}
      name: ${lookup(local.email_to_id, split("--", each.key)[1])}
  EOT
  filename = "yamls/teams/people/${split("--", each.key)[0]}--${lower(replace(replace(split("@", split("--", each.key)[1])[0], ".", ""), "_", "-"))}.yaml"
}
