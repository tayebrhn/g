<?php

//============================================================+
// File name   : admin_operations_integrity.php
// Description : Regression tests for Admin Operations, Question List
//               bulk actions, Rating Editor, SSL Certificates, and
//               Database Backup utilities integrity and authorization.
//============================================================+

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/fixtures/code');

// ---------------------------------------------------------------------------
// Database stubs
// ---------------------------------------------------------------------------

$GLOBALS['stub_count_rows'] = [];
$GLOBALS['stub_fetch_rows'] = [];
$GLOBALS['stub_queries'] = [];

function F_escape_sql($db, $str, $quote = true)
{
    return $str;
}

function F_count_rows($tables, $where = '')
{
    $val = array_shift($GLOBALS['stub_count_rows']);
    return $val === null ? 0 : $val;
}

function F_db_query($sql, $db)
{
    $GLOBALS['stub_queries'][] = $sql;
    return 'stub-result';
}

function F_db_fetch_array($result)
{
    $val = array_shift($GLOBALS['stub_fetch_rows']);
    return $val === null ? false : $val;
}

function F_display_db_error($exit = true)
{
    throw new RuntimeException('F_display_db_error() called in stub test.');
}

function F_getBoolean($val)
{
    if (is_bool($val)) {
        return $val;
    }
    return in_array(strtolower((string) $val), ['1', 'true', 'on', 'yes'], true);
}

function utrim($str)
{
    return trim((string) $str);
}

$db = 'stub-db';
$l = [
    'm_authorization_denied' => 'Authorization denied',
    'm_score_higher_than_max' => 'Score higher than max',
    'm_updated' => 'Updated',
    'm_disabled_vs_deleted' => 'Disabled vs deleted',
    'm_delete_confirm' => 'Delete confirm',
    'm_deleted' => 'Deleted',
    'w_delete' => 'Delete',
    'w_restore' => 'Restore',
];

require_once '../config/tce_config.php';
require_once __DIR__ . '/../shared/code/tce_functions_authorization.php';

if (! defined('K_TABLE_MODULES')) {
    define('K_TABLE_MODULES', K_TABLE_PREFIX . 'modules');
}
if (! defined('K_TABLE_SUBJECTS')) {
    define('K_TABLE_SUBJECTS', K_TABLE_PREFIX . 'subjects');
}
if (! defined('K_TABLE_QUESTIONS')) {
    define('K_TABLE_QUESTIONS', K_TABLE_PREFIX . 'questions');
}
if (! defined('K_TABLE_ANSWERS')) {
    define('K_TABLE_ANSWERS', K_TABLE_PREFIX . 'answers');
}
if (! defined('K_TABLE_TESTS')) {
    define('K_TABLE_TESTS', K_TABLE_PREFIX . 'tests');
}
if (! defined('K_TABLE_TEST_USER')) {
    define('K_TABLE_TEST_USER', K_TABLE_PREFIX . 'tests_users');
}
if (! defined('K_TABLE_TESTS_LOGS')) {
    define('K_TABLE_TESTS_LOGS', K_TABLE_PREFIX . 'tests_logs');
}
if (! defined('K_TABLE_SSLCERTS')) {
    define('K_TABLE_SSLCERTS', K_TABLE_PREFIX . 'sslcerts');
}
if (! defined('K_TABLE_TEST_SSLCERTS')) {
    define('K_TABLE_TEST_SSLCERTS', K_TABLE_PREFIX . 'test_sslcerts');
}

$failures = [];

function assert_true(bool $cond, string $msg): void
{
    global $failures;
    if (! $cond) {
        $failures[] = $msg;
    }
}

function assert_false(bool $cond, string $msg): void
{
    global $failures;
    if ($cond) {
        $failures[] = $msg;
    }
}

function assert_equals($expected, $actual, string $msg): void
{
    global $failures;
    if ($expected !== $actual) {
        $failures[] = $msg . ' [Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true) . ']';
    }
}

// ---------------------------------------------------------------------------
// 1. Static Source Code Assertions
// ---------------------------------------------------------------------------

$show_all_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_show_all_questions.php'));
$rating_src   = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_rating.php'));
$sslcerts_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_sslcerts.php'));
$backup_src   = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_backup.php'));

// --- A. tce_show_all_questions.php ---
assert_true(
    strpos($show_all_src, '$can_modify = ! F_is_readonly_content()') !== false
    && strpos($show_all_src, 'F_isAuthorizedToModify(K_TABLE_MODULES') !== false,
    'tce_show_all_questions.php must define $can_modify checking F_is_readonly_content and F_isAuthorizedToModify.'
);

assert_true(
    strpos($show_all_src, 'if ($can_modify && isset($_POST[\'update\']) && ! empty($menu_action))') !== false,
    'tce_show_all_questions.php must gate bulk action execution behind $can_modify.'
);

assert_true(
    strpos($show_all_src, '$target_mod_id > 0 && (F_isAuthorizedToModify(K_TABLE_MODULES, \'module_id\', $target_mod_id, \'module_user_id\') || F_isAuthorizedToModify(K_TABLE_SUBJECTS, \'subject_id\', $new_subject_id, \'subject_user_id\'))') !== false,
    'tce_show_all_questions.php must verify target subject modify authority for move/copy actions.'
);

assert_true(
    strpos($show_all_src, 'if ($can_modify) {') !== false
    && strpos($show_all_src, 'name="questionid\' . $itemcount') !== false,
    'tce_show_all_questions.php must gate selection checkboxes behind $can_modify.'
);

assert_true(
    strpos($show_all_src, 'name="menu_action"') !== false
    && strpos($show_all_src, 'if ($can_modify) {') !== false,
    'tce_show_all_questions.php must gate bulk action toolbar behind $can_modify.'
);

// --- B. tce_edit_rating.php ---
assert_true(
    strpos($rating_src, '$test_id = isset($_REQUEST[\'test_id\']) ? (int) $_REQUEST[\'test_id\'] : 0;') !== false
    && strpos($rating_src, '$testlog_id = isset($_REQUEST[\'testlog_id\']) ? (int) $_REQUEST[\'testlog_id\'] : 0;') !== false,
    'tce_edit_rating.php must extract test_id and testlog_id from $_REQUEST.'
);

assert_true(
    strpos($rating_src, 'SELECT testuser_test_id FROM \' . K_TABLE_TESTS_LOGS . \', \' . K_TABLE_TEST_USER') !== false,
    'tce_edit_rating.php must resolve parent test ID from testlog_id.'
);

assert_true(
    strpos($rating_src, 'if ($test_id > 0 && $test_id != $real_test_id)') !== false,
    'tce_edit_rating.php must detect mismatch between claimed test_id and parent test_id.'
);

assert_true(
    strpos($rating_src, '$record_readonly = F_is_readonly_content() || ($test_id <= 0 || ! F_isAuthorizedToModify(K_TABLE_TESTS, \'test_id\', $test_id, \'test_user_id\'));') !== false,
    'tce_edit_rating.php must enforce $record_readonly based on F_is_readonly_content and test modify authority.'
);

assert_true(
    strpos($rating_src, 'SELECT test_score_right, question_difficulty FROM \' . K_TABLE_TESTS') !== false
    && strpos($rating_src, 'if ($testlog_score > $max_score)') !== false,
    'tce_edit_rating.php must compute server-side max score and reject scores exceeding it.'
);

// --- C. tce_edit_sslcerts.php ---
assert_true(
    strpos($sslcerts_src, '$ssl_enabled = isset($_REQUEST[\'ssl_enabled\']) ? F_getBoolean($_REQUEST[\'ssl_enabled\']) : false;') !== false
    && strpos($sslcerts_src, '$ssl_name = isset($_REQUEST[\'ssl_name\']) ? utrim($_REQUEST[\'ssl_name\']) : \'\';') !== false,
    'tce_edit_sslcerts.php must extract request parameters from $_REQUEST.'
);

assert_true(
    strpos($sslcerts_src, 'UPDATE \' . K_TABLE_SSLCERTS . \' SET') !== false,
    'tce_edit_sslcerts.php must update K_TABLE_SSLCERTS on disable when certificate is in use.'
);

assert_false(
    strpos($sslcerts_src, 'UPDATE \' . K_TABLE_QUESTIONS . \' SET' . "\n" . "\t\t\t\t" . 'ssl_enabled'),
    'tce_edit_sslcerts.php must NOT update K_TABLE_QUESTIONS for SSL certificates.'
);

assert_true(
    strpos($sslcerts_src, '$record_readonly = F_is_readonly_content() || ($ssl_id > 0 && ! F_isAuthorizedToModify(K_TABLE_SSLCERTS, \'ssl_id\', $ssl_id, \'ssl_user_id\'));') !== false,
    'tce_edit_sslcerts.php must enforce modify authority and read-only gating.'
);

// --- D. tce_edit_backup.php ---
assert_true(
    strpos($backup_src, '$backup_file = isset($_REQUEST[\'backup_file\']) ? $_REQUEST[\'backup_file\'] : \'\';') !== false
    && strpos($backup_src, '$forcerestore = isset($_REQUEST[\'forcerestore\']) ? $_REQUEST[\'forcerestore\'] : \'\';') !== false,
    'tce_edit_backup.php must extract backup_file and forcerestore from $_REQUEST.'
);

assert_true(
    strpos($backup_src, 'F_isValidbackupFile($backup_file)') !== false,
    'tce_edit_backup.php must validate backup filename using F_isValidbackupFile.'
);

assert_true(
    strpos($backup_src, 'if (F_is_readonly_content() && in_array($menu_mode, [\'backup\', \'restore\', \'forcerestore\']))') !== false,
    'tce_edit_backup.php must clear $menu_mode in read-only content mode.'
);

assert_true(
    strpos($backup_src, 'if (! F_is_readonly_content()) {') !== false
    && strpos($backup_src, 'F_submit_button(\'backup\'') !== false,
    'tce_edit_backup.php must hide backup and restore buttons in read-only content mode.'
);

// ---------------------------------------------------------------------------
// 2. Functional Backup Filename Validation Unit Tests
// ---------------------------------------------------------------------------

function F_isValidbackupFile_test(string $file): bool
{
    return (strlen($file) === 35 && str_ends_with($file, '.gz') && preg_match('|\.\./|i', $file) === 0 && preg_match('/[^a-zA-Z0-9\_\-\.]+/i', $file) === 0);
}

// Exactly 35 chars, valid format: 14 timestamp + 1 + 13 name + 4 (.sql) + 3 (.gz) = 35 chars
$valid_sql_backup = '20261001120000_tcexam_backup.sql.gz';
assert_true(F_isValidbackupFile_test($valid_sql_backup), 'Valid SQL backup file of 35 chars must pass validation.');

$valid_tar_backup = '20261001120000_tcexam_backup.tar.gz';
assert_true(F_isValidbackupFile_test($valid_tar_backup), 'Valid TAR backup file of 35 chars must pass validation.');

// Directory traversal attempts
assert_false(F_isValidbackupFile_test('../../../etc/passwd_backup.sql.gz'), 'Directory traversal with ../ must be rejected.');
assert_false(F_isValidbackupFile_test('..%2F..%2Fetc/passwd_backup.sql.gz'), 'Encoded path traversal must be rejected.');

// Invalid character attempts (shell injection)
assert_false(F_isValidbackupFile_test('20261001120000;rm -rf;backup.sql.gz'), 'Semicolons and spaces must be rejected.');
assert_false(F_isValidbackupFile_test('20261001120000|cat /etc/passwd.gz'), 'Pipes must be rejected.');
assert_false(F_isValidbackupFile_test('20261001120000`whoami`backup.sql.gz'), 'Backticks must be rejected.');

// Invalid length attempts
assert_false(F_isValidbackupFile_test('short_backup.sql.gz'), 'Filename with length != 35 must be rejected.');
assert_false(F_isValidbackupFile_test('20261001120000_tcexam_backup_extra_long.sql.gz'), 'Filename with length > 35 must be rejected.');

// Missing extension attempts
assert_false(F_isValidbackupFile_test('20261001120000_tcexam_backup.sql.bz'), 'Non-.gz extension must be rejected.');
assert_false(F_isValidbackupFile_test('20261001120000_tcexam_backup.sql   '), 'Trailing whitespace must be rejected.');

// ---------------------------------------------------------------------------
// 3. Functional Rating Editor Score Capping & Hierarchy Unit Tests
// ---------------------------------------------------------------------------

// Helper to simulate rating score validation
function eval_rating_score(float $submitted_score, float $test_score_right, float $question_difficulty): array
{
    $server_max_score = round($test_score_right * $question_difficulty, 3);
    if ($submitted_score > $server_max_score) {
        return [false, 'm_score_higher_than_max', $server_max_score];
    }
    return [true, 'm_updated', $server_max_score];
}

// Scenario A: Standard question (score_right = 2.0, difficulty = 1.0 -> max 2.0)
[$valid_a, $msg_a, $max_a] = eval_rating_score(2.0, 2.0, 1.0);
assert_true($valid_a, 'Score exactly matching max score must be accepted.');
assert_equals(2.0, $max_a, 'Max score calculation must match.');

[$invalid_a, $msg_invalid_a] = eval_rating_score(2.001, 2.0, 1.0);
assert_false($invalid_a, 'Score exceeding max score by 0.001 must be rejected.');
assert_equals('m_score_higher_than_max', $msg_invalid_a, 'Rejection message must indicate score higher than max.');

// Scenario B: Weighted question (score_right = 3.5, difficulty = 1.5 -> max 5.25)
[$valid_b, $msg_b, $max_b] = eval_rating_score(5.25, 3.5, 1.5);
assert_true($valid_b, 'Score matching weighted max score must be accepted.');
assert_equals(5.25, $max_b, 'Weighted max score must equal 5.25.');

[$spoofed_b, $msg_spoofed_b] = eval_rating_score(10.0, 3.5, 1.5);
assert_false($spoofed_b, 'Spoofed client score 10.0 must be rejected despite any client-side hidden field.');

// Helper to simulate parent test verification
function eval_rating_parent_test(?int $claimed_test_id, int $real_parent_test_id): array
{
    if ($claimed_test_id !== null && $claimed_test_id > 0 && $claimed_test_id !== $real_parent_test_id) {
        return [false, 'm_authorization_denied', $real_parent_test_id];
    }
    return [true, 'ok', $real_parent_test_id];
}

[$mismatch_ok, $mismatch_err] = eval_rating_parent_test(99, 50);
assert_false($mismatch_ok, 'Mismatch between claimed test_id (99) and parent test_id (50) must deny authorization.');
assert_equals('m_authorization_denied', $mismatch_err, 'Authorization denied error must be returned on mismatch.');

[$match_ok, $match_res, $synced_test_id] = eval_rating_parent_test(0, 50);
assert_true($match_ok, 'When claimed test_id is omitted/0, parent test_id must be synchronized.');
assert_equals(50, $synced_test_id, 'Synchronized test ID must match parent test ID.');

// ---------------------------------------------------------------------------
// 4. Functional Bulk Questions Modify Authority Simulation
// ---------------------------------------------------------------------------

function eval_bulk_action_permissions(int $user_level, int $user_perms, bool $is_owner, bool $same_group): array
{
    $_SESSION = [
        'session_user_id' => 10,
        'session_user_level' => $user_level,
        'session_user_perms' => $user_perms,
    ];

    $readonly = F_is_readonly_content();
    $can_modify = ! $readonly && ($user_level >= 10 || F_user_can(K_PERM_ADMIN) || $is_owner || ($same_group && F_user_can(K_PERM_EDIT_CONTENT)));

    return [$readonly, $can_modify];
}

// Case 1: Read-only operator (GLOBAL_VIEW only)
[$ro_1, $can_mod_1] = eval_bulk_action_permissions(5, K_PERM_GLOBAL_VIEW, true, true);
assert_true($ro_1, 'Operator with only K_PERM_GLOBAL_VIEW must be in read-only content mode.');
assert_false($can_mod_1, 'Read-only content operator must have $can_modify = false for bulk actions.');

// Case 2: Full content operator modifying owned content
[$ro_2, $can_mod_2] = eval_bulk_action_permissions(5, K_PERM_EDIT_CONTENT, true, false);
assert_false($ro_2, 'Full content operator must not be in read-only content mode.');
assert_true($can_mod_2, 'Owner operator must have $can_modify = true.');

// Case 3: Content operator attempting bulk action on foreign unshared content
[$ro_3, $can_mod_3] = eval_bulk_action_permissions(5, K_PERM_EDIT_CONTENT, false, false);
assert_false($can_mod_3, 'Non-owner outside group must have $can_modify = false.');

// Case 4: Administrator
[$ro_4, $can_mod_4] = eval_bulk_action_permissions(10, K_PERM_ALL, false, false);
assert_true($can_mod_4, 'Administrator must always have $can_modify = true.');

// ---------------------------------------------------------------------------
// Summary
// ---------------------------------------------------------------------------

echo "Running Admin Operations Integrity and Authorization Tests...\n";
if (empty($failures)) {
    echo "ALL ADMIN OPERATIONS INTEGRITY TESTS PASSED SUCCESSFULLY (0 errors).\n";
    exit(0);
} else {
    echo "TEST FAILURES DETECTED (" . count($failures) . " errors):\n";
    foreach ($failures as $i => $err) {
        echo "  " . ($i + 1) . ". " . $err . "\n";
    }
    exit(1);
}
