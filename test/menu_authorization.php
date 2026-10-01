<?php

//============================================================+
// File name   : menu_authorization.php
// Description : Regression test for admin menu authorization.
//============================================================+

/**
 * Verify the number of permitted links on each admin landing page for the
 * representative capability masks and for the legacy level fallback.
 *
 * This test uses the real menu definitions and authorization helper but does
 * not connect to the database or require a user account.
 *
 * Capability masks (see shared/code/tce_auth_caps.php) are independent:
 * a mask is not extended by a higher capability. The legacy level rows
 * verify the fallback used by sessions created before the capabilities
 * were introduced.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/../admin/code');

define('K_NEWLINE', PHP_EOL);

$_SERVER['SCRIPT_NAME'] = '/admin/code/tce_menu_users.php';
$_SESSION = ['session_user_level' => 0];
$l = [];

ob_start();
require 'tce_page_menu.php';
ob_end_clean();

$sections = [
    'users' => $menu['tce_menu_users.php']['sub'],
    'modules' => $menu['tce_menu_modules.php']['sub'],
    'tests' => $menu['tce_menu_tests.php']['sub'],
];

$failures = [];

/**
 * Runs the menu renderer for each section with the given session state.
 * @param string $label description of the session under test
 * @param array $session $_SESSION replacement
 * @param array $expected section name => expected link count
 */
$menu_test_session = function (string $label, array $session, array $expected) use ($sections, &$failures) {
    $_SESSION = $session;
    foreach ($sections as $section => $items) {
        $output = '';
        foreach ($items as $link => $data) {
            $output .= F_menu_link($link, $data, 1);
        }

        $actual = substr_count($output, '<li>');
        if ($actual !== $expected[$section]) {
            $failures[] = sprintf('%s: expected %d %s links, received %d.', $label, $expected[$section], $section, $actual);
        }
    }
};

// --- capability masks: independent, never cumulative ----------------------
$menu_test_session(
    'OPERATOR only',
    ['session_user_id' => 2, 'session_user_level' => 5, 'session_user_perms' => K_PERM_OPERATOR],
    ['users' => 0, 'modules' => 1, 'tests' => 5]
);
$menu_test_session(
    'MANAGE_IDENTITY only',
    ['session_user_id' => 2, 'session_user_level' => 6, 'session_user_perms' => K_PERM_MANAGE_IDENTITY],
    ['users' => 5, 'modules' => 0, 'tests' => 0]
);
$menu_test_session(
    'VIEW_CONTENT only',
    ['session_user_id' => 2, 'session_user_level' => 2, 'session_user_perms' => K_PERM_VIEW_CONTENT],
    ['users' => 0, 'modules' => 4, 'tests' => 0]
);
$menu_test_session(
    'EDIT_CONTENT only (the VIEW_CONTENT editors stay closed)',
    ['session_user_id' => 2, 'session_user_level' => 3, 'session_user_perms' => K_PERM_EDIT_CONTENT],
    ['users' => 0, 'modules' => 2, 'tests' => 0]
);
$menu_test_session(
    'GLOBAL_VIEW only',
    ['session_user_id' => 2, 'session_user_level' => 9, 'session_user_perms' => K_PERM_GLOBAL_VIEW],
    ['users' => 0, 'modules' => 0, 'tests' => 0]
);
$menu_test_session(
    'ADMIN without content capabilities',
    ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ADMIN],
    ['users' => 0, 'modules' => 0, 'tests' => 0]
);
$menu_test_session(
    'all capabilities',
    ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ALL],
    ['users' => 5, 'modules' => 7, 'tests' => 5]
);

// --- legacy level fallback (sessions created before the capabilities) ------
$legacy_expected = [
    0 => ['users' => 0, 'modules' => 0, 'tests' => 0],
    1 => ['users' => 0, 'modules' => 0, 'tests' => 0],
    2 => ['users' => 0, 'modules' => 4, 'tests' => 0],
    3 => ['users' => 0, 'modules' => 6, 'tests' => 0],
    5 => ['users' => 0, 'modules' => 7, 'tests' => 5],
    6 => ['users' => 5, 'modules' => 7, 'tests' => 5],
    9 => ['users' => 5, 'modules' => 7, 'tests' => 5],
    10 => ['users' => 5, 'modules' => 7, 'tests' => 5],
];
foreach ($legacy_expected as $level => $expectedCounts) {
    $menu_test_session(
        'legacy level ' . $level,
        ['session_user_id' => 2, 'session_user_level' => $level],
        $expectedCounts
    );
}

// --- top-level admin menu: index.php must be visible to all capability holders ---
$top_menu_sessions = [
    'OPERATOR only' => [['session_user_id' => 2, 'session_user_level' => 5, 'session_user_perms' => K_PERM_OPERATOR], true],
    'MANAGE_IDENTITY only' => [['session_user_id' => 2, 'session_user_level' => 6, 'session_user_perms' => K_PERM_MANAGE_IDENTITY], true],
    'VIEW_CONTENT only' => [['session_user_id' => 2, 'session_user_level' => 2, 'session_user_perms' => K_PERM_VIEW_CONTENT], true],
    'EDIT_CONTENT only' => [['session_user_id' => 2, 'session_user_level' => 3, 'session_user_perms' => K_PERM_EDIT_CONTENT], true],
    'GLOBAL_VIEW only' => [['session_user_id' => 2, 'session_user_level' => 9, 'session_user_perms' => K_PERM_GLOBAL_VIEW], true],
    'BACKUP only' => [['session_user_id' => 2, 'session_user_level' => 9, 'session_user_perms' => K_PERM_BACKUP], true],
    'ADMIN without content capabilities' => [['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ADMIN], true],
    'all capabilities' => [['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_ALL], true],
    'anonymous user' => [['session_user_level' => 0], false],
    'test-taker level 1 (no capabilities)' => [['session_user_id' => 2, 'session_user_level' => 1, 'session_user_perms' => 0], false],
];

foreach ($top_menu_sessions as $label => [$session, $should_see_index]) {
    $_SESSION = $session;
    $output = F_menu_link('index.php', $menu['index.php'], 0);
    $sees_index = (is_string($output) && strpos($output, '<li>') !== false);
    if ($sees_index !== $should_see_index) {
        $failures[] = sprintf('%s: expected index.php visibility %s, received %s.', $label, $should_see_index ? 'true' : 'false', $sees_index ? 'true' : 'false');
    }
}

if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Admin menu authorization checks passed.' . PHP_EOL;
