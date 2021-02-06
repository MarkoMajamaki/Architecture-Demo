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

### Deployment with docker-compose

```bash
# Deploy with docker compose
make docker-compose-deploy

# Destroy deployment
make docker-compose-destroy
```

### Deployment with Kind

```bash
# Deploy to Kind cluster
make kind-deploy

# Delete cluster
make kind-destroy

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672 && open http://127.0.0.1:15672/

# Test connection
curl -k https://localhost/customer-api/customer
```

### Deployment with Minikube

```bash
# Remove <minikube ip> architecture-demo.info from /etc/hosts if this is NOT first time to deploy!

# Deploy to minikube
make minikube-deploy

# Destroy minikube
make minikube-destroy

# Open minikube dashboard for debugging
minikube dashboard

# Check connection
curl -k https://architecture-demo.info/customer-api/customer

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl -n architecture-demo port-forward rabbitmq-0 8080:15672 && open http://localhost:8080
```

### Deployment to Azure

```bash
# Login to Azure
az login

# Go Terraform folder to execute commands
cd deployment/azure

# Create TLS certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out ingress-tls.crt \
    -keyout ingress-tls.key \
    -subj "/CN=architecture-demo.info/O=ingress-tls"

# Init Terraform infrastructure
terraform init

# Do plan to create infrastructure
terraform plan

# Create infrastructure and deploy
terraform apply

# Because ACR is empty, Kubernetes deployment is waiting for customer-api and order-api images 
# to be uploaded to ACR. Open another terminal, login to ACR and push local docker images to ACR.
az acr login --name ArchitectureDemoACR
sh push_images_acr.sh

# Configure kubectl to connect to your Kubernetes cluster
az aks get-credentials --resource-group architecture_demo_rg --name ArchitectureDemoAKS

# Check ingress external ip
kubectl --namespace architecture-demo get services -o wide -w ingress-controller-ingress-nginx-controller

# Check connection
# TODO

# Destroy Azure infrastructure
terraform destroy
```
###

### Development with Bridge to Kubernetes

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