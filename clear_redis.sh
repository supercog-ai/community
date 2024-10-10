#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Set default values if not provided in .env
REDIS_HOST=${REDIS_HOST:-localhost}
REDIS_PORT=${REDIS_PORT:-6379}
REDIS_PASSWORD=${REDIS_PASSWORD:-}

# Function to execute Redis command
execute_redis_command() {
    if [ -n "$REDIS_PASSWORD" ]; then
        docker run --rm --network host redis:alpine redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -a "$REDIS_PASSWORD" "$@"
    else
        docker run --rm --network host redis:alpine redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" "$@"
    fi
}

# Check Redis connection
if ! execute_redis_command ping > /dev/null 2>&1; then
    echo "Failed to connect to Redis at $REDIS_HOST:$REDIS_PORT"
    exit 1
fi

echo "Connected to Redis at $REDIS_HOST:$REDIS_PORT"

# Get all keys
keys=$(execute_redis_command keys '*')

if [ -z "$keys" ]; then
    echo "No keys found in Redis."
    exit 0
fi

# Count the number of keys
key_count=$(echo "$keys" | wc -l)

# Delete all keys
execute_redis_command del $keys > /dev/null 2>&1

echo "Deleted $key_count keys from Redis."
