#!/bin/bash

set -e

sudo firewall-cmd --new-zone=wireguard --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --zone=wireguard --change-interface=wg0 --permanent

sudo firewall-cmd --zone=wireguard --add-port=443/tcp --permanent
sudo firewall-cmd --zone=wireguard --add-port=3478/udp --permanent
sudo firewall-cmd --zone=wireguard --add-port=10001/udp --permanent
sudo firewall-cmd --zone=wireguard --add-port=8080/tcp --permanent

sudo firewall-cmd --zone=wireguard --add-port=1900/udp --permanent
sudo firewall-cmd --zone=wireguard --add-port=8843/tcp --permanent
sudo firewall-cmd --zone=wireguard --add-port=8880/tcp --permanent
sudo firewall-cmd --zone=wireguard --add-port=6789/tcp --permanent
sudo firewall-cmd --zone=wireguard --add-port=5514/tcp --permanent

sudo firewall-cmd --reload
