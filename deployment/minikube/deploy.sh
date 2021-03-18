deploy()
{
	# Start minikube
	minikube start

	# Enable minikube ingress controller
	minikube addons enable ingress

	# Add demo host DNS for debugging (Mac OS)
	echo "$(minikube ip) architecture-demo.info" | sudo tee -a /etc/hosts

	cd ../../
	dotnet build backend/CustomerApi/CustomerApi
	dotnet build backend/OrderApi/OrderApi
	dotnet build backend/AuthApi/AuthApi
	cd frontend && flutter build web && cd ..

	eval $(minikube docker-env)

    docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
    docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
    docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
	docker build -t architecture_demo/frontend:v1 frontend/
	
    docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest

	# Create self signed sertificate
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout deployment/tls.key -out deployment/tls.crt -subj "/CN=architecture-demo.info" -days 365

	# Add namespace
	kubectl apply -f deployment/common/namespace.yaml 

	# Add sertificate
	kubectl create secret tls ingress-tls-secret --cert=deployment/tls.crt --key=deployment/tls.key -n architecture-demo

	# Apply minikube ingress
	kubectl apply -f deployment/minikube/ingress.yaml
	kubectl apply -f deployment/minikube/sqlserver-pvc.yaml 

	# Apply common services
	kubectl apply -f deployment/common/namespace.yaml 
	kubectl apply -f deployment/common/rabbitmq-config.yaml 
	kubectl apply -f deployment/common/sqlserver.yaml 
	kubectl apply -f deployment/common/auth-api.yaml
	kubectl apply -f deployment/common/customer-api.yaml
	kubectl apply -f deployment/common/order-api.yaml
	kubectl apply -f deployment/common/frontend.yaml

	# Add RabbitMQ	
    helm repo add bitnami https://charts.bitnami.com/bitnami
	
	helm install rabbitmq \
	--set replicaCount=3,auth.username=guest,auth.password=guest,extraPlugins=rabbitmq_federation \
	bitnami/rabbitmq -n architecture-demo
}

destroy()
{
	minikube delete
}

"$@"