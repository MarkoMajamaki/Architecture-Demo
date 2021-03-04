provider "kubernetes" {
    config_path = var.kube_config
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  backend "azurerm" {
    resource_group_name   = "architecture_demo_tfstate_rg"
    storage_account_name  = "tfstate000"
    container_name        = "tfstate-container"
    key                   = "k8s.tfstate"
  }
}
