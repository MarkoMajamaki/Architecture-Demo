provider "azuread" {
  version = "~>0.7"
}

resource "azurerm_resource_group" "rg" {
  name     = "architecture_demo_rg"
  location = var.location
}

data "azuread_service_principal" "aks_principal" {
  application_id = var.serviceprinciple_id
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = "ArchitectureDemoAcr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                  = "ArchitectureDemoAks"
  kubernetes_version    = var.kubernetes_version
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  dns_prefix            = "aks"  
  
  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_B2s"
    type = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
  }

  service_principal  {
    client_id = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = var.ssh_key
    }
  }

  network_profile {
      network_plugin = "kubenet"
      load_balancer_sku = "Standard"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }
}