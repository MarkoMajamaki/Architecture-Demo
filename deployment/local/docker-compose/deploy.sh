deploy()
{
	# Create self signed sertificate
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout certs/tls.key -out certs/tls.crt -subj "/CN=localhost" -days 365

	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest
    docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
    docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
    docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
	docker build -t architecture_demo/frontend:v1 frontend/

	cd deployment/local/docker-compose 
	docker-compose up
}

destroy()
{
	cd deployment/local/docker-compose && docker-compose down

	docker rmi architecture_demo/order-api:v1
	docker rmi architecture_demo/customer-api:v1
	docker rmi architecture_demo/frontend:v1
}

"$@"