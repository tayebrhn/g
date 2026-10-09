#!/usr/bin/env bash
# ============================================================
# TCExam — Build & Package Offline Production Bundle (Linux / macOS)
# ============================================================
set -eo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

OUTPUT_FILE="${1:-$ROOT_DIR/offline-deployment/tcexam-offline-bundle.tar}"

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  TCExam — Building & Packaging Offline Production Bundle${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker is not running or not installed.${NC}"
    exit 1
fi

# 2. Build updated application image
echo -e "${BLUE}[1/4] Building latest tcexam-app:latest image with updated codebase...${NC}"
docker build -t tcexam-app:latest "$ROOT_DIR"

# 3. Verify base images
echo -e "${BLUE}[2/4] Verifying base images (nginx:alpine, mariadb:10.11)...${NC}"
if ! docker image inspect nginx:alpine >/dev/null 2>&1; then
    echo "      Pulling nginx:alpine..."
    docker pull nginx:alpine
fi

if ! docker image inspect mariadb:10.11 >/dev/null 2>&1; then
    echo "      Pulling mariadb:10.11..."
    docker pull mariadb:10.11
fi

# 4. Ensure destination directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# 5. Export images to portable archive
echo -e "${BLUE}[3/4] Packaging images into archive: $OUTPUT_FILE...${NC}"
echo -e "${YELLOW}      (This may take 30-60 seconds, archive is ~400 MB)${NC}"
docker save -o "$OUTPUT_FILE" tcexam-app:latest nginx:alpine mariadb:10.11

FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
echo -e "${GREEN}[SUCCESS] Bundle generated: $OUTPUT_FILE ($FILE_SIZE)${NC}"

# 6. Summary instructions
echo -e "${BLUE}[4/4] Done!${NC}"
echo -e "${YELLOW}============================================================${NC}"
echo -e "${YELLOW}  How to Apply this Update / Patch on the Offline Server:${NC}"
echo -e "${YELLOW}============================================================${NC}"
echo -e "  1. Copy the updated file:"
echo -e "     '$OUTPUT_FILE'"
echo -e "     to the 'offline-deployment/' folder on your target server."
echo ""
echo -e "  2. On the offline server, run:"
echo -e "     ./apply-patch.sh   (or apply-patch.bat on Windows)"
echo ""
echo -e "  3. The script will take a safety database backup, load the new"
echo -e "     image, and recreate the app container with ZERO data loss."
echo -e "${YELLOW}============================================================${NC}"
