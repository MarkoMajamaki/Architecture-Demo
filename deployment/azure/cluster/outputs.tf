output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_kube_config" {
    value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "aks_cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "aks_client_certificate" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "aks_client_key" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "aks_host" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}