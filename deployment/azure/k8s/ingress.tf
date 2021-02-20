# Ingress tls secret
resource "kubernetes_secret" "ingress" {
  metadata {
    name = "ingress-tls"
    namespace = kubernetes_namespace.architecture-demo.metadata.0.name
  }
  # Use Azure Key Vault in real project!
  data = {
    "tls.crt" = "MIIC6jCCAdICCQDeebIcFX8o1TANBgkqhkiG9w0BAQsFADA3MR8wHQYDVQQDDBZhcmNoaXRlY3R1cmUtZGVtby5pbmZvMRQwEgYDVQQKDAtpbmdyZXNzLXRsczAeFw0yMTAyMDkwNDM5MDJaFw0yMjAyMDkwNDM5MDJaMDcxHzAdBgNVBAMMFmFyY2hpdGVjdHVyZS1kZW1vLmluZm8xFDASBgNVBAoMC2luZ3Jlc3MtdGxzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy7scM720sTyZe1HLQubMApNRSUH5MsB9h7QHd063K4HFYli14AO3evMUg9db6M4YQcLwiO8LJL04JdMAHvagENQeY2rKA7OrmPUeaMKFALCFPldn6AiX4g1gIYkzTj+yu3Jfuj3nv09ylNcyudJN4uwbs23DsAEOyThOkay3bu8Ly7owxK+sP10F5NDyU0U8lwBla8Q79gTAlY71rt8MuVeUOvEvxn9+9Pa5uXPgPm4Y6PDEbMKriFkWp5HjNA96fKTY0mQ0m9+B+PuN7jx7xbONn68QVRxVy8L98181zK0xUAd9R6Bj7lWEPwuVGg7zQapwXL/vIHQdHFcbR7vqvQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQA4SYxGobyNnIlMQWIDIQhwZy3JAu78VHorhjzTJs8uumLLhf7aohIWBEn04/G04EJoy6POJ6xqhmqCoOkjMoWcD6xxjcGJWQ0rZsIUGiwD2lVIsvUEmHHdzOBpDOL68TC0bm/Fpg96ONFESp2pRJ4IjorRQUJO1jh6XlNtDyK7W1gGz3Qpp7/JJ6CY8TdouoWLtCoA02ZTuUVwci7uDDy7E0BOJKTzuVjJo4qc4elUk+9DT4rmxNwrwyj9ZHWZn8TFBWbvGyMvE69I79NoGfJj92T3iWbxmTsaO/uUwdL/wH0yICze2zLxTiDq686mZWn1ukxpfDoldcpPbJQ2EI2g"
    "tls.key" = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDLuxwzvbSxPJl7UctC5swCk1FJQfkywH2HtAd3TrcrgcViWLXgA7d68xSD11vozhhBwvCI7wskvTgl0wAe9qAQ1B5jasoDs6uY9R5owoUAsIU+V2foCJfiDWAhiTNOP7K7cl+6Pee/T3KU1zK50k3i7BuzbcOwAQ7JOE6RrLdu7wvLujDEr6w/XQXk0PJTRTyXAGVrxDv2BMCVjvWu3wy5V5Q68S/Gf3709rm5c+A+bhjo8MRswquIWRankeM0D3p8pNjSZDSb34H4+43uPHvFs42frxBVHFXLwv3zXzXMrTFQB31HoGPuVYQ/C5UaDvNBqnBcv+8gdB0cVxtHu+q9AgMBAAECggEAdpdrej7yoL0axqs9O6tnlBQ3HAK4Ua+1IrpMIkoC2+OFh5MGA+mF857uETTafnEBs74LEFq9zNwMhBAIIP4E/ObM7agrAe6jc70zv12D2Hvog/qTNIFUEDUjAUKBSApSO0T/rkT80uMnWrbOA1cFGZPBKDg70gc7mSwaqDe2625VuO7Z4v71HsX8VypomajDUgGBymb+5dztwvYslL/kqFhZrDrp5xmO4MHXf+c/iJmdruMTT1kkZqUp9Nox6IPfa+cH75pW2cs1yY/fVIBYfv7R9/ZDP6MTUJf+C/X4rqkAu6NXDiL85om3/ISfSq+V3dMSH5jxTN9cFkJcFUXfwQKBgQD9/MVoE4Y6Lpi+o8olQM5sxUMcVQ1h8UWzVSZI1geaCwcBm/oJulx4rjO0IbkVBVfVjK9/oidSTNcHfXCjoI2lr059Pi783e9EW5f/tm+0zREhBcc3NnN3S9wes71GyoYaRzYobIlGWguh8aZg/qglxHkHlKCHtZVZ87QrHboIkQKBgQDNWGQE1uxP1j5UJNgSDJi/QKb1/+LwE7ZBvEJEZe1jgAaD5OfEZwOxdbzFymp+IimsvvEOclw+kqyNkGJIHSseQ4bgPepTP10wXqeIr5ykgqeO2mtMnYiQogJoZFiCaFzmKgAzKm9wdR0x70GEqjWM53Ycr8GckOvQiQ6c7dx1bQKBgQCM36ymg13J25qA8tvmOcHE9sy4ZDxd/LLKOwpXD897k245aEgRKTqs/QJUgPflPudu3O9ifZANx+zkjKDzQNQP9+Iy+VCalIZnhd4SyR/ASpWbmVbbuunkW0EmDk+HekFTRfg2B61ERiF5m0zLM7QT7puqprc7Tm4eTFu8JmrO4QKBgGxUaz+aWsSrk+o0HcE34AVViD9TJVfeLlJzjMoks53AVq+SPSsB5ZLjOBloddHhF/dILEeg0UU5f8qXFyJQMQUgPrFiOJJ+ZR01clDLxGmNe/QDCoQ6v2b98SM9fOwfPpM2KTDU/EFpp2NGg1wHp4SUP11W419DnQRAqfLkEV/pAoGBALcCg4y8CJglFpFpdX2JHfEtk+zE3wdKR2gYZtDXwLJBKw54T6Q3IDv1bPb0LhdczzYkpqZeIuq/5CvIwmioDXSFiqoV++VBK/2OXlfgwX3gNIT9lswugGzsxuQSKVz9sqgBS1istZGTaWle+LKGvyOfJM5WuBQ/YgLWfWeLONtW"
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