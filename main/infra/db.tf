data "azurerm_client_config" "current" {}

resource "random_password" "db_admin_password" {
  length  = 64
  special = false
}


resource "azurerm_postgresql_flexible_server" "datacollector" {
  name                   = "datacollector-server"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "15"
  administrator_login    = "psqladmin"
  administrator_password = random_password.db_admin_password.result
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "2"

  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_postgresql_flexible_server_database" "datacollector" {
  name      = "datacollector"
  server_id = azurerm_postgresql_flexible_server.datacollector.id
  collation = "en_US.utf8"
  charset   = "utf8"
}


data "azurerm_public_ip" "aks_outbound" {
  name                = regex("([^/]+$)", tolist(azurerm_kubernetes_cluster.k8s.network_profile[0].load_balancer_profile[0].effective_outbound_ips)[0])[0]
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "datacollector_k8s" {
  name             = "allow-k8s"
  server_id        = azurerm_postgresql_flexible_server.datacollector.id
  start_ip_address = data.azurerm_public_ip.aks_outbound.ip_address
  end_ip_address   = data.azurerm_public_ip.aks_outbound.ip_address
}

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "datacollector_self" {
  name             = "allow-self"
  server_id        = azurerm_postgresql_flexible_server.datacollector.id
  start_ip_address = chomp(data.http.my_ip.response_body)
  end_ip_address   = chomp(data.http.my_ip.response_body)
}
