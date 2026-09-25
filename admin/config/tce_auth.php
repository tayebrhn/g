<?php
//============================================================+
// File name   : tce_auth.php
// Begin       : 2002-09-02
// Last Update : 2023-11-30
//
// Description : Define access levels for each admin page
//               Note:
//                0 = Anonymous user (uregistered user)
//                1 = registered user
//                2 = read-only access to the authorized groups content
//                3 = content author (modules, subjects, questions, answers, media, import)
//                5 = operator / examiner (tests, results, rating, OMR, SSL, online users)
//                6 = identity administrator (users and groups)
//                9 = site administrator (global visibility, backup)
//               10 = System Administrator
//               4, 7 and 8 are unused
//               The values of the tier constants below can be changed to
//               redistribute the responsibilities; see shared/code/tce_auth_tiers.php
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
 * Configuration file: define access levels for each admin page.
 * @package com.tecnick.tcexam.admin.cfg
 * @author Nicola Asuni
 * @since 2002-09-02
 */

// ************************************************************
// SECURITY WARNING :
// SET THIS FILE AS READ ONLY AFTER MODIFICATIONS
// ************************************************************

/**
 * Administrator level.
 */
define('K_AUTH_ADMINISTRATOR', 10);

/**
 * Operator level.
 */
define('K_AUTH_OPERATOR', 5);

// -- LEGACY TIER CONSTANTS (COMPATIBILITY ONLY) -------------------------------
// The pages are gated by the independent capabilities defined in
// shared/code/tce_auth_caps.php (see PERMISSIONS.md); the user level no
// longer grants any right and these constants are kept only for backward
// compatibility with older configurations and third-party code.

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
 * Required user's level to access index page.
 */
define('K_AUTH_INDEX', K_AUTH_OPERATOR);

// --- LEGACY CONSTANTS (COMPATIBILITY ONLY, DO NOT USE IN NEW CODE) -----------
// The constants below predate the authorization tiers. The pages no longer
// reference them: they use the tier constants defined above
// (K_AUTH_VIEW_CONTENT, K_AUTH_EDIT_CONTENT, K_AUTH_OPERATOR,
// K_AUTH_MANAGE_IDENTITY, K_AUTH_GLOBAL_VIEW, K_AUTH_SITE_ADMIN).
// They are kept defined so that older configurations and third-party code that
// still reference them keep working; changing their values has no effect on the
// shipped pages. See shared/code/tce_auth_tiers.php and PERMISSIONS.md.

/**
 * Required user's level to access "user editor".
 */
define('K_AUTH_ADMIN_USERS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to delete users.
 */
define('K_AUTH_DELETE_USERS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to export users.
 */
define('K_AUTH_EXPORT_USERS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to import users.
 */
define('K_AUTH_IMPORT_USERS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to access "group editor".
 */
define('K_AUTH_ADMIN_GROUPS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to delete user groups.
 */
define('K_AUTH_DELETE_GROUPS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to move users from one group to another.
 */
define('K_AUTH_MOVE_GROUPS', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to access "tcecode editor".
 */
define('K_AUTH_ADMIN_TCECODE', K_AUTH_OPERATOR);

/**
 * Required user's level to access "module editor".
 */
define('K_AUTH_ADMIN_MODULES', K_AUTH_OPERATOR);

/**
 * Required user's level to access "subject editor".
 */
define('K_AUTH_ADMIN_SUBJECTS', K_AUTH_OPERATOR);

/**
 * Required user's level to access "question editor".
 */
define('K_AUTH_ADMIN_QUESTIONS', K_AUTH_OPERATOR);

/**
 * Required user's level to access "answer editor".
 */
define('K_AUTH_ADMIN_ANSWERS', K_AUTH_OPERATOR);

/**
 * Required user's level to access "test editor".
 */
define('K_AUTH_ADMIN_TESTS', K_AUTH_OPERATOR);

/**
 * Required user's level to access "TCExam information".
 */
define('K_AUTH_ADMIN_INFO', 0);

/**
 * Required user's level to display online users.
 */
define('K_AUTH_ADMIN_ONLINE_USERS', K_AUTH_OPERATOR);

/**
 * Required user's level to upload images.
 */
define('K_AUTH_ADMIN_UPLOAD_IMAGES', K_AUTH_OPERATOR);

/**
 * Required user's level to manually rate free text answers.
 */
define('K_AUTH_ADMIN_RATING', K_AUTH_OPERATOR);

/**
 * Required user's level to display results.
 */
define('K_AUTH_ADMIN_RESULTS', K_AUTH_OPERATOR);

/**
 * Required user's level to import questions.
 */
define('K_AUTH_ADMIN_IMPORT', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to import OMR answers.
 */
define('K_AUTH_ADMIN_OMR_IMPORT', K_AUTH_OPERATOR);

/**
 * Required user's level to import questions.
 */
define('K_AUTH_BACKUP', K_AUTH_ADMINISTRATOR);

/**
 * Required user's level to access file manager for multimedia files.
 */
define('K_AUTH_ADMIN_FILEMANAGER', K_AUTH_OPERATOR);

/**
 * Required user's level to create and delete directories.
 */
define('K_AUTH_ADMIN_DIRS', K_AUTH_OPERATOR);

/**
 * Required user's level to delete multimedia files.
 */
define('K_AUTH_DELETE_MEDIAFILE', K_AUTH_OPERATOR);

/**
 * Required user's level to rename multimedia files.
 */
define('K_AUTH_RENAME_MEDIAFILE', K_AUTH_OPERATOR);

/**
 * Required user's level to edit SSL certificates.
 */
define('K_AUTH_ADMIN_SSLCERT', K_AUTH_OPERATOR);

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
