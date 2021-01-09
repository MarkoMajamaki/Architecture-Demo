# Architecture demo for kubernetes ASP.NET project

This is ASP.NET Kubernetes demo for training and learning.

### Deployment with docker-compose

```bash
# Start Docker and run following command in deployment folder
docker-compose up

# Clean deployment with command
docker-compose down

# Delete docker image
docker rmi architecture_demo/order-api:v1
docker rmi architecture_demo/customer-api:v1
docker rmi architecture_demo/frontend:v1
docker rmi architecture_demo/nginx:v1
```

### Deployment with Minikube

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

# Switch off your own local Docker desktop installation and run command
eval $(minikube docker-env)

# Add sertificate
kubectl create secret tls architecture-demo-tls --cert=deployment/minikube/tls.crt --key=deployment/minikube/tls.key -n architecture-demo

# Navigate to root folder and build docker images
docker build -t architecture_demo/order-api:v1 backend/OrderApi/
docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
docker build -t architecture_demo/frontend:v1 frontend/

# Pull MS SQL Server image
docker pull mcr.microsoft.com/mssql/server:latest

# Pull RabbitMq image
docker pull rabbitmq:3-management

# Deploy all kubernetes resources
kubectl apply -f deployment/minikube/namespace.yaml 
kubectl apply -f deployment/minikube/secrets.yaml 
kubectl apply -f deployment/minikube/rabbitmq-deployment.yaml 
kubectl apply -f deployment/minikube/sqlserver-deployment.yaml 
kubectl apply -f deployment/minikube/order-api-deployment.yaml
kubectl apply -f deployment/minikube/customer-api-deployment.yaml
kubectl apply -f deployment/minikube/frontend-deployment.yaml
kubectl apply -f deployment/minikube/ingress.yaml

# Check connection
curl -k https://architecture-demo.info/order-api/test/test
curl -k https://architecture-demo.info/customer-api/test/test
curl -k https://architecture-demo.info/customer-api/customer
```

#### Clean

```bash

# Delete all resources from minikube
kubectl delete all --all -n architecture-demo
kubectl delete ingress ingress -n architecture-demo
kubectl delete statefulset rabbitmq -n architecture-demo
kubectl delete pvc sqlserver-pvc -n architecture-demo
kubectl delete secret architecture-demo-secrets -n architecture-demo
kubectl delete namespace architecture-demo

# Delete docker image
docker rmi architecture_demo/order-api:v1
docker rmi architecture_demo/customer-api:v1
docker rmi architecture_demo/frontend:v1
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
```

Follow instructions from here: https://code.visualstudio.com/docs/containers/minikube

Flutter frontend debugging is not working!