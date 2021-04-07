
create()
{
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
}

init()
{
# Initialize Vault with five key share and three key threshold.
kubectl exec vault-0 -- vault operator init -key-shares=5 -key-threshold=3 -format=json > cluster-keys.json

# Unseal every vault
VAULT_UNSEAL_KEY1=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[0]")
VAULT_UNSEAL_KEY2=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[1]")
VAULT_UNSEAL_KEY3=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[2]")

kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY1
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY2
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY3

kubectl exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY1
kubectl exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY2
kubectl exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY3

kubectl exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY1
kubectl exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY2
kubectl exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY3

# Show root key
cat cluster-keys.json | jq -r ".root_token"

# start an interactive shell session on the vault-0 pod
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh

# Login (manually) TODO
vault login

# Enable the Kubernetes authentication method
vault auth enable kubernetes

# Configure the Kubernetes authentication method to use the service account token, the location of the Kubernetes host, and its certificate.
vault write auth/kubernetes/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Write out the policy that enables the read capability for secrets at path secret/facebook_auth_config
vault policy write facebook-auth-config-policy - <<EOF
path "secret/facebook_auth_config" {
capabilities = ["read"]
}
EOF

# Create a Kubernetes authentication role, that connects the Kubernetes service account name and app policy
vault write auth/kubernetes/role/auth-config-role \
        bound_service_account_names=vault-service-account \
        bound_service_account_namespaces=architecture-demo \
        policies=facebook-auth-config-policy \
        ttl=24h

# Enable search engine
vault secrets enable -path secret kv

# Set Facebook auth secrets
vault kv put secret/facebook_auth_config AppId=<Your Facebook AppId> AppSecret=<Your Facebook AppSecret>

# Show secrets
vault kv get secret/facebook_auth_config

exit
}

