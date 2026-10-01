<?php

//============================================================+
// File name   : candidate_flow_integrity.php
// Description : Regression tests for candidate test execution
//               and result flow integrity.
//============================================================+

/**
 * Verify candidate flow protections:
 *   1. Page header inclusion occurs strictly after parameter/visibility validation
 *      in public test result and start scripts to ensure clean 302 redirects.
 *   2. Free-text answer textarea outputs valid XHTML class attributes (no malformed markup).
 *   3. Client-side timer (timer.js) guards DOM element lookups and avoids eval-based intervals.
 *   4. Keyboard shortcut handling guards against input/textarea focus hijacking.
 *   5. Test completion logic routes to immediate results when test_results_to_users is enabled.
 */

declare(strict_types=1);

error_reporting(E_ALL);

chdir(__DIR__ . '/..');

$failures = [];

// ---------------------------------------------------------------------------
// 1. Header inclusion order in public scripts
// ---------------------------------------------------------------------------
$scripts_to_check = [
    'public/code/tce_test_results.php' => [
        'validation_patterns' => ['/\$_REQUEST\[[\'"]testid[\'"]\]/', '/test_results_to_users/'],
        'header_pattern' => '/require_once\([\'"]\.\.\/code\/tce_page_header\.php[\'"]\)/',
    ],
    'public/code/tce_show_result_user.php' => [
        'validation_patterns' => ['/\$_REQUEST\[[\'"]testuser_id[\'"]\]/', '/\$_REQUEST\[[\'"]test_id[\'"]\]/', '/test_results_to_users/'],
        'header_pattern' => '/require_once\([\'"]\.\.\/code\/tce_page_header\.php[\'"]\)/',
    ],
    'public/code/tce_test_start.php' => [
        'validation_patterns' => ['/\$_REQUEST\[[\'"]testid[\'"]\]/'],
        'header_pattern' => '/require_once\([\'"]\.\.\/code\/tce_page_header\.php[\'"]\)/',
    ],
];

foreach ($scripts_to_check as $path => $checks) {
    $content = @file_get_contents($path);
    if ($content === false) {
        $failures[] = "Unable to read script: $path";
        continue;
    }

    if (preg_match($checks['header_pattern'], $content, $header_match, PREG_OFFSET_CAPTURE) !== 1) {
        $failures[] = "$path is missing tce_page_header.php inclusion.";
        continue;
    }
    $header_pos = $header_match[0][1];

    foreach ($checks['validation_patterns'] as $v_pat) {
        if (preg_match($v_pat, $content, $v_match, PREG_OFFSET_CAPTURE) !== 1) {
            $failures[] = "$path is missing expected validation matching $v_pat.";
            continue;
        }
        $v_pos = $v_match[0][1];
        if ($v_pos > $header_pos) {
            $failures[] = "$path performs validation after page header inclusion at offset $header_pos.";
        }
    }
}

// ---------------------------------------------------------------------------
// 2. Textarea class attribute formatting in tce_functions_test.php
// ---------------------------------------------------------------------------
$fn_test = @file_get_contents('shared/code/tce_functions_test.php');
if ($fn_test === false) {
    $failures[] = 'Unable to read shared/code/tce_functions_test.php';
} else {
    if (strpos($fn_test, 'onchange="saveAnswer()"answertext">') !== false) {
        $failures[] = 'shared/code/tce_functions_test.php contains malformed textarea markup without class attribute.';
    }

    if (strpos($fn_test, 'name="answertext" id="answertext" onchange="saveAnswer()" class="') === false) {
        $failures[] = 'shared/code/tce_functions_test.php missing proper class attribute on answertext textarea.';
    }

    // -----------------------------------------------------------------------
    // 3. Keyboard shortcut focus guard in actionByChar
    // -----------------------------------------------------------------------
    if (strpos($fn_test, 'target.tagName') === false || strpos($fn_test, 'TEXTAREA') === false) {
        $failures[] = 'actionByChar in shared/code/tce_functions_test.php does not guard against TEXTAREA input focus.';
    }
}

// ---------------------------------------------------------------------------
// 4. Timer script robustness (timer.js)
// ---------------------------------------------------------------------------
$timer_js = @file_get_contents('shared/jscripts/timer.js');
if ($timer_js === false) {
    $failures[] = 'Unable to read shared/jscripts/timer.js';
} else {
    // Check testform guard
    if (preg_match('/var\s+tf\s*=\s*document\.getElementById\([\'"]testform[\'"]\);/', $timer_js) !== 1) {
        $failures[] = 'timer.js missing testform null-guard variable definition.';
    }

    // Check timerform guard
    if (preg_match('/var\s+timerform\s*=\s*document\.getElementById\([\'"]timerform[\'"]\);/', $timer_js) !== 1) {
        $failures[] = 'timer.js missing timerform null-guard.';
    }

    // Check setInterval function reference (not eval string)
    if (strpos($timer_js, 'setInterval(FJ_timer, 500)') === false) {
        $failures[] = 'timer.js should use function reference setInterval(FJ_timer, 500).';
    }
}

// ---------------------------------------------------------------------------
// 5. Test completion routing to immediate results
// ---------------------------------------------------------------------------
$execute_php = @file_get_contents('public/code/tce_test_execute.php');
if ($execute_php === false) {
    $failures[] = 'Unable to read public/code/tce_test_execute.php';
} else {
    if (strpos($execute_php, 'tce_test_results.php?testid=') === false) {
        $failures[] = 'tce_test_execute.php does not route to tce_test_results.php upon completion.';
    }

    if (strpos($execute_php, 'test_results_to_users') === false) {
        $failures[] = 'tce_test_execute.php does not check test_results_to_users before redirecting.';
    }
}

// ---------------------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo 'Candidate flow integrity checks passed.' . PHP_EOL;
