resource "local_file" "people_yamls" {
  for_each = toset(concat(local.instructors, local.students, local.team_members))
  content  = <<-EOT
    apiVersion: v1
    kind: Namespace
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}
      labels:
        istio-injection: enabled
    ---
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-full-access
      namespace: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}
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
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-user-access
      namespace: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-full-access
    subjects:
    - kind: User
      namespace: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}
      name: ${lookup(local.email_to_id, each.key)}
    ---
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-prometheus
      namespace: prometheus
    rules:
    - apiGroups: [""]
      resources: ["pods/portforward"]
      verbs: ["*"]
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-prometheus
      namespace: prometheus
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-prometheus
    subjects:
    - kind: User
      namespace: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-prometheus
      name: ${lookup(local.email_to_id, each.key)}
    ---
    kind: Certificate
    apiVersion: cert-manager.io/v1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-cert
      namespace: istio-ingress
    spec:
      secretName: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-cert
      commonName: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}.mids255.com
      dnsNames:
      - ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}.mids255.com
      issuerRef:
        name: letsencrypt-prod
        kind: ClusterIssuer
    ---
    kind: Gateway
    apiVersion: networking.istio.io/v1beta1
    metadata:
      name: ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-gateway
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
          credentialName: istio-ingress/${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}-cert
        hosts:
        - ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}.mids255.com
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
        - ${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}.mids255.com
        tls:
          httpsRedirect: true
    EOT
  filename = "yamls/people/${lower(replace(replace(split("@", each.key)[0], ".", ""), "_", "-"))}.yaml"
}
