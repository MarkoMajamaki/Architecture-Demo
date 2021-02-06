provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      version = "=2.45.1"
    }
  }
}