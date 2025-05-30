#!/bin/bash
# test_namingtool_api.sh
# This script tests the Azure Naming Tool API using variables from example/terraform.auto.tfvars

# Load variables from terraform.auto.tfvars
VARS_FILE="$(dirname "$0")/example/terraform.auto.tfvars"

# Helper to extract value from tfvars
get_tfvar() {
  local key="$1"
  grep -E "^${key}[[:space:]]*=" "$VARS_FILE" | sed -E "s/^${key}[[:space:]]*=[[:space:]]*\"?([^\"]*)\"?.*/\1/"
}

API_KEY=$(get_tfvar api_key)
CLIENT_ID=$(get_tfvar client_id)
TENANT_ID=$(get_tfvar tenant_id)
CLIENT_SECRET=$(get_tfvar client_secret)
API_APP_ID=$(get_tfvar api_app_id)
API_URL=$(get_tfvar api_url)
RESOURCE_TYPE=$(get_tfvar resource_type)

# Extract components from tfvars (assumes all are present)
RESOURCE_ENV=$(grep 'ResourceEnvironment' "$VARS_FILE" | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/')
RESOURCE_INSTANCE=$(grep 'ResourceInstance' "$VARS_FILE" | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/')
RESOURCE_LOCATION=$(grep 'ResourceLocation' "$VARS_FILE" | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/')
RESOURCE_PROJAPPSVC=$(grep 'ResourceProjAppSvc' "$VARS_FILE" | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/')

# Get access token
ACCESS_TOKEN=$(curl -s -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID&scope=api://$API_APP_ID/.default&client_secret=$CLIENT_SECRET&grant_type=client_credentials" | jq -r .access_token)

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
  echo "Failed to obtain access token."
  exit 1
fi

echo "Access token obtained. Calling Azure Naming Tool API..."

# Call the API
curl -X POST "${API_URL%/}/api/ResourceNamingRequests/RequestName" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "APIKey: $API_KEY" \
  -d '{
    "resourceEnvironment": "'$RESOURCE_ENV'",
    "resourceInstance": "'$RESOURCE_INSTANCE'",
    "resourceLocation": "'$RESOURCE_LOCATION'",
    "resourceProjAppSvc": "'$RESOURCE_PROJAPPSVC'",
    "resourceType": "'$RESOURCE_TYPE'"
  }'
