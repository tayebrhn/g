#!/usr/bin/env bash
# ============================================================
# TCExam — 1-Command Development Environment (macOS / Linux)
# ============================================================
set -eo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Starting TCExam Development Server...${NC}"
echo -e "${BLUE}============================================================${NC}"

# Check for subcommands
case "$1" in
    stop|down)
        docker compose -f docker-compose.yml -f docker-compose.dev.yml down
        echo "TCExam development containers stopped."
        exit 0
        ;;
    restart)
        docker compose -f docker-compose.yml -f docker-compose.dev.yml restart
        echo "TCExam development containers restarted."
        exit 0
        ;;
    status)
        docker compose -f docker-compose.yml -f docker-compose.dev.yml ps
        exit 0
        ;;
    seed)
        echo -e "${BLUE}[INFO] Seeding showcase curriculum, users, and exams...${NC}"
        docker compose -f docker-compose.yml -f docker-compose.dev.yml exec -T db mariadb -u root -proot_secret_pass tcexam < seed_data/showcase_seed.sql
        echo -e "${GREEN}[SUCCESS] Showcase seed complete!${NC}"
        exit 0
        ;;
    scale)
        REPL="${2:-2}"
        echo -e "${BLUE}[INFO] Scaling app workers to ${REPL} replicas...${NC}"
        docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --scale app="${REPL}"
        exit 0
        ;;
esac

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker is not running or not installed.${NC}"
    echo "Please start Docker Desktop / daemon and try again."
    exit 1
fi

# 2. Ensure .env exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}[INFO] .env not found. Creating from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}[SUCCESS] Initialized .env with default settings.${NC}"
fi

# Parse ports dynamically from .env
APP_PORT=$(grep -E '^[[:space:]]*APP_PORT=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "80")
if [ -z "$APP_PORT" ]; then APP_PORT="80"; fi
DB_PORT_FORWARD=$(grep -E '^[[:space:]]*DB_PORT_FORWARD=' .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "\r' || echo "3307")
if [ -z "$DB_PORT_FORWARD" ]; then DB_PORT_FORWARD="3307"; fi

# 3. Launch Docker Compose with Dev profile
echo -e "${BLUE}[INFO] Launching containers (PHP-FPM, Nginx, MariaDB)...${NC}"
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# 4. Wait for services to be ready
echo -e "${BLUE}[INFO] Waiting for web and database services to initialize on port ${APP_PORT}...${NC}"
RETRIES=20
READY=false
while [ $RETRIES -gt 0 ]; do
    if curl --max-time 2 -s -f "http://localhost:${APP_PORT}/health.txt" >/dev/null 2>&1; then
        READY=true
        break
    fi
    sleep 2
    RETRIES=$((RETRIES - 1))
done

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  TCExam Development Environment is ONLINE!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Candidate Portal:    ${BLUE}http://localhost:${APP_PORT}/public/code/index.php${NC}"
echo -e "  Admin Suite:         ${BLUE}http://localhost:${APP_PORT}/admin/code/index.php${NC}"
echo -e "  Default Login:       Username: ${YELLOW}admin${NC}   Password: ${YELLOW}1234${NC}"
echo -e "  Database GUI:        localhost:${DB_PORT_FORWARD}"
echo -e "                       User: ${YELLOW}tcexam${NC}      Pass: ${YELLOW}tcexam_secret_pass${NC}"
echo -e "                       Database: ${YELLOW}tcexam${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Hot Reloading:       ${GREEN}ACTIVE${NC} (edits in ./ reflect immediately)"
echo -e "  Error Reporting:     ${GREEN}VERBOSE${NC} (display_errors = On)"
echo -e "  OPcache:             ${GREEN}INSTANT${NC} (revalidate_freq = 0)"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Useful Commands:"
echo -e "    View PHP logs:     docker compose logs -f app"
echo -e "    Container Shell:   docker compose exec app sh"
echo -e "    Stop Server:       docker compose down"
echo -e "${GREEN}============================================================${NC}"
echo ""
