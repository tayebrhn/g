<?php

//============================================================+
// File name   : answer_key_visibility.php
// Description : Regression test for the answer-key restriction.
//============================================================+

/**
 * Verify that the answer key (the correct answers) inside the result
 * reports is only visible to the question author:
 *
 *   F_canSeeAnswerKeys() - the owner of the subject the question belongs
 *   to, the users sharing a group with that owner, or the K_PERM_GLOBAL_VIEW
 *   users. Test-takers reading their own report, unrelated operators, and
 *   the anonymous recipients of the e-mailed reports (capability token)
 *   only see their own selected answers.
 *
 * The database functions are stubbed, so this test requires no database
 * and no user account. The renderers are checked by source assertions:
 * F_printUserTestStat(), the public tce_test_results.php loop and the PDF
 * printUserTestDetails() must all consult F_canSeeAnswerKeys() and gate
 * the explanations with it.
 *
 * The helper caches its result per subject for the lifetime of the request,
 * so every scenario below uses its own subject ID (exactly like a real
 * request, where the session never changes).
 *
 * Run with "php test/answer_key_visibility.php disabled" to verify the
 * legacy behaviour restored by K_RESTRICT_ANSWER_KEYS = false.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

// the switch must be defined before the helpers are loaded
if (! defined('K_RESTRICT_ANSWER_KEYS')) {
    define('K_RESTRICT_ANSWER_KEYS', ! in_array('disabled', $argv, true));
}
// The helpers include their configuration with the CWD-relative path
// "../config/tce_config.php"; from this directory that resolves to the
// database-free stub in ../config/tce_config.php.
chdir(__DIR__ . '/fixtures/code');

// ---------------------------------------------------------------------------
// Database stubs (defined before including the files under test).
// ---------------------------------------------------------------------------

$GLOBALS['stub_count_rows'] = [];
$GLOBALS['stub_fetch_rows'] = [];
$GLOBALS['stub_calls'] = ['count_rows' => 0, 'query' => 0, 'fetch' => 0];

function F_escape_sql($db, $str)
{
    return $str;
}

function F_count_rows($tables, $where = '')
{
    ++$GLOBALS['stub_calls']['count_rows'];
    $value = array_shift($GLOBALS['stub_count_rows']);
    return $value === null ? 0 : $value;
}

function F_db_query($sql, $db)
{
    ++$GLOBALS['stub_calls']['query'];
    return 'stub-result';
}

function F_db_fetch_array($result)
{
    ++$GLOBALS['stub_calls']['fetch'];
    $value = array_shift($GLOBALS['stub_fetch_rows']);
    return $value === null ? false : $value;
}

function F_display_db_error($exit = true)
{
    throw new RuntimeException('F_display_db_error() must not be called in the stubbed test.');
}

function getPasswordHash($password)
{
    return 'H(' . $password . ')';
}

function checkPassword($password, $hash)
{
    return $hash === 'H(' . $password . ')';
}

$db = 'stub-db';
$l = [];

require_once '../config/tce_config.php';
require_once __DIR__ . '/../shared/code/tce_functions_authorization.php';

$failures = [];

function reset_stub_db($count_rows = [], $fetch_rows = [])
{
    $GLOBALS['stub_count_rows'] = $count_rows;
    $GLOBALS['stub_fetch_rows'] = $fetch_rows;
    $GLOBALS['stub_calls'] = ['count_rows' => 0, 'query' => 0, 'fetch' => 0];
}

function check($label, $condition)
{
    if (! $condition) {
        $GLOBALS['failures'][] = $label;
        fwrite(STDERR, '  [FAIL] ' . $label . PHP_EOL);
    }
}

echo 'K_RESTRICT_ANSWER_KEYS = ' . (K_RESTRICT_ANSWER_KEYS ? 'true' : 'false') . PHP_EOL;

if (K_RESTRICT_ANSWER_KEYS) {
    // --- the subject owner may see the key --------------------------------
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 3, 'session_user_perms' => K_PERM_EDIT_CONTENT];
    reset_stub_db([1]);
    check('the subject owner sees the answer key', F_canSeeAnswerKeys(101) === true);

    // --- a user sharing a group with the owner may see the key -----------
    reset_stub_db([0, 1], [[5]]);
    check('a group peer of the subject owner sees the answer key', F_canSeeAnswerKeys(102) === true);

    // --- the global-view users may see the key ----------------------------
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 9, 'session_user_perms' => K_PERM_GLOBAL_VIEW];
    reset_stub_db();
    check('the GLOBAL_VIEW users see the answer key', F_canSeeAnswerKeys(103) === true);
    check('GLOBAL_VIEW check does not query the database', $GLOBALS['stub_calls']['count_rows'] === 0 && $GLOBALS['stub_calls']['query'] === 0);

    // --- an unrelated operator must NOT see the key -----------------------
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 5, 'session_user_perms' => K_PERM_OPERATOR];
    reset_stub_db([0, 0], [[5]]);
    check('an operator unrelated to the author does not see the answer key', F_canSeeAnswerKeys(104) === false);

    // --- a test-taker reading the own report must NOT see the key ---------
    $_SESSION = ['session_user_id' => 9, 'session_user_level' => 1, 'session_user_perms' => 0];
    reset_stub_db([0, 0], [[2]]);
    check('a test-taker does not see the answer key in the own report', F_canSeeAnswerKeys(105) === false);

    // --- an ADMIN capability without GLOBAL_VIEW does not bypass ----------
    $_SESSION = ['session_user_id' => 9, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ADMIN];
    reset_stub_db([0, 0], [[2]]);
    check('K_PERM_ADMIN without GLOBAL_VIEW does not reveal the answer key', F_canSeeAnswerKeys(106) === false);

    // --- anonymous sessions never see the key -----------------------------
    // (this is the e-mailed-results capability-token path)
    $_SESSION = ['session_user_id' => 1, 'session_user_level' => 0, 'session_user_perms' => 0];
    reset_stub_db([1]);
    check('an anonymous session (emailed-results token) does not see the answer key', F_canSeeAnswerKeys(107) === false);
    check('the anonymous guard does not query the database', $GLOBALS['stub_calls']['count_rows'] === 0 && $GLOBALS['stub_calls']['query'] === 0);

    // --- unknown subject: fail closed --------------------------------------
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ALL];
    reset_stub_db();
    check('an unknown subject fails closed', F_canSeeAnswerKeys(0) === false);

    // --- the result is cached per subject for the whole request ------------
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 3, 'session_user_perms' => K_PERM_EDIT_CONTENT];
    reset_stub_db([1]);
    F_canSeeAnswerKeys(108);
    $calls_after_first = $GLOBALS['stub_calls']['count_rows'] + $GLOBALS['stub_calls']['query'];
    F_canSeeAnswerKeys(108);
    F_canSeeAnswerKeys(108);
    $calls_after_third = $GLOBALS['stub_calls']['count_rows'] + $GLOBALS['stub_calls']['query'];
    check('the answer-key check is cached per subject', $calls_after_first === $calls_after_third);
} else {
    // --- legacy behaviour: whoever opens the report sees the key -----------
    $_SESSION = ['session_user_id' => 9, 'session_user_level' => 1, 'session_user_perms' => 0];
    reset_stub_db();
    check('with the restriction disabled the key is visible', F_canSeeAnswerKeys(7) === true);
    check('with the restriction disabled no database is queried', $GLOBALS['stub_calls']['count_rows'] === 0 && $GLOBALS['stub_calls']['query'] === 0);
}

// ---------------------------------------------------------------------------
// Source assertions: every result renderer must consult the helper.
// ---------------------------------------------------------------------------
$renderers = [
    'shared/code/tce_functions_test_stats.php' => ['F_canSeeAnswerKeys(', 'F_printUserTestStat'],
    'public/code/tce_test_results.php' => ['F_canSeeAnswerKeys('],
    'shared/code/tcpdfex.php' => ['F_canSeeAnswerKeys(', 'printUserTestDetails'],
    'admin/code/tce_xml_question_stats.php' => ['F_canSeeAnswerKeys('],
];

foreach ($renderers as $file => $required) {
    $source = @file_get_contents(__DIR__ . '/../' . $file);
    if ($source === false) {
        $failures[] = 'missing renderer: ' . $file;
        continue;
    }

    foreach ($required as $needle) {
        if (strpos($source, $needle) === false) {
            $failures[] = $file . ' must reference ' . $needle;
        }
    }
}

// the explanations are gated together with the key in every renderer
foreach (['shared/code/tce_functions_test_stats.php', 'public/code/tce_test_results.php', 'shared/code/tcpdfex.php'] as $file) {
    $source = file_get_contents(__DIR__ . '/../' . $file);
    if (strpos($source, 'show_keys && K_ENABLE_QUESTION_EXPLANATION') === false) {
        $failures[] = $file . ' must gate the question explanation with the answer key';
    }

    if (strpos($source, 'show_keys && K_ENABLE_ANSWER_EXPLANATION') === false) {
        $failures[] = $file . ' must gate the answer explanation with the answer key';
    }
}

// the helper must be defined in the shared authorization library
$source = file_get_contents(__DIR__ . '/../shared/code/tce_functions_authorization.php');
if (strpos($source, 'function F_canSeeAnswerKeys(') === false) {
    $failures[] = 'shared/code/tce_functions_authorization.php must define F_canSeeAnswerKeys()';
}

// ---------------------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Answer-key visibility checks passed.' . PHP_EOL;
