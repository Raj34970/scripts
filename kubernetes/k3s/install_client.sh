#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.8.167:6443 K3S_TOKEN=K105cdcab77453bbc5f9c801ccd8567600142aca980935832cab309028c111142ba::server:d19bb1e6713d42909d7e3ab6735ed48c sh -
kubectl get nodes

# /usr/local/bin/k3s-agent-uninstall.sh