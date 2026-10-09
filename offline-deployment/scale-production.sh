#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# ============================================================
# TCExam — Horizontal Scale & Load Balancing (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  TCExam Application Replica Scaling & Load Balancing${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker daemon is not running.${NC}"
    exit 1
fi

REPLICAS=$1
if [ -z "$REPLICAS" ]; then
    read -p "Enter desired number of app worker replicas [1-8]: " REPLICAS
fi

if [ -z "$REPLICAS" ]; then REPLICAS=2; fi

if [ "$REPLICAS" -lt 1 ] 2>/dev/null; then
    echo -e "${RED}[ERROR] Replicas must be at least 1.${NC}"
    exit 1
fi

if [ "$REPLICAS" -gt 16 ] 2>/dev/null; then
    echo -e "${RED}[ERROR] Maximum supported replicas is 16.${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Scaling application service to ${REPLICAS} replicas...${NC}"
docker compose up -d --scale app="${REPLICAS}"

sleep 2
docker compose ps app

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  [SUCCESS] Scaled to ${REPLICAS} Application Replicas!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Nginx is now actively load-balancing incoming requests"
echo -e "  across all ${REPLICAS} container instances with automatic"
echo -e "  failover on timeout or error."
echo -e "${GREEN}============================================================${NC}"
echo ""
