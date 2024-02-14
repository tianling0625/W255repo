# resource "azurerm_key_vault" "datacollector" {
#   name                        = "datacollector-vault"
#   location                    = azurerm_resource_group.rg-sensitive.location
#   resource_group_name         = azurerm_resource_group.rg-sensitive.name
#   enabled_for_disk_encryption = true
#   enable_rbac_authorization   = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false

#   sku_name = "standard"
# }


# resource "azurerm_key_vault_secret" "database_url" {
#   name         = "database-url"
#   value        = "postgres://${azurerm_postgresql_flexible_server.datacollector.administrator_login}:${azurerm_postgresql_flexible_server.datacollector.administrator_password}@${azurerm_postgresql_flexible_server.datacollector.fqdn}:5432/${azurerm_postgresql_flexible_server_database.datacollector.name}?schema=public"
#   key_vault_id = azurerm_key_vault.datacollector.id
# }

# resource "azurerm_key_vault_secret" "google_client_id" {
#   name         = "google-client-id"
#   value        = var.google_client_id
#   key_vault_id = azurerm_key_vault.datacollector.id
# }

# resource "azurerm_key_vault_secret" "google_client_secret" {
#   name         = "google-client-secret"
#   value        = var.google_client_secret
#   key_vault_id = azurerm_key_vault.datacollector.id
# }

# resource "azurerm_key_vault_secret" "google_auth_callback_url_base" {
#   name         = "google-auth-callback-url-base"
#   value        = var.google_auth_callback_url_base
#   key_vault_id = azurerm_key_vault.datacollector.id
# }

# resource "azurerm_key_vault_secret" "session_secret" {
#   name         = "session-secret"
#   value        = var.session_secret
#   key_vault_id = azurerm_key_vault.datacollector.id
# }
