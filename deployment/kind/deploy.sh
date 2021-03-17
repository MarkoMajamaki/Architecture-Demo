deploy()
{
	dotnet build backend/CustomerApi/CustomerApi
	dotnet build backend/OrderApi/OrderApi
	dotnet build backend/AuthApi/AuthApi
	cd frontend && flutter build web && cd ..

    docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
    docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
    docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
	docker build -t architecture_demo/frontend:v1 frontend/

	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest

    # Create cluster with config
    kind create cluster --name architecture-demo-cluster --config deployment/kind/kind.config

    # Load images to cluster
    kind load docker-image architecture_demo/auth-api:v1 --name architecture-demo-cluster
    kind load docker-image architecture_demo/customer-api:v1 --name architecture-demo-cluster
    kind load docker-image architecture_demo/order-api:v1 --name architecture-demo-cluster
    kind load docker-image architecture_demo/frontend:v1 --name architecture-demo-cluster
    kind load docker-image rabbitmq:3.8-management --name architecture-demo-cluster
    kind load docker-image mcr.microsoft.com/mssql/server:latest --name architecture-demo-cluster

    # Add namespace
    kubectl apply -f deployment/common/namespace.yaml 

    # Deploy ingress controller
    kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

    # Wait when ingerss controller is ready
    kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s

    # Deploy Kind PersistentVolumeClaim for sql server
    kubectl apply -f deployment/kind/sqlserver-pvc.yaml 

    # Deploy common services
	kubectl apply -f deployment/common/rabbitmq-config.yaml 
	kubectl apply -f deployment/common/sqlserver.yaml 
	kubectl apply -f deployment/common/auth-api.yaml
	kubectl apply -f deployment/common/customer-api.yaml
	kubectl apply -f deployment/common/order-api.yaml
	kubectl apply -f deployment/common/frontend.yaml

    # Deploy ingress rules
    kubectl apply -f deployment/kind/ingress.yaml 

    # Deploy RabbitMQ
	helm repo add bitnami https://charts.bitnami.com/bitnami
	
	helm install rabbitmq \
	--set replicaCount=3,auth.username=guest,auth.password=guest,extraPlugins=rabbitmq_federation \
	bitnami/rabbitmq -n architecture-demo    
}

destroy()
{
    kind delete cluster --name architecture-demo-cluster
}

"$@"