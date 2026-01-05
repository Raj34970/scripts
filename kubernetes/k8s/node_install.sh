#!/bin/bash

# Update OS and disable swap
apt update && apt upgrade -y
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Install dependencies
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Kubernetes APT repository
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Enable kubelet
systemctl enable --now kubelet

# Join the cluster
# Replace <CONTROL_PLANE_IP>, <TOKEN>, and <HASH> with the output from the control plane
# Example:
# kubeadm join <CONTROL_PLANE_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
