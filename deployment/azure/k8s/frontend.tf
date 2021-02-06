resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          image = "architecturedemoacr.azurecr.io/frontend:v1"
          name  = "frontend"                  
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  spec {
    selector = {
        app = "frontend"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}