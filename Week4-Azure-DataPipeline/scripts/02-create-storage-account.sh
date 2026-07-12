#!/usr/bin/env bash
# ==============================================================================
# 02-create-storage-account.sh
# Creates the Storage Account and both Blob containers (raw-data, processed-data)
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo "Creating storage account: $STORAGE_ACCOUNT ..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

echo "Fetching storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[0].value" -o tsv)

echo "Creating container: $RAW_CONTAINER ..."
az storage container create \
  --name "$RAW_CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY" \
  --public-access off

echo "Creating container: $PROCESSED_CONTAINER ..."
az storage container create \
  --name "$PROCESSED_CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY" \
  --public-access off

echo "Done. Storage account and containers created."
