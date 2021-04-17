deploy()
{
    docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
    docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
    docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
	docker build -t architecture_demo/frontend:v1 frontend/

	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest

    # Create cluster with config
    kind create cluster --name architecture-demo --config deployment/local/kind/kind.config

    # Load images to cluster
    kind load docker-image architecture_demo/auth-api:v1 --name architecture-demo
    kind load docker-image architecture_demo/customer-api:v1 --name architecture-demo
    kind load docker-image architecture_demo/order-api:v1 --name architecture-demo
    kind load docker-image architecture_demo/frontend:v1 --name architecture-demo
    kind load docker-image rabbitmq:3.8-management --name architecture-demo
    kind load docker-image mcr.microsoft.com/mssql/server:latest --name architecture-demo

    # Add namespace
    kubectl apply -f deployment/local/common/namespace.yaml 

    # Deploy ingress controller
    kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

    # Wait when ingerss controller is ready
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s

    # Set vault
    sh deployment/local/common/deploy_vault.sh

    # Deploy Kind PersistentVolumeClaim for sql server
    kubectl apply -f deployment/local/kind/sqlserver-pvc.yaml 

    # Deploy common services
	kubectl apply -f deployment/local/common/frontend.yaml
	kubectl apply -f deployment/local/common/rabbitmq-config.yaml 
	kubectl apply -f deployment/local/common/sqlserver.yaml 
    kubectl apply -f deployment/local/common/vault-service-account.yaml 
	kubectl apply -f deployment/local/common/auth-api.yaml
	kubectl apply -f deployment/local/common/customer-api.yaml
	kubectl apply -f deployment/local/common/order-api.yaml
	kubectl apply -f deployment/local/common/frontend.yaml
	kubectl apply -f deployment/local/common/ingress-tls-secret.yaml

    # Deploy ingress rules
    kubectl apply -f deployment/local/kind/ingress.yaml 
    
    # Deploy RabbitMq
    sh deployment/local/common/deploy_rabbitmq.sh
}

destroy()
{
    kind delete cluster --name architecture-demo
}

"$@"