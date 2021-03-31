az acr login --name ArchitectureDemoACR

# Build
docker build -f backend/AuthApi/Dockerfile -t architecture_demo/auth-api:v1 backend/
docker build -f backend/OrderApi/Dockerfile -t architecture_demo/order-api:v1 backend/
docker build -f backend/CustomerApi/Dockerfile -t architecture_demo/customer-api:v1 backend/	
docker build -t architecture_demo/frontend:v1 frontend/

# Tag based on ACR login path
docker tag architecture_demo/auth-api:v1 architecturedemoacr.azurecr.io/auth-api:v1
docker tag architecture_demo/customer-api:v1 architecturedemoacr.azurecr.io/customer-api:v1
docker tag architecture_demo/order-api:v1 architecturedemoacr.azurecr.io/order-api:v1
docker tag architecture_demo/frontend:v1 architecturedemoacr.azurecr.io/frontend:v1

# Push to ACR
docker push architecturedemoacr.azurecr.io/auth-api:v1
docker push architecturedemoacr.azurecr.io/customer-api:v1
docker push architecturedemoacr.azurecr.io/order-api:v1
docker push architecturedemoacr.azurecr.io/frontend:v1
