resource "azurerm_application_load_balancer" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_application_load_balancer_frontend" "this" {
  name                         = var.frontend_name
  application_load_balancer_id = azurerm_application_load_balancer.this.id
}

resource "azurerm_application_load_balancer_subnet_association" "this" {
  name                         = var.association_name
  application_load_balancer_id = azurerm_application_load_balancer.this.id
  subnet_id                    = var.association_subnet_id
}
