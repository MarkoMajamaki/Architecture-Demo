# Deployment with Kind

```bash
# Deploy to Kind cluster
sh deploy.sh deploy

# Access the RabbitMQ Management interface: (username: guest, password: guest)
kubectl port-forward --namespace architecture-demo svc/rabbitmq 15672:15672
http://127.0.0.1:15672/

# Open frontend
https://localhost

# Delete cluster
sh deploy.sh destroy
```
