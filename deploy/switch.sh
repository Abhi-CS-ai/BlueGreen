#!/bin/bash
set -e

STATE_FILE="/opt/bluegreen/active_env"

if [ ! -f "$STATE_FILE" ]; then
  echo "green" > "$STATE_FILE"
fi

ACTIVE_ENV=$(cat "$STATE_FILE")

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

echo "$NEW_ENV" > "$STATE_FILE"

NGINX_CONTAINER=$(docker ps \
  --filter "label=com.docker.compose.service=nginx" \
  --format "{{.Names}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "ERROR: Nginx container not running"
  exit 1
fi

docker exec "$NGINX_CONTAINER" nginx -s reload

echo "Traffic successfully switched to $NEW_ENV"
