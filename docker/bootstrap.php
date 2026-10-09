<?php
/**
 * TCExam Docker Container Bootstrap Script
 *
 * Configures application paths, database settings, waits for database
 * readiness, and auto-seeds initial database structure and seed data.
 */

$dbHost = getenv('DB_HOST') ?: 'db';
$dbPort = getenv('DB_PORT') ?: '3306';
$dbName = getenv('DB_NAME') ?: 'tcexam';
$dbUser = getenv('DB_USER') ?: 'tcexam';
$dbPassword = getenv('DB_PASSWORD') ?: 'tcexam_secret_pass';
$appUrl = getenv('APP_URL') ?: 'http://localhost:8080';
$randomSecurity = getenv('RANDOM_SECURITY') ?: 'f8a7c29e1d5b4a3c6e80f2149b7d8e3c1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d';

echo "==> TCExam bootstrap starting...\n";

// 1. Initialize configuration directories from defaults if missing
$baseDir = '/var/www/html';
$configDirs = ['shared', 'admin', 'public'];

foreach ($configDirs as $dir) {
    $targetDir = "$baseDir/$dir/config";
    $defaultDir = "$baseDir/$dir/config.default";
    if (!is_dir($targetDir)) {
        @mkdir($targetDir, 0775, true);
    }
    if (is_dir($defaultDir)) {
        $files = scandir($defaultDir);
        foreach ($files as $f) {
            if ($f === '.' || $f === '..') continue;
            $dst = "$targetDir/$f";
            if (!file_exists($dst)) {
                copy("$defaultDir/$f", $dst);
            }
        }
    }
}

// 2. Helper to replace constant definitions
function set_define_value($file, $constant, $value) {
    if (!file_exists($file)) return false;
    $content = file_get_contents($file);
    $escaped = addcslashes($value, "'\\");
    $pattern = "/define\s*\(\s*['\"]" . preg_quote($constant, '/') . "['\"]\s*,\s*.*?(\);)/s";
    $replacement = "define('" . $constant . "', '" . $escaped . "'$1";
    $updated = preg_replace($pattern, $replacement, $content);
    return file_put_contents($file, $updated) !== false;
}

echo "==> Applying environment configuration to TCExam...\n";
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_TYPE', 'MYSQL');
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_HOST', $dbHost);
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_PORT', $dbPort);
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_NAME', $dbName);
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_USER_NAME', $dbUser);
set_define_value("$baseDir/shared/config/tce_db_config.php", 'K_DATABASE_USER_PASSWORD', $dbPassword);

set_define_value("$baseDir/shared/config/tce_paths.php", 'K_PATH_HOST', $appUrl);
set_define_value("$baseDir/shared/config/tce_paths.php", 'K_PATH_TCEXAM', '/');
set_define_value("$baseDir/shared/config/tce_paths.php", 'K_PATH_MAIN', "$baseDir/");

set_define_value("$baseDir/shared/config/tce_general_constants.php", 'K_RANDOM_SECURITY', $randomSecurity);

// 3. Wait for database readiness
echo "==> Waiting for database connection at $dbHost:$dbPort...\n";
$maxTries = 40;
$connected = false;
mysqli_report(MYSQLI_REPORT_OFF);

for ($i = 1; $i <= $maxTries; $i++) {
    try {
        $mysqli = @new mysqli($dbHost, $dbUser, $dbPassword, '', (int)$dbPort);
        if ($mysqli && !$mysqli->connect_error) {
            $connected = true;
            $mysqli->close();
            break;
        }
        $err = $mysqli ? $mysqli->connect_error : mysqli_connect_error();
        echo "==> [Attempt $i/$maxTries] Connection failed: $err\n";
    } catch (Throwable $e) {
        echo "==> [Attempt $i/$maxTries] Exception: " . $e->getMessage() . "\n";
    }
    sleep(2);
}

if (!$connected) {
    fwrite(STDERR, "Error: Could not connect to database after $maxTries attempts.\n");
    exit(1);
}

echo "==> Database service is online and accepting connections.\n";

// 4. Verify and initialize schema if empty
$mysqli = @new mysqli($dbHost, $dbUser, $dbPassword, $dbName, (int)$dbPort);
if (!$mysqli || $mysqli->connect_error) {
    $mysqli = @new mysqli($dbHost, $dbUser, $dbPassword, '', (int)$dbPort);
    @$mysqli->query("CREATE DATABASE IF NOT EXISTS `$dbName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    @$mysqli->select_db($dbName);
}

$check = $mysqli->query("SHOW TABLES LIKE 'tce_users'");
if (!$check || $check->num_rows == 0) {
    echo "==> Fresh database detected. Auto-seeding TCExam schema and seed data...\n";
    
    $structureFile = "$baseDir/install/mysql_db_structure.sql";
    if (file_exists($structureFile)) {
        $structureSql = file_get_contents($structureFile);
        $mysqli->multi_query($structureSql);
        while ($mysqli->more_results() && $mysqli->next_result()) { /* flush results */ }
    }
    
    $dataFile = "$baseDir/install/db_data.sql";
    if (file_exists($dataFile)) {
        $dataSql = file_get_contents($dataFile);
        $mysqli->multi_query($dataSql);
        while ($mysqli->more_results() && $mysqli->next_result()) { /* flush results */ }
    }
    
    echo "==> TCExam database initialized successfully!\n";
} else {
    echo "==> Existing TCExam schema detected. Skipping auto-seeding.\n";
}

$mysqli->close();
echo "==> TCExam bootstrap complete.\n";
exit(0);
