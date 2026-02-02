#!/bin/bash
set -e

ACTIVE_ENV=$(cat deploy/active_env)

if [ "$ACTIVE_ENV" = "blue" ]; then
  NEW_ENV="green"
else
  NEW_ENV="blue"
fi

echo "Switching traffic from $ACTIVE_ENV to $NEW_ENV"

# Update upstream config
cat > nginx/conf.d/upstream.conf <<EOF
upstream backend {
    server backend-${NEW_ENV}:3000;
}
EOF

# Update active environment
echo "$NEW_ENV" > deploy/active_env

# Dynamically find nginx container
NGINX_CONTAINER=$(docker ps \
  --filter "ancestor=nginx:1.25-alpine" \
  --format "{{.Names}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "ERROR: Nginx container not found"
  exit 1
fi

# Reload nginx safely
docker exec "$NGINX_CONTAINER" nginx -s reload

echo "Traffic successfully switched to $NEW_ENV"

