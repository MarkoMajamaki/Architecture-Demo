# Tag based on ACR login path
docker tag architecture_demo/customer-api:v1 architecturedemoacr.azurecr.io/customer-api:v1
docker tag architecture_demo/order-api:v1 architecturedemoacr.azurecr.io/order-api:v1
docker tag architecture_demo/frontend:v1 architecturedemoacr.azurecr.io/frontend:v1

# Push to ACR
docker push architecturedemoacr.azurecr.io/customer-api:v1
docker push architecturedemoacr.azurecr.io/order-api:v1
docker push architecturedemoacr.azurecr.io/frontend:v1
