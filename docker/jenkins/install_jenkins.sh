#!/bin/bash
mkdir -p /var/lib/jenkins
chown -R 1000:1000 /var/lib/jenkins
docker compose up -d