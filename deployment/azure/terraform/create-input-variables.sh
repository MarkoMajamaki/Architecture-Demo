# Make sure that everything is done to this subscription
az account set --subscription $1

# Create rback for aks
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks -o json)

# Get appId and passowrd from service principal	json
SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')	
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

# Create service principal
az role assignment create --assignee $SERVICE_PRINCIPAL \
    --scope "/subscriptions/$1" \
    --role Contributor

# Create ssh key
ssh-keygen -t rsa -b 4096 -N "VeryStrongSecret123#" -C "mail@gmail.com" -q -f  ~/.ssh/id_rsa
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

# Delete file if exist
if [ -f "$3" ]; then
    rm $3
fi

# Create file for terraform variables
{
    echo "serviceprinciple_id = \"$SERVICE_PRINCIPAL\""
    echo "serviceprinciple_key = \"$SERVICE_PRINCIPAL_SECRET\""
    echo "tenant_id = \"$2\""
    echo "subscription_id = \"$1\""
    echo "ssh_key = \"$SSH_KEY\""
} >> $3