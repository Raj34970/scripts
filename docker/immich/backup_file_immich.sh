#!/bin/bash

# setting the vars
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
RETURN_CODE=0

# loading the .env file
if [ ! -f "$(dirname "$0")/.env" ]; then RETURN_CODE=1; critical "No environment file, use the sample file"; fi
set -a
source "$(dirname "$0")/.env"
set +a

# Create backup directory if not exists
sudo mkdir -p "${BACKUP_DIR}"

echo "🔹 Starting Nextcloud files backup at ${TIMESTAMP}..."

# Backup Immich external data
echo "📂 Backing up Immich external data... (2/3)"
tar czf "${BACKUP_DIR}/immich_external_lib_${TIMESTAMP}.tar.gz" -C "${IMMICH_EXTERNAL_LIB}" import

# Backup Immich app data
echo "📂 Backing up Immich uploads data...(3/3)"
sudo tar czf "${BACKUP_DIR}/immich_app_data_${TIMESTAMP}.tar.gz" -C "${IMMICH_APP_DATA}" library

echo "✅ Backup completed! Files are stored in: ${BACKUP_DIR}"

# Optional: Remove old backups (older than 7 days)
sudo find "${BACKUP_DIR}" -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;

echo "🗑️ Old backups older than 7 days deleted."

exit 0
