resource "helm_release" "rabbitmq" {
  name  = "rabbitmq"
  namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "rabbitmq"

  set {
    name = "replicaCount"
    value = 3
  }
  set {
    name = "auth.username"
    value = "guest"
  }
  set {
    name = "auth.password"
    value = "guest"
  }
  set {
    name ="auth.erlangCookie"
    value = "erlangcookie"
  }
  set {
    name = "extraPlugins"
    value = "rabbitmq_federation"
  }
}

# RabbitMQ configuration
resource "kubernetes_config_map" "rabbitmq" {
  metadata {
    name = "rabbitmq"
    namespace=kubernetes_namespace.architecture-demo.metadata.0.name
  }

  data = {
    RabbitMq__HostName = "rabbitmq.architecture-demo.svc.cluster.local"
    RabbitMq__Port = "5672"
    RabbitMq__UserName = "guest"
    RabbitMq__Password = "guest"
    RabbitMq__QueueName = "TestQueueName"
  }
}