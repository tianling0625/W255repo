#!/bin/bash

# set env
TF_STATE="../terraform.tfstate"
export DOMAIN_NAME=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azurerm_dns_zone"))][].instances[].attributes.name' -r)
export AZ_AKS_NAME=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azurerm_kubernetes_cluster"))][].instances[].attributes.name' -r)
export AZ_RESOURCE_GROUP=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azurerm_resource_group"))][] | select(.name=="rg").instances[].attributes.name' -r)
export AZ_TENANT_ID=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azurerm_subscription"))][].instances[].attributes.tenant_id' -r)
export AZ_SUBSCRIPTION_ID=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azurerm_subscription"))][].instances[].attributes.subscription_id' -r)
export SP_CLIENT_ID=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azuread_application"))][].instances[].attributes.application_id' -r)
export SP_CLIENT_SECRET=$(cat ${TF_STATE} | jq '[.resources[] | select(.type | contains("azuread_service_principal_password"))][].instances[].attributes.value' -r)
export ACME_ISSUER_EMAIL="winegarj@berkeley.edu"

# read from .env for GITHUB_PAT, etc.
set -o allexport
source .env
set +o allexport

# add AKS to context
az aks get-credentials --name ${AZ_AKS_NAME} --resource-group ${AZ_RESOURCE_GROUP} --overwrite-existing --admin

# Use helm to deploy, requires helm-diff to be installed
# helm plugin install https://github.com/databus23/helm-diff
helmfile sync

## Not yet helmified
kubectl apply -f grafana.yaml
kubectl apply -f prometheus.yaml
kubectl apply -f kiali.yaml
kubectl apply -f jaeger.yaml
kubectl apply -f kiali.yaml
