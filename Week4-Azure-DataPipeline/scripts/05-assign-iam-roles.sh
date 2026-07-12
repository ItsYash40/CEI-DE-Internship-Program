#!/usr/bin/env bash
# ==============================================================================
# 05-assign-iam-roles.sh
# Grants Azure Data Factory's system-assigned managed identity access to the
# Storage Account (Reader + Blob Data Contributor), following least-privilege
# best practice instead of relying solely on the account key.
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo "Fetching Data Factory's managed identity principal ID ..."
ADF_PRINCIPAL_ID=$(az datafactory show \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --query "identity.principalId" -o tsv)

STORAGE_ID=$(az storage account show \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "id" -o tsv)

echo "Assigning 'Reader' role ..."
az role assignment create \
  --assignee "$ADF_PRINCIPAL_ID" \
  --role "Reader" \
  --scope "$STORAGE_ID"

echo "Assigning 'Storage Blob Data Contributor' role ..."
az role assignment create \
  --assignee "$ADF_PRINCIPAL_ID" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ID"

echo "Done. ADF's managed identity now has Reader + Blob Data Contributor on the storage account."

echo ""
echo "Current role assignments on the storage account:"
az role assignment list --scope "$STORAGE_ID" --output table
