<?php

//============================================================+
// File name   : authorization_tiers.php
// Description : Regression test for the authorization capabilities.
//============================================================+

/**
 * Verify the capability helpers, the legacy level fallback, the level labels,
 * and that the content editors cannot be modified without the EDIT_CONTENT
 * capability.
 *
 * This test requires the authorization configuration but does not connect to
 * the database or require a user account.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/../admin/code');

define('K_NEWLINE', PHP_EOL);

$_SESSION = ['session_user_level' => 0];
$l = [];

require_once('../config/tce_auth.php');
require_once('../../shared/code/tce_functions_general.php');
require_once('../../shared/code/tce_functions_authorization.php');

$failures = [];

// The legacy tier constants must stay defined and ordered (backward
// compatibility for older configurations and third-party code).
$ladder = [
    'K_AUTH_VIEW_CONTENT',
    'K_AUTH_EDIT_CONTENT',
    'K_AUTH_OPERATOR',
    'K_AUTH_MANAGE_IDENTITY',
    'K_AUTH_GLOBAL_VIEW',
    'K_AUTH_SITE_ADMIN',
    'K_AUTH_ADMINISTRATOR',
];
$previous = -1;
foreach ($ladder as $name) {
    if (! defined($name)) {
        $failures[] = 'Undefined tier constant: ' . $name;
        continue;
    }

    $value = constant($name);
    if ($value < $previous) {
        $failures[] = sprintf('%s (%d) is below the previous tier (%d).', $name, $value, $previous);
    }

    $previous = $value;
}

// All the capability constants must be single, distinct bits.
$capabilities = [
    'K_PERM_VIEW_CONTENT',
    'K_PERM_EDIT_CONTENT',
    'K_PERM_OPERATOR',
    'K_PERM_MANAGE_IDENTITY',
    'K_PERM_GLOBAL_VIEW',
    'K_PERM_BACKUP',
    'K_PERM_ADMIN',
];
$seen_masks = [];
foreach ($capabilities as $name) {
    if (! defined($name)) {
        $failures[] = 'Undefined capability constant: ' . $name;
        continue;
    }

    $value = constant($name);
    if ($value <= 0 || ($value & ($value - 1)) !== 0) {
        $failures[] = $name . ' must be a single bit.';
    }

    if (isset($seen_masks[$value])) {
        $failures[] = $name . ' duplicates the mask of ' . $seen_masks[$value] . '.';
    }

    $seen_masks[$value] = $name;
}

if (defined('K_PERM_ALL') && K_PERM_ALL !== (K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY | K_PERM_GLOBAL_VIEW | K_PERM_BACKUP | K_PERM_ADMIN)) {
    $failures[] = 'K_PERM_ALL must be the mask of all the capabilities.';
}

// The capability helpers must not extend a mask with a higher capability.
$capability_checks = [
    [K_PERM_VIEW_CONTENT, true, false],
    [K_PERM_EDIT_CONTENT, false, false],
    [K_PERM_OPERATOR, true, false],
    [K_PERM_MANAGE_IDENTITY, true, false],
    [K_PERM_GLOBAL_VIEW, true, true],
    [K_PERM_BACKUP, true, false],
    [K_PERM_ADMIN, true, false],
    [K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT, false, false],
    [K_PERM_GLOBAL_VIEW | K_PERM_BACKUP, true, true],
    [K_PERM_ALL, false, true],
];
foreach ($capability_checks as [$mask, $readonly, $global_view]) {
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => $mask];
    if (F_is_readonly_content() !== $readonly) {
        $failures[] = sprintf('F_is_readonly_content() inconsistent for the mask %d.', $mask);
    }

    if (F_has_global_view() !== $global_view) {
        $failures[] = sprintf('F_has_global_view() inconsistent for the mask %d.', $mask);
    }

    if (F_user_can($mask) !== true || F_user_can_any($mask) !== true) {
        $failures[] = sprintf('F_user_can() must accept the current mask %d.', $mask);
    }

    if (F_user_can(K_PERM_ALL & ~ $mask) !== ($mask === K_PERM_ALL)) {
        $failures[] = sprintf('F_user_can() must reject the capabilities missing from the mask %d.', $mask);
    }
}

// The legacy level fallback must reproduce the cumulative ladder for the
// sessions created before the capabilities were introduced.
for ($level = 0; $level <= 10; ++$level) {
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => $level];
    if (F_is_readonly_content() !== ($level < K_AUTH_EDIT_CONTENT)) {
        $failures[] = 'F_is_readonly_content() inconsistent at level ' . $level . '.';
    }

    if (F_has_global_view() !== ($level >= K_AUTH_GLOBAL_VIEW)) {
        $failures[] = 'F_has_global_view() inconsistent at level ' . $level . '.';
    }
}

// Every level must have a label, both plain and prefixed with the level number.
for ($level = 0; $level <= 10; ++$level) {
    $name = F_getUserLevelLabel($level);
    if ($name === '') {
        $failures[] = 'Missing user level label for level ' . $level . '.';
    }

    if (F_getUserLevelLabel($level, true) !== $level . ' - ' . $name) {
        $failures[] = 'Numbered user level label is inconsistent for level ' . $level . '.';
    }
}

// Every capability must have a non-empty label for the user editor.
foreach (F_getCapabilityNames() as $cap_mask => $cap_info) {
    if (F_getCapabilityLabel($cap_mask) === '') {
        $failures[] = 'Missing capability label for mask ' . $cap_mask . '.';
    }
    if (F_getCapabilityDescription($cap_mask) === '') {
        $failures[] = 'Missing capability description for mask ' . $cap_mask . '.';
    }
}

// The content editors must open at the view capability and refuse
// modifications when the EDIT_CONTENT capability is missing.
$editors = [
    'tce_edit_module.php',
    'tce_edit_subject.php',
    'tce_edit_question.php',
    'tce_edit_answer.php',
];
foreach ($editors as $editor) {
    $source = @file_get_contents($editor);
    if ($source === false) {
        $failures[] = 'Missing content editor: ' . $editor;
        continue;
    }

    $source = str_replace(["\r\n", "\r"], "\n", $source);
    if (strpos($source, '$pageperm = K_PERM_VIEW_CONTENT;') === false) {
        $failures[] = $editor . ' must be gated at K_PERM_VIEW_CONTENT.';
    }

    if (strpos($source, 'F_is_readonly_content()') === false) {
        $failures[] = $editor . ' must check F_is_readonly_content().';
    }

    if (strpos($source, "\$menu_mode = '';") === false) {
        $failures[] = $editor . ' must disable modifications for read-only users.';
    }
}

// The mutating pages must gate modifications with the modify predicates, so a
// global viewer cannot change records it does not own (only the K_PERM_ADMIN
// capability may modify the records of other users).
$modifiers = [
    'tce_edit_module.php',
    'tce_edit_subject.php',
    'tce_edit_question.php',
    'tce_edit_answer.php',
    'tce_edit_test.php',
    'tce_edit_rating.php',
    'tce_edit_sslcerts.php',
    'tce_edit_user.php',
    'tce_edit_group.php',
];
foreach ($modifiers as $page) {
    $source = @file_get_contents($page);
    if ($source === false) {
        $failures[] = 'Missing page: ' . $page;
        continue;
    }

    if (strpos($source, 'F_isAuthorizedToModify') === false) {
        $failures[] = $page . ' must check F_isAuthorizedToModify*().';
    }

    if (strpos($source, '$record_readonly') === false) {
        $failures[] = $page . ' must set $record_readonly to disable modifications.';
    }
}

// The shared helpers must define the modify predicates without the global-view bypass.
$source = @file_get_contents('../../shared/code/tce_functions_authorization.php');
if ($source === false) {
    $failures[] = 'Missing shared/code/tce_functions_authorization.php';
} else {
    foreach (['F_isAuthorizedToModify(', 'F_isAuthorizedRecord(', 'F_getResultsToken(', 'F_checkResultsToken('] as $required) {
        if (strpos($source, 'function ' . $required) === false) {
            $failures[] = 'shared/code/tce_functions_authorization.php must define ' . rtrim($required, '(') . '().';
        }
    }
}

$source = @file_get_contents('tce_functions_user_select.php');
if ($source === false) {
    $failures[] = 'Missing admin/code/tce_functions_user_select.php';
} else {
    foreach (['F_isAuthorizedToModifyUser(', 'F_isAuthorizedToModifyGroup('] as $required) {
        if (strpos($source, 'function ' . $required) === false) {
            $failures[] = 'admin/code/tce_functions_user_select.php must define ' . rtrim($required, '(') . '().';
        }
    }
}

if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Authorization capability checks passed.' . PHP_EOL;
