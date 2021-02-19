deploy()
{
	# Start minikube
	minikube start

	# Enable minikube ingress controller
	minikube addons enable ingress

	# Add demo host DNS for debugging (Mac OS)
	echo "$(minikube ip) architecture-demo.info" | sudo tee -a /etc/hosts

	dotnet build backend/CustomerApi/CustomerApi
	dotnet build backend/OrderApi/OrderApi
	cd frontend && flutter build web && cd ..

	eval $(minikube docker-env)

	docker build -t architecture_demo/order-api:v1 backend/OrderApi/
	docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
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
	kubectl apply -f deployment/common/sqlserver-deployment.yaml 
	kubectl apply -f deployment/common/customer-api-deployment.yaml
	kubectl apply -f deployment/common/order-api-deployment.yaml
	kubectl apply -f deployment/common/frontend-deployment.yaml

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