resource "kubernetes_deployment" "sqlserver" {
  metadata {
    name = "sqlserver"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sqlserver"
      }
    }

    template {
      metadata {
        labels = {
          app = "sqlserver"
        }
      }

      spec {
        termination_grace_period_seconds = 30
        hostname = "mssqlinst"
        security_context {
          fs_group = 10001
        }
        container {
          image = "mcr.microsoft.com/mssql/server:2019-latest"
          name  = "sqlserver"
          port {
            container_port = 1433
          }

          env {
            name = "SA_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.sqlserver.metadata.0.name
                key = "password"
              }
            }
          }
          env {
            name = "ACCEPT_EULA"
            value = "Y"
          }
          env {
            name = "MSSQL_PID"
            value = "Developer"
          }

          volume_mount {
            mount_path = "/var/opt/mssql/data"
            name = "sqlserver-volume"
          }
        }
                  
        volume {
          name = "sqlserver-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sqlserver.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sqlserver" {
  metadata {
    name = "sqlserver"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  spec {
    selector = {
        app = "sqlserver"
    }
    port {
      port        = 1433
      target_port = 1433
    }
    
    type = "NodePort"
  }
}

# SQL Server volume claim to persist SQL server to Azure disk
resource "kubernetes_persistent_volume_claim" "sqlserver" {
  metadata {
    name = "sqlserver"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  wait_until_bound = false
  spec {
    storage_class_name = "default"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

# SQL Server config
resource "kubernetes_config_map" "sqlserver-config" {
  metadata {
    name = "sqlserver-config"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }

  data = {
    Database__Server = "sqlserver"
    Database__Port = "1433"
    Database__User = "sa"
  }
}

# SQL Server password
resource "kubernetes_secret" "sqlserver" {
  metadata {
    name = "sqlserver"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }
  
  data = {
    password = "mssQlp4ssword#"
  }
}