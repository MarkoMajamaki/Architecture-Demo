helm repo add hashicorp https://helm.releases.hashicorp.com

helm install consul hashicorp/consul \
        --set global.datacenter=vault-kubernetes-tutorial \
        --set client.enabled=true \
        --set server.replicas=1 \
        --set server.bootstrapExpect=1 \
        --set server.disruptionBudget.maxUnavailable=0 \
        -n architecture-demo

helm install vault hashicorp/vault \
        --set server.affinity="" \
        --set server.ha.enabled=true \
        --set ui.enabled=true \
        --set ui.serviceType=LoadBalancer \
        -n architecture-demo
