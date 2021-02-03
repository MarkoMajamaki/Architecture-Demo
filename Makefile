#
# Docker compose deploy
#
docker-compose-deploy:
	$(MAKE) compile
	$(MAKE) build-images
	# cd deployment && docker-compose up

docker-compose-destroy:
	cd deployment && docker-compose down
	$(MAKE) remove-images

#
# Kind deploy
#
kind-deploy:
	$(MAKE) compile
	$(MAKE) build-images
	$(MAKE) pull-images
	
	# Create cluster with config
	kind create cluster --name architecture-demo-cluster --config deployment/kind/kind.config

	# Load images to cluster
	kind load docker-image architecture_demo/customer-api:v1 --name architecture-demo-cluster
	kind load docker-image architecture_demo/order-api:v1 --name architecture-demo-cluster
	kind load docker-image architecture_demo/frontend:v1 --name architecture-demo-cluster
	kind load docker-image rabbitmq:3.8-management --name architecture-demo-cluster
	kind load docker-image mcr.microsoft.com/mssql/server:latest --name architecture-demo-cluster

	# Create self signed sertificate
	$(MAKE) create-ssh

	# Add namespace
	kubectl apply -f deployment/common/namespace.yaml 

	# Add ingress sertificate to that namespace
	kubectl create secret tls ingress-tls-secret --cert=deployment/tls.crt --key=deployment/tls.key -n architecture-demo

	# Deploy ingress controller
	kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

	# Wait when ingerss controller is ready
	kubectl wait --namespace ingress-nginx \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
	--timeout=90s

	# Deploy Kind PersistentVolumeClaim for sql server
	kubectl apply -f deployment/kind/sqlserver-pvc.yaml 

	# Deploy common services
	$(MAKE) deploy-k8s-common

	# Deploy ingress rules
	kubectl apply -f deployment/kind/ingress.yaml 

	# Deploy RabbitMQ
	$(MAKE) add-rabbitmq
	
	# Mirror RabbitMq nodes (not working because pods are not ready!)
	# $(MAKE) mirror-rabbitmq

kind-destroy:
	# Delete K8S cluster
	kind delete cluster --name architecture-demo-cluster

#
# Minikube deployment. Close docker desktop first and remove <minikube ip> architecture-demo.info
# from /etc/hosts if this is NOT first time to deploy.
#
minikube-deploy:
	# Start minikube
	minikube start

	# Enable minikube ingress controller
	minikube addons enable ingress

	# Add demo host DNS for debugging (Mac OS)
	echo "$(minikube ip) architecture-demo.info" | sudo tee -a /etc/hosts

	$(MAKE) compile
	$(MAKE) build-minikube-images
	$(MAKE) pull-minikube-images

	# Create self signed sertificate
	$(MAKE) create-ssh

	# Add namespace
	kubectl apply -f deployment/common/namespace.yaml 

	# Add sertificate
	kubectl create secret tls ingress-tls-secret --cert=deployment/tls.crt --key=deployment/tls.key -n architecture-demo

	# Apply minikube ingress
	kubectl apply -f deployment/minikube/ingress.yaml

	# Apply common services
	$(MAKE) deploy-k8s-common

	# Add RabbitMQ
	$(MAKE) add-rabbitmq

	# Mirror RabbitMq nodes (not working because pods are not ready!)
	# $(MAKE) mirror-rabbitmq

minikube-destroy:
	minikube delete

#
# Common
#
pull-images:
	docker pull rabbitmq:3.8-management
	docker pull mcr.microsoft.com/mssql/server:latest
	
compile:
	dotnet build backend/CustomerApi/CustomerApi
	dotnet build backend/OrderApi/OrderApi
	# cd frontend && flutter build web && cd ..

pull-minikube-images:
	@eval $$(minikube docker-env) ;\
	docker pull rabbitmq:3.8-management

	@eval $$(minikube docker-env) ;\
	docker pull mcr.microsoft.com/mssql/server:latest

build-minikube-images:
	@eval $$(minikube docker-env) ;\
	docker build -t architecture_demo/order-api:v1 backend/OrderApi/

	@eval $$(minikube docker-env) ;\ 
	docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/

	# @eval $$(minikube docker-env) ;\
	# eval $(minikube docker-env) && docker build -t architecture_demo/frontend:v1 frontend/ TODO

build-images:
	docker build -t architecture_demo/order-api:v1 backend/OrderApi/
	docker build -t architecture_demo/customer-api:v1 backend/CustomerApi/
	# docker build -t architecture_demo/frontend:v1 frontend/ TODO

remove-images:
	docker rmi architecture_demo/order-api:v1
	docker rmi architecture_demo/customer-api:v1
	docker rmi architecture_demo/frontend:v1

deploy-k8s-common:
	kubectl apply -f deployment/common/namespace.yaml 
	kubectl apply -f deployment/common/sqlserver-deployment.yaml 
	kubectl apply -f deployment/common/customer-api-deployment.yaml
	kubectl apply -f deployment/common/order-api-deployment.yaml
	kubectl apply -f deployment/common/frontend-deployment.yaml

create-ssh:
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout deployment/tls.key -out deployment/tls.crt -subj "/CN=architecture-demo.info" -days 365

remove-resources:
	kubectl delete all --all -n architecture-demo
	kubectl delete ingress ingress -n architecture-demo
	kubectl delete statefulset rabbitmq -n architecture-demo
	kubectl delete pvc sqlserver-pvc -n architecture-demo
	kubectl delete secret architecture-demo-secrets -n architecture-demo
	kubectl delete namespace architecture-demo
	kubectl delete ingress ingress
	kubectl delete pvc sqlserver-pvc
	kubectl delete pv --all

# Add RabbitMQ using Bitnami helm chart
add-rabbitmq:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	
	helm install rabbitmq \
	--set replicaCount=3,auth.username=guest,auth.password=guest,extraPlugins=rabbitmq_federation \
	bitnami/rabbitmq -n architecture-demo

remove-rabbitmq:
	helm delete rabbitmq

mirror-rabbitmq:
	# Open RabbitMq first node
	kubectl exec -it rabbitmq-0 bash -n architecture-demo

	# Mirror all Rabbitmq nodes
	rabbitmqctl set_policy ha-fed \
		".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"all" }' \
		--priority 1 \
		--apply-to queues

	# Close first node
	exit
