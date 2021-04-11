deploy()
{
	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest
	docker build -t architecture_demo/auth-api:v1 backend/AuthApi/
	docker build -t architecture_demo/order-api:v1 backend/OrderApi/
	docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
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