<?php
/**
 * Test: Docker Configuration & Turnkey Bootstrap Integrity
 *
 * Verifies that all Docker orchestration assets are present, correctly
 * configured, secure, and ready for one-command production/development deployment.
 */

$rootDir = dirname(__DIR__);
$errors = [];
$totalAssertions = 0;

function assertCondition($cond, $message) {
    global $errors, $totalAssertions;
    $totalAssertions++;
    if (!$cond) {
        $errors[] = $message;
        echo "[FAIL] $message\n";
    } else {
        echo "[PASS] $message\n";
    }
}

echo "============================================================\n";
echo "Running Docker Configuration & Bootstrap Integrity Tests\n";
echo "============================================================\n";

// -------------------------------------------------------------
// Section 1: Existence and Readability of Docker Assets
// -------------------------------------------------------------
$requiredFiles = [
    'Dockerfile',
    'docker-compose.yml',
    '.dockerignore',
    '.env.example',
    'docker/docker-entrypoint.sh',
    'docker/bootstrap.php',
    'docker/nginx/default.conf',
    'docker/php/php-custom.ini',
    'docker/export-offline-bundle.ps1',
    'docker/export-offline-bundle.sh',
    'docker/start-offline.bat',
    'docker/start-offline.sh',
];

foreach ($requiredFiles as $file) {
    $fullPath = $rootDir . '/' . $file;
    assertCondition(
        file_exists($fullPath) && filesize($fullPath) > 20,
        "Required Docker asset '$file' must exist and not be empty."
    );
}

// -------------------------------------------------------------
// Section 2: Dockerfile Integrity & Extension Coverage
// -------------------------------------------------------------
$dockerfileContent = file_get_contents($rootDir . '/Dockerfile');

assertCondition(
    strpos($dockerfileContent, 'FROM php:8.2-fpm-alpine') !== false,
    "Dockerfile must use php:8.2-fpm-alpine base image."
);

$requiredExtensions = [
    'bcmath', 'curl', 'gd', 'intl', 'mbstring',
    'mysqli', 'opcache', 'pdo_mysql', 'xml', 'zip'
];
foreach ($requiredExtensions as $ext) {
    assertCondition(
        strpos($dockerfileContent, $ext) !== false,
        "Dockerfile must install PHP extension '$ext'."
    );
}

assertCondition(
    strpos($dockerfileContent, 'ENTRYPOINT ["docker-entrypoint.sh"]') !== false,
    "Dockerfile must specify docker-entrypoint.sh as ENTRYPOINT."
);

assertCondition(
    strpos($dockerfileContent, 'EXPOSE 9000') !== false,
    "Dockerfile must expose PHP-FPM port 9000."
);

// -------------------------------------------------------------
// Section 3: Entrypoint Script & Bootstrap Logic & DB Auto-Seeding
// -------------------------------------------------------------
$entrypointContent = file_get_contents($rootDir . '/docker/docker-entrypoint.sh');
$bootstrapContent = file_get_contents($rootDir . '/docker/bootstrap.php');

assertCondition(
    strpos($entrypointContent, '#!/bin/sh') === 0 && strpos($entrypointContent, 'set -e') !== false,
    "Entrypoint must start with '#!/bin/sh' and enable 'set -e'."
);

assertCondition(
    strpos($entrypointContent, 'bootstrap.php') !== false,
    "Entrypoint must invoke bootstrap.php."
);

$requiredEnvVars = ['DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USER', 'DB_PASSWORD', 'APP_URL', 'RANDOM_SECURITY'];
foreach ($requiredEnvVars as $env) {
    assertCondition(
        strpos($bootstrapContent, $env) !== false,
        "Bootstrap must bind environment variable '$env'."
    );
}

assertCondition(
    strpos($bootstrapContent, 'Waiting for database connection') !== false,
    "Bootstrap must include a database readiness polling loop."
);

assertCondition(
    strpos($bootstrapContent, 'mysql_db_structure.sql') !== false &&
    strpos($bootstrapContent, 'db_data.sql') !== false,
    "Bootstrap must automatically seed fresh databases with structure and initial data."
);

assertCondition(
    strpos($entrypointContent, 'exec "$@"') !== false,
    "Entrypoint must pass execution to container CMD using exec \"$@\"."
);

// -------------------------------------------------------------
// Section 4: Nginx Reverse Proxy Configuration
// -------------------------------------------------------------
$nginxContent = file_get_contents($rootDir . '/docker/nginx/default.conf');

assertCondition(
    strpos($nginxContent, 'app:9000') !== false && strpos($nginxContent, 'fastcgi_pass') !== false,
    "Nginx config must route PHP traffic to FastCGI service 'app:9000'."
);

assertCondition(
    strpos($nginxContent, 'resolver 127.0.0.11') !== false,
    "Nginx config must use Docker embedded DNS resolver 127.0.0.11 for dynamic scaling."
);

assertCondition(
    strpos($nginxContent, 'location = /health.txt') !== false,
    "Nginx config must provide a dedicated /health.txt liveness probe."
);

$securityBlocked = ['/install/', '/admin/backup/', '/cache/backup/', 'shared/config'];
foreach ($securityBlocked as $blocked) {
    assertCondition(
        strpos($nginxContent, $blocked) !== false,
        "Nginx config must explicitly block sensitive path '$blocked'."
    );
}

assertCondition(
    strpos($nginxContent, 'fastcgi_read_timeout 300s;') !== false,
    "Nginx config must set FastCGI timeout to 300s for long-running CBT operations."
);

// -------------------------------------------------------------
// Section 5: Docker Compose Orchestration
// -------------------------------------------------------------
$composeContent = file_get_contents($rootDir . '/docker-compose.yml');

assertCondition(
    strpos($composeContent, 'app:') !== false &&
    strpos($composeContent, 'web:') !== false &&
    strpos($composeContent, 'db:') !== false,
    "docker-compose.yml must define 'app', 'web', and 'db' services."
);

assertCondition(
    strpos($composeContent, 'mariadb:10.11') !== false,
    "docker-compose.yml must use MariaDB 10.11 LTS database service."
);

assertCondition(
    strpos($composeContent, 'condition: service_healthy') !== false,
    "App service must depend on database service_healthy condition."
);

$volumes = ['db_data', 'cache_data', 'backup_data'];
foreach ($volumes as $vol) {
    assertCondition(
        strpos($composeContent, $vol . ':') !== false,
        "docker-compose.yml must define persistent volume '$vol'."
    );
}

// -------------------------------------------------------------
// Section 6: Environment Example Defaults
// -------------------------------------------------------------
$envContent = file_get_contents($rootDir . '/.env.example');
assertCondition(
    strpos($envContent, 'APP_PORT=8080') !== false,
    ".env.example must define APP_PORT=8080."
);
assertCondition(
    strpos($envContent, 'APP_URL=http://localhost:8080') !== false,
    ".env.example must define APP_URL=http://localhost:8080."
);
assertCondition(
    strpos($envContent, 'RANDOM_SECURITY=') !== false,
    ".env.example must provide RANDOM_SECURITY secret placeholder."
);

// -------------------------------------------------------------
// Section 7: Development Profile & 1-Command Startup Assets
// -------------------------------------------------------------
$devAssets = [
    'docker-compose.dev.yml',
    'docker/php/php-dev.ini',
    'dev.bat',
    'dev.sh',
    'dev.ps1',
    'Makefile',
    'docs/DEVELOPMENT.md',
];
foreach ($devAssets as $devAsset) {
    $fullDevPath = $rootDir . '/' . $devAsset;
    assertCondition(
        file_exists($fullDevPath) && filesize($fullDevPath) > 20,
        "Development asset '$devAsset' must exist and not be empty."
    );
}

$composeDevContent = file_get_contents($rootDir . '/docker-compose.dev.yml');
assertCondition(
    strpos($composeDevContent, './:/var/www/html') !== false,
    "docker-compose.dev.yml must mount host root directory into /var/www/html for hot reloading."
);
assertCondition(
    strpos($composeDevContent, 'php-dev.ini') !== false,
    "docker-compose.dev.yml must mount php-dev.ini override."
);
assertCondition(
    strpos($composeDevContent, '3306') !== false,
    "docker-compose.dev.yml must expose MariaDB port 3306 for external GUI tools."
);

$phpDevContent = file_get_contents($rootDir . '/docker/php/php-dev.ini');
assertCondition(
    strpos($phpDevContent, 'display_errors = On') !== false,
    "php-dev.ini must enable display_errors for development."
);
assertCondition(
    strpos($phpDevContent, 'error_reporting = E_ALL') !== false,
    "php-dev.ini must set error_reporting to E_ALL."
);
assertCondition(
    strpos($phpDevContent, 'revalidate_freq = 0') !== false,
    "php-dev.ini must set opcache revalidation frequency to 0 for instant hot reloading."
);

$devBatContent = file_get_contents($rootDir . '/dev.bat');
assertCondition(
    strpos($devBatContent, 'docker compose') !== false &&
    strpos($devBatContent, 'docker-compose.dev.yml') !== false,
    "dev.bat must launch containers with development compose profile."
);

$devShContent = file_get_contents($rootDir . '/dev.sh');
assertCondition(
    strpos($devShContent, 'docker compose') !== false &&
    strpos($devShContent, 'docker-compose.dev.yml') !== false,
    "dev.sh must launch containers with development compose profile."
);

// -------------------------------------------------------------
// Section 8: Standalone Offline Production Deployment Assets
// -------------------------------------------------------------
$offlineAssets = [
    'docker/build-offline-bundle.ps1',
    'docker/build-offline-bundle.sh',
    'offline-deployment/docker-compose.yml',
    'offline-deployment/nginx/default.conf',
    'offline-deployment/.env.example',
    'offline-deployment/start-production.bat',
    'offline-deployment/start-production.sh',
    'offline-deployment/apply-patch.bat',
    'offline-deployment/apply-patch.sh',
    'offline-deployment/stop-production.bat',
    'offline-deployment/stop-production.sh',
    'offline-deployment/backup-database.bat',
    'offline-deployment/backup-database.sh',
    'offline-deployment/README.md',
    'offline-deployment/tcexam-offline-bundle.tar',
];
foreach ($offlineAssets as $asset) {
    $fullAssetPath = $rootDir . '/' . $asset;
    assertCondition(
        file_exists($fullAssetPath) && filesize($fullAssetPath) > 20,
        "Offline deployment asset '$asset' must exist and not be empty."
    );
}

$offlineComposeContent = file_get_contents($rootDir . '/offline-deployment/docker-compose.yml');
assertCondition(
    strpos($offlineComposeContent, 'build:') === false,
    "offline-deployment/docker-compose.yml must NOT contain 'build:' directive to ensure 100% offline deployment."
);
assertCondition(
    strpos($offlineComposeContent, '"${APP_PORT:-80}:80"') !== false,
    "offline-deployment/docker-compose.yml must map port 80 as default for production."
);
assertCondition(
    strpos($offlineComposeContent, '"${APP_ALT_PORT:-8080}:80"') !== false,
    "offline-deployment/docker-compose.yml must map port 8080 as alternative port."
);

$offlineStartBat = file_get_contents($rootDir . '/offline-deployment/start-production.bat');
assertCondition(
    strpos($offlineStartBat, 'tcexam-offline-bundle.tar') !== false,
    "start-production.bat must reference offline tarball bundle."
);

// -------------------------------------------------------------
// Summary
// -------------------------------------------------------------
echo "------------------------------------------------------------\n";
echo "Total Assertions: $totalAssertions\n";
if (empty($errors)) {
    echo "SUCCESS: All Docker configuration integrity tests passed!\n";
    exit(0);
} else {
    echo "FAILED: " . count($errors) . " error(s) encountered.\n";
    foreach ($errors as $e) {
        echo "  - $e\n";
    }
    exit(1);
}
