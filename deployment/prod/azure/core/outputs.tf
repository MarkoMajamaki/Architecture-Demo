output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_kube_config" {
    value = azurerm_kubernetes_cluster.aks.kube_config_raw
}