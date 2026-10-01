<?php

//============================================================+
// File name   : tce_auth_caps.php
// Begin       : 2026-09-24
// Last Update : 2026-09-24
//
// Description : Authorization capabilities (independent permissions).
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
 * Authorization capabilities (independent permissions).
 *
 * Each capability is a single bit of the tce_users.user_perms bitmask.
 * Capabilities are independent: granting a higher capability never
 * includes a lower one, and the numeric user level (rank) no longer
 * grants or withholds any capability. The level is only used for
 * precedence rules (which account an identity administrator may manage,
 * the maximum rank it may grant, and the visibility filters based on
 * "lower rank than me").
 *
 * Capabilities:
 *   K_PERM_VIEW_CONTENT      open the content editors in read-only mode
 *   K_PERM_EDIT_CONTENT      author modules, subjects, questions, answers,
 *                            multimedia files, question import
 *   K_PERM_OPERATOR          author tests, view/export results, rate answers,
 *                            import OMR, SSL certificates, online users
 *   K_PERM_MANAGE_IDENTITY   administer users and groups
 *   K_PERM_GLOBAL_VIEW       see the data of every group
 *   K_PERM_BACKUP            run backups
 *   K_PERM_ADMIN             system update, reassign record owners,
 *                            unrestricted grants (full administrator)
 *
 * The mask of every account is stored in tce_users.user_perms and copied
 * into the session variable "session_user_perms" at login, then refreshed
 * from the database at every request when K_CHECK_USER_PER_REQUEST is
 * enabled.
 *
 * @package com.tecnick.tcexam.shared
 * @author Nicola Asuni
 * @since 2026-09-24
 */

/**
 * Capability to open the content editors in read-only mode.
 */
define('K_PERM_VIEW_CONTENT', 1 << 0);

/**
 * Capability to author modules, subjects, questions, answers, multimedia files and to import questions.
 */
define('K_PERM_EDIT_CONTENT', 1 << 1);

/**
 * Capability to author tests, view and export results, rate free-text answers, import OMR answers, manage SSL certificates and display online users.
 */
define('K_PERM_OPERATOR', 1 << 2);

/**
 * Capability to administer users and groups.
 */
define('K_PERM_MANAGE_IDENTITY', 1 << 3);

/**
 * Capability to see the data of every group (not just the user's own groups).
 */
define('K_PERM_GLOBAL_VIEW', 1 << 4);

/**
 * Capability to run backups.
 */
define('K_PERM_BACKUP', 1 << 5);

/**
 * Capability to run the system update, reassign record owners and grant any capability (full administrator).
 */
define('K_PERM_ADMIN', 1 << 6);

/**
 * Mask of all the capabilities.
 */
define('K_PERM_ALL', K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY | K_PERM_GLOBAL_VIEW | K_PERM_BACKUP | K_PERM_ADMIN);

/**
 * Returns the capability mask of the current session.
 * Sessions created before the capabilities were introduced do not carry
 * the "session_user_perms" variable: their mask is derived from the
 * legacy cumulative level so that old sessions keep working until the
 * next login refreshes it from the database.
 * @return int capability mask of the current user
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_user_perms()
{
    if (isset($_SESSION['session_user_perms'])) {
        return (int) $_SESSION['session_user_perms'];
    }

    return F_cumulative_perms_for_level($_SESSION['session_user_level'] ?? 0);
}

/**
 * Returns true when the current user holds at least one of the specified
 * capabilities. A mask of 0 is held by anyone, so it disables the check.
 * @param $perm (int) bitmask of capabilities (any of them grants access)
 * @return boolean true when the user holds at least one of the capabilities
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_user_can_any($perm)
{
    return (F_user_perms() & (int) $perm) !== 0;
}

/**
 * Returns true when the current user holds all the specified capabilities.
 * A mask of 0 is held by anyone, so it disables the check.
 * @param $perm (int) bitmask of capabilities (all of them are required)
 * @return boolean true when the user holds all the capabilities
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_user_can($perm)
{
    return (F_user_perms() & (int) $perm) === (int) $perm;
}

/**
 * Returns the capability mask that reproduces the behaviour of the legacy
 * cumulative user level, so that an account migrated from a level-based
 * installation keeps exactly the rights it had.
 * @param $level (int) legacy user level
 * @return int capability mask
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_cumulative_perms_for_level($level)
{
    $level = (int) $level;
    if ($level >= 10) {
        return K_PERM_ALL;
    }

    if ($level == 9) {
        return K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY | K_PERM_GLOBAL_VIEW | K_PERM_BACKUP;
    }

    if ($level >= 6) {
        return K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY;
    }

    if ($level >= 5) {
        return K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR;
    }

    if ($level >= 3) {
        return K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT;
    }

    if ($level == 2) {
        return K_PERM_VIEW_CONTENT;
    }

    return 0;
}

/**
 * Returns the list of capabilities for the user editor and tables.
 * Each entry maps the capability bitmask to its language key and the
 * built-in English name used when the key is missing or empty.
 * @return array capability bitmask => [language key, built-in name]
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_getCapabilityNames()
{
    return [
        K_PERM_VIEW_CONTENT => ['w_cap_view_content', 'view content'],
        K_PERM_EDIT_CONTENT => ['w_cap_edit_content', 'edit content'],
        K_PERM_OPERATOR => ['w_cap_operator', 'operator'],
        K_PERM_MANAGE_IDENTITY => ['w_cap_manage_identity', 'manage users and groups'],
        K_PERM_GLOBAL_VIEW => ['w_cap_global_view', 'global view'],
        K_PERM_BACKUP => ['w_cap_backup', 'backup'],
        K_PERM_ADMIN => ['w_cap_admin', 'system administration'],
    ];
}

/**
 * Returns the human readable name of the specified capability, prefixed by
 * nothing. The name is taken from the language resources when defined and
 * otherwise falls back to the built-in English name.
 * @param $perm (int) capability bitmask (single capability)
 * @return string capability name
 * @author Nicola Asuni
 * @since 2026-09-24
 */
function F_getCapabilityLabel($perm)
{
    global $l;
    foreach (F_getCapabilityNames() as $mask => [$key, $default]) {
        if ($mask === (int) $perm) {
            return (isset($l[$key]) && $l[$key] !== '') ? $l[$key] : $default;
        }
    }

    return (string) $perm;
}

/**
 * Returns the list of capability help descriptions for the user editor and tables.
 * Each entry maps the capability bitmask to its language key and the
 * built-in English description used when the key is missing or empty.
 * @return array capability bitmask => [language key, built-in description]
 * @author Nicola Asuni
 * @since 2026-10-01
 */
function F_getCapabilityDescriptions()
{
    return [
        K_PERM_VIEW_CONTENT => ['h_cap_view_content', 'open content editors in read-only mode'],
        K_PERM_EDIT_CONTENT => ['h_cap_edit_content', 'create and edit modules, topics, questions, and answers in own groups'],
        K_PERM_OPERATOR => ['h_cap_operator', 'manage tests, grade answers, and view exam results in own groups'],
        K_PERM_MANAGE_IDENTITY => ['h_cap_manage_identity', 'create, edit, and assign users and groups globally across all groups'],
        K_PERM_GLOBAL_VIEW => ['h_cap_global_view', 'view all tests, questions, and exam results across every group; reveal answer keys in reports'],
        K_PERM_BACKUP => ['h_cap_backup', 'create, download, and restore system database and configuration backups'],
        K_PERM_ADMIN => ['h_cap_admin', 'full system administration, configuration, owner reassignment, and capability delegation'],
    ];
}

/**
 * Returns the human-readable description of the specified capability.
 * The description is taken from language resources when defined and
 * otherwise falls back to the built-in English text.
 * @param $perm (int) capability bitmask (single capability)
 * @return string capability description
 * @author Nicola Asuni
 * @since 2026-10-01
 */
function F_getCapabilityDescription($perm)
{
    global $l;
    foreach (F_getCapabilityDescriptions() as $mask => [$key, $default]) {
        if ($mask === (int) $perm) {
            return (isset($l[$key]) && $l[$key] !== '') ? $l[$key] : $default;
        }
    }

    return '';
}

//============================================================+
// END OF FILE
//============================================================+
