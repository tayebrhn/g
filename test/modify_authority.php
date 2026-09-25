<?php

//============================================================+
// File name   : modify_authority.php
// Description : Regression test for the modify authorization helpers.
//============================================================+

/**
 * Verify that the "may I modify it?" predicates stay stricter than the
 * "may I see it?" predicates:
 *
 *   F_isAuthorizedToModify()       - owner, or a shared group, or K_PERM_ADMIN
 *   F_isAuthorizedToModifyUser()   - self, or a lower rank with a shared group, or K_PERM_ADMIN
 *   F_isAuthorizedToModifyGroup()  - own group, or K_PERM_ADMIN
 *
 * In particular a GLOBAL_VIEW user, which may SEE every record via
 * F_isAuthorizedUser(), must NOT be able to modify a record it does not own
 * and shares no group with - not even with a high rank, because capabilities
 * are independent. The database functions are stubbed, so this test requires
 * no database and no user account.
 *
 * The results-token helpers (F_getResultsToken / F_checkResultsToken) are
 * verified as well: signature validation and expiry. The final section
 * re-checks the main predicates through the legacy level fallback used by
 * the sessions created before the capabilities were introduced.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

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

// the rank is set to the maximum so that only the capabilities vary
$_SESSION = ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => 0];

require_once '../config/tce_config.php';
require_once __DIR__ . '/../shared/code/tce_functions_authorization.php';
require_once __DIR__ . '/../admin/code/tce_functions_user_select.php';

$failures = [];

function reset_stub_db($count_rows = [], $fetch_rows = [])
{
    $GLOBALS['stub_count_rows'] = $count_rows;
    $GLOBALS['stub_fetch_rows'] = $fetch_rows;
    $GLOBALS['stub_calls'] = ['count_rows' => 0, 'query' => 0, 'fetch' => 0];
}

function set_test_session($perms)
{
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => $perms];
}

// ---------------------------------------------------------------------------
// 1. F_isAuthorizedToModify (record level)
// ---------------------------------------------------------------------------
$modules_table = 'tce_modules';

// the K_PERM_ADMIN capability modifies everything without touching the database
set_test_session(K_PERM_ADMIN);
reset_stub_db();
if (! F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'K_PERM_ADMIN must be authorized to modify any record.';
}
if ($GLOBALS['stub_calls']['count_rows'] !== 0 || $GLOBALS['stub_calls']['query'] !== 0) {
    $failures[] = 'K_PERM_ADMIN modify check must not query the database.';
}

// ... while the GLOBAL_VIEW capability alone must not, not even at rank 10
set_test_session(K_PERM_GLOBAL_VIEW);
reset_stub_db([0, 0], [[5]]);
if (F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'A GLOBAL_VIEW user must not modify a record outside its groups.';
}

// ... and neither must the whole non-administrative mask
set_test_session(K_PERM_ALL & ~ K_PERM_ADMIN);
reset_stub_db([0, 0], [[5]]);
if (F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'A user without K_PERM_ADMIN must not modify a record outside its groups.';
}

// a new record can always be created by an authorized user
set_test_session(K_PERM_EDIT_CONTENT);
reset_stub_db();
if (! F_isAuthorizedToModify($modules_table, 'module_id', 0, 'module_user_id')) {
    $failures[] = 'A new record must be modifiable.';
}

// the owner may modify its own record
reset_stub_db([1]);
if (! F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'The record owner must be authorized to modify.';
}

// a user sharing a group with the owner may modify the record
reset_stub_db([0, 1], [[5]]);
if (! F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'A user sharing a group with the owner must be authorized to modify.';
}

// the GLOBAL_VIEW capability grants visibility but not modify rights
set_test_session(K_PERM_GLOBAL_VIEW);
reset_stub_db([0, 0], [[5]]);
if (! F_isAuthorizedUser($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'A GLOBAL_VIEW user must see every record.';
}

// a record owned by the anonymous user (owner_id = 1) is not modifiable without K_PERM_ADMIN
reset_stub_db([0, 0], [[1]]);
if (F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'A record owned by the anonymous user must not be modifiable without K_PERM_ADMIN.';
}

// ---------------------------------------------------------------------------
// 2. F_isAuthorizedToModifyUser
// ---------------------------------------------------------------------------
set_test_session(K_PERM_ADMIN);
reset_stub_db();
if (! F_isAuthorizedToModifyUser(9)) {
    $failures[] = 'K_PERM_ADMIN must be authorized to modify any user.';
}
if ($GLOBALS['stub_calls']['query'] !== 0) {
    $failures[] = 'K_PERM_ADMIN user-modify check must not query the database.';
}

if (! F_isAuthorizedToModifyUser(0)) {
    $failures[] = 'A new user must be modifiable.';
}

if (! F_isAuthorizedToModifyUser($_SESSION['session_user_id'])) {
    $failures[] = 'A user must be authorized to modify its own account.';
}

// a GLOBAL_VIEW user manages only lower-rank users sharing a group
set_test_session(K_PERM_GLOBAL_VIEW);
reset_stub_db([0], [['user_level' => 3]]);
if (F_isAuthorizedToModifyUser(9)) {
    $failures[] = 'A GLOBAL_VIEW user must not modify a user outside its groups.';
}

reset_stub_db([1], [['user_level' => 3]]);
if (! F_isAuthorizedToModifyUser(9)) {
    $failures[] = 'A GLOBAL_VIEW user must modify a lower-rank user sharing a group.';
}

reset_stub_db([1], [['user_level' => 10]]);
if (F_isAuthorizedToModifyUser(9)) {
    $failures[] = 'A user of equal or higher rank must never be modifiable at rank 10.';
}

// ---------------------------------------------------------------------------
// 3. F_isAuthorizedToModifyGroup
// ---------------------------------------------------------------------------
set_test_session(K_PERM_ADMIN);
reset_stub_db();
if (! F_isAuthorizedToModifyGroup(4)) {
    $failures[] = 'K_PERM_ADMIN must be authorized to modify any group.';
}
if ($GLOBALS['stub_calls']['query'] !== 0) {
    $failures[] = 'K_PERM_ADMIN group-modify check must not query the database.';
}

if (! F_isAuthorizedToModifyGroup(0)) {
    $failures[] = 'A new group must be modifiable.';
}

set_test_session(K_PERM_GLOBAL_VIEW);
reset_stub_db([], [[2]]);
if (! F_isAuthorizedToModifyGroup(4)) {
    $failures[] = 'A GLOBAL_VIEW user must modify a group it belongs to.';
}

reset_stub_db([], [false]);
if (F_isAuthorizedToModifyGroup(4)) {
    $failures[] = 'A GLOBAL_VIEW user must not modify a group it does not belong to.';
}

// ---------------------------------------------------------------------------
// 4. Results capability token
// ---------------------------------------------------------------------------
$now = time();

$token = F_getResultsToken(31, 12, 5, $now);
if (! F_checkResultsToken(31, 12, 5, $now, $token)) {
    $failures[] = 'A valid results token must be accepted.';
}

// an old token within the time to live still validates
$recent = $now - (int) floor(F_getResultsTokenTtl() / 2);
$token = F_getResultsToken(31, 12, 5, $recent);
if (! F_checkResultsToken(31, 12, 5, $recent, $token)) {
    $failures[] = 'A results token within its time to live must be accepted.';
}

// an expired token must be rejected
$expired = $now - (F_getResultsTokenTtl() + 100);
$token = F_getResultsToken(31, 12, 5, $expired);
if (F_checkResultsToken(31, 12, 5, $expired, $token)) {
    $failures[] = 'An expired results token must be rejected.';
}

// a token bound to other ids must be rejected
$token = F_getResultsToken(31, 12, 5, $now);
if (F_checkResultsToken(32, 12, 5, $now, $token)) {
    $failures[] = 'A results token must not validate for another test-user id.';
}

// a missing timestamp or empty token must be rejected
if (F_checkResultsToken(31, 12, 5, 0, $token)) {
    $failures[] = 'A results token without timestamp must be rejected.';
}
if (F_checkResultsToken(31, 12, 5, $now, '')) {
    $failures[] = 'An empty results token must be rejected.';
}

// ---------------------------------------------------------------------------
// 5. Legacy level fallback (sessions without session_user_perms)
// ---------------------------------------------------------------------------
// level 10 falls back to the full mask and modifies everything
$_SESSION = ['session_user_id' => 2, 'session_user_level' => 10];
reset_stub_db();
if (! F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'The level-10 fallback must authorize modifications.';
}

// level 9 falls back to GLOBAL_VIEW and must only see
$_SESSION = ['session_user_id' => 2, 'session_user_level' => 9];
reset_stub_db([0, 0], [[5]]);
if (F_isAuthorizedToModify($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'The level-9 fallback must not authorize modifications.';
}

if (! F_isAuthorizedUser($modules_table, 'module_id', 7, 'module_user_id')) {
    $failures[] = 'The level-9 fallback must keep global visibility.';
}

// ---------------------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Modify-authority checks passed.' . PHP_EOL;
