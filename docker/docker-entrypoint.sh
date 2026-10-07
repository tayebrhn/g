#!/bin/sh
set -e

# ============================================================
# TCExam Docker Container Entrypoint
# ============================================================

echo "==> TCExam container starting up..."

# Run PHP bootstrap (initializes config, waits for DB, and seeds schema if fresh)
php /var/www/html/docker/bootstrap.php

# Ensure runtime directories exist with proper write permissions
mkdir -p /var/www/html/cache /var/www/html/admin/backup /var/www/html/cache/backup
chown -R www-data:www-data /var/www/html/cache /var/www/html/admin/backup /var/www/html/shared/config /var/www/html/admin/config /var/www/html/public/config
chmod -R 775 /var/www/html/cache /var/www/html/admin/backup

echo "==> Starting PHP-FPM..."
exec "$@"
