provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      version = "=2.45.1"
    }
  }
  backend "azurerm" {
    resource_group_name   = "architecture_demo_tfstate_rg"
    storage_account_name  = "tfstate000"
    container_name        = "tfstate-container"
    key                   = "terraform.tfstate"
  }
}
