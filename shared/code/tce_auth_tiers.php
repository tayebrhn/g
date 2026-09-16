<?php

//============================================================+
// File name   : tce_auth_tiers.php
// Begin       : 2026-09-15
// Last Update : 2026-09-15
//
// Description : Authorization tiers (capability levels).
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
 * Authorization tiers (capability levels).
 *
 * These constants are the single place where a capability is mapped to a
 * numeric user level. Pages and helpers refer to the tier names; the numeric
 * values can be overridden from the per-installation configuration files
 * (admin/config/tce_auth.php), which are loaded before this file.
 *
 * Ladder:
 *   0  anonymous user
 *   1  registered user
 *   2  K_AUTH_VIEW_CONTENT     read-only access to group-shared content
 *   3  K_AUTH_EDIT_CONTENT     author modules/subjects/questions/answers/media/bulk import
 *   5  K_AUTH_OPERATOR         examiner: tests, results, rating, OMR, SSL, online users
 *   6  K_AUTH_MANAGE_IDENTITY  administer users and groups
 *   9  K_AUTH_GLOBAL_VIEW      see the data of every group
 *   9  K_AUTH_SITE_ADMIN       backup
 *  10  K_AUTH_ADMINISTRATOR   system administration
 *
 * Levels 4, 7 and 8 are intentionally left unassigned.
 *
 * The default of each tier reproduces the behaviour that existed before the
 * tier names were introduced, so upgrading the code alone never widens any
 * user's rights: rights only change when the installation config redefines a
 * tier's value.
 *
 * @package com.tecnick.tcexam.shared
 * @author Nicola Asuni
 * @since 2026-09-15
 */

/**
 * Required user's level to view (without editing) the content of the groups the user belongs to.
 */
if (!defined('K_AUTH_VIEW_CONTENT')) {
    define('K_AUTH_VIEW_CONTENT', 2);
}

/**
 * Required user's level to author modules, subjects, questions, answers, multimedia files and to import questions.
 */
if (!defined('K_AUTH_EDIT_CONTENT')) {
    define('K_AUTH_EDIT_CONTENT', 3);
}

/**
 * Required user's level to administer users and groups.
 */
if (!defined('K_AUTH_MANAGE_IDENTITY')) {
    define('K_AUTH_MANAGE_IDENTITY', defined('K_AUTH_ADMIN_USERS') ? K_AUTH_ADMIN_USERS : 10);
}

/**
 * Minimum user's level to see the data of every group (not just the user's own groups).
 */
if (!defined('K_AUTH_GLOBAL_VIEW')) {
    define('K_AUTH_GLOBAL_VIEW', defined('K_AUTH_ADMINISTRATOR') ? K_AUTH_ADMINISTRATOR : 10);
}

/**
 * Required user's level to run backups.
 */
if (!defined('K_AUTH_SITE_ADMIN')) {
    define('K_AUTH_SITE_ADMIN', defined('K_AUTH_BACKUP') ? K_AUTH_BACKUP : 10);
}

/**
 * Returns the human readable name of the specified user level, for use in labels and tables.
 *
 * The name is taken from the language resources when defined (see the "w_level_*" keys) and
 * otherwise falls back to the built-in English name, so the label is always available even
 * when the language resources have not been updated. Levels without an assigned
 * responsibility are named "unused". Unknown levels fall back to the level number, so the
 * result is never empty.
 *
 * @param $level (int) user level
 * @param $with_number (boolean) when true the label is prefixed with the level number, e.g. "3 - content author"
 * @return string level label
 * @author Nicola Asuni
 * @since 2026-09-15
 */
function F_getUserLevelLabel($level, $with_number = false)
{
    global $l;
    $level = (int) $level;
    $labels = [
        0 => ['w_level_anonymous', 'anonymous'],
        1 => ['w_level_registered', 'registered user'],
        2 => ['w_level_viewer', 'viewer (read-only)'],
        3 => ['w_level_author', 'content author'],
        4 => ['w_level_unused', 'unused'],
        5 => ['w_level_examiner', 'examiner'],
        6 => ['w_level_identity', 'identity administrator'],
        7 => ['w_level_unused', 'unused'],
        8 => ['w_level_unused', 'unused'],
        9 => ['w_level_siteadmin', 'site administrator'],
        10 => ['w_level_admin', 'administrator'],
    ];
    if (! isset($labels[$level])) {
        return (string) $level;
    }

    [$key, $default] = $labels[$level];
    $name = (isset($l[$key]) && $l[$key] !== '') ? $l[$key] : $default;
    return $with_number ? ($level . ' - ' . $name) : $name;
}

//============================================================+
// END OF FILE
//============================================================+
