resource "azurerm_application_load_balancer" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_application_load_balancer_frontend" "this" {
  name                         = var.frontend_name
  application_load_balancer_id = azurerm_application_load_balancer.this.id

  depends_on = [
    time_sleep.wait_for_agfc
  ]
}


resource "azurerm_application_load_balancer_subnet_association" "this" {
  name                         = var.association_name
  application_load_balancer_id = azurerm_application_load_balancer.this.id
  subnet_id                    = var.association_subnet_id

  depends_on = [
    time_sleep.wait_for_agfc
  ]
}

resource "time_sleep" "wait_for_agfc" {
  depends_on = [
    azurerm_application_load_balancer.this
  ]

  create_duration = "90s"
}
