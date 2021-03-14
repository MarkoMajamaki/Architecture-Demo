# Compile all services
dotnet build backend/CustomerApi/CustomerApi
dotnet build backend/OrderApi/OrderApi
dotnet build backend/AuthApi/AuthApi
cd frontend && flutter build web && cd ..

# Pull images
docker pull rabbitmq:3.8-management
docker pull mcr.microsoft.com/mssql/server:latest

# Build images
docker build -t architecture_demo/auth-api:v1 backend/AuthApi/
docker build -t architecture_demo/order-api:v1 backend/OrderApi/
docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
docker build -t architecture_demo/frontend:v1 frontend/