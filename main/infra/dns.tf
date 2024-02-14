resource "azurerm_dns_zone" "domain" {
  name                = "mids255.com"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create service principal for DNS updates in AKS
resource "azuread_application" "dns_sp" {
  display_name = "DNSManagerSP"
}

resource "azuread_service_principal" "dns_sp" {
  application_id = azuread_application.dns_sp.application_id
}

resource "azuread_service_principal_password" "dns_sp" {
  service_principal_id = azuread_service_principal.dns_sp.id
}

resource "azurerm_role_assignment" "dns_sp" {
  for_each             = toset(["DNS Zone Contributor", "Reader"])
  scope                = azurerm_dns_zone.domain.id
  role_definition_name = each.key
  principal_id         = azuread_service_principal.dns_sp.id
}
