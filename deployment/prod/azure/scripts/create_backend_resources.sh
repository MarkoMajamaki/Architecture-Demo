# Original: https://github.com/jcorioland/terraform-azure-reference/blob/master/scripts/init-remote-state-backend.sh

set -e

LOCATION=northeurope
RESOURCE_GROUP_NAME=architecture_demo_backend
STORAGE_ACCOUNT_NAME=account010
CONTAINER_NAME=container
KEYVAULT_NAME=keyvault-000

# Create the resource group
if  ( `az group exists --resource-group $RESOURCE_GROUP_NAME` == "true" );
then
    echo "Resource group $RESOURCE_GROUP_NAME exists..."
else
    echo "Creating $RESOURCE_GROUP_NAME resource group..."
    az group create -n $RESOURCE_GROUP_NAME -l $LOCATION
    echo "Resource group $RESOURCE_GROUP_NAME created."
fi

# Create the storage account
if ( `az storage account check-name --name $STORAGE_ACCOUNT_NAME --query 'nameAvailable'` == "true" );
then
    echo "Creating $STORAGE_ACCOUNT_NAME storage account..."
    az storage account create \
        -g $RESOURCE_GROUP_NAME \
        -l $LOCATION \
        --name $STORAGE_ACCOUNT_NAME \
        --sku Standard_LRS \
        --encryption-services blob
    echo "Storage account $STORAGE_ACCOUNT_NAME created."
else
    echo "Storage account $STORAGE_ACCOUNT_NAME exists..."
fi

# Retrieve the storage account key
echo "Retrieving storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
echo "Storage account key retrieved."

# Create a storage container (for the Terraform State)
if ( `az storage container exists --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY --query exists` == "true" );
then
    echo "Storage container $CONTAINER_NAME exists..."
else
    echo "Creating $CONTAINER_NAME storage container..."
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
    echo "Storage container $CONTAINER_NAME created."
fi

# Create an Azure KeyVault
if ( `az keyvault list --query "[?name == '$KEYVAULT_NAME'].name | [0] == '$KEYVAULT_NAME'"` == "true" );
then
    echo "Key vault $KEYVAULT_NAME exists..."
else
    echo "Creating $KEYVAULT_NAME key vault..."
    az keyvault create -g $RESOURCE_GROUP_NAME -l $LOCATION --name $KEYVAULT_NAME
    echo "Key vault $KEYVAULT_NAME created."
fi

# Store the Terraform State Storage Key into KeyVault
echo "Store storage access key into key vault secret..."
az keyvault secret set --name tfstate-storage-key --value $ACCOUNT_KEY --vault-name $KEYVAULT_NAME -o none
echo "Key vault secret created."

echo ""
echo "Azure Storage Account and KeyVault have been created!"
echo ""



