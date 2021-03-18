
# Deployment to Azure

```bash
# Login to Azure
az login

# Create Terraform state backend
sh scripts/init_remote_state_backend.sh

# Init Terraform infrastructure, do plan, and apply plan to create base infrastructure
cd core
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Save AKS config to file from Terraform output
terraform output -raw aks_kube_config > ../k8s/kube_config

# Go to root folder, start docker, build docker images and push to Azure Container Registery.
sh deployment/azure/scripts/build_and_push_acr.sh

# Go to Terraform kubernetes folder
cd k8s

# Init k8s terraform, do plan, and apply plan to create Kubernetes services with Terraform
terraform init
terraform plan -out tfplan
terraform apply tfplan

# Configure kubectl to connect to your Kubernetes cluster
az aks get-credentials --resource-group architecture_demo_rg --name ArchitectureDemoAKS

# Check ingress external ip
kubectl --namespace architecture-demo get services -o wide -w ingress-controller-ingress-nginx-controller

# Check connection
https://<EXTERNAL_IP>

# Destroy Azure infrastructure
cd ../k8s && terraform destroy
cd ../core && terraform destroy

# Delete architecture_demo_tfstate_rg
# TODO
```

## Azure Devops
Create service principal to connect Azure Devops and Azure. Use this to create new service connection in Azure Devops settings. Terraform ACR role assignment creation needs owner rights.

```
az ad sp create-for-rbac -n "Azure_Devops_SP" --role owner
```
