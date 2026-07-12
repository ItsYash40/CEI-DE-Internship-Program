#!/usr/bin/env bash
# ==============================================================================
# variables.sh
# Central place to configure names used across every script.
# Edit these before running anything (storage account name must be globally
# unique across ALL of Azure, so change it to something only you would pick).
# ==============================================================================

export RESOURCE_GROUP="rg-superstore-adf-project"
export LOCATION="centralindia"                     # change to your nearest region, e.g. eastus
export STORAGE_ACCOUNT="stsuperstoreadf2026"        # must be globally unique, lowercase, no spaces
export RAW_CONTAINER="raw-data"
export PROCESSED_CONTAINER="processed-data"
export DATA_FACTORY_NAME="adf-superstore-project"   # must be globally unique
export LOCAL_CSV_PATH="../data/Sample - Superstore.csv"
