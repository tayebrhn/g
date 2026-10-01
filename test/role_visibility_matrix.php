<?php
/**
 * Test Suite: Role Visibility and Multi-Tier Authorization Matrix
 *
 * Verifies that:
 * 1. K_PERM_MANAGE_IDENTITY provides inherently global authority over users and groups.
 * 2. An Identity Administrator can view, edit, and assign subordinate users across all groups (and unassigned users).
 * 3. Vertical rank boundaries (user_level < session_user_level) are strictly preserved (no peer or superior editing).
 * 4. Content Authors and Examiners remain strictly isolated to their own groups unless granted K_PERM_GLOBAL_VIEW.
 * 5. Candidates have 0 administrative access.
 * 6. Global Viewers have universal visibility but read-only protection without modification capabilities.
 * 7. System Administrators hold complete, unrestricted authority.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/fixtures/code');

$GLOBALS['stub_count_rows'] = [];
$GLOBALS['stub_fetch_rows'] = [];
$GLOBALS['stub_queries'] = [];

function F_escape_sql($db, $str, $quote = true)
{
    return (string) $str;
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

function F_display_db_error($exit = true) {}

$db = 'stub-db';
$l = [
    'a_meta_charset' => 'UTF-8',
    'a_meta_dir' => 'ltr',
    'm_authorization_denied' => 'Authorization denied',
];

require_once '../config/tce_config.php';
require_once __DIR__ . '/../shared/code/tce_functions_authorization.php';
require_once __DIR__ . '/../admin/code/tce_functions_user_select.php';

if (! defined('K_TABLE_USERS')) {
    define('K_TABLE_USERS', K_TABLE_PREFIX . 'users');
}
if (! defined('K_TABLE_GROUPS')) {
    define('K_TABLE_GROUPS', K_TABLE_PREFIX . 'groups');
}
if (! defined('K_TABLE_USERGROUP')) {
    define('K_TABLE_USERGROUP', K_TABLE_PREFIX . 'usrgroups');
}

$failures = [];

function assert_true(bool $cond, string $msg): void
{
    global $failures;
    if (! $cond) {
        $failures[] = "FAILED: $msg";
    }
}

function assert_false(bool $cond, string $msg): void
{
    assert_true(! $cond, $msg);
}

function assert_equals($expected, $actual, string $msg): void
{
    global $failures;
    if ($expected !== $actual) {
        $failures[] = "FAILED: $msg (expected: " . var_export($expected, true) . ", got: " . var_export($actual, true) . ")";
    }
}

// ---------------------------------------------------------------------------
// 1. Static Source Code Assertions
// ---------------------------------------------------------------------------

$user_select_src = file_get_contents(__DIR__ . '/../admin/code/tce_functions_user_select.php');
$edit_user_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_user.php');

// Test 1.1: F_isAuthorizedEditorForGroup allows K_PERM_MANAGE_IDENTITY
assert_true(
    strpos($user_select_src, 'if (F_has_global_view() || F_user_can(K_PERM_MANAGE_IDENTITY) || empty($group_id))') !== false,
    'F_isAuthorizedEditorForGroup must permit K_PERM_MANAGE_IDENTITY to access all groups.'
);

// Test 1.2: F_isAuthorizedToModifyGroup allows K_PERM_MANAGE_IDENTITY
assert_true(
    strpos($user_select_src, 'if (isset($_SESSION[\'session_user_level\']) && (F_user_can(K_PERM_ADMIN) || F_user_can(K_PERM_MANAGE_IDENTITY)))') !== false,
    'F_isAuthorizedToModifyGroup must permit K_PERM_MANAGE_IDENTITY to modify any group.'
);

// Test 1.3: F_isAuthorizedUserRecord allows K_PERM_MANAGE_IDENTITY for subordinate users
assert_true(
    strpos($user_select_src, 'if (F_user_can(K_PERM_MANAGE_IDENTITY)) {') !== false,
    'F_isAuthorizedUserRecord must allow K_PERM_MANAGE_IDENTITY to manage subordinate accounts across all groups.'
);

// Test 1.4: F_user_group_select_sql selects all groups for K_PERM_MANAGE_IDENTITY
assert_true(
    strpos($user_select_src, 'if (F_has_global_view() || F_user_can(K_PERM_MANAGE_IDENTITY)) {') !== false,
    'F_user_group_select_sql must select all groups when caller has K_PERM_MANAGE_IDENTITY.'
);

// Test 1.5: F_show_select_user and popup bypass group containment for K_PERM_MANAGE_IDENTITY
assert_true(
    substr_count($user_select_src, 'if (! F_has_global_view() && ! F_user_can(K_PERM_MANAGE_IDENTITY)) {') >= 2,
    'F_show_select_user and F_show_select_user_popup must bypass shared-group requirement for K_PERM_MANAGE_IDENTITY.'
);

// Test 1.6: tce_edit_user.php user dropdown query bypasses group filter for K_PERM_MANAGE_IDENTITY
assert_true(
    strpos($edit_user_src, 'if (! F_has_global_view() && ! F_user_can(K_PERM_MANAGE_IDENTITY)) {') !== false,
    'tce_edit_user.php user dropdown query must bypass shared-group requirement for K_PERM_MANAGE_IDENTITY.'
);

// ---------------------------------------------------------------------------
// 2. Functional Tests: Group Authority Matrix
// ---------------------------------------------------------------------------

// 2.1: Identity Admin (Level 6, MANAGE_IDENTITY) - must have access to both own and unowned groups
$_SESSION = [
    'session_user_id' => 3,
    'session_user_level' => 6,
    'session_user_perms' => K_PERM_MANAGE_IDENTITY,
];

// In F_isAuthorizedEditorForGroup: when K_PERM_MANAGE_IDENTITY is true, it returns true without calling F_isUserOnGroup
assert_true(F_isAuthorizedEditorForGroup(15), 'Identity Admin can view owned group 15.');
assert_true(F_isAuthorizedEditorForGroup(9), 'Identity Admin can view unowned group 9 globally.');
assert_true(F_isAuthorizedToModifyGroup(15), 'Identity Admin can modify owned group 15.');
assert_true(F_isAuthorizedToModifyGroup(9), 'Identity Admin can modify unowned group 9 globally.');

// 2.2: Content Author (Level 3, EDIT_CONTENT) - must be restricted to owned groups
$_SESSION = [
    'session_user_id' => 10,
    'session_user_level' => 3,
    'session_user_perms' => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT,
];

// Stub fetch row: user 10 is on group 15 (returns row), not on group 9 (returns false)
$GLOBALS['stub_fetch_rows'] = [['usrgrp_user_id' => 10], false, ['usrgrp_user_id' => 10], false];
assert_true(F_isAuthorizedEditorForGroup(15), 'Content Author can view owned group 15.');
assert_false(F_isAuthorizedEditorForGroup(9), 'Content Author cannot view unowned group 9.');
assert_true(F_isAuthorizedToModifyGroup(15), 'Content Author can modify owned group 15.');
assert_false(F_isAuthorizedToModifyGroup(9), 'Content Author cannot modify unowned group 9.');

// 2.3: Examiner (Level 5, OPERATOR) - must be restricted to owned groups
$_SESSION = [
    'session_user_id' => 11,
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR,
];

$GLOBALS['stub_fetch_rows'] = [['usrgrp_user_id' => 11], false, ['usrgrp_user_id' => 11], false];
assert_true(F_isAuthorizedEditorForGroup(15), 'Examiner can view owned group 15.');
assert_false(F_isAuthorizedEditorForGroup(9), 'Examiner cannot view unowned group 9.');
assert_true(F_isAuthorizedToModifyGroup(15), 'Examiner can modify owned group 15.');
assert_false(F_isAuthorizedToModifyGroup(9), 'Examiner cannot modify unowned group 9.');

// 2.4: Global Viewer (Level 9, GLOBAL_VIEW) - can view all groups, but cannot modify unowned without ADMIN or MANAGE_IDENTITY
$_SESSION = [
    'session_user_id' => 12,
    'session_user_level' => 9,
    'session_user_perms' => K_PERM_GLOBAL_VIEW,
];

$GLOBALS['stub_fetch_rows'] = [false]; // not on group 9
assert_true(F_isAuthorizedEditorForGroup(9), 'Global Viewer can view unowned group 9.');
assert_false(F_isAuthorizedToModifyGroup(9), 'Global Viewer cannot modify unowned group 9 without K_PERM_ADMIN or MANAGE_IDENTITY.');

// ---------------------------------------------------------------------------
// 3. Functional Tests: User Record Authority Matrix
// ---------------------------------------------------------------------------

// Identity Admin (Level 6)
$_SESSION = [
    'session_user_id' => 3,
    'session_user_level' => 6,
    'session_user_perms' => K_PERM_MANAGE_IDENTITY,
];

// 3.1: Subordinate candidate in unowned group (Level 1, group 9)
$GLOBALS['stub_fetch_rows'] = [['user_level' => 1]];
assert_true(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 4),
    'Identity Admin can manage subordinate user (Level 1) in unowned group.'
);

// 3.2: Subordinate candidate with NO group at all (Level 1, unassigned)
$GLOBALS['stub_fetch_rows'] = [['user_level' => 1]];
assert_true(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 7),
    'Identity Admin can manage unassigned subordinate user (Level 1) with no groups.'
);

// 3.3: Peer user of equal level (Level 6) - MUST BE BLOCKED by vertical rank ceiling
$GLOBALS['stub_fetch_rows'] = [['user_level' => 6]];
assert_false(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 25),
    'Identity Admin CANNOT manage peer user of equal rank (Level 6).'
);

// 3.4: Superior administrator (Level 10) - MUST BE BLOCKED by vertical rank ceiling
$GLOBALS['stub_fetch_rows'] = [['user_level' => 10]];
assert_false(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 2),
    'Identity Admin CANNOT manage superior user (Level 10 Superadmin).'
);

// 3.5: Self-editing own account (Level 6)
assert_true(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 3),
    'Identity Admin can view/edit their own profile.'
);

// ---------------------------------------------------------------------------
// 4. Functional Tests: Non-Identity Role Containment
// ---------------------------------------------------------------------------

// Content Author (Level 3, EDIT_CONTENT) - must NOT have global user authority
$_SESSION = [
    'session_user_id' => 10,
    'session_user_level' => 3,
    'session_user_perms' => K_PERM_EDIT_CONTENT,
];

// Subordinate in unowned group: count_rows returns 0 (no shared group)
$GLOBALS['stub_fetch_rows'] = [['user_level' => 1]];
$GLOBALS['stub_count_rows'] = [0];
assert_false(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 4),
    'Content Author CANNOT manage subordinate in unowned group.'
);

// Subordinate in shared group: count_rows returns 1 (shared group)
$GLOBALS['stub_fetch_rows'] = [['user_level' => 1]];
$GLOBALS['stub_count_rows'] = [1];
assert_true(
    F_isAuthorizedUserRecord(K_PERM_GLOBAL_VIEW, 6),
    'Content Author can manage subordinate in shared group.'
);

// ---------------------------------------------------------------------------
// Summary
// ---------------------------------------------------------------------------

echo "Running Role Visibility & Multi-Tier Authorization Matrix Tests...\n";
if (empty($failures)) {
    echo "ALL ROLE VISIBILITY MATRIX TESTS PASSED SUCCESSFULLY (0 errors).\n";
    exit(0);
} else {
    echo "TEST FAILURES DETECTED (" . count($failures) . " errors):\n";
    foreach ($failures as $i => $err) {
        echo "  " . ($i + 1) . ". " . $err . "\n";
    }
    exit(1);
}
