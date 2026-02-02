#!/bin/bash
set -e

ACTIVE_ENV=$(cat deploy/active_env)

if [ "$ACTIVE_ENV" = "blue" ]; then
  NEW_ENV="green"
else
  NEW_ENV="blue"
fi

echo "Switching traffic from $ACTIVE_ENV to $NEW_ENV"

cat > nginx/conf.d/upstream.conf <<EOF
upstream backend {
    server backend-${NEW_ENV}:3000;
}
EOF

echo "$NEW_ENV" > deploy/active_env

# Find nginx container via compose label (bulletproof)
NGINX_CONTAINER=$(docker ps \
  --filter "label=com.docker.compose.service=nginx" \
  --format "{{.Names}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "ERROR: Nginx container not running"
  exit 1
fi

docker exec "$NGINX_CONTAINER" nginx -s reload

echo "Traffic successfully switched to $NEW_ENV"
