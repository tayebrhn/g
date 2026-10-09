<?php
/**
 * Test Suite: Showcase Seed Data Integrity & Compatibility
 *
 * Validates that all seed assets in seed_data/ meet TCExam's architectural
 * requirements and can be imported cleanly across TSV, CSV, and SQL formats.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/fixtures/code');
require_once(__DIR__ . '/fixtures/config/tce_config.php');
require_once(__DIR__ . '/../shared/code/tce_functions_general.php');

$failures = [];

function assert_true($cond, $msg) {
    global $failures;
    if (!$cond) {
        $failures[] = $msg;
        echo "[FAIL] " . $msg . "\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

function assert_equals($expected, $actual, $msg) {
    global $failures;
    if ($expected !== $actual) {
        $failures[] = $msg . ' Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true);
        echo "[FAIL] " . $msg . ' (Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true) . ")\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

$seedDir = dirname(__DIR__) . '/seed_data';

// =============================================================================
// Section 1: File Existence & Basic Structure
// =============================================================================
assert_true(file_exists($seedDir . '/users_seed.tsv'), 'users_seed.tsv must exist in seed_data/');
assert_true(file_exists($seedDir . '/users_seed.csv'), 'users_seed.csv must exist in seed_data/');
assert_true(file_exists($seedDir . '/modules_and_questions_seed.tsv'), 'modules_and_questions_seed.tsv must exist in seed_data/');
assert_true(file_exists($seedDir . '/modules_and_questions_seed.csv'), 'modules_and_questions_seed.csv must exist in seed_data/');
assert_true(file_exists($seedDir . '/showcase_seed.sql'), 'showcase_seed.sql must exist in seed_data/');
assert_true(file_exists($seedDir . '/showcase_results_seed.sql'), 'showcase_results_seed.sql must exist in seed_data/');
assert_true(file_exists($seedDir . '/README.md'), 'README.md must exist in seed_data/');

// =============================================================================
// Section 2: Users Dataset Integrity
// =============================================================================
$usersTsvLines = file($seedDir . '/users_seed.tsv', FILE_IGNORE_NEW_LINES);
assert_true($usersTsvLines !== false && count($usersTsvLines) >= 15, 'users_seed.tsv must contain at least 15 seeded users');

$header = explode("\t", $usersTsvLines[0]);
assert_equals(16, count($header), 'users_seed.tsv header must have exactly 16 columns');
assert_equals('user_name', $header[1], 'Column 1 must be user_name');
assert_equals('user_level', $header[12], 'Column 12 must be user_level');
assert_equals('user_groups', $header[15], 'Column 15 must be user_groups');

$levelsFound = [];
$groupsFound = [];
for ($i = 1; $i < count($usersTsvLines); $i++) {
    $row = explode("\t", $usersTsvLines[$i]);
    assert_equals(16, count($row), "User row $i must contain exactly 16 columns");
    $levelsFound[(int)$row[12]] = true;
    foreach (explode(',', $row[15]) as $grp) {
        $groupsFound[trim($grp)] = true;
    }
}

assert_true(isset($levelsFound[10]), 'Seeded users must include Administrator tier (Level 10)');
assert_true(isset($levelsFound[6]), 'Seeded users must include Identity Manager tier (Level 6)');
assert_true(isset($levelsFound[5]), 'Seeded users must include Test Operator tier (Level 5)');
assert_true(isset($levelsFound[3]), 'Seeded users must include Content Author tier (Level 3)');
assert_true(isset($levelsFound[1]), 'Seeded users must include Candidate tier (Level 1)');
assert_true(count($groupsFound) >= 5, 'Seeded users must span across at least 5 distinct groups/cohorts');

// =============================================================================
// Section 3: Questions & Modules Dataset Integrity
// =============================================================================
$fp = fopen($seedDir . '/modules_and_questions_seed.tsv', 'r');
assert_true($fp !== false, 'modules_and_questions_seed.tsv must be readable');

$mCount = 0;
$sCount = 0;
$qCount = 0;
$aCount = 0;
$sTypes = 0;
$mTypes = 0;
$curQ = null;

while (($row = fgetcsv($fp, 0, "\t", '"')) !== false) {
    if (!isset($row[0])) continue;
    switch ($row[0]) {
        case 'M':
            $mCount++;
            break;
        case 'S':
            $sCount++;
            break;
        case 'Q':
            $qCount++;
            if ($row[4] === 'S') $sTypes++;
            if ($row[4] === 'M') $mTypes++;
            break;
        case 'A':
            $aCount++;
            break;
    }
}
fclose($fp);

assert_true($mCount >= 3, "Curriculum must include at least 3 modules (found $mCount)");
assert_true($sCount >= 6, "Curriculum must include at least 6 subjects (found $sCount)");
assert_true($qCount >= 30, "Curriculum must include at least 30 questions (found $qCount)");
assert_true($sTypes > 0, 'Curriculum must include Single-Choice questions');
assert_true($mTypes > 0, 'Curriculum must include Multiple-Choice questions');
assert_true($aCount === $qCount * 4, "Every question must have exactly 4 answer options ($aCount answers for $qCount questions)");

// =============================================================================
// Section 4: CSV / TSV Parity
// =============================================================================
$csvContent = file_get_contents($seedDir . '/modules_and_questions_seed.csv');
$tsvConverted = F_csv_to_tsv($csvContent);
assert_true(strlen($tsvConverted) > 0, 'CSV must convert back to non-empty TSV cleanly');

// =============================================================================
// Section 5: Simulated Exam Results & Analytics Integrity
// =============================================================================
$resContent = file_get_contents($seedDir . '/showcase_results_seed.sql');
assert_true(strpos($resContent, 'tce_tests_users') !== false, 'Results seed must populate tce_tests_users');
assert_true(strpos($resContent, 'tce_tests_logs') !== false, 'Results seed must populate tce_tests_logs');
assert_true(strpos($resContent, 'tce_tests_logs_answers') !== false, 'Results seed must populate tce_tests_logs_answers');

preg_match_all('/INSERT INTO tce_tests_users/i', $resContent, $mAtt);
assert_equals(17, count($mAtt[0]), 'Must define exactly 17 candidate attempts');

preg_match_all('/SELECT t\.test_id, u\.user_id, 4,/i', $resContent, $mComp);
assert_equals(14, count($mComp[0]), 'Must define exactly 14 completed graded attempts (status 4)');

preg_match_all('/SELECT t\.test_id, u\.user_id, 0,/i', $resContent, $mRead);
assert_equals(3, count($mRead[0]), 'Must define exactly 3 ready-to-take candidate sessions (status 0)');

preg_match_all('/INSERT INTO tce_tests_logs\s*\(/i', $resContent, $mLog);
assert_equals(168, count($mLog[0]), 'Must define exactly 168 question logs (14 completed * 12 questions)');

preg_match_all('/INSERT INTO tce_tests_logs_answers/i', $resContent, $mAns);
assert_equals(168, count($mAns[0]), 'Must define exactly 168 answer selection evaluations');

// Summary
// =============================================================================
echo "\n------------------------------------------------------------\n";
if ($failures === []) {
    echo "SHOWCASE SEED INTEGRITY TEST PASSED: All seed structures and constraints valid.\n";
    exit(0);
} else {
    echo "SHOWCASE SEED INTEGRITY TEST FAILED with " . count($failures) . " issue(s).\n";
    exit(1);
}

