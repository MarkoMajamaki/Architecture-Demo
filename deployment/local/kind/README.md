# Deployment with Kind

```bash
# Go to repo root directory and deploy project to Kind k8s cluster
sh deployment/local/kind/deploy.sh deploy

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672/

# Open frontend
https://localhost

# Delete cluster
sh deployment/local/kind/deploy.sh destroy
```
