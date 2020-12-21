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
docker build -t architecture_demo/order-api:v1 src/OrderApi/
docker build -t architecture_demo/customer-api:v1 src/CustomerApi/

# Pull MS SQL Server image
docker pull mcr.microsoft.com/mssql/server:latest

# Add docker images to minikube cache
minikube cache add architecture_demo/order-api:v1
minikube cache add architecture_demo/customer-api:v1
minikube cache add mcr.microsoft.com/mssql/server:latest

# Check cache
minikube cache list

# Deploy all kubernetes resources
kubectl apply -f kubernetes/dev/namespace.yaml 
kubectl apply -f kubernetes/dev/secrets.yaml 
kubectl apply -f kubernetes/dev/sqlserver-deployment.yaml 
kubectl apply -f kubernetes/dev/order-api-deployment.yaml
kubectl apply -f kubernetes/dev/customer-api-deployment.yaml
kubectl apply -f kubernetes/dev/ingress.yaml

# Check connection
curl architecture-demo.info/order/test/testing
```

#### Clean

```bash
# Delete docker images from minikube cache
minikube cache delete architecture_demo/order-api:v1
minikube cache delete architecture_demo/customer-api:v1

# Delete all resources from minikube
kubectl delete all --all -n architecture-demo
kubectl delete ingress ingress -n architecture-demo
kubectl delete pvc sqlserver-pvc -n architecture-demo
kubectl delete secret architecture-demo-secrets -n architecture-demo
kubectl delete namespace architecture-demo

# Delete docker image
docker rmi architecture_demo/order-api:v1
docker rmi architecture_demo/customer-api:v1
```

### Deployment to Azure

TODO

#### Clean

