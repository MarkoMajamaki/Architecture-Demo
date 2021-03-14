resource "kubernetes_deployment" "auth-api" {
  metadata {
    name = "auth-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  
  depends_on = [ kubernetes_deployment.sqlserver, ]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth-api"
        }
      }

      spec {
        container {
          image = "architecturedemoacr.azurecr.io/auth-api:v1"
          name  = "auth-api"
          
          # SQL Server
          env_from {
            config_map_ref {
              name = kubernetes_config_map.sqlserver-config.metadata.0.name
            }
          }
          env {
            name = "DatabaseName"
            value = "auth-db"
          }
          env {
            name = "DatabasePassword"   
            value_from {
              secret_key_ref {
                name = kubernetes_secret.sqlserver.metadata.0.name
                key = "password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "auth-api" {
  metadata {
    name = "auth-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  spec {
    selector = {
        app = "auth-api"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}