terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cnappuser6-tfstate"
    storage_account_name = "sttfcnappuser6"
    container_name       = "tfstate-dev"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
