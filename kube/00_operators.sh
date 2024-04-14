#!/bin/bash

set -e

# https://www.cncf.io/blog/2023/09/29/recommended-architectures-for-postgresql-in-kubernetes/
# Install cloudnative-pg operator
# https://github.com/cloudnative-pg/cloudnative-pg/blob/74ea784f3d3b57cca85100b7f4979e60a0daad48/docs/src/installation_upgrade.md
# 
kubectl apply --server-side -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.2.yaml

kubectl rollout status deployment -n cnpg-system cnpg-controller-manager

kubectl apply --server-side -f namespace.yaml

# https://www.keycloak.org/operator/installation
kubectl apply --server-side -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/24.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply --server-side -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/24.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# ARM64 version built manually with inspiration from:
# https://github.com/keycloak/keycloak/issues/11820#issuecomment-1270305865
# jib config is outdated, jib has been replaced with the docker builder. Use quarkus.docker.buildx.platform instead.
# Enabling jib requires setting:
#   quarkus.container-image.builder=jib
# at: 
#    operator/src/main/resources/application.properties
# and adding the quarkus-container-image-jib maven dependecy to:
#   operator/pom.xml
#
# Both docker and jib builders seem to work with 24.0.2 source.
# Built on Ubuntu 22.04 in WSL2 with maven and openjdk-17-jdk packages installed.

kubectl -n keycloak apply --server-side \
  -f keycloak-operator.yml

kubectl rollout status deployment -n keycloak keycloak-operator 


