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

# To Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672/

# Test connection
curl -k https://localhost/customer-api/customer
```

### Deployment with Minikube

```bash
# Remove <minikube ip> architecture-demo.info from /etc/hosts if this is NOT first time to deploy!

# Deploy to minikube
make minikube-deploy

# Open minikube dashboard for debugging
minikube dashboard

# Check connection
curl -k https://architecture-demo.info/order-api/test/test
curl -k https://architecture-demo.info/customer-api/test/test
curl -k https://architecture-demo.info/customer-api/customer

# Open RabbitMq dashboard
kubectl -n architecture-demo port-forward rabbitmq-0 8080:15672
http://localhost:8080

# Destroy minikube
make minikube-destroy
```

### Deployment to Azure

https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app

1. Create Azure container registery (ACR) and add images to registery
3. Create Azure kubernetes service (AKS) with service principle
4. Login to AKS and add ingress with Helm and other resources

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