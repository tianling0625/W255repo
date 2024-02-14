locals {
  cluster_name = "w255-aks"
}
resource "azurerm_kubernetes_cluster" "k8s" {
  name                      = local.cluster_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  node_resource_group       = "aks_${local.cluster_name}_${azurerm_resource_group.rg.location}"
  dns_prefix                = "w255"
  automatic_channel_upgrade = "node-image"

  kubernetes_version = "1.27.3"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name                = "default"
    min_count           = 1
    max_count           = 12
    vm_size             = "standard_d16ls_v5"
    enable_auto_scaling = true
    vnet_subnet_id      = azurerm_subnet.aks_vm.id
    # os_disk_type        = "Ephemeral"
  }

  auto_scaler_profile {}

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  network_profile {
    load_balancer_sku   = "standard"
    network_plugin      = "azure"
    network_policy      = "azure"
    network_plugin_mode = "overlay"

    pod_cidr       = "172.16.0.0/16"
    service_cidr   = "10.3.0.0/16"
    dns_service_ip = cidrhost("10.3.0.0/16", 10)
  }

  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "acr_access-sensitive" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_access" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr-sensitive.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_access_push" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
