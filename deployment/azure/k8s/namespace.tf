resource "kubernetes_namespace" "architecture-demo" {
  metadata {
    annotations = {
      name = "architecture-demo"
    }
    name = "architecture-demo"
  }
}