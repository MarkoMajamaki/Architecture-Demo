# Architecture demo for Kubernetes ASP.NET project

This is ASP.NET Kubernetes demo for training and learning. **Repo is still under heavy development and some features might not working!**

Used technologies:
* ASP.NET
* Flutter
* Docker
* Kubernetes
* Helm
* Azure
* Azure Devops CI/CD
* Terraform
* Minikube
* RabbitMq
* SQL Server
* Entity Framework
* CQRS
* MediatR
* Swager
* OAuth
* Clean architecture

## Facebook authentication secrets for local development
```bash
# Go AuthApi project
cd backend/AuthApi/AuthApi

# Enable secret management tool
dotnet user-secrets init

# Add secrets for local development
dotnet user-secrets set "FacebookAuth:AppId" "{Your Facebook AppId}"
dotnet user-secrets set "FacebookAuth:AppSecret" "{Your Facebook AppSecret}"
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