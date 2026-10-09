#!/usr/bin/env bash

# ============================================================
# TCExam — Production Offline Maintainer Console (Linux)
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

while true; do
    clear
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}          TCExam Production Maintainer Console${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo -e "  [${YELLOW}1${NC}]  Start Cluster          - Boot services and verify health"
    echo -e "  [${YELLOW}2${NC}]  Stop Cluster           - Gracefully halt all containers"
    echo -e "  [${YELLOW}3${NC}]  Restart Cluster        - Cycle containers and reload"
    echo -e "  [${YELLOW}4${NC}]  Cluster Status         - Health probes and metrics"
    echo -e "  [${YELLOW}5${NC}]  Scale App Replicas     - Load-balance FastCGI workers"
    echo -e "  [${YELLOW}6${NC}]  Seed Showcase Data     - Populate demo users and exams"
    echo -e "  [${YELLOW}7${NC}]  Backup Database        - Snapshot database to backups/"
    echo -e "  [${YELLOW}8${NC}]  Restore Database       - Restore from existing backup"
    echo -e "  [${YELLOW}9${NC}]  Follow Live Logs       - Tail container output (Ctrl+C to quit)"
    echo -e "  [${YELLOW}10${NC}] Apply Patch/Update     - Upgrade container images safely"
    echo -e "  [${YELLOW}0${NC}]  Exit Console"
    echo -e "${BLUE}============================================================${NC}"

    read -p "Select option [0-10]: " option

    case "$option" in
        1)
            ./start-production.sh
            read -p "Press Enter to return to menu..."
            ;;
        2)
            ./stop-production.sh
            read -p "Press Enter to return to menu..."
            ;;
        3)
            ./restart-production.sh
            read -p "Press Enter to return to menu..."
            ;;
        4)
            ./status-production.sh
            read -p "Press Enter to return to menu..."
            ;;
        5)
            ./scale-production.sh
            read -p "Press Enter to return to menu..."
            ;;
        6)
            ./seed-database.sh
            read -p "Press Enter to return to menu..."
            ;;
        7)
            ./backup-database.sh
            read -p "Press Enter to return to menu..."
            ;;
        8)
            ./restore-database.sh
            read -p "Press Enter to return to menu..."
            ;;
        9)
            echo -e "${BLUE}[INFO] Following logs from all containers. Press Ctrl+C to return to menu.${NC}"
            docker compose logs -f
            ;;
        10)
            ./apply-patch.sh
            read -p "Press Enter to return to menu..."
            ;;
        0)
            echo "Exiting console."
            exit 0
            ;;
        *)
            echo -e "${RED}[ERROR] Invalid selection.${NC}"
            sleep 1
            ;;
    esac
done
