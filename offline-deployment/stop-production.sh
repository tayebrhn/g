#!/usr/bin/env bash
set -e
echo "Stopping TCExam production services..."
docker compose down
echo "TCExam services stopped."
