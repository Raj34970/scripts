#!/bin/bash

apt update && apt upgrade -y
apt install apt-transport-https ca-certificates curl gnupg -y

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Enable modules for Kubernetes networking
modprobe overlay
modprobe br_netfilter
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Install containerd
apt install -y containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install CNI plugins (so kubelet dependency satisfied)
CNI_VERSION="v1.3.0"
ARCH="amd64"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

# Add Kubernetes repos
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes
apt update
apt install -y kubectl kubelet kubeadm
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet

# Initialize control plane
kubeadm init --pod-network-cidr=10.244.0.0/16

# Setup kubeconfig
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install a CNI plugin
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Print join command
kubeadm token create --print-join-command



# kubeadm join 192.168.8.164:6443 --token mb9dvn.3ubbtxgxza66c2sz --discovery-token-ca-cert-hash sha256:e99de4b28f1abd193b22a540b79bb7ca8206b0c661f8d31c42cba2dd48f1448d