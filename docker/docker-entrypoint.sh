#!/bin/sh
set -e

# ============================================================
# TCExam Docker Container Entrypoint & Bootstrapper
# ============================================================

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-tcexam}"
DB_USER="${DB_USER:-tcexam}"
DB_PASSWORD="${DB_PASSWORD:-tcexam_secret_pass}"
APP_URL="${APP_URL:-http://localhost:8080}"
RANDOM_SECURITY="${RANDOM_SECURITY:-f8a7c29e1d5b4a3c6e80f2149b7d8e3c1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d}"

echo "==> TCExam container starting up..."

# 1. Initialize configuration directories from defaults if missing
if [ ! -f "/var/www/html/shared/config/tce_db_config.php" ]; then
    echo "==> Initializing configuration files from templates..."
    mkdir -p /var/www/html/shared/config /var/www/html/admin/config /var/www/html/public/config
    cp -rn /var/www/html/shared/config.default/* /var/www/html/shared/config/ 2>/dev/null || true
    cp -rn /var/www/html/admin/config.default/* /var/www/html/admin/config/ 2>/dev/null || true
    cp -rn /var/www/html/public/config.default/* /var/www/html/public/config/ 2>/dev/null || true
fi

# 2. Inject environment settings into PHP configuration files
echo "==> Applying environment configuration to TCExam..."
php -r "
function set_define(\$file, \$key, \$val) {
    if (!file_exists(\$file)) return;
    \$content = file_get_contents(\$file);
    \$escaped = addcslashes(\$val, \"'\\\\\");
    \$pattern = \"/define\s*\(\s*['\"]\" . preg_quote(\$key, '/') . \"['\"]\s*,\s*.*?(\);)/s\";
    \$replacement = \"define('\" . \$key . \"', '\" . \$escaped . \"'\$1\";
    \$updated = preg_replace(\$pattern, \$replacement, \$content);
    file_put_contents(\$file, \$updated);
}

// Database configuration
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_TYPE', 'MYSQL');
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_HOST', '${DB_HOST}');
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_PORT', '${DB_PORT}');
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_NAME', '${DB_NAME}');
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_USER_NAME', '${DB_USER}');
set_define('/var/www/html/shared/config/tce_db_config.php', 'K_DATABASE_USER_PASSWORD', '${DB_PASSWORD}');

// Paths configuration
set_define('/var/www/html/shared/config/tce_paths.php', 'K_PATH_HOST', '${APP_URL}');
set_define('/var/www/html/shared/config/tce_paths.php', 'K_PATH_TCEXAM', '/');
set_define('/var/www/html/shared/config/tce_paths.php', 'K_PATH_MAIN', '/var/www/html/');

// Security constants
set_define('/var/www/html/shared/config/tce_general_constants.php', 'K_RANDOM_SECURITY', '${RANDOM_SECURITY}');
"

# 3. Wait for database connectivity
echo "==> Waiting for database connection at ${DB_HOST}:${DB_PORT}..."
MAX_TRIES=30
COUNT=0
until php -r "
    \$mysqli = @new mysqli('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '', (int)'${DB_PORT}');
    if (\$mysqli->connect_error) { exit(1); }
    \$mysqli->close();
    exit(0);
" > /dev/null 2>&1; do
    COUNT=$((COUNT + 1))
    if [ "$COUNT" -ge "$MAX_TRIES" ]; then
        echo "Error: Database connection timed out after $MAX_TRIES attempts."
        exit 1
    fi
    sleep 2
done
echo "==> Database service is online and accepting connections."

# 4. Check if database needs schema initialization
echo "==> Verifying TCExam database schema..."
php -r "
    \$mysqli = new mysqli('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '', (int)'${DB_PORT}');
    \$mysqli->query(\"CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci\");
    \$mysqli->select_db('${DB_NAME}');

    \$res = \$mysqli->query(\"SHOW TABLES LIKE 'tce_users'\");
    if (\$res && \$res->num_rows > 0) {
        echo 'EXISTS';
    } else {
        echo 'EMPTY';
    }
    \$mysqli->close();
" > /tmp/db_status.txt

DB_STATUS=$(cat /tmp/db_status.txt 2>/dev/null || echo "EMPTY")
rm -f /tmp/db_status.txt

if [ "$DB_STATUS" = "EMPTY" ]; then
    echo "==> Fresh database detected. Auto-seeding TCExam schema and seed data..."
    php -r "
        \$mysqli = new mysqli('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '${DB_NAME}', (int)'${DB_PORT}');
        
        // Load schema
        \$structure_sql = file_get_contents('/var/www/html/install/mysql_db_structure.sql');
        if (\$structure_sql) {
            \$mysqli->multi_query(\$structure_sql);
            while (\$mysqli->more_results() && \$mysqli->next_result()) {;}
        }
        
        // Load seed data
        \$data_sql = file_get_contents('/var/www/html/install/db_data.sql');
        if (\$data_sql) {
            \$mysqli->multi_query(\$data_sql);
            while (\$mysqli->more_results() && \$mysqli->next_result()) {;}
        }
        
        \$mysqli->close();
    "
    echo "==> TCExam database initialized successfully!"
else
    echo "==> Existing TCExam schema detected. Skipping auto-seeding."
fi

# 5. Ensure runtime directories exist with proper write permissions
mkdir -p /var/www/html/cache /var/www/html/admin/backup /var/www/html/cache/backup
chown -R www-data:www-data /var/www/html/cache /var/www/html/admin/backup /var/www/html/shared/config /var/www/html/admin/config /var/www/html/public/config
chmod -R 775 /var/www/html/cache /var/www/html/admin/backup

echo "==> TCExam initialization complete. Starting PHP-FPM..."
exec "$@"
