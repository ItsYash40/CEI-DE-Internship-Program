#!/usr/bin/env bash
# ==============================================================================
# 06-run-pipeline.sh
# Triggers the pipeline on demand and polls the run status until it finishes.
# ==============================================================================
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo "Triggering pipeline run: PL_Superstore_EndToEnd ..."
RUN_ID=$(az datafactory pipeline create-run \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --pipeline-name "PL_Superstore_EndToEnd" \
  --query "runId" -o tsv)

echo "Run ID: $RUN_ID"
echo "Polling status ..."

STATUS="InProgress"
while [ "$STATUS" == "InProgress" ] || [ "$STATUS" == "Queued" ]; do
  sleep 10
  STATUS=$(az datafactory pipeline-run show \
    --resource-group "$RESOURCE_GROUP" \
    --factory-name "$DATA_FACTORY_NAME" \
    --run-id "$RUN_ID" \
    --query "status" -o tsv)
  echo "  Status: $STATUS"
done

echo "Final status: $STATUS"

echo ""
echo "Activity run details:"
az datafactory pipeline-run show \
  --resource-group "$RESOURCE_GROUP" \
  --factory-name "$DATA_FACTORY_NAME" \
  --run-id "$RUN_ID" \
  --output table
