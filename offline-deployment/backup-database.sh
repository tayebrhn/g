#!/usr/bin/env bash
set -eo pipefail
cd "$(dirname "$0")"

mkdir -p backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backups/tcexam_backup_${TIMESTAMP}.sql"

echo "============================================================"
echo "  Backing up TCExam database to ${BACKUP_FILE}..."
echo "============================================================"

docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "${BACKUP_FILE}"

echo "[SUCCESS] Backup completed successfully!"
echo "File: ${BACKUP_FILE}"
echo "============================================================"
