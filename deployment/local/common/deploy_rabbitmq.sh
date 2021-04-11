helm repo add bitnami https://charts.bitnami.com/bitnami

helm install rabbitmq \
--set replicaCount=3,auth.username=guest,auth.password=guest,extraPlugins=rabbitmq_federation \
bitnami/rabbitmq -n architecture-demo    
