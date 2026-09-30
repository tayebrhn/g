<?php
//============================================================+
// File name   : tce_config.php
// Begin       : 2026-09-24
// Last Update : 2026-09-24
//
// Description : Minimal configuration stub for the database-free
//               authorization tests (test/modify_authority.php).
//
//               The authorization helpers include their configuration
//               with the CWD-relative path "../config/tce_config.php".
//               The test changes the working directory to
//               test/fixtures/code so that this stub is loaded instead
//               of the real (database-connecting) configuration.
//               This file defines only the constants used by the
//               helpers under test and never connects to a database.
//
// Author: Nicola Asuni
//
// (c) Copyright:
//               Nicola Asuni
//               Tecnick.com LTD
//               www.tecnick.com
//               info@tecnick.com
//
// License:
//    Copyright (C) 2004-2026 Nicola Asuni - Tecnick.com LTD
//    See LICENSE.TXT file for more information.
//============================================================+

if (! defined('K_RANDOM_SECURITY')) {
    define('K_RANDOM_SECURITY', 'test-random-security-seed');
}

if (! defined('K_SECONDS_IN_MINUTE')) {
    define('K_SECONDS_IN_MINUTE', 60);
}

if (! defined('K_SECONDS_IN_HOUR')) {
    define('K_SECONDS_IN_HOUR', 60 * K_SECONDS_IN_MINUTE);
}

if (! defined('K_SECONDS_IN_DAY')) {
    define('K_SECONDS_IN_DAY', 24 * K_SECONDS_IN_HOUR);
}

if (! defined('K_TABLE_PREFIX')) {
    define('K_TABLE_PREFIX', 'tce_');
}

if (! defined('K_TABLE_USERS')) {
    define('K_TABLE_USERS', K_TABLE_PREFIX . 'users');
}

if (! defined('K_TABLE_USERGROUP')) {
    define('K_TABLE_USERGROUP', K_TABLE_PREFIX . 'usrgroups');
}

if (! defined('K_TABLE_SUBJECTS')) {
    define('K_TABLE_SUBJECTS', K_TABLE_PREFIX . 'subjects');
}

if (! defined('K_AUTH_VIEW_CONTENT')) {
    define('K_AUTH_VIEW_CONTENT', 2);
}

if (! defined('K_AUTH_EDIT_CONTENT')) {
    define('K_AUTH_EDIT_CONTENT', 3);
}

if (! defined('K_AUTH_OPERATOR')) {
    define('K_AUTH_OPERATOR', 5);
}

if (! defined('K_AUTH_MANAGE_IDENTITY')) {
    define('K_AUTH_MANAGE_IDENTITY', 6);
}

if (! defined('K_AUTH_GLOBAL_VIEW')) {
    define('K_AUTH_GLOBAL_VIEW', 9);
}

if (! defined('K_AUTH_SITE_ADMIN')) {
    define('K_AUTH_SITE_ADMIN', 9);
}

if (! defined('K_AUTH_ADMINISTRATOR')) {
    define('K_AUTH_ADMINISTRATOR', 10);
}
