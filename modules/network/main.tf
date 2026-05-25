resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

resource "azurerm_subnet" "agfc" {
  name                 = var.agfc_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.agfc_subnet_address_prefixes

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.ServiceNetworking/trafficControllers"
    }
  }
}
