# Cluster module for AKS and ACR
module "cluster" {
  source                = "./cluster/"
  resource_group_name   = var.resource_group_name
  location              = var.location
  kubernetes_version    = var.kubernetes_version   
  system_node_count     = var.system_node_count
  cluster_name          = var.cluster_name
  acr_name              = var.acr_name
}

# Kubernetes deployment module 
# module "k8s" {
#   source                = "./k8s/"
#   host                  = "${module.cluster.host}"
# }