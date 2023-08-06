#!/bin/bash
set -e

echo $PATH

cleanup() {
    rm ./config/master.key
}

trap cleanup EXIT

rm -f /VehicleMinders/tmp/pids/server.pid || true

secrets=$(aws secretsmanager get-secret-value --secret-id rds_redis_secrets --query 'SecretString' --output text)
export DATABASE_URL=$(echo $secrets | jq -r '.rds_url')
export REDIS_URL=$(echo $secrets | jq -r '.redis_endpoint')
export MASTER_KEY=$(echo $secrets | jq -r '.master_key')

echo "$MASTER_KEY" > ./config/master.key

exec "$@"