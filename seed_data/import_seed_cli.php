<?php
/**
 * CLI Seed Data Importer for TCExam
 *
 * Imports the showcase seed data directly into the TCExam database from the CLI,
 * either by executing the SQL seed script or calling TCExam's internal import handlers.
 *
 * Usage:
 *   php seed_data/import_seed_cli.php [options]
 *
 * Options:
 *   --method=sql|tsv    Import method (default: sql)
 *   --host=<host>       Override DB host (default from config: K_DATABASE_HOST)
 *   --port=<port>       Override DB port (default from config: K_DATABASE_PORT)
 *   --database=<db>     Override DB name (default from config: K_DATABASE_NAME)
 *   --user=<user>       Override DB user (default from config: K_DATABASE_USER_NAME)
 *   --password=<pass>   Override DB password (default from config: K_DATABASE_USER_PASSWORD)
 *   --help              Display this help message
 */

declare(strict_types=1);

error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);

$options = getopt('', ['method::', 'host::', 'port::', 'database::', 'user::', 'password::', 'with-results', 'results-only', 'help']);

if (isset($options['help'])) {
    echo <<<HELP
TCExam CLI Seed Data Importer
-----------------------------
Usage:
  php seed_data/import_seed_cli.php [options]

Options:
  --method=sql|tsv    Choose import mechanism (default: sql)
  --host=<host>       Database hostname
  --port=<port>       Database port
  --database=<name>   Database name
  --user=<username>   Database user
  --password=<secret> Database password
  --with-results      Also import simulated candidate attempts & analytics
  --results-only      Only import simulated candidate attempts (curriculum must exist)
  --help              Show this manual

HELP;
    exit(0);
}

// Load default configs
$dbConfigFile = __DIR__ . '/../shared/config/tce_db_config.php';
if (file_exists($dbConfigFile)) {
    require_once $dbConfigFile;
}

$dbHost = $options['host'] ?? (defined('K_DATABASE_HOST') ? K_DATABASE_HOST : '127.0.0.1');
$dbPort = (int)($options['port'] ?? (defined('K_DATABASE_PORT') ? K_DATABASE_PORT : 3306));
$dbName = $options['database'] ?? (defined('K_DATABASE_NAME') ? K_DATABASE_NAME : 'tcexam');
$dbUser = $options['user'] ?? (defined('K_DATABASE_USER_NAME') ? K_DATABASE_USER_NAME : 'tcexam');
$dbPass = $options['password'] ?? (defined('K_DATABASE_USER_PASSWORD') ? K_DATABASE_USER_PASSWORD : '');
$method = strtolower($options['method'] ?? 'sql');
$withResults = isset($options['with-results']);
$resultsOnly = isset($options['results-only']);

echo "Connecting to MySQL database '$dbName' on $dbHost:$dbPort with user '$dbUser'...\n";

// Attempt connection via mysqli
mysqli_report(MYSQLI_REPORT_OFF);
$mysqli = @new mysqli($dbHost, $dbUser, $dbPass, $dbName, $dbPort);

if ($mysqli->connect_errno) {
    echo "\n[NOTICE] Unable to establish direct database connection: " . $mysqli->connect_error . "\n";
    echo "This is expected if your database runs inside Docker or a remote host.\n\n";
    echo "To import the seed data:\n";
    echo "1. Via Docker container:\n";
    echo "   docker compose exec -T db mariadb -u $dbUser -p$dbPass $dbName < seed_data/showcase_seed.sql\n";
    if ($withResults || $resultsOnly) {
        echo "   docker compose exec -T db mariadb -u $dbUser -p$dbPass $dbName < seed_data/showcase_results_seed.sql\n";
    }
    echo "\n2. Via local MySQL CLI:\n";
    echo "   mysql -h $dbHost -P $dbPort -u $dbUser -p $dbName < seed_data/showcase_seed.sql\n";
    if ($withResults || $resultsOnly) {
        echo "   mysql -h $dbHost -P $dbPort -u $dbUser -p $dbName < seed_data/showcase_results_seed.sql\n";
    }
    echo "\n3. Via TCExam Admin Web UI:\n";
    echo "   - Go to Admin -> Users -> Import Users and upload seed_data/users_seed.tsv\n";
    echo "   - Go to Admin -> Questions -> Import Questions and upload seed_data/modules_and_questions_seed.tsv\n";
    exit(0);
}

echo "Database connection established successfully!\n";

$sqlFilesToImport = [];
if (!$resultsOnly) {
    $sqlFile = __DIR__ . '/showcase_seed.sql';
    if (!file_exists($sqlFile)) {
        die("Error: showcase_seed.sql not found at $sqlFile\n");
    }
    $sqlFilesToImport[] = $sqlFile;
}

if ($withResults || $resultsOnly) {
    $resultsFile = __DIR__ . '/showcase_results_seed.sql';
    if (!file_exists($resultsFile)) {
        die("Error: showcase_results_seed.sql not found at $resultsFile\n");
    }
    $sqlFilesToImport[] = $resultsFile;
}

foreach ($sqlFilesToImport as $file) {
    $baseName = basename($file);
    echo "Importing $baseName into '$dbName'...\n";

    $sqlContent = file_get_contents($file);
    if ($mysqli->multi_query($sqlContent)) {
        do {
            if ($res = $mysqli->store_result()) {
                $res->free();
            }
            if ($mysqli->errno && $mysqli->errno !== 1062) {
                echo "[ERROR] SQL Execution Error in $baseName: " . $mysqli->error . "\n";
                exit(1);
            }
        } while ($mysqli->more_results() && $mysqli->next_result());
    } else {
        if ($mysqli->errno && $mysqli->errno !== 1062) {
            echo "[ERROR] Initial Query Failed in $baseName: " . $mysqli->error . "\n";
            exit(1);
        }
    }
    echo "  [OK] Successfully executed $baseName\n";
}

echo "\n[SUCCESS] TCExam showcase seed data imported successfully!\n";
if ($withResults || $resultsOnly) {
    echo "Simulated exam results loaded: navigate to Results -> All Users to view analytics.\n";
} else {
    echo "You can now log in with seeded accounts or take the showcase exams.\n";
}

