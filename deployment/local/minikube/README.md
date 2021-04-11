# Deployment with Minikube

```bash
# Close docker desktop and remove <minikube ip> architecture-demo.info from /etc/hosts if this is NOT first time to deploy!

# # Go to repo root directory and deploy backend project to Minikube
sh deployment/local/minikube/deploy.sh deploy

# Open client
open https://architecture-demo.info

# Check api connection
curl -k https://architecture-demo.info/customer-api/customer

# Open minikube dashboard for debugging
minikube dashboard

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672

# Destroy minikube
sh deployment/local/minikube/deploy.sh destroy
```
