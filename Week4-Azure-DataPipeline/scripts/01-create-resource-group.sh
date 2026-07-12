#!/usr/bin/env bash
# ==============================================================================
# 01-create-resource-group.sh
# Creates the Resource Group that will contain every resource in this project.
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo "Logging in (opens browser)..."
az login

echo "Creating resource group: $RESOURCE_GROUP in $LOCATION ..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

echo "Done. Resource group '$RESOURCE_GROUP' created."
