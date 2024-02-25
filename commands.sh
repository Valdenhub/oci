#!/bin/bash
podman pod rm -f core
podman pod create --publish 8080:80 --network=slirp4netns core

podman run -d --pod=core --name=nxginx \
  --volume $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
  docker.io/nginx:1.25.4-alpine

# podman run --rm --pod=core --name=nxginx-debug \
#   --volume $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
#   docker.io/nginx:1.25.4-alpine

podman run -d --pod=core --name=keycloak \
    --env KEYCLOAK_ADMIN=admin \
    --env KEYCLOAK_ADMIN_PASSWORD=admin \
    --env KC_HOSTNAME_ADMIN=keycloak.localtest.me \
    --env KC_HOSTNAME=keycloak.localtest.me \
    quay.io/keycloak/keycloak:23.0.7 \
    start-dev

# create nginx.conf
#podman run --rm --entrypoint=cat docker.io/nginx /etc/nginx/nginx.conf > nginx.conf
