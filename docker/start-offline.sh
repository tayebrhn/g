#!/bin/sh
set -e

# ============================================================
# TCExam — Start Offline Server (Linux / macOS)
# ============================================================

if [ -f "tcexam-offline-bundle.tar" ]; then
    echo "Loading offline Docker images from tcexam-offline-bundle.tar..."
    docker load -i tcexam-offline-bundle.tar
fi

if [ ! -f ".env" ]; then
    echo "Initializing environment from .env.example..."
    cp ../.env.example .env
fi

echo "Starting TCExam offline services..."
docker compose up -d

echo ""
echo "============================================================"
echo "TCExam is running in offline mode!"
echo "Candidate Portal:     http://localhost:8080/public/code/index.php"
echo "Administrator Suite:  http://localhost:8080/admin/code/index.php"
echo "Default Credentials:  Username: admin  Password: 1234"
echo "============================================================"
