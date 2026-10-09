#!/usr/bin/env bash
set -e

# ============================================================
# TCExam — Stop Offline Production Cluster (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Stopping TCExam Production Services...${NC}"
echo -e "${BLUE}============================================================${NC}"

docker compose down

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  [SUCCESS] TCExam production cluster has been gracefully stopped.${NC}"
echo -e "  All persistent database records and exam logs remain safe on disk."
echo -e "${GREEN}============================================================${NC}"
echo ""
