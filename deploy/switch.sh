#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# 1. Determine the active and new environments
# If the file doesn't exist, we assume 'blue' is active and switch to 'green'
if [ -f deploy/active_env ]; then
    ACTIVE_ENV=$(cat deploy/active_env)
else
    ACTIVE_ENV="blue"
fi

if [ "$ACTIVE_ENV" = "blue" ]; then
    NEW_ENV="green"
else
    NEW_ENV="blue"
fi

echo "Switching traffic from $ACTIVE_ENV to $NEW_ENV..."

# 2. Update the Nginx upstream configuration
# This points the 'backend' group to the new color's container
cat > nginx/conf.d/upstream.conf <<EOF
upstream backend {
    server backend-${NEW_ENV}:3000;
}
EOF

# 3. Save the new environment state
echo "$NEW_ENV" > deploy/active_env

# 4. Find the Nginx container name
# We filter by the label created by docker compose -p bluegreen
NGINX_CONTAINER=$(docker ps \
  --filter "label=com.docker.compose.service=nginx" \
  --format "{{.Names}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
    echo "ERROR: Nginx container 'nginx-proxy' not found or not running."
    exit 1
fi

# 5. Reload Nginx using SIGHUP
# This is the "bulletproof" way to reload config without PID file errors
echo "Sending reload signal to $NGINX_CONTAINER..."
docker kill -s HUP "$NGINX_CONTAINER"

echo "------------------------------------------------"
echo "✅ SUCCESS: Traffic successfully switched to $NEW_ENV"
echo "------------------------------------------------"