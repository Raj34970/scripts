#!/bin/bash

# setting the vars
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
RETURN_CODE=0

if [ ! -f "$(dirname "$0")/.env" ]; then RETURN_CODE=1; critical "No environment file, use the sample file"; fi
set -a

source "$(dirname "$0")/.env"
set +a

# Create backup directory if not exists
sudo mkdir -p "${BACKUP_DIR}"

sudo chown jenkins:jenkins /mnt/data/backups/

echo "🔹 Starting Immich SQL backup at ${TIMESTAMP}..."

# Backup MariaDB database inside the container
echo "🗄️ Dumping Immich database...(1/3)"
sudo docker exec -t immich_postgres sh -c "pg_dumpall --clean --if-exists --username='${DB_USERNAME}'" | gzip > "${BACKUP_DIR}/immich-db_${TIMESTAMP}.sql.gz"

echo "✅ Backup completed! DB zip saved to: ${BACKUP_DIR}/immich-db_${TIMESTAMP}.sql.gz"
