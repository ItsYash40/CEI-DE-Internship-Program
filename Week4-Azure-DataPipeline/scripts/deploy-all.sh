#!/usr/bin/env bash
# ==============================================================================
# deploy-all.sh
# Runs the full project end-to-end, in order. Requires Azure CLI installed
# and "Sample - Superstore.csv" already placed inside /data.
# ==============================================================================
set -euo pipefail
cd "$(dirname "$0")"

./01-create-resource-group.sh
./02-create-storage-account.sh
./03-upload-data.sh
./04-create-data-factory.sh
./05-assign-iam-roles.sh
./06-run-pipeline.sh

echo ""
echo "=============================================="
echo " All done! Full pipeline deployed and executed."
echo "=============================================="
