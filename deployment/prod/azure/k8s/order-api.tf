resource "kubernetes_deployment" "order-api" {
  metadata {
    name = "order-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  
  depends_on = [ kubernetes_deployment.sqlserver, helm_release.rabbitmq, ]
  
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "order-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "order-api"
        }
      }

      spec {
        container {
          image = "architecturedemoacr.azurecr.io/order-api:v1"
          name  = "order-api"
          
          # SQL Server
          env_from {
            config_map_ref {
              name = kubernetes_config_map.sqlserver-config.metadata.0.name
            }
          }
          env {
            name = "Database__Name"
            value = "order-db"
          }
          env {
            name = "Database__Password"            
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

resource "kubernetes_service" "order-api" {
  metadata {
    name = "order-api"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  spec {
    selector = {
        app = "order-api"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}