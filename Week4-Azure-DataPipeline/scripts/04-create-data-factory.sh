#!/usr/bin/env bash
# ==============================================================================
# 04-create-data-factory.sh
# Creates the Azure Data Factory (V2) instance with a system-assigned
# managed identity, then deploys the linked service, datasets, and pipeline
# JSON definitions from the /adf folder.
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo "Creating Data Factory: $DATA_FACTORY_NAME ..."
az datafactory create \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --location "$LOCATION"

ACCOUNT_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[0].value" -o tsv)

echo "Deploying Linked Service ..."
az datafactory linked-service create \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --linked-service-name "LS_BlobStorage_Superstore" \
  --properties @"$(dirname "$0")/../adf/linkedServices/LS_BlobStorage_Superstore.json"

echo "Deploying Source Dataset ..."
az datafactory dataset create \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --dataset-name "DS_Source_SuperstoreCSV" \
  --properties @"$(dirname "$0")/../adf/datasets/DS_Source_SuperstoreCSV.json"

echo "Deploying Destination Dataset ..."
az datafactory dataset create \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --dataset-name "DS_Destination_SuperstoreCSV" \
  --properties @"$(dirname "$0")/../adf/datasets/DS_Destination_SuperstoreCSV.json"

echo "Deploying Pipeline ..."
az datafactory pipeline create \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --pipeline-name "PL_Superstore_EndToEnd" \
  --pipeline @"$(dirname "$0")/../adf/pipelines/PL_Superstore_EndToEnd.json"

echo "Done. Data Factory and all ADF objects deployed."
echo "Note: the Linked Service JSON uses an accountKey placeholder —"
echo "edit adf/linkedServices/LS_BlobStorage_Superstore.json or pass it via"
echo "Key Vault / connectionString before deploying in a real environment."
