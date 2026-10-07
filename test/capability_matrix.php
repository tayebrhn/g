<?php

//============================================================+
// File name   : capability_matrix.php
// Description : Regression test for the capability bitmask model.
//============================================================+

/**
 * Verify that the capabilities are independent (never cumulative):
 *
 *   - the legacy level to mask mapping reproduces exactly the old ladder;
 *   - a capability mask is never extended by another capability;
 *   - every admin page declares its capability in $pageperm and no page
 *     still gates on a tier constant;
 *   - the menu entries reference defined capabilities.
 *
 * This test requires no database and no user account.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/../admin/code');

define('K_NEWLINE', PHP_EOL);

$_SESSION = [];
$l = [];

require_once('../config/tce_auth.php');
require_once('../../shared/code/tce_functions_general.php');
require_once('../../shared/code/tce_functions_authorization.php');

$failures = [];

// ---------------------------------------------------------------------------
// 1. The legacy level to mask mapping must reproduce the cumulative ladder.
// ---------------------------------------------------------------------------
$expected_mapping = [
    0 => 0,
    1 => 0,
    2 => K_PERM_VIEW_CONTENT,
    3 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT,
    4 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT,
    5 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR,
    6 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY,
    7 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY,
    8 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY,
    9 => K_PERM_VIEW_CONTENT | K_PERM_EDIT_CONTENT | K_PERM_OPERATOR | K_PERM_MANAGE_IDENTITY | K_PERM_GLOBAL_VIEW | K_PERM_BACKUP,
    10 => K_PERM_ALL,
];
foreach ($expected_mapping as $level => $mask) {
    if (F_cumulative_perms_for_level($level) !== $mask) {
        $failures[] = sprintf('The mapping of level %d must be %d.', $level, $mask);
    }

    // the fallback used by the sessions created before the capabilities
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => $level];
    if (F_user_perms() !== $mask) {
        $failures[] = sprintf('The level-%d session fallback must produce the mask %d.', $level, $mask);
    }
}

// ---------------------------------------------------------------------------
// 2. The capability predicates must not extend a mask.
// ---------------------------------------------------------------------------
$_SESSION = ['session_user_id' => 2, 'session_user_level' => 10, 'session_user_perms' => K_PERM_OPERATOR];
if (F_user_can(K_PERM_OPERATOR) !== true) {
    $failures[] = 'F_user_can() must accept the held capability.';
}
if (F_user_can_any(K_PERM_OPERATOR | K_PERM_ADMIN) !== true) {
    $failures[] = 'F_user_can_any() must accept a mask sharing a held bit.';
}
if (F_user_can(K_PERM_OPERATOR | K_PERM_ADMIN) !== false) {
    $failures[] = 'F_user_can() must reject a mask with unheld bits (all-of semantics).';
}
if (F_user_can(K_PERM_VIEW_CONTENT) !== false || F_user_can(K_PERM_EDIT_CONTENT) !== false) {
    $failures[] = 'The OPERATOR capability must not include the content capabilities.';
}
if (F_user_can(K_PERM_ADMIN) !== false) {
    $failures[] = 'The OPERATOR capability must not include K_PERM_ADMIN.';
}

// K_PERM_ADMIN alone must not unlock the content, identity or operator pages
$_SESSION['session_user_perms'] = K_PERM_ADMIN;
foreach ([K_PERM_VIEW_CONTENT, K_PERM_EDIT_CONTENT, K_PERM_OPERATOR, K_PERM_MANAGE_IDENTITY] as $perm) {
    if (F_user_can_any($perm) !== false) {
        $failures[] = 'K_PERM_ADMIN alone must not include the capability ' . $perm . '.';
    }
}

// a zero mask disables the checks (any-user pages and the token path)
$_SESSION['session_user_perms'] = 0;
if (F_user_can(0) !== true || F_user_can_any(0) !== false) {
    $failures[] = 'A zero capability mask has inconsistent semantics.';
}

// ---------------------------------------------------------------------------
// 3. Every admin page must declare its capability, none a legacy tier level.
// ---------------------------------------------------------------------------
$known_capabilities = [
    'K_PERM_VIEW_CONTENT',
    'K_PERM_EDIT_CONTENT',
    'K_PERM_OPERATOR',
    'K_PERM_MANAGE_IDENTITY',
    'K_PERM_BACKUP',
    'K_PERM_ADMIN',
    'K_PERM_ALL',
];
$pages = [
    'index.php' => 'K_PERM_ALL',
    'tce_colorpicker.php' => 'K_PERM_VIEW_CONTENT',
    'tce_edit_answer.php' => 'K_PERM_VIEW_CONTENT',
    'tce_edit_backup.php' => 'K_PERM_BACKUP',
    'tce_edit_group.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_edit_module.php' => 'K_PERM_VIEW_CONTENT',
    'tce_edit_question.php' => 'K_PERM_VIEW_CONTENT',
    'tce_edit_rating.php' => 'K_PERM_OPERATOR',
    'tce_edit_sslcerts.php' => 'K_PERM_OPERATOR',
    'tce_edit_subject.php' => 'K_PERM_VIEW_CONTENT',
    'tce_edit_test.php' => 'K_PERM_OPERATOR',
    'tce_edit_user.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_email_results.php' => 'K_PERM_OPERATOR',
    'tce_filemanager.php' => 'K_PERM_EDIT_CONTENT',
    'tce_import_questions.php' => 'K_PERM_EDIT_CONTENT',
    'tce_import_users.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_menu_modules.php' => 'K_PERM_VIEW_CONTENT',
    'tce_menu_tests.php' => 'K_PERM_OPERATOR',
    'tce_menu_users.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_pdf_all_questions.php' => 'K_PERM_OPERATOR',
    'tce_pdf_results.php' => 'K_PERM_OPERATOR',
    'tce_popup_test_info.php' => 'K_PERM_OPERATOR',
    'tce_preview_tcecode.php' => 'K_PERM_VIEW_CONTENT',
    'tce_select_mediafile.php' => 'K_PERM_EDIT_CONTENT',
    'tce_select_tests.php' => 'K_PERM_OPERATOR',
    'tce_select_tests_popup.php' => 'K_PERM_OPERATOR',
    'tce_select_users.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_select_users_popup.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_show_all_questions.php' => 'K_PERM_OPERATOR',
    'tce_show_online_users.php' => 'K_PERM_OPERATOR',
    'tce_show_result_allusers.php' => 'K_PERM_OPERATOR',
    'tce_show_result_user.php' => 'K_PERM_OPERATOR',
    'tce_tsv_questions.php' => 'K_PERM_OPERATOR',
    'tce_tsv_result_allusers.php' => 'K_PERM_OPERATOR',
    'tce_tsv_users.php' => 'K_PERM_MANAGE_IDENTITY',
    'tce_update.php' => 'K_PERM_ADMIN',
    'tce_xml_question_stats.php' => 'K_PERM_OPERATOR',
    'tce_xml_questions.php' => 'K_PERM_OPERATOR',
    'tce_xml_results.php' => 'K_PERM_OPERATOR',
    'tce_xml_user_results.php' => 'K_PERM_OPERATOR',
    'tce_xml_users.php' => 'K_PERM_MANAGE_IDENTITY',
];
foreach ($pages as $page => $capability) {
    $source = @file_get_contents($page);
    if ($source === false) {
        $failures[] = 'Missing admin page: ' . $page;
        continue;
    }

    $source = str_replace(["\r\n", "\r"], "\n", $source);
    if (preg_match('/\$pageperm\s*=\s*([^;]+);/', $source, $matches) !== 1) {
        $failures[] = $page . ' must declare its capability in $pageperm.';
        continue;
    }

    if (strpos($matches[1], $capability) === false) {
        $failures[] = $page . ' must be gated at ' . $capability . ' (found: ' . trim($matches[1]) . ').';
    }

    if (preg_match('/\$pagelevel\s*=\s*K_AUTH_/', $source) === 1) {
        $failures[] = $page . ' still gates on a legacy tier level.';
    }
}

// every $pageperm declaration must reference a known capability
foreach (glob('*.php') as $page) {
    $source = @file_get_contents($page);
    if ($source === false || strpos($source, '$pageperm') === false) {
        continue;
    }

    if (preg_match_all('/\$pageperm[^;]+;/', $source, $matches) === false) {
        continue;
    }

    foreach ($matches[0] as $declaration) {
        if (! preg_match('/K_PERM_[A-Z_]+/', $declaration, $perm_match)) {
            $failures[] = $page . ' declares $pageperm without a K_PERM_* capability.';
            continue;
        }

        if (! defined($perm_match[0]) && ! in_array($perm_match[0], $known_capabilities, true)) {
            $failures[] = $page . ' references the unknown capability ' . $perm_match[0] . '.';
        }
    }
}

// ---------------------------------------------------------------------------
// 4. The admin menu entries must reference defined capabilities.
// ---------------------------------------------------------------------------
$_SERVER['SCRIPT_NAME'] = '/admin/code/tce_menu_users.php';
$menu = [];
ob_start();
require 'tce_page_menu.php';
ob_end_clean();

foreach ($menu as $link => $data) {
    if (isset($data['perm']) && $data['perm'] != 0) {
        if (($data['perm'] & K_PERM_ALL) !== $data['perm']) {
            $failures[] = 'The menu item ' . $link . ' references an unknown capability.';
        }
    }

    foreach ($data['sub'] ?? [] as $sublink => $subdata) {
        if (isset($subdata['perm']) && $subdata['perm'] != 0) {
            if (($subdata['perm'] & K_PERM_ALL) !== $subdata['perm']) {
                $failures[] = 'The menu item ' . $sublink . ' references an unknown capability.';
            }
        }
    }
}

// ---------------------------------------------------------------------------
// 5. The rank must stay independent from the capabilities: the visibility
//    of the user lists must depend only on the rank, and F_has_global_view
//    only on the GLOBAL_VIEW capability.
// ---------------------------------------------------------------------------
foreach ([0, K_PERM_GLOBAL_VIEW, K_PERM_OPERATOR, K_PERM_ADMIN] as $perms) {
    $_SESSION = ['session_user_id' => 2, 'session_user_level' => 5, 'session_user_perms' => $perms];
    if (F_has_global_view() !== (($perms & K_PERM_GLOBAL_VIEW) !== 0)) {
        $failures[] = 'F_has_global_view() inconsistent for the mask ' . (int) $perms . '.';
    }
}

// ---------------------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Capability matrix checks passed.' . PHP_EOL;
