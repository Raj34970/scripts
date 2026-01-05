#!/bin/bash
apt update && apt upgrade -y
apt install curl -y
curl -sfL https://get.k3s.io | sh -
kubectl get nodes
cat /var/lib/rancher/k3s/server/node-token

# metalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
kubectl get pods -n metallb-system


# /usr/local/bin/k3s-uninstall.sh