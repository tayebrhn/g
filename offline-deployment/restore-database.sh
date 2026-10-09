#!/usr/bin/env bash
set -e

# ============================================================
# TCExam — Production Database Restoration Utility (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  TCExam Production Database Restoration Utility${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker daemon is not running.${NC}"
    exit 1
fi

if [ ! -d "backups" ]; then
    echo -e "${RED}[ERROR] No 'backups' directory found.${NC}"
    exit 1
fi

# List backup files
files=(backups/*.sql)
if [ ! -e "${files[0]}" ]; then
    echo -e "${RED}[ERROR] No .sql backup files found in 'backups/' directory.${NC}"
    exit 1
fi

echo -e "${YELLOW}Available Database Backups in 'backups/':${NC}"
echo "------------------------------------------------------------"
index=1
declare -a file_list
for f in backups/*.sql; do
    echo -e "  [${index}] $(basename "$f")"
    file_list[$index]="$f"
    index=$((index + 1))
done
echo "------------------------------------------------------------"

read -p "Select backup number to restore [1-$((index - 1))]: " choice
if [ -z "$choice" ] || [ -z "${file_list[$choice]}" ]; then
    echo -e "${YELLOW}[INFO] Invalid selection or cancelled.${NC}"
    exit 0
fi

selected_file="${file_list[$choice]}"

echo ""
echo -e "${RED}[WARNING] You are about to restore: $selected_file${NC}"
echo "Existing database content will be replaced."
read -p "Are you sure you want to proceed? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}[INFO] Restoration cancelled.${NC}"
    exit 0
fi

# Safety snapshot
timestamp=$(date +"%Y%m%d_%H%M%S")
safety_backup="backups/pre_restore_safety_${timestamp}.sql"
echo -e "${BLUE}[INFO] Creating pre-restore safety snapshot: ${safety_backup}...${NC}"
docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "$safety_backup" 2>/dev/null || true

echo -e "${BLUE}[INFO] Restoring database from: $selected_file...${NC}"
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "$selected_file"

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  [SUCCESS] Database Restored Successfully!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Restored File:       ${selected_file}"
echo -e "  Safety Snapshot:     ${safety_backup}"
echo -e "${GREEN}============================================================${NC}"
echo ""
