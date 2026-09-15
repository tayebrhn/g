<?php

//============================================================+
// File name   : authorization_tiers.php
// Description : Regression test for the authorization tiers.
//============================================================+

/**
 * Verify the authorization tier ladder, the visibility/read-only helpers derived
 * from it, and that the content editors cannot be modified at the view tier.
 *
 * This test requires the authorization configuration but does not connect to the
 * database or require a user account.
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

// The ladder must be ordered so that a higher level is never less privileged.
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

// Level 5 must keep the pre-existing operator behaviour.
$_SESSION['session_user_level'] = K_AUTH_OPERATOR;
if (F_is_readonly_content()) {
    $failures[] = 'Level ' . K_AUTH_OPERATOR . ' must not be read-only.';
}

if (F_has_global_view()) {
    $failures[] = 'Level ' . K_AUTH_OPERATOR . ' must not have global visibility.';
}

// The helpers must stay consistent with the tiers on every level.
for ($level = 0; $level <= K_AUTH_ADMINISTRATOR; ++$level) {
    $_SESSION['session_user_level'] = $level;
    if (F_is_readonly_content() !== ($level < K_AUTH_EDIT_CONTENT)) {
        $failures[] = 'F_is_readonly_content() inconsistent at level ' . $level . '.';
    }

    if (F_has_global_view() !== ($level >= K_AUTH_GLOBAL_VIEW)) {
        $failures[] = 'F_has_global_view() inconsistent at level ' . $level . '.';
    }
}

// Every level must have a label for the user editor dropdown.
for ($level = 0; $level <= K_AUTH_ADMINISTRATOR; ++$level) {
    if (F_getUserLevelLabel($level) === '') {
        $failures[] = 'Missing user level label for level ' . $level . '.';
    }
}

// The content editors must open at the view tier and refuse modifications when read-only.
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
    if (strpos($source, '$pagelevel = K_AUTH_VIEW_CONTENT;') === false) {
        $failures[] = $editor . ' must be gated at K_AUTH_VIEW_CONTENT.';
    }

    if (strpos($source, 'F_is_readonly_content()') === false) {
        $failures[] = $editor . ' must check F_is_readonly_content().';
    }

    if (strpos($source, "\$menu_mode = '';") === false) {
        $failures[] = $editor . ' must disable modifications for read-only users.';
    }
}

if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "Authorization tier checks passed." . PHP_EOL;
