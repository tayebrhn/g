#!/usr/bin/env bash
set -e

# ============================================================
# TCExam — Production Offline Cluster Status Dashboard (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  TCExam Production Cluster Status & Health Dashboard${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker daemon is not running.${NC}"
    exit 1
fi

# 2. Read ports from .env
APP_PORT=$(grep -E '^[[:space:]]*APP_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "80")
if [ -z "$APP_PORT" ]; then APP_PORT="80"; fi
APP_ALT_PORT=$(grep -E '^[[:space:]]*APP_ALT_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "8080")
if [ -z "$APP_ALT_PORT" ]; then APP_ALT_PORT="8080"; fi
APP_REPLICAS=$(grep -E '^[[:space:]]*APP_REPLICAS=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "1")
if [ -z "$APP_REPLICAS" ]; then APP_REPLICAS="1"; fi

echo -e "${YELLOW}[1/4] Container Services State:${NC}"
echo "------------------------------------------------------------"
docker compose ps
echo ""

echo -e "${YELLOW}[2/4] Live Resource Utilization:${NC}"
echo "------------------------------------------------------------"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
echo ""

echo -e "${YELLOW}[3/4] Health & Connectivity Probes:${NC}"
echo "------------------------------------------------------------"
if curl --max-time 3 -s -f "http://localhost:${APP_PORT}/health.txt" >/dev/null 2>&1; then
    echo -e "  [${GREEN}PASS${NC}] Web Proxy (Port ${APP_PORT}):   HEALTHY (HTTP 200 OK)"
elif curl --max-time 3 -s -f "http://localhost:${APP_ALT_PORT}/health.txt" >/dev/null 2>&1; then
    echo -e "  [${GREEN}PASS${NC}] Web Proxy (Port ${APP_ALT_PORT}): HEALTHY (HTTP 200 OK)"
else
    echo -e "  [${RED}FAIL${NC}] Web Proxy:             UNREACHABLE (HTTP probe failed)"
fi

if docker compose exec -T db mariadb-admin ping -u root -proot_secret_pass >/dev/null 2>&1; then
    echo -e "  [${GREEN}PASS${NC}] Database Engine:        HEALTHY (Accepting SQL connections)"
else
    echo -e "  [${RED}FAIL${NC}] Database Engine:        UNHEALTHY or STOPPED"
fi
echo ""

echo -e "${YELLOW}[4/4] Endpoints & Access URLs:${NC}"
echo "------------------------------------------------------------"
echo -e "  Candidate Portal:  ${BLUE}http://localhost:${APP_PORT}/public/code/index.php${NC}"
echo -e "  Alternative Port:  ${BLUE}http://localhost:${APP_ALT_PORT}/public/code/index.php${NC}"
echo -e "  Admin Suite:       ${BLUE}http://localhost:${APP_PORT}/admin/code/index.php${NC}"
echo -e "  Default Admin:     Username: ${YELLOW}admin${NC}   Password: ${YELLOW}1234${NC}"
if [ "$APP_REPLICAS" -gt 1 ] 2>/dev/null; then
    echo -e "  App Replicas:      ${YELLOW}${APP_REPLICAS} workers (Load-Balanced)${NC}"
fi
echo -e "${BLUE}============================================================${NC}"
echo ""
