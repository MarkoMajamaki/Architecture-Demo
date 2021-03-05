# Architecture demo for kubernetes ASP.NET project

This is ASP.NET Kubernetes demo for training and learning. **Repo is still under heavy development and some features might not working!**

Used technologies:
* ASP.NET
* Flutter
* Docker
* Kubernetes
* Helm
* Azure
* Terraform
* Minikube
* RabbitMq
* SQL Server
* Entity Framework
* CQRS
* MediatR
* Swager
* Clean architecture

## Deployment with docker-compose

```bash
# Deploy with docker compose
sh deployment/docker-compose/deploy.sh deploy

# Destroy deployment
sh deployment/docker-compose/deploy.sh destroy
```

## Deployment with Kind

```bash
# Deploy to Kind cluster
sh deployment/kind/deploy.sh deploy

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672/

# Open frontend
https://localhost

# Delete cluster
sh deployment/kind/deploy.sh destroy
```

## Deployment with Minikube

```bash
# Close docker desktop and remove <minikube ip> architecture-demo.info from /etc/hosts if this is NOT first time to deploy!

# Deploy to minikube
sh deployment/minikube/deploy.sh deploy

# Open client
open https://architecture-demo.info

# Check api connection
curl -k https://architecture-demo.info/customer-api/customer

# Open minikube dashboard for debugging
minikube dashboard

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672

# Destroy minikube
sh deployment/minikube/deploy.sh destroy
```

## Deployment to Azure

```bash
# Login to Azure
az login

# Go Terraform folder to execute commands
cd deployment/azure

# Create Terraform state backend
sh scripts/init_remote_state_backend.sh

# Init Terraform infrastructure, do plan, and apply plan to create base infrastructure
cd core
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Save AKS config to file from Terraform output
terraform output -raw aks_kube_config > ../k8s/kube_config

# Go to root folder, start docker, build docker images and push to Azure Container Registery.
sh deployment/azure/scripts/build_and_push_acr.sh

# Go to Terraform kubernetes folder
cd k8s

# Init k8s terraform, do plan, and apply plan to create Kubernetes services with Terraform
terraform init
terraform plan -out tfplan
terraform apply tfplan

# Configure kubectl to connect to your Kubernetes cluster
az aks get-credentials --resource-group architecture_demo_rg --name ArchitectureDemoAKS

# Check ingress external ip
kubectl --namespace architecture-demo get services -o wide -w ingress-controller-ingress-nginx-controller

# Check connection
https://<EXTERNAL_IP>

# Destroy Azure infrastructure
cd ../k8s && terraform destroy
cd ../core && terraform destroy
# TODO: delete architecture_demo_tfstate_rg
```

### Azure Devops
Create service principal to connect Azure Devops and Azure. Use this to create new service connection in Azure Devops settings. Terraform ACR role assignment creation needs owner rights.

```
az ad sp create-for-rbac -n "Azure_Devops_SP" --role owner
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

## Development with Bridge to Kubernetes

```bash
# Set context to minikube namespace architecture-demo
kubectl config set-context --current --namespace=architecture-demo

# Check context
kubectl config get-contexts

# Open port for debug. Remove comment from CustomerUpdateSend.cs
kubectl -n architecture-demo port-forward rabbitmq-0 8001:5672
```

Follow instructions from here: https://code.visualstudio.com/docs/containers/minikube

Flutter frontend debugging is not working!