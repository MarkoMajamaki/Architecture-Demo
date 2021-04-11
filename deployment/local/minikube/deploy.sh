deploy()
{
	# Start minikube
	minikube start

	# Enable minikube ingress controller
	minikube addons enable ingress

	# Add demo host DNS for debugging (Mac OS)
	echo "$(minikube ip) architecture-demo.info" | sudo tee -a /etc/hosts

	eval $(minikube docker-env)

    docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
    docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
    docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
	docker build -t architecture_demo/frontend:v1 frontend/
	
    docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest

    # Deploy Minikube PersistentVolumeClaim for sql server
	kubectl apply -f deployment/local/minikube/sqlserver-pvc.yaml 

	# Apply common services
	kubectl apply -f deployment/local/common/namespace.yaml 
	kubectl apply -f deployment/local/common/rabbitmq-config.yaml 
	kubectl apply -f deployment/local/common/sqlserver.yaml 
	kubectl apply -f deployment/local/common/auth-api.yaml
	kubectl apply -f deployment/local/common/customer-api.yaml
	kubectl apply -f deployment/local/common/order-api.yaml
	kubectl apply -f deployment/local/common/frontend.yaml
	kubectl apply -f deployment/local/common/ingress-tls-secret.yaml

    # Deploy ingress rules
	kubectl apply -f deployment/local/minikube/ingress.yaml

	# Add RabbitMQ	
    helm repo add bitnami https://charts.bitnami.com/bitnami
	
    # Deploy RabbitMq
    sh deployment/local/common/deploy_rabbitmq.sh
}

destroy()
{
	minikube delete
}

"$@"