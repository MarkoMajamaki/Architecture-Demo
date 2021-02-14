deploy()
{
	dotnet build backend/CustomerApi/CustomerApi
	dotnet build backend/OrderApi/OrderApi
	cd frontend && flutter build web && cd ..

	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest
	docker build -t architecture_demo/order-api:v1 backend/OrderApi/
	docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
	docker build -t architecture_demo/frontend:v1 frontend/

	cd deployment/docker-compose 
	docker-compose up
	cd ../../
}

destroy()
{
	cd deployment/docker-compose && docker-compose down

	docker rmi architecture_demo/order-api:v1
	docker rmi architecture_demo/customer-api:v1
	docker rmi architecture_demo/frontend:v1
}

"$@"