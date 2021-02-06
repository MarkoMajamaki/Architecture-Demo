# Ingress tls secret
resource "kubernetes_secret" "ingress" {
  metadata {
    name = "ingress-tls"
    namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  }
  data = {
    "tls.crt" = file("${path.module}/../ingress-tls.crt")
    "tls.key" = file("${path.module}/../ingress-tls.key")
  }

  type = "kubernetes.io/tls"
}  

resource "helm_release" "ingress-controller" {
  name = "ingress-controller"
  namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"

  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name = "replicaCount"
    value = 1
  }
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
    namespace = kubernetes_namespace.architecture-demo.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    }
  }

  depends_on = [ helm_release.ingress-controller, ]
  
  spec {
    tls {
      secret_name = kubernetes_secret.ingress.metadata.0.name
    }

    rule {
      http {
        path {
          path = "/(.*)"
          backend {
            service_name = kubernetes_service.frontend.metadata.0.name
            service_port = 80
          }
        }
        path {
          path = "/customer-api/(.*)"
          backend {
            service_name = kubernetes_service.customer-api.metadata.0.name
            service_port = 80
          }
        }
        path {
          path = "/order-api/(.*)"
          backend {
            service_name = kubernetes_service.order-api.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}