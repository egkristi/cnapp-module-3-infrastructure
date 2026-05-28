terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cnapp-tfstate"
    storage_account_name = "sttfcnapp"
    container_name       = "tfstate-dev"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
