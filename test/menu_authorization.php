<?php

//============================================================+
// File name   : menu_authorization.php
// Description : Regression test for admin menu authorization.
//============================================================+

/**
 * Verify the number of permitted links on each admin landing page for the
 * representative access levels.
 *
 * This test uses the real menu definitions and authorization helper but does
 * not connect to the database or require a user account.
 *
 * Tier mapping (see shared/code/tce_auth_tiers.php and admin/config/tce_auth.php):
 *   2  view content (modules/subjects/questions/answers editors, read-only)
 *   3  edit content (adds question import and file manager)
 *   5  examiner    (adds question list, and the whole tests section)
 *   6  manage identity (the whole users section)
 *   9  global view + backup
 *  10  administrator
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

$expected = [
    0 => ['users' => 0, 'modules' => 0, 'tests' => 0],
    1 => ['users' => 0, 'modules' => 0, 'tests' => 0],
    2 => ['users' => 0, 'modules' => 4, 'tests' => 0],
    3 => ['users' => 0, 'modules' => 6, 'tests' => 0],
    5 => ['users' => 0, 'modules' => 7, 'tests' => 5],
    6 => ['users' => 5, 'modules' => 7, 'tests' => 5],
    9 => ['users' => 5, 'modules' => 7, 'tests' => 5],
    10 => ['users' => 5, 'modules' => 7, 'tests' => 5],
];

$failures = [];
foreach ($expected as $level => $expectedCounts) {
    $_SESSION['session_user_level'] = $level;
    foreach ($sections as $section => $items) {
        $output = '';
        foreach ($items as $link => $data) {
            $output .= F_menu_link($link, $data, 1);
        }

        $actual = substr_count($output, '<li>');
        if ($actual !== $expectedCounts[$section]) {
            $failures[] = sprintf(
                'Level %d: expected %d %s links, received %d.',
                $level,
                $expectedCounts[$section],
                $section,
                $actual
            );
        }
    }
}

if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "Admin menu authorization checks passed." . PHP_EOL;
