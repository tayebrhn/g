#!/bin/sh
set -e

# ============================================================
# TCExam — Export Offline Docker Bundle (Linux / Unix)
# ============================================================

OUTPUT_FILE="${1:-tcexam-offline-bundle.tar}"

echo "==> Verifying Docker images for offline deployment..."
docker image inspect tcexam-app:latest >/dev/null
docker image inspect nginx:alpine >/dev/null
docker image inspect mariadb:10.11 >/dev/null

echo "==> Packaging images into portable archive: $OUTPUT_FILE..."
docker save -o "$OUTPUT_FILE" tcexam-app:latest nginx:alpine mariadb:10.11

echo "==> Offline Docker bundle successfully generated: $OUTPUT_FILE"
echo ""
echo "==> How to deploy on an offline / air-gapped server:"
echo "    1. Copy '$OUTPUT_FILE', 'docker-compose.yml', and '.env.example' to the offline server."
echo "    2. On the offline server, run:"
echo "       docker load -i $OUTPUT_FILE"
echo "       cp .env.example .env"
echo "       docker compose up -d"
