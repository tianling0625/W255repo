# output "client_key" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
# }

# output "cluster_ca_certificate" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
# }

# output "cluster_username" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
# }

# output "cluster_password" {
#   value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
# }

# output "kube_config" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
#   sensitive = true
# }

# output "invitation_links" {
#   value = { for user in azuread_invitation.invitations : user.user_email_address => user.redeem_url }
# }

# output "client_id" {
#   value = azuread_application.dns_sp.application_id
# }

# output "client_secret" {
#   value     = azuread_service_principal_password.dns_sp.value
#   sensitive = true
# }
