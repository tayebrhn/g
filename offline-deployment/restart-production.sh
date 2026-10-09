#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# ============================================================
# TCExam — Production Offline Cluster Restarter (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Restarting TCExam Production Offline Cluster...${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker daemon is not running.${NC}"
    exit 1
fi

# 2. Read ports and replicas from .env
APP_PORT=$(grep -E '^[[:space:]]*APP_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "80")
if [ -z "$APP_PORT" ]; then APP_PORT="80"; fi
APP_ALT_PORT=$(grep -E '^[[:space:]]*APP_ALT_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "8080")
if [ -z "$APP_ALT_PORT" ]; then APP_ALT_PORT="8080"; fi
APP_REPLICAS=$(grep -E '^[[:space:]]*APP_REPLICAS=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "1")
if [ -z "$APP_REPLICAS" ]; then APP_REPLICAS="1"; fi

# 3. Restart containers
echo -e "${BLUE}[INFO] Restarting TCExam containers...${NC}"
if [ "$APP_REPLICAS" -gt 1 ] 2>/dev/null; then
    docker compose up -d --force-recreate --scale app="${APP_REPLICAS}"
else
    docker compose restart
fi

# 4. Wait for web service readiness
echo -e "${BLUE}[INFO] Waiting for web service readiness on port ${APP_PORT}...${NC}"
RETRIES=15
while [ $RETRIES -gt 0 ]; do
    if curl --max-time 2 -s -f "http://localhost:${APP_PORT}/health.txt" >/dev/null 2>&1 || curl --max-time 2 -s -f "http://localhost:${APP_ALT_PORT}/health.txt" >/dev/null 2>&1; then
        break
    fi
    sleep 2
    RETRIES=$((RETRIES - 1))
done

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  TCExam Cluster Restarted Successfully!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Candidate Portal (Port ${APP_PORT}):    ${BLUE}http://localhost:${APP_PORT}/public/code/index.php${NC}"
echo -e "  Alternative Port (Port ${APP_ALT_PORT}):  ${BLUE}http://localhost:${APP_ALT_PORT}/public/code/index.php${NC}"
echo -e "  Administrator Suite:           ${BLUE}http://localhost:${APP_PORT}/admin/code/index.php${NC}"
if [ "$APP_REPLICAS" -gt 1 ] 2>/dev/null; then
    echo -e "  Load Balancing:                ${YELLOW}${APP_REPLICAS} active app replicas${NC}"
fi
echo -e "${GREEN}============================================================${NC}"
echo ""
