provider "azurerm" {
  features {}
}

# provider "kubernetes" {
#     host                   =  var.host
#     client_certificate     =  var.client_certificate
#     client_key             =  var.client_key
#     cluster_ca_certificate =  var.cluster_ca_certificate
# }

terraform {
  required_providers {
    azurerm = {
      version = "=2.45.1"
    }
  }
}