resource "kubernetes_deployment" "customer-api" {
  metadata {
    name = "customer-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  
  depends_on = [ kubernetes_deployment.sqlserver, ]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "customer-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "customer-api"
        }
      }

      spec {
        container {
          image = "architecturedemoacr.azurecr.io/customer-api:v1"
          name  = "customer-api"
          
          # SQL Server
          env_from {
            config_map_ref {
              name = kubernetes_config_map.sqlserver-config.metadata.0.name
            }
          }
          env {
            name = "DatabaseName"
            value = "customer-db"
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

          # RabbitMQ          
          env_from {
            config_map_ref {
              name = kubernetes_config_map.rabbitmq.metadata.0.name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "customer-api" {
  metadata {
    name = "customer-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  spec {
    selector = {
        app = "customer-api"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}