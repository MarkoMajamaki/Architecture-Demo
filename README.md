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
* Azure Key Vault
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

## Facebook authentication secrets for local development
```bash
# Go AuthApi project
cd backend/AuthApi/AuthApi

# Enable secret management tool
dotnet user-secrets init

# Add secrets for local development
dotnet user-secrets set "FacebookAuth:AppId" "Your Facebook AppId"
dotnet user-secrets set "FacebookAuth:AppSecret" "Your Facebook AppSecret"
```

## Mirror all RabbitMQ nodes
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