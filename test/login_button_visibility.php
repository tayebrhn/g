<?php

//============================================================+
// File name   : login_button_visibility.php
// Description : Regression test for login button visibility guard.
//============================================================+

/**
 * Verify that the userbar login button is suppressed when viewing the login
 * form or tce_login.php, that the top menu marks tce_login.php as active
 * rather than a clickable reload link, and that non-login anonymous pages
 * preserve the userbar login button.
 *
 * This test requires no database and no user account.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/../public/code');

if (! defined('K_NEWLINE')) {
    define('K_NEWLINE', PHP_EOL);
}

if (! defined('K_LANGUAGE_SELECTOR')) {
    define('K_LANGUAGE_SELECTOR', false);
}

$l = [
    'h_user_info' => 'user info',
    'w_user' => 'user',
    'h_logout_link' => 'logout',
    'w_logout' => 'logout',
    'h_login_button' => 'login',
    'w_login' => 'log in',
    'h_login_link' => 'login link',
    'a_meta_charset' => 'UTF-8',
];

require_once __DIR__ . '/../shared/code/tce_functions_menu.php';

$failures = [];

// ---------------------------------------------------------------------------
// 1. On login form ($GLOBALS['is_login_page'] = true)
// ---------------------------------------------------------------------------
$_SESSION = ['session_user_level' => 0];
$GLOBALS['is_login_page'] = true;
$_SERVER['SCRIPT_NAME'] = '/public/code/index.php';

ob_start();
include __DIR__ . '/../shared/code/tce_page_userbar.php';
$userbar_login_page = ob_get_clean();

if (strpos($userbar_login_page, 'loginbutton') !== false) {
    $failures[] = 'Userbar must not render login button when is_login_page is true.';
}

$menu_item = [
    'link' => 'tce_login.php',
    'title' => 'login',
    'name' => 'log in',
    'level' => 0,
    'key' => 'l',
    'enabled' => true,
];
$menu_login_page = F_menu_link('tce_login.php', $menu_item, 0);

if (strpos($menu_login_page, '<span class="active">log in</span>') === false) {
    $failures[] = 'Menu must mark tce_login.php as active span when is_login_page is true.';
}
if (strpos($menu_login_page, '<a href="tce_login.php"') !== false) {
    $failures[] = 'Menu must not render clickable link for tce_login.php when is_login_page is true.';
}

// ---------------------------------------------------------------------------
// 2. On tce_login.php directly
// ---------------------------------------------------------------------------
$GLOBALS['is_login_page'] = false;
$_SERVER['SCRIPT_NAME'] = '/public/code/tce_login.php';

ob_start();
include __DIR__ . '/../shared/code/tce_page_userbar.php';
$userbar_login_script = ob_get_clean();

if (strpos($userbar_login_script, 'loginbutton') !== false) {
    $failures[] = 'Userbar must not render login button on tce_login.php.';
}

$menu_login_script = F_menu_link('tce_login.php', $menu_item, 0);
if (strpos($menu_login_script, '<span class="active">log in</span>') === false) {
    $failures[] = 'Menu must mark tce_login.php as active span on tce_login.php.';
}

// ---------------------------------------------------------------------------
// 3. On non-login anonymous page (e.g. tce_user_registration.php)
// ---------------------------------------------------------------------------
$GLOBALS['is_login_page'] = false;
$_SERVER['SCRIPT_NAME'] = '/public/code/tce_user_registration.php';

ob_start();
include __DIR__ . '/../shared/code/tce_page_userbar.php';
$userbar_anon = ob_get_clean();

if (strpos($userbar_anon, 'loginbutton') === false) {
    $failures[] = 'Userbar must render login button on non-login anonymous pages.';
}

$menu_anon = F_menu_link('tce_login.php', $menu_item, 0);
if (strpos($menu_anon, '<a href="tce_login.php"') === false) {
    $failures[] = 'Menu must render clickable link for tce_login.php on non-login anonymous pages.';
}

// ---------------------------------------------------------------------------
// 4. Authenticated session (level >= 1)
// ---------------------------------------------------------------------------
$_SESSION['session_user_level'] = 1;
$_SESSION['session_user_name'] = 'candidate1';

ob_start();
include __DIR__ . '/../shared/code/tce_page_userbar.php';
$userbar_logged = ob_get_clean();

if (strpos($userbar_logged, 'logoutbutton') === false) {
    $failures[] = 'Userbar must render logout button when user is logged in.';
}
if (strpos($userbar_logged, 'candidate1') === false) {
    $failures[] = 'Userbar must render username when user is logged in.';
}
if (strpos($userbar_logged, 'loginbutton') !== false) {
    $failures[] = 'Userbar must not render login button when user is logged in.';
}

// ---------------------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Login button visibility guard tests passed.' . PHP_EOL;
