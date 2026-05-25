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

  default_node_pool {
    name           = var.default_node_pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}
