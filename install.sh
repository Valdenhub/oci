#!/bin/bash

#WG_ADDRESS="192.168.128.100"

INSTALL_K3S_VERSION="v1.29.2+k3s1"
INSTALL_K3S_EXEC="server --cluster-init --selinux
    --cluster-domain home.arpa
    --cluster-cidr 192.168.232.0/21
    --service-cidr 192.168.240.0/21
    --cluster-dns 192.168.240.10
"

    # --flannel-iface wg0
    # --bind-address $WG_ADDRESS
    # --node-ip $WG_ADDRESS
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$INSTALL_K3S_VERSION INSTALL_K3S_EXEC=$INSTALL_K3S_EXEC sh -
