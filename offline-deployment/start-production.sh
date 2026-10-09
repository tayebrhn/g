#!/usr/bin/env bash
# ============================================================
# TCExam — Production Offline Server Launcher (Linux)
# ============================================================
set -eo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Starting TCExam Production Offline Server...${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is installed and running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker is not running or not installed.${NC}"
    echo "Please start the Docker service (systemctl start docker) and try again."
    exit 1
fi

# 2. Load offline images from bundle if needed
if [ -f "tcexam-offline-bundle.tar" ]; then
    if ! docker image inspect tcexam-app:latest >/dev/null 2>&1; then
        echo -e "${BLUE}[INFO] Loading offline Docker images from tcexam-offline-bundle.tar...${NC}"
        docker load -i tcexam-offline-bundle.tar
    else
        echo -e "${GREEN}[INFO] Offline Docker images already cached.${NC}"
    fi
fi

# 3. Initialize production environment file
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}[INFO] Creating .env from .env.example...${NC}"
    cp .env.example .env
fi

# Read ports and replicas dynamically from .env
APP_PORT=$(grep -E '^[[:space:]]*APP_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "80")
if [ -z "$APP_PORT" ]; then APP_PORT="80"; fi
APP_ALT_PORT=$(grep -E '^[[:space:]]*APP_ALT_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "8080")
if [ -z "$APP_ALT_PORT" ]; then APP_ALT_PORT="8080"; fi
APP_REPLICAS=$(grep -E '^[[:space:]]*APP_REPLICAS=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "1")
if [ -z "$APP_REPLICAS" ]; then APP_REPLICAS="1"; fi

# 4. Launch containers
if [ "$APP_REPLICAS" -gt 1 ] 2>/dev/null; then
    echo -e "${BLUE}[INFO] Starting production cluster with ${APP_REPLICAS} load-balanced app workers...${NC}"
    docker compose up -d --scale app="${APP_REPLICAS}"
else
    echo -e "${BLUE}[INFO] Starting production cluster on ports ${APP_PORT} and ${APP_ALT_PORT}...${NC}"
    docker compose up -d
fi

# 5. Wait for readiness
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
echo -e "${GREEN}  TCExam Production Offline Server is ONLINE!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Candidate Portal (Primary Port ${APP_PORT}):    ${BLUE}http://localhost:${APP_PORT}/public/code/index.php${NC}"
echo -e "  Alternative Access (Port ${APP_ALT_PORT}):       ${BLUE}http://localhost:${APP_ALT_PORT}/public/code/index.php${NC}"
echo -e "  Administrator Suite:                        ${BLUE}http://localhost:${APP_PORT}/admin/code/index.php${NC}"
echo -e "  Default Credentials:                        Username: ${YELLOW}admin${NC}   Password: ${YELLOW}1234${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  LAN / Network Exam Delivery:"
echo -e "    Candidates in this exam room connect to:"
echo -e "    ${BLUE}http://<SERVER_IP>:${APP_PORT}/public/code/index.php${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Management:"
echo -e "    Stop server:   ./stop-production.sh"
echo -e "    Backup data:   ./backup-database.sh"
echo -e "    Apply patch:   ./apply-patch.sh <bundle.tar>"
echo -e "    View logs:     docker compose logs -f"
echo -e "${GREEN}============================================================${NC}"
echo ""
