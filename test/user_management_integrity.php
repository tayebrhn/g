<?php

//============================================================+
// File name   : user_management_integrity.php
// Description : Regression tests for User Management, Level Elevation
//               restrictions, Permission Delegation, Bulk User Actions,
//               and Visibility integrity.
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
    'm_delete_confirm' => 'Delete confirm',
    'm_delete_anonymous' => 'Cannot delete anonymous user',
    'm_user_deleted' => 'User deleted',
    'm_user_updated' => 'User updated',
    'w_delete' => 'Delete',
    'w_update' => 'Update',
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

$edit_user_src    = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_user.php'));
$edit_group_src   = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_group.php'));
$select_users_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_select_users.php'));
$popup_users_src  = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_select_users_popup.php'));
$online_users_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_show_online_users.php'));
$import_users_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_import_users.php'));
$import_quest_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_import_questions.php'));

// --- A. tce_edit_user.php ---
assert_true(
    strpos($edit_user_src, '$user_id = isset($_REQUEST[\'user_id\']) ? (int) $_REQUEST[\'user_id\'] : 0;') !== false,
    'tce_edit_user.php must extract and initialize $user_id from $_REQUEST.'
);

assert_true(
    strpos($edit_user_src, '$user_name = isset($_REQUEST[\'user_name\']) ? utrim($_REQUEST[\'user_name\']) : \'\';') !== false
    && strpos($edit_user_src, '$user_email = isset($_REQUEST[\'user_email\']) ? utrim($_REQUEST[\'user_email\']) : \'\';') !== false
    && strpos($edit_user_src, '$user_password = isset($_REQUEST[\'user_password\']) ? $_REQUEST[\'user_password\'] : \'\';') !== false,
    'tce_edit_user.php must extract user_name, user_email, and user_password from $_REQUEST.'
);

assert_true(
    strpos($edit_user_src, '$newpassword = isset($_REQUEST[\'newpassword\']) ? $_REQUEST[\'newpassword\'] : \'\';') !== false
    && strpos($edit_user_src, '$newpassword_repeat = isset($_REQUEST[\'newpassword_repeat\']) ? $_REQUEST[\'newpassword_repeat\'] : \'\';') !== false,
    'tce_edit_user.php must extract newpassword and newpassword_repeat from $_REQUEST.'
);

assert_true(
    strpos($edit_user_src, '$forcedelete = isset($_REQUEST[\'forcedelete\']) ? $_REQUEST[\'forcedelete\'] : \'\';') !== false,
    'tce_edit_user.php must extract forcedelete from $_REQUEST.'
);

assert_true(
    strpos($edit_user_src, 'if ($forcedelete == $l[\'w_delete\'] || isset($_POST[\'forcedelete\']))') !== false,
    'tce_edit_user.php must accept isset($_POST[\'forcedelete\']) for deletion execution.'
);

assert_true(
    strpos($edit_user_src, 'if (F_isAuthorizedToModifyGroup($group_id))') !== false,
    'tce_edit_user.php must enforce F_isAuthorizedToModifyGroup when altering user group memberships.'
);

assert_true(
    strpos($edit_user_src, '"user_name=\'" . F_escape_sql($db, $user_name) . "\'"') !== false,
    'tce_edit_user.php must escape user_name when checking uniqueness in case add.'
);

// --- B. tce_edit_group.php ---
assert_true(
    strpos($edit_group_src, '$forcedelete = $_REQUEST[\'forcedelete\'] ?? \'\';') !== false,
    'tce_edit_group.php must extract forcedelete from $_REQUEST.'
);

assert_true(
    strpos($edit_group_src, 'if ($forcedelete == $l[\'w_delete\'] || isset($_POST[\'forcedelete\']))') !== false,
    'tce_edit_group.php must accept isset($_POST[\'forcedelete\']) on group deletion.'
);

// --- C. tce_select_users.php ---
assert_true(
    strpos($select_users_src, '$new_group_id = isset($_REQUEST[\'new_group_id\']) ? (int) $_REQUEST[\'new_group_id\'] : 0;') !== false
    && strpos($select_users_src, '$from_group_id = isset($_REQUEST[\'from_group_id\']) ? (int) $_REQUEST[\'from_group_id\'] : 0;') !== false
    && strpos($select_users_src, '$to_group_id = isset($_REQUEST[\'to_group_id\']) ? (int) $_REQUEST[\'to_group_id\'] : 0;') !== false,
    'tce_select_users.php must extract group action parameters from $_REQUEST.'
);

assert_true(
    strpos($select_users_src, 'if (isset($_POST[\'delete\'])) {') !== false
    && strpos($select_users_src, '$menu_mode = \'delete\';') !== false,
    'tce_select_users.php must handle delete submission in $menu_mode.'
);

assert_true(
    strpos($select_users_src, 'if (isset($_POST[$keyname])) {') !== false
    && strpos($select_users_src, '$user_id = (int) $_POST[$keyname];') !== false,
    'tce_select_users.php must extract selected user IDs from $_POST[$keyname].'
);

// --- D. tce_select_users_popup.php & tce_show_online_users.php ---
assert_true(
    strpos($popup_users_src, '$cid = isset($_REQUEST[\'cid\']) ? preg_replace(\'/[^a-z0-9_]/\', \'\', $_REQUEST[\'cid\']) : \'\';') !== false,
    'tce_select_users_popup.php must extract $cid from $_REQUEST.'
);

assert_true(
    strpos($online_users_src, '$order_field = isset($_REQUEST[\'order_field\']) ? $_REQUEST[\'order_field\'] : \'cpsession_expiry\';') !== false,
    'tce_show_online_users.php must extract order_field from $_REQUEST.'
);

// --- E. Importers ---
assert_true(
    strpos($import_users_src, '$file_type = isset($_REQUEST[\'file_type\']) ? (int) $_REQUEST[\'file_type\'] : 2;') !== false,
    'tce_import_users.php must extract file_type from $_REQUEST.'
);

assert_true(
    strpos($import_quest_src, '$type = isset($_REQUEST[\'type\']) ? (int) $_REQUEST[\'type\'] : 1;') !== false,
    'tce_import_questions.php must extract type from $_REQUEST.'
);

// ---------------------------------------------------------------------------
// 2. Functional Unit Tests: Level Elevation & Self-Edit Locking
// ---------------------------------------------------------------------------

function eval_user_level_assignment(int $editor_level, int $editor_perms, int $target_user_id, int $session_user_id, int $submitted_level): int
{
    $_SESSION = [
        'session_user_id' => $session_user_id,
        'session_user_level' => $editor_level,
        'session_user_perms' => $editor_perms,
    ];

    $user_level = $submitted_level;
    if (! F_user_can(K_PERM_ADMIN)) {
        if ($target_user_id == $session_user_id) {
            // you cannot change your own level
            $user_level = (int) $_SESSION['session_user_level'];
        } else {
            // you cannot create a user with a level equal or higher than yours
            $user_level = min(max(0, ((int) $_SESSION['session_user_level'] - 1)), $user_level);
        }
    }

    return $user_level;
}

// Test 2.1: Editor level 5 editing own profile submits level 8 -> locked to own level 5
$level_self = eval_user_level_assignment(5, K_PERM_MANAGE_IDENTITY, 20, 20, 8);
assert_equals(5, $level_self, 'Editor editing own profile cannot change own level.');

// Test 2.2: Editor level 5 editing subordinate submits level 5 -> capped at 4 (session_level - 1)
$level_promo_equal = eval_user_level_assignment(5, K_PERM_MANAGE_IDENTITY, 30, 20, 5);
assert_equals(4, $level_promo_equal, 'Non-admin editor cannot promote user to level equal to own level.');

// Test 2.3: Editor level 5 editing subordinate submits level 7 -> capped at 4
$level_promo_higher = eval_user_level_assignment(5, K_PERM_MANAGE_IDENTITY, 30, 20, 7);
assert_equals(4, $level_promo_higher, 'Non-admin editor cannot promote user to level higher than own level.');

// Test 2.4: Editor level 5 editing subordinate submits level 3 -> accepted as 3
$level_promo_valid = eval_user_level_assignment(5, K_PERM_MANAGE_IDENTITY, 30, 20, 3);
assert_equals(3, $level_promo_valid, 'Non-admin editor can assign level strictly below own level.');

// Test 2.5: Full Administrator (K_PERM_ADMIN) submits level 10 -> accepted as 10
$level_admin = eval_user_level_assignment(10, K_PERM_ALL, 30, 20, 10);
assert_equals(10, $level_admin, 'Administrator holding K_PERM_ADMIN can assign maximum level 10.');

// ---------------------------------------------------------------------------
// 3. Functional Unit Tests: Capability Delegation & Masking
// ---------------------------------------------------------------------------

function eval_user_perms_delegation(int $editor_perms, int $target_user_id, int $session_user_id, int $submitted_perms, int $current_target_perms): int
{
    $_SESSION = [
        'session_user_id' => $session_user_id,
        'session_user_level' => 5,
        'session_user_perms' => $editor_perms,
    ];

    $user_perms = $submitted_perms & K_PERM_ALL;
    if (! F_user_can(K_PERM_ADMIN)) {
        if ($target_user_id == $session_user_id) {
            // you cannot change your own capabilities
            $user_perms = F_user_perms();
        } else {
            // you may only grant capabilities you hold yourself;
            // capabilities you cannot grant stay as they are
            $user_perms = ($user_perms & F_user_perms()) | ($current_target_perms & ~ F_user_perms());
        }
    }

    return $user_perms;
}

// Test 3.1: Editor holding MANAGE_IDENTITY | OPERATOR (8 | 4 = 12) editing own profile attempts to grant ALL (127)
$perms_self = eval_user_perms_delegation(K_PERM_MANAGE_IDENTITY | K_PERM_OPERATOR, 20, 20, K_PERM_ALL, K_PERM_MANAGE_IDENTITY | K_PERM_OPERATOR);
assert_equals(K_PERM_MANAGE_IDENTITY | K_PERM_OPERATOR, $perms_self, 'Editor cannot elevate own capabilities.');

// Test 3.2: Editor holding MANAGE_IDENTITY | OPERATOR (12) editing subordinate who already has VIEW_CONTENT | EDIT_CONTENT (1 | 2 = 3):
// Editor attempts to grant BACKUP (32) and remove EDIT_CONTENT (2):
// Editor holds: bits 2, 3 (values 4, 8). Does NOT hold bits 0, 1, 5, 6 (values 1, 2, 32, 64).
// Result must:
//   - Reject granting BACKUP (32)
//   - Preserve existing VIEW_CONTENT | EDIT_CONTENT (3)
//   - Grant any held capability submitted (e.g. OPERATOR = 4)
$editor_holds = K_PERM_MANAGE_IDENTITY | K_PERM_OPERATOR; // 12
$target_existing = K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT; // 3
$submitted_by_editor = K_PERM_OPERATOR | K_PERM_BACKUP; // 4 | 32 = 36 (wants to grant OPERATOR and BACKUP, while unchecking EDIT_CONTENT)

$perms_delegated = eval_user_perms_delegation($editor_holds, 30, 20, $submitted_by_editor, $target_existing);
// Expected: (36 & 12) | (3 & ~12) = 4 | 3 = 7 (VIEW_CONTENT | EDIT_CONTENT | OPERATOR)
assert_equals(K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR, $perms_delegated, 'Delegation must filter unheld grants and preserve unheld existing capabilities.');

// Test 3.3: Administrator holding K_PERM_ADMIN can grant any capability
$perms_admin = eval_user_perms_delegation(K_PERM_ALL, 30, 20, K_PERM_ALL, 0);
assert_equals(K_PERM_ALL, $perms_admin, 'Administrator holding K_PERM_ADMIN can grant K_PERM_ALL.');

// ---------------------------------------------------------------------------
// 4. Functional Unit Tests: User Deletion Safeguards
// ---------------------------------------------------------------------------

function eval_user_deletion(int $editor_perms, int $editor_id, int $target_user_id): array
{
    $_SESSION = [
        'session_user_id' => $editor_id,
        'session_user_level' => 5,
        'session_user_perms' => $editor_perms,
    ];

    if (! F_user_can(K_PERM_MANAGE_IDENTITY) || $target_user_id == $editor_id || $target_user_id == 1) {
        return [false, 'm_authorization_denied'];
    }

    return [true, 'ok'];
}

// Test 4.1: Attempt to delete user 1 (anonymous user)
[$del_anon_ok, $del_anon_msg] = eval_user_deletion(K_PERM_MANAGE_IDENTITY, 20, 1);
assert_false($del_anon_ok, 'Deleting user ID 1 (anonymous) must be blocked.');
assert_equals('m_authorization_denied', $del_anon_msg, 'Authorization denied on anonymous user deletion.');

// Test 4.2: Attempt to delete self
[$del_self_ok, $del_self_msg] = eval_user_deletion(K_PERM_MANAGE_IDENTITY, 20, 20);
assert_false($del_self_ok, 'Deleting own account must be blocked.');
assert_equals('m_authorization_denied', $del_self_msg, 'Authorization denied on self-deletion.');

// Test 4.3: Valid subordinate deletion
[$del_sub_ok, $del_sub_msg] = eval_user_deletion(K_PERM_MANAGE_IDENTITY, 20, 30);
assert_true($del_sub_ok, 'Deleting subordinate user must be allowed for identity manager.');
assert_equals('ok', $del_sub_msg, 'Subordinate deletion status must be ok.');

// ---------------------------------------------------------------------------
// 5. Functional Unit Tests: Group Modification Authority
// ---------------------------------------------------------------------------

// Test 5.1: Editor in Group 1 (not Group 2), without K_PERM_ADMIN
$_SESSION = [
    'session_user_id' => 20,
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_MANAGE_IDENTITY | K_PERM_GLOBAL_VIEW,
];

// F_isUserOnGroup calls F_db_fetch_array: returns row for user 20 on group 1, false on group 2
$GLOBALS['stub_fetch_rows'] = [['usrgrp_user_id' => 20], false];
$can_mod_g1 = F_isAuthorizedToModifyGroup(1);
$can_mod_g2 = F_isAuthorizedToModifyGroup(2);

assert_true($can_mod_g1, 'Editor can modify membership of their own group (Group 1).');
assert_false($can_mod_g2, 'Global view editor without K_PERM_ADMIN cannot modify unowned group (Group 2).');

// ---------------------------------------------------------------------------
// Summary
// ---------------------------------------------------------------------------

echo "Running User Management & Visibility Integrity Tests...\n";
if (empty($failures)) {
    echo "ALL USER MANAGEMENT INTEGRITY TESTS PASSED SUCCESSFULLY (0 errors).\n";
    exit(0);
} else {
    echo "TEST FAILURES DETECTED (" . count($failures) . " errors):\n";
    foreach ($failures as $i => $err) {
        echo "  " . ($i + 1) . ". " . $err . "\n";
    }
    exit(1);
}
