terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "5.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-paglabackend"
    storage_account_name = "paglabackend2"
    container_name       = "newcontainer"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "73c9b1d1-79bb-4bf7-8b46-db211fe52d6f"
}