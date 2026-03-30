terraform {
  backend "azurerm" {
    resource_group_name  = "rg-opella-tfstate"
    storage_account_name = "stopellatfstatelubert"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
