resource "random_string" "acr_name" {
  length  = 5
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_container_registry" "this" {
  name                = "${var.name_prefix}${random_string.acr_name.result}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.acr_admin_enabled

  tags = var.tags
}
