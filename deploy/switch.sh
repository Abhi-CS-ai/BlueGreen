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

# Reload Nginx safely
docker exec nginx-proxy nginx -s reload

echo "Traffic successfully switched to $NEW_ENV"
