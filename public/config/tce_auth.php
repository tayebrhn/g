<?php
//============================================================+
// File name   : tce_auth.php
// Begin       : 2010-09-17
// Last Update : 2023-11-30
//
// Description : Define access levels for each public page
//               Note:
//                0 = Anonymous user (uregistered user)
//                1 = registered user
//               10 = System Administrator
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

/**
 * @file
 * Configuration file: define access levels for each public page.
 * @package com.tecnick.tcexam.public.cfg
 * @author Nicola Asuni
 * @since 2010-09-17
 */

// ************************************************************
// SECURITY WARNING :
// SET THIS FILE AS READ ONLY AFTER MODIFICATIONS
// ************************************************************


/**
 * Required user's level to access index page.
 */
define('K_AUTH_PUBLIC_INDEX', 1);

/**
 * Required user's level to execute a test
 */
define('K_AUTH_PUBLIC_TEST_EXECUTE', 1);

/**
 * Required user's level to view test general information
 */
define('K_AUTH_PUBLIC_TEST_INFO', 1);

/**
 * Required user's level to view test results
 */
define('K_AUTH_PUBLIC_TEST_RESULTS', 1);

/**
 * Required user's level to access user page submenu
 */
define('K_AUTH_PAGE_USER', 1);

/**
 * Required user's level to change email
 */
define('K_AUTH_USER_CHANGE_EMAIL', 1);

/**
 * Required user's level to change password
 */
define('K_AUTH_USER_CHANGE_PASSWORD', 1);

/**
 * Required user's level to display a link for administration area
 */
define('K_ADMIN_LINK', 5);

// -- LEGACY TIER CONSTANTS (COMPATIBILITY ONLY) -------------------------------
// The shared helpers are gated by the independent capabilities defined in
// shared/code/tce_auth_caps.php (see PERMISSIONS.md); these constants are
// kept only for backward compatibility with older configurations.

/**
 * Read-only access to the content of the authorized groups.
 */
define('K_AUTH_VIEW_CONTENT', 2);

/**
 * Authoring of modules, subjects, questions, answers, multimedia files and question import.
 */
define('K_AUTH_EDIT_CONTENT', 3);

/**
 * Administration of users and groups.
 */
define('K_AUTH_MANAGE_IDENTITY', 6);

/**
 * Minimum level to see the data of every group (not just the user's own groups).
 */
define('K_AUTH_GLOBAL_VIEW', 9);

/**
 * Minimum level to run backups.
 */
define('K_AUTH_SITE_ADMIN', 9);

/**
 * Minimum page level for which a valid client SSL certificate is required.
 * Use false or a level above 10 to disable the control.
 * Use 0 to enable for all area.
 * Use 10 to enable just for the ADMIN pages.
 */
define('K_AUTH_SSL_LEVEL', false);

/**
 * Comma separated lit of SSL certificates IDs required to
 * access pages with K_AUTH_SSL_LEVEL level or more.
 */
define('K_AUTH_SSLIDS', '');

//============================================================+
// END OF FILE
//============================================================+
