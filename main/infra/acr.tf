resource "azurerm_container_registry" "acr" {
  name                = "w255mids"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_container_registry" "acr-sensitive" {
  name                = "w255midssensitive"
  resource_group_name = azurerm_resource_group.rg-sensitive.name
  location            = azurerm_resource_group.rg-sensitive.location
  sku                 = "Premium"
  admin_enabled       = false
}
