#!/usr/bin/env bash
# ============================================================
# TCExam — Apply Offline Production Patch / Update (Linux)
# ============================================================
set -eo pipefail
cd "$(dirname "$0")"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Applying TCExam Offline Production Patch / Update...${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker is not running or not installed.${NC}"
    exit 1
fi

# 2. Verify bundle archive is present
if [ ! -f "tcexam-offline-bundle.tar" ]; then
    if [ -f "../tcexam-offline-bundle.tar" ]; then
        cp -f "../tcexam-offline-bundle.tar" "tcexam-offline-bundle.tar"
    elif [ -f "../docker/tcexam-offline-bundle.tar" ]; then
        cp -f "../docker/tcexam-offline-bundle.tar" "tcexam-offline-bundle.tar"
    fi
fi
if [ ! -f "tcexam-offline-bundle.tar" ]; then
    echo -e "${RED}[ERROR] 'tcexam-offline-bundle.tar' not found in $(pwd).${NC}"
    echo "Please copy the updated bundle file into this folder and retry."
    exit 1
fi

# 3. Take safety pre-patch database backup
mkdir -p backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PRE_PATCH_BACKUP="backups/pre_patch_backup_${TIMESTAMP}.sql"

echo -e "${BLUE}[1/3] Creating safety database backup before applying patch...${NC}"
if docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "${PRE_PATCH_BACKUP}" 2>/dev/null; then
    echo -e "${GREEN}[SUCCESS] Pre-patch database backup saved to: ${PRE_PATCH_BACKUP}${NC}"
else
    echo -e "${YELLOW}[WARNING] Database was offline or not yet initialized; proceeding with update.${NC}"
fi

# 4. Load updated Docker images
echo -e "${BLUE}[2/3] Loading updated Docker images from tcexam-offline-bundle.tar...${NC}"
docker load -i tcexam-offline-bundle.tar

# 5. Recreate application and web containers with updated image
echo -e "${BLUE}[3/3] Replacing running containers with updated image (zero data loss)...${NC}"
docker compose stop app web >/dev/null 2>&1 || true
docker volume rm tcexam_app_code >/dev/null 2>&1 || true
docker compose up -d --force-recreate app web

APP_PORT=80
if [ -f ".env" ]; then
    VAL=$(grep -E '^[[:space:]]*APP_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r')
    if [ -n "$VAL" ]; then APP_PORT="$VAL"; fi
fi

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  TCExam Patch / Update Applied Successfully!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  - All existing database records, exams, and users are preserved."
echo -e "  - Pre-patch safety backup: ${YELLOW}${PRE_PATCH_BACKUP}${NC}"
echo -e "  - Candidate Portal:  ${BLUE}http://localhost:${APP_PORT}/public/code/index.php${NC}"
echo -e "  - Admin Suite:       ${BLUE}http://localhost:${APP_PORT}/admin/code/index.php${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
