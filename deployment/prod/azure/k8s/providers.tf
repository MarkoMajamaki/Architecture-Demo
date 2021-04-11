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
    resource_group_name   = "architecture_demo_backend"
    storage_account_name  = "account010"
    container_name        = "container"
    key                   = "k8s.tfstate"
  }
}
