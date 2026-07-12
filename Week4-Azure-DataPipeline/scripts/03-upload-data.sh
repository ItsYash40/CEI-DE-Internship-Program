#!/usr/bin/env bash
# ==============================================================================
# 03-upload-data.sh
# Uploads the Superstore CSV (downloaded manually from Kaggle) into the
# raw-data container.
#
# Download the dataset first from:
#   https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
# and place "Sample - Superstore.csv" inside the /data folder of this repo.
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

if [ ! -f "$LOCAL_CSV_PATH" ]; then
  echo "ERROR: File not found at $LOCAL_CSV_PATH"
  echo "Download the dataset from Kaggle and place it in the /data folder first."
  exit 1
fi

ACCOUNT_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[0].value" -o tsv)

echo "Uploading $LOCAL_CSV_PATH to container '$RAW_CONTAINER' ..."
az storage blob upload \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY" \
  --container-name "$RAW_CONTAINER" \
  --name "Sample - Superstore.csv" \
  --file "$LOCAL_CSV_PATH" \
  --overwrite

echo "Done. File uploaded to raw-data container."
