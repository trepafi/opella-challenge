#!/usr/bin/env bash
#
# Bootstrap the Azure Storage Account used for Terraform remote state.
# Run this once before the first `terraform init`.
#
# Prerequisites:
#   - Azure CLI installed and logged in (`az login`)
#   - Correct subscription selected (`az account set --subscription <id>`)
#
set -euo pipefail

RESOURCE_GROUP="rg-opella-tfstate"
LOCATION="eastus"
STORAGE_ACCOUNT="stopellatfstatelubert"
CONTAINER="tfstate"

echo "==> Creating resource group: ${RESOURCE_GROUP}"
az group create \
  --name "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --tags environment=shared project=opella managed_by=terraform-bootstrap

echo "==> Creating storage account: ${STORAGE_ACCOUNT}"
az storage account create \
  --name "${STORAGE_ACCOUNT}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --tags environment=shared project=opella managed_by=terraform-bootstrap

echo "==> Creating blob container: ${CONTAINER}"
az storage container create \
  --name "${CONTAINER}" \
  --account-name "${STORAGE_ACCOUNT}" \
  --auth-mode login

echo "==> Done. Terraform backend is ready."
echo "    Resource Group:   ${RESOURCE_GROUP}"
echo "    Storage Account:  ${STORAGE_ACCOUNT}"
echo "    Container:        ${CONTAINER}"
