#!/usr/bin/env bash
set -e

# ============================================================
# TCExam — 1-Click Showcase Database Seeder (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  TCExam Showcase Database Seeding Utility${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker daemon is not running.${NC}"
    exit 1
fi

# 2. Verify database container is online
if ! docker compose exec -T db mariadb-admin ping -u root -proot_secret_pass >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Database container 'db' is not accepting connections.${NC}"
    echo -e "Please start the server using ./start-production.sh first."
    exit 1
fi

# 3. Locate showcase seed SQL files
SEED_SQL=""
if [ -f "../seed_data/showcase_seed.sql" ]; then
    SEED_SQL="../seed_data/showcase_seed.sql"
elif [ -f "seed_data/showcase_seed.sql" ]; then
    SEED_SQL="seed_data/showcase_seed.sql"
elif [ -f "showcase_seed.sql" ]; then
    SEED_SQL="showcase_seed.sql"
else
    echo -e "${BLUE}[INFO] Extracting showcase seed from application container...${NC}"
    docker compose exec -T app cat /var/www/html/seed_data/showcase_seed.sql > showcase_seed_temp.sql 2>/dev/null || true
    if [ -f "showcase_seed_temp.sql" ]; then
        SEED_SQL="showcase_seed_temp.sql"
    else
        echo -e "${RED}[ERROR] showcase_seed.sql could not be found.${NC}"
        exit 1
    fi
fi

SEED_RES_SQL=""
if [ -f "../seed_data/showcase_results_seed.sql" ]; then
    SEED_RES_SQL="../seed_data/showcase_results_seed.sql"
elif [ -f "seed_data/showcase_results_seed.sql" ]; then
    SEED_RES_SQL="seed_data/showcase_results_seed.sql"
elif [ -f "showcase_results_seed.sql" ]; then
    SEED_RES_SQL="showcase_results_seed.sql"
else
    docker compose exec -T app cat /var/www/html/seed_data/showcase_results_seed.sql > showcase_res_temp.sql 2>/dev/null || true
    if [ -f "showcase_res_temp.sql" ]; then
        SEED_RES_SQL="showcase_res_temp.sql"
    fi
fi

# 4. Determine whether to include results
LOAD_RESULTS=1
if [ "$1" == "--curriculum-only" ]; then
    LOAD_RESULTS=0
elif [ "$1" == "--with-results" ]; then
    LOAD_RESULTS=1
elif [ -z "$1" ] && [ -t 0 ]; then
    read -r -p "Load simulated exam attempts & analytics results? [Y/n]: " USER_CHOICE
    if [[ "$USER_CHOICE" =~ ^[Nn] ]]; then
        LOAD_RESULTS=0
    fi
fi

echo -e "${BLUE}[INFO] Loading showcase curriculum, users, and certification exams...${NC}"
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "$SEED_SQL"

if [ "$LOAD_RESULTS" -eq 1 ] && [ -n "$SEED_RES_SQL" ]; then
    echo -e "${BLUE}[INFO] Loading simulated candidate exam attempts, answer logs, and scores...${NC}"
    if docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "$SEED_RES_SQL"; then
        echo -e "${BLUE}[INFO] Exam attempts and analytics loaded successfully.${NC}"
    else
        echo -e "${YELLOW}[WARNING] Failed to load simulated exam results.${NC}"
    fi
fi

if [ -f "showcase_seed_temp.sql" ]; then
    rm -f "showcase_seed_temp.sql"
fi
if [ -f "showcase_res_temp.sql" ]; then
    rm -f "showcase_res_temp.sql"
fi

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  [SUCCESS] Showcase Database Seeding Completed!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "  Populated Entities:"
echo -e "    - 9 User Groups (Academic Registry, Proctors, Cohorts)"
echo -e "    - 21 Users across all permission tiers (Password: ${YELLOW}Password123!${NC})"
echo -e "    - 3 Modules (Web Engineering, Cybersecurity, DevOps)"
echo -e "    - 7 Subjects & 42 Questions (Single & Multiple Choice)"
echo -e "    - 3 Pre-configured Certification Exams:"
echo -e "        * CS101: Web & Database Engineering Certification"
echo -e "        * SEC201: Cybersecurity Fundamentals & Network Defense"
echo -e "        * OPS301: Cloud Infrastructure & DevOps Readiness"
if [ "$LOAD_RESULTS" -eq 1 ]; then
    echo -e "    - 14 Completed Student Attempts with Realistic Bell Curve"
    echo -e "    - 3 Ready-to-Take Candidate Sessions (Live Exam Execution)"
    echo -e "    - Full Analytics in Results -> All Users & User Scorecards"
fi
echo -e "${GREEN}============================================================${NC}"
echo ""
