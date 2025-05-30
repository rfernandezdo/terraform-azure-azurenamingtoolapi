#!/bin/bash
# Usage: get_token.sh <tenant_id> <client_id> <api_app_id> <client_secret>
# Make sure jq is installed for the get_token.sh script to work
# sudo apt-get install jq
chmod +x get_token.sh

set -e

# Hide secrets in output
MASKED_CLIENT_ID="${2:0:4}****${2: -4}"
MASKED_API_APP_ID="${3:0:4}****${3: -4}"

RESPONSE=$(curl -s -X POST "https://login.microsoftonline.com/$1/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$2&scope=api://$3/.default&client_secret=$4&grant_type=client_credentials")
TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')
if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "Error obtaining token for client_id: $MASKED_CLIENT_ID, api_app_id: $MASKED_API_APP_ID" >&2
  exit 1
fi
# Output only the token, not secrets
echo "{\"access_token\": \"$TOKEN\"}"
