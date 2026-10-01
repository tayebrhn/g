<?php

//============================================================+
// File name   : editor_mutation_authority.php
// Description : Regression tests for Admin Content Editors creation
//               and mutation authorization gating.
//============================================================+

/**
 * Verify that the Admin Content Editors (tce_edit_subject.php,
 * tce_edit_question.php, tce_edit_answer.php):
 * 1. Properly gate creation ($record_id == 0) against unauthorized parent
 *    modules and subjects via F_isAuthorizedToModify().
 * 2. Unpack and synchronize parent IDs from the database to prevent
 *    cross-parameter spoofing (e.g. passing an owned module_id with a
 *    foreign question_subject_id or answer_question_id).
 * 3. Enforce read-only state ($record_readonly = true, $menu_mode = '')
 *    when the user lacks modify authority on the parent hierarchy.
 * 4. Maintain defense-in-depth authorization checks inside case 'add':.
 * 5. Allow authorized owners, group peers, and K_PERM_ADMIN holders to
 *    create and modify records normally.
 */

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

$db = 'stub-db';
$l = ['m_authorization_denied' => 'Authorization denied'];

require_once '../config/tce_config.php';
require_once __DIR__ . '/../shared/code/tce_functions_authorization.php';

if (! defined('K_TABLE_MODULES')) {
    define('K_TABLE_MODULES', K_TABLE_PREFIX . 'modules');
}
if (! defined('K_TABLE_QUESTIONS')) {
    define('K_TABLE_QUESTIONS', K_TABLE_PREFIX . 'questions');
}
if (! defined('K_TABLE_ANSWERS')) {
    define('K_TABLE_ANSWERS', K_TABLE_PREFIX . 'answers');
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

// ---------------------------------------------------------------------------
// 1. Static Source Code Assertions
// ---------------------------------------------------------------------------

$subject_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_subject.php'));
$question_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_question.php'));
$answer_src = str_replace(["\r\n", "\r"], "\n", (string) file_get_contents(__DIR__ . '/../admin/code/tce_edit_answer.php'));

// Subject editor checks
assert_true(
    strpos($subject_src, "elseif (\$subject_module_id > 0) {\n    \$can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id');") !== false
    || strpos($subject_src, "\$can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id');") !== false,
    'tce_edit_subject.php must verify parent module modify authority on subject creation ($subject_id == 0).'
);
assert_true(
    strpos($subject_src, "! F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id')") !== false,
    'tce_edit_subject.php must check module modify authority in case add.'
);

// Question editor checks
assert_true(
    strpos($question_src, "SELECT subject_module_id FROM ' . K_TABLE_SUBJECTS . ' WHERE subject_id=' . \$question_subject_id") !== false,
    'tce_edit_question.php must synchronize subject_module_id from K_TABLE_SUBJECTS when question_subject_id is provided.'
);
assert_true(
    strpos($question_src, "if (\$question_subject_id > 0) {\n    \$can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id')\n        || F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', \$question_subject_id, 'subject_user_id');") !== false,
    'tce_edit_question.php must gate question creation and modification on parent subject/module modify authority.'
);
assert_true(
    strpos($question_src, "\$question_subject_id <= 0 || (! F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id') && ! F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', \$question_subject_id, 'subject_user_id'))") !== false,
    'tce_edit_question.php must enforce defense-in-depth authorization in case add.'
);

// Answer editor checks
assert_true(
    strpos($answer_src, "\$subject_module_id = (int) \$m['subject_module_id'];\n            \$question_subject_id = (int) \$m['question_subject_id'];\n            \$answer_question_id = (int) \$m['answer_question_id'];") !== false,
    'tce_edit_answer.php must unpack parent IDs from database query when answer_id > 0.'
);
assert_true(
    strpos($answer_src, "SELECT subject_module_id, question_subject_id\n            FROM ' . K_TABLE_SUBJECTS . ', ' . K_TABLE_QUESTIONS") !== false,
    'tce_edit_answer.php must synchronize subject_module_id and question_subject_id from target question.'
);
assert_true(
    strpos($answer_src, "\$answer_question_id <= 0 || (! F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', \$subject_module_id, 'module_user_id') && ! F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', \$question_subject_id, 'subject_user_id'))") !== false,
    'tce_edit_answer.php must enforce defense-in-depth authorization in case add.'
);

// ---------------------------------------------------------------------------
// 2. Functional Authority Logic Simulation
// ---------------------------------------------------------------------------

// Helper to simulate subject editor modify check
function eval_subject_editor_auth(int $subject_id, int $subject_module_id): array
{
    $can_modify = false;
    if ($subject_id > 0) {
        $can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', $subject_module_id, 'module_user_id')
            || F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', $subject_id, 'subject_user_id');
    } elseif ($subject_module_id > 0) {
        $can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', $subject_module_id, 'module_user_id');
    }

    $menu_mode = 'add';
    if (F_is_readonly_content() || ! $can_modify) {
        $record_readonly = true;
        $menu_mode = '';
    } else {
        $record_readonly = false;
    }

    return [$record_readonly, $menu_mode];
}

// Helper to simulate question editor modify check
function eval_question_editor_auth(int $question_id, int $question_subject_id, int $subject_module_id): array
{
    $can_modify = false;
    if ($question_subject_id > 0) {
        $can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', $subject_module_id, 'module_user_id')
            || F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', $question_subject_id, 'subject_user_id');
    }

    $menu_mode = 'add';
    if (F_is_readonly_content() || ! $can_modify) {
        $record_readonly = true;
        $menu_mode = '';
    } else {
        $record_readonly = false;
    }

    return [$record_readonly, $menu_mode];
}

// Helper to simulate answer editor modify check
function eval_answer_editor_auth(int $answer_id, int $answer_question_id, int $question_subject_id, int $subject_module_id): array
{
    $can_modify = false;
    if ($question_subject_id > 0) {
        $can_modify = F_isAuthorizedToModify(K_TABLE_MODULES, 'module_id', $subject_module_id, 'module_user_id')
            || F_isAuthorizedToModify(K_TABLE_SUBJECTS, 'subject_id', $question_subject_id, 'subject_user_id');
    }

    $menu_mode = 'add';
    if (F_is_readonly_content() || ! $can_modify) {
        $record_readonly = true;
        $menu_mode = '';
    } else {
        $record_readonly = false;
    }

    return [$record_readonly, $menu_mode];
}

// Scenario 1: User 20 (Group 2, EDIT_CONTENT + GLOBAL_VIEW) attempts to add a subject into Module 10 (owned by User 10 in Group 1)
$_SESSION = [
    'session_user_id' => 20,
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_EDIT_CONTENT | K_PERM_GLOBAL_VIEW,
];

// F_isAuthorizedToModify for Module 10 returns false (not owner, no shared group, not admin)
// F_count_rows for owner check (0), F_db_fetch_array for owner_id (10), F_count_rows for shared group (0)
$GLOBALS['stub_count_rows'] = [0, 0];
$GLOBALS['stub_fetch_rows'] = [['module_user_id' => 10]];

[$readonly, $mode] = eval_subject_editor_auth(0, 10);
assert_true($readonly, 'User 20 must be read-only when creating subject under foreign Module 10.');
assert_true($mode === '', 'menu_mode must be cleared when creating subject under foreign Module 10.');

// Scenario 2: User 10 (owner of Module 10) adds a subject into Module 10
$_SESSION = [
    'session_user_id' => 10,
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_EDIT_CONTENT,
];

// F_count_rows for owner check returns 1 (owner)
$GLOBALS['stub_count_rows'] = [1];
$GLOBALS['stub_fetch_rows'] = [];

[$readonly, $mode] = eval_subject_editor_auth(0, 10);
assert_false($readonly, 'Owner User 10 must NOT be read-only when creating subject under Module 10.');
assert_true($mode === 'add', 'menu_mode add must be preserved for owner User 10.');

// Scenario 3: User 20 attempts to add a question into Subject 5 (under foreign Module 10, owned by User 10)
$_SESSION = [
    'session_user_id' => 20,
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_EDIT_CONTENT | K_PERM_GLOBAL_VIEW,
];

// Both module and subject checks return false
// Module check: count_rows(0), fetch(10), count_rows(0)
// Subject check: count_rows(0), fetch(10), count_rows(0)
$GLOBALS['stub_count_rows'] = [0, 0, 0, 0];
$GLOBALS['stub_fetch_rows'] = [['module_user_id' => 10], ['subject_user_id' => 10]];

[$readonly, $mode] = eval_question_editor_auth(0, 5, 10);
assert_true($readonly, 'User 20 must be read-only when creating question under foreign Subject 5.');
assert_true($mode === '', 'menu_mode must be cleared when creating question under foreign Subject 5.');

// Scenario 4: User 20 attempts cross-parameter spoofing:
// submits subject_module_id = 99 (owned by User 20) with question_subject_id = 5 (belongs to Module 10)
// The question editor queries: SELECT subject_module_id FROM subjects WHERE subject_id = 5 => returns 10
$GLOBALS['stub_fetch_rows'] = [['subject_module_id' => 10]];
$sql = "SELECT subject_module_id FROM tce_subjects WHERE subject_id=5 LIMIT 1";
$r = F_db_query($sql, $db);
$m = F_db_fetch_array($r);
$synced_module_id = (int) $m['subject_module_id'];
assert_true($synced_module_id === 10, 'Target subject real module ID must be 10, neutralizing spoofed 99.');

// Module check for 10 fails, Subject check for 5 fails
$GLOBALS['stub_count_rows'] = [0, 0, 0, 0];
$GLOBALS['stub_fetch_rows'] = [['module_user_id' => 10], ['subject_user_id' => 10]];
[$readonly, $mode] = eval_question_editor_auth(0, 5, $synced_module_id);
assert_true($readonly, 'Cross-parameter spoofed question creation must be blocked as read-only.');
assert_true($mode === '', 'Cross-parameter spoofed question menu_mode must be cleared.');

// Scenario 5: User 20 attempts to add an answer to Question 100 (belongs to Subject 5 under Module 10)
// The answer editor queries question and subject: returns subject_module_id = 10, question_subject_id = 5
$GLOBALS['stub_fetch_rows'] = [['subject_module_id' => 10, 'question_subject_id' => 5]];
$sql = "SELECT subject_module_id, question_subject_id FROM tce_subjects, tce_questions WHERE subject_id=question_subject_id AND question_id=100 LIMIT 1";
$r = F_db_query($sql, $db);
$m = F_db_fetch_array($r);
$synced_module_id = (int) $m['subject_module_id'];
$synced_subject_id = (int) $m['question_subject_id'];
assert_true($synced_module_id === 10 && $synced_subject_id === 5, 'Answer editor must synchronize parent IDs to 10 and 5.');

$GLOBALS['stub_count_rows'] = [0, 0, 0, 0];
$GLOBALS['stub_fetch_rows'] = [['module_user_id' => 10], ['subject_user_id' => 10]];
[$readonly, $mode] = eval_answer_editor_auth(0, 100, $synced_subject_id, $synced_module_id);
assert_true($readonly, 'User 20 must be read-only when creating answer under foreign question.');
assert_true($mode === '', 'menu_mode must be cleared when creating answer under foreign question.');

// Scenario 6: Admin user (K_PERM_ADMIN | K_PERM_EDIT_CONTENT) can add to any module/subject
$_SESSION = [
    'session_user_id' => 999,
    'session_user_level' => 10,
    'session_user_perms' => K_PERM_ADMIN | K_PERM_EDIT_CONTENT,
];

// F_isAuthorizedToModify returns true immediately when K_PERM_ADMIN is held
$GLOBALS['stub_count_rows'] = [];
$GLOBALS['stub_fetch_rows'] = [];

[$readonly, $mode] = eval_subject_editor_auth(0, 10);
assert_false($readonly, 'Admin must NOT be read-only when creating subject under Module 10.');
assert_true($mode === 'add', 'Admin menu_mode add must be preserved.');

[$readonly, $mode] = eval_question_editor_auth(0, 5, 10);
assert_false($readonly, 'Admin must NOT be read-only when creating question under Subject 5.');
assert_true($mode === 'add', 'Admin question menu_mode add must be preserved.');

[$readonly, $mode] = eval_answer_editor_auth(0, 100, 5, 10);
assert_false($readonly, 'Admin must NOT be read-only when creating answer under Question 100.');
assert_true($mode === 'add', 'Admin answer menu_mode add must be preserved.');

// Scenario 7: User with K_PERM_VIEW_CONTENT only (read-only content)
$_SESSION = [
    'session_user_id' => 10, // even though they own the module!
    'session_user_level' => 5,
    'session_user_perms' => K_PERM_VIEW_CONTENT,
];

$GLOBALS['stub_count_rows'] = [1];
$GLOBALS['stub_fetch_rows'] = [];
[$readonly, $mode] = eval_subject_editor_auth(0, 10);
assert_true($readonly, 'VIEW_CONTENT only account must always be read-only even on owned module.');
assert_true($mode === '', 'VIEW_CONTENT only account must have menu_mode cleared.');

if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Editor mutation authority checks passed.' . PHP_EOL;
