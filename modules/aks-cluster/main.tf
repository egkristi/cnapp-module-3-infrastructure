resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  default_node_pool {
    name                        = var.default_node_pool_name
    node_count                  = var.node_count
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.subnet_id
    temporary_name_for_rotation = var.temporary_node_pool_name

    upgrade_settings {
      max_surge                     = var.default_node_pool_max_surge
      drain_timeout_in_minutes      = var.default_node_pool_drain_timeout_in_minutes
      node_soak_duration_in_minutes = var.default_node_pool_node_soak_duration_in_minutes
    }

  }
  lifecycle {
    ignore_changes = [
      microsoft_defender
    ]
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}
