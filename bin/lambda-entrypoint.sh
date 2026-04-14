#!/bin/sh

set -e

if [ -n "$SECRETS_ARN" ]; then
  SECRETS=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRETS_ARN" \
    --query SecretString \
    --output text)

  export_secret() {
    val=$(echo "$SECRETS" | jq -r ".$1")
    if [ "$val" != "null" ]; then
      export "$1=$val"
    fi
  }

  export_secret AWS_BUCKET
  export_secret AWS_ACCESS_KEY_ID
  export_secret AWS_SECRET_ACCESS_KEY
  export_secret AWS_REGION
  export_secret SLACK_WEBHOOK_URL
  export_secret OMNIAUTH_GITHUB_CLIENT_ID
  export_secret OMNIAUTH_GITHUB_CLIENT_SECRET
  export_secret OMNIAUTH_GITHUB_ORGANIZATION
  export_secret DATABASE_URL
fi

$(dirname $0)/rails server -b 0.0.0.0 -p 8080
