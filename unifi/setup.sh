#!/bin/bash

set -e

sudo dnf install -y wireguard-tools podman dbus-daemon slirp4netns

#cat <<EOF | sudo tee /etc/subuid
#opc:100000:65536
#EOF
#cat <<EOF | sudo tee /etc/subgid
#opc:100000:65536
#EOF
#podman system migrate

sudo loginctl enable-linger $(whoami)
systemctl --user enable --now dbus-broker

cat <<EOF | sudo tee /etc/sysctl.d/99-rootless.conf
net.ipv4.ping_group_range = 0 2147483647
net.ipv4.ip_unprivileged_port_start=0
EOF

sudo sysctl --system

sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF

sudo systemctl daemon-reload
sudo reboot