# Architecture demo for Kubernetes ASP.NET project

This is ASP.NET Kubernetes demo for training and learning. 

**Repo is still under heavy development and some features might not working!**

## Used technologies:
Frontend
* Flutter

Backend
* Microservices with clean architecture
* ASP.NET
* RabbitMq
* SQL Server
* Entity Framework
* CQRS
* MediatR
* Swager
* OAuth with Facebook authentication

Infrastructure
* Local deployment with Minikube, Kind and docker compose
* Production deployment to Azure using Terraform
* Azure Kubernetes Services
* Azure Container Registery
* Hashicorp Vault
* Kubernetes
* Docker
* Helm charts

Testing
* xUnit integration and unit tests

Azure Devops CI/CD pipeline
1. Create infrastructure to Azure using Terraform
2. Run integration and unit tests
3. Build docker images and push to ACR
4. Deploy services to AKS

## Deploy
Deploy local dev enviroment with Kind, Minikube or Docker compose and production enviroment to Azure using terraform.

### Secret management
Use local secret management tool when debug backend locally. In production or local Kind and Minikube cluster, use Hashicorp Vault to protect secrets. 

#### Set local secrets for backend
```bash
# Go AuthApi project
cd backend/AuthApi/AuthApi

# Enable secret management tool
dotnet user-secrets init

# Add secrets for local development
dotnet user-secrets set "Facebook:AppId" "Your_Facebook_AppId"
dotnet user-secrets set "Facebook:AppSecret" "Your_Facebook_AppSecret"
```

#### Set secrets to Hashicorp Vault after deployment
```bash
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

# Login
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
vault kv put secret/facebook_auth_config AppId=Your_Facebook_AppId AppSecret=Your_Facebook_AppSecret

# Show secrets
vault kv get secret/facebook_auth_config

exit
```

### Mirror all RabbitMQ nodes
```
# Open RabbitMQ first node
kubectl exec -it rabbitmq-0 bash -n architecture-demo

# Mirror all RabbitMQ nodes
rabbitmqctl set_policy ha-fed \
    ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"all" }' \
    --priority 1 \
    --apply-to queues

# Close first node
exit
```