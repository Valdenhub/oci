#!/bin/bash

kubectl -n keycloak create secret tls keycloak-tls-secret \
    --cert ../certs/auth.home.arpa.crt \
    --key /dev/stdin<<<$(systemd-ask-password "Keycloak private key passphrase" \
                        | openssl rsa -passin stdin -in ../certs/auth.home.arpa.key)

kubectl -n keycloak apply --server-side -f secrets.yaml