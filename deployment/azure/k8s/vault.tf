resource "helm_release" "consul" {
  name  = "consul"
  namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  repository = "https://helm.releases.hashicorp.com/"
  chart = "consul"
  
  set {
    name = "global.datacenter"
    value = "vault-kubernetes-tutorial"
  }

  set {
    name = "client.enabled"
    value = "true"
  }

  set {
    name = "server.replicas"
    value = "1"
  }

  set {
    name = "server.bootstrapExpect"
    value = "1"
  }

   set {
    name = "server.disruptionBudget.maxUnavailable"
    value = "0"
  }
}

resource "helm_release" "vault" {
  name  = "vault"
  namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  repository = "https://helm.releases.hashicorp.com/"
  chart = "vault"

  depends_on = [
    helm_release.consul,
  ]
  
  set {
    name = "server.affinity"
    value = ""
  }

  set {
    name = "server.ha.enabled"
    value = "true"
  }

  set {
    name = "ui.enabled"
    value = "true"
  }

  set {
    name = "ui.serviceType"
    value = "LoadBalancer"
  }
}

resource "kubernetes_service_account" "vault_service_account" {
  metadata {
    name = "vault-service-account"
    namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  }
}