provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      version = "=2.52.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "architecture_demo_backend"
    storage_account_name  = "account010"
    container_name        = "container"
    key                   = "core.tfstate"
  }
}
