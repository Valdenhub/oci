#!/bin/bash

set -e

mkdir -p ~/.config/containers/systemd

MONGO_PASS=$(systemd-ask-password MONGO_PASS)
MONGO_INITDB_ROOT_PASSWORD=$(systemd-ask-password MONGO_INITDB_ROOT_PASSWORD)

cat <<EOF | tee ~/.config/containers/systemd/unifi-configs.yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: unifi-config
data:
  PUID: "1000"
  PGID: "1000"
  TZ: "Etc/UTC"
  MONGO_USER: "unifi"
  MONGO_PASS: "$MONGO_PASS"
  MONGO_HOST: "localhost"
  MONGO_PORT: "27017"
  MONGO_DBNAME: "unifi"
  MONGO_AUTHSOURCE: "admin"
  MEM_LIMIT: "1024"
  MEM_STARTUP: "1024"
  MONGO_TLS: ""
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: unifi-db-config
data:
  MONGO_INITDB_ROOT_USERNAME: "root"
  MONGO_INITDB_ROOT_PASSWORD: "$MONGO_INITDB_ROOT_PASSWORD"
  MONGO_USER: "unifi"
  MONGO_PASS: "$MONGO_PASS"
  MONGO_DBNAME: "unifi"
  MONGO_AUTHSOURCE: "admin"

EOF

cp unifi.yaml ~/.config/containers/systemd/unifi.yaml

cat <<EOF | tee ~/.config/containers/systemd/unifi.kube
[Unit]
Description=Unifi Network Application
After=local-fs.target network.target

[Kube]
ConfigMap=unifi-configs.yaml
Yaml=unifi.yaml

Network=slirp4netns:port_handler=slirp4netns

PublishPort=443:8443/tcp
PublishPort=3478:3478/udp
PublishPort=10001:10001/udp
PublishPort=8080:8080/tcp
# OPTIONAL PORTS
# Required for Make controller discoverable on L2 network option
PublishPort=1900:1900/udp
# Unifi guest portal HTTPS redirect port
PublishPort=8843:8843/tcp
# Unifi guest portal HTTP redirect port
PublishPort=8880:8880/tcp
# For mobile throughput test
PublishPort=6789:6789/tcp
# Remote syslog port
PublishPort=5514:5514/tcp

[Install]
WantedBy=multi-user.target default.target
EOF

systemctl --user daemon-reload