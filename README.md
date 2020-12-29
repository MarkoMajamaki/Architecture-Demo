# Architecture demo for kubernetes ASP.NET project

This is ASP.NET Kubernetes demo for training and learning.

### Deployment to minikube

```bash
# Start minikube
minikube start

# Open minikube dashboard for debugging
minikube dashboard

# Enable minikube ingress controller
minikube addons enable ingress

# Add demo host DNS for debugging (Mac OS)
echo "$(minikube ip) architecture-demo.info" | sudo tee -a /etc/hosts

# Check is DNS added at the end of the file
cat /etc/hosts

# Navigate to root folder and build docker images
docker build -t architecture_demo/order-api:v1 backend/OrderApi/
docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/

# Pull MS SQL Server image
docker pull mcr.microsoft.com/mssql/server:latest

# Pull RabbitMq image
docker pull rabbitmq:3-management

# Add docker images to minikube cache
minikube cache add architecture_demo/order-api:v1
minikube cache add architecture_demo/customer-api:v1
minikube cache add mcr.microsoft.com/mssql/server:latest
minikube cache add rabbitmq:3-management

# Reload cache
minikube cache reload

# Check cache
minikube cache list

# Deploy all kubernetes resources
kubectl apply -f deployment/minikube/namespace.yaml 
kubectl apply -f deployment/minikube/secrets.yaml 
kubectl apply -f deployment/minikube/rabbitmq-deployment.yaml 
kubectl apply -f deployment/minikube/sqlserver-deployment.yaml 
kubectl apply -f deployment/minikube/order-api-deployment.yaml
kubectl apply -f deployment/minikube/customer-api-deployment.yaml
kubectl apply -f deployment/minikube/ingress.yaml

# Check connection
curl architecture-demo.info/order/test/test
curl architecture-demo.info/customer/test/test
```

#### Clean

```bash
# Delete docker images from minikube cache
minikube cache delete architecture_demo/order-api:v1
minikube cache delete architecture_demo/customer-api:v1

# Delete all resources from minikube
kubectl delete all --all -n architecture-demo
kubectl delete ingress ingress -n architecture-demo
kubectl delete statefulset rabbitmq -n architecture-demo
kubectl delete pvc sqlserver-pvc -n architecture-demo
kubectl delete secret architecture-demo-secrets -n architecture-demo
kubectl delete namespace architecture-demo
kubectl delete all --all -n rabbitmq
kubectl delete namespace rabbitmq


# Delete docker image
docker rmi architecture_demo/order-api:v1
docker rmi architecture_demo/customer-api:v1
```

### Deployment to Azure

https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app

1. Create Azure container registery (ACR) and add images to registery
3. Create Azure kubernetes service (AKS) with service principle
4. Login to AKS and add ingress with Helm and other resources


