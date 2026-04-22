#!/bin/bash
set -e

IMAGE_NAME="lxhome-ansible-runner"

echo "--- Building Docker Image ---"
docker compose build

echo "--- Importing to K3s ---"
docker save "${IMAGE_NAME}:local" | k3s ctr images import -

echo "--- Cleaning up old job ---"
kubectl delete job "${IMAGE_NAME}" --ignore-not-found=true

echo "--- Deploying the the kubernetes pods ---"
kubectl apply -f job.yaml

echo "--- Waiting for job to finish ---"
kubectl wait --for=condition=complete job/"${IMAGE_NAME}" --timeout=300s

echo "--- Fetching Results ---"
kubectl logs job/"${IMAGE_NAME}"