<?php
/**
 * Test Suite: Candidate Exam Execution Experience Integrity
 *
 * Verifies the candidate exam execution overhaul in:
 * - public/code/tce_test_execute.php
 * - shared/code/tce_functions_test.php
 * - shared/jscripts/timer.js
 * - public/styles/default.css
 *
 * Checks:
 * 1. Question Palette grid, status chips, and stats header generation.
 * 2. Option letter badges (A, B, C, D) and Clear Selection link for MCSA questions.
 * 3. Flag for Review toggle button, persistence via session/localStorage, and palette updates.
 * 4. Sticky Exam Header with Question X of Y, Progress Bar, and Smart Timer box.
 * 5. Countdown timer urgency thresholds (< 300s amber warning, < 60s critical alert).
 * 6. Pre-Submission Review Summary Card & Modal with interactive jump chips.
 * 7. Comprehensive stylesheet definitions and keyframe animations.
 */

declare(strict_types=1);

error_reporting(E_ALL);

$failures = [];

function assert_true(bool $cond, string $msg): void {
    global $failures;
    if (!$cond) {
        $failures[] = $msg;
        echo "[FAIL] " . $msg . "\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

function assert_equals($expected, $actual, string $msg): void {
    global $failures;
    if ($expected !== $actual) {
        $failures[] = $msg . ' (Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true) . ')';
        echo "[FAIL] " . $msg . ' (Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true) . ")\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

$fn_test_src = file_get_contents(__DIR__ . '/../shared/code/tce_functions_test.php');
$execute_src = file_get_contents(__DIR__ . '/../public/code/tce_test_execute.php');
$timer_js_src = file_get_contents(__DIR__ . '/../shared/jscripts/timer.js');
$css_src = file_get_contents(__DIR__ . '/../public/styles/default.css');

// ===========================================================================
// Section 1: Option Letter Badges & Clear Selection UX
// ===========================================================================

// 1.1 Option letter badges rendered for answer choices
assert_true(
    strpos($fn_test_src, '<span class="option_badge">\' . $ans_letter . \'</span>') !== false,
    'tce_functions_test.php must render option letter badges (A, B, C, ...) for answer choices.'
);
assert_true(
    strpos($fn_test_src, '<span class="answer_desc">\' . F_decode_tcecode($ma[\'answer_description\']) . \'</span>') !== false,
    'tce_functions_test.php must wrap answer description in answer_desc container.'
);

// 1.2 Clear selection control for MCSA questions
assert_true(
    strpos($fn_test_src, 'clear_selection_box') !== false
    && strpos($fn_test_src, 'FJ_clear_selection()') !== false,
    'tce_functions_test.php must render clear selection link and FJ_clear_selection() for MCSA questions.'
);
assert_true(
    strpos($fn_test_src, "radios[i].value==\\'0\\'") !== false,
    'FJ_clear_selection() must select the hidden unselected option (value 0).'
);

// 1.3 Suppress decimal markers when option badges are present to avoid double numbering
assert_true(
    strpos($css_src, 'ol.answer:has(.option_badge)') !== false
    && strpos($css_src, 'list-style-type: none;') !== false,
    'default.css must suppress decimal numbering when option badges are present.'
);

// 1.4 Option letter badges in test results review (tce_functions_test_stats.php)
$stats_src = file_get_contents(__DIR__ . '/../shared/code/tce_functions_test_stats.php');
assert_true(
    strpos($stats_src, '$ans_letter = chr(65 + ($ma[\'logansw_order\'] - 1));') !== false
    && strpos($stats_src, '<span class="option_badge">\' . $ans_letter . \'</span>') !== false,
    'tce_functions_test_stats.php must display option letter badges (A, B, C, D) in test review.'
);

// 1.5 Letter labels in PDF test reports (tcpdfex.php)
$pdf_src = file_get_contents(__DIR__ . '/../shared/code/tcpdfex.php');
assert_true(
    strpos($pdf_src, '$ans_label = ($m[\'question_type\'] == 1 || $m[\'question_type\'] == 2) ? chr(64 + $idx) : $idx;') !== false,
    'tcpdfex.php must use letter labels (A, B, C, D) for choice questions in PDF reports.'
);

// ===========================================================================
// Section 2: Question Palette & Navigation Grid
// ===========================================================================

// 2.1 Question Palette container and stats header
assert_true(
    strpos($fn_test_src, 'qpalette_box') !== false
    && strpos($fn_test_src, 'qpalette_header') !== false
    && strpos($fn_test_src, 'pal_stat_answered') !== false
    && strpos($fn_test_src, 'pal_stat_unanswered') !== false
    && strpos($fn_test_src, 'pal_stat_flagged') !== false,
    'F_questionsMenu must generate question palette container with answered/unanswered/flagged summary stats.'
);

// 2.2 Question Palette grid and chip buttons
assert_true(
    strpos($fn_test_src, 'qpalette_grid') !== false
    && strpos($fn_test_src, 'qpalette_chip') !== false
    && strpos($fn_test_src, 'chip_current') !== false
    && strpos($fn_test_src, 'chip_answered') !== false
    && strpos($fn_test_src, 'chip_unanswered') !== false
    && strpos($fn_test_src, 'chip_flagged') !== false,
    'F_questionsMenu must render numbered palette chips with status classes (current, answered, unanswered, flagged).'
);

// 2.3 Form jump inputs preservation inside palette chips
assert_true(
    strpos($fn_test_src, 'name="jumpquestion_\' . $item[\'testlog_id\']') !== false,
    'F_questionsMenu must maintain jumpquestion_X button inputs inside chips to preserve answer auto-saving on navigation.'
);

// 2.4 Backward-compatible hidden qlist
assert_true(
    strpos($fn_test_src, '<ol class="qlist" style="display:none;">') !== false,
    'F_questionsMenu must retain hidden legacy qlist for backward compatibility with external scripts.'
);

// 2.5 Palette legend
assert_true(
    strpos($fn_test_src, 'qpalette_legend') !== false
    && strpos($fn_test_src, 'legend_box') !== false,
    'F_questionsMenu must render visual color legend explaining palette status indicators.'
);

// ===========================================================================
// Section 3: Flag for Review Toggle & Persistence
// ===========================================================================

// 3.1 Toggle Flag button in navigation bar
assert_true(
    strpos($fn_test_src, 'id="btn_toggle_flag"') !== false
    && strpos($fn_test_src, 'FJ_toggle_flag(') !== false,
    'F_questionsMenu must render Flag for Review toggle button in navigation controls.'
);

// 3.2 Flag persistence in session & request handling
assert_true(
    strpos($execute_src, '$_SESSION[\'test_flags_\' . $test_id]') !== false
    && strpos($execute_src, 'flagged_log_ids') !== false,
    'tce_test_execute.php must synchronize flagged questions via session and flagged_log_ids request parameter.'
);

// 3.3 Hidden flagged_log_ids inputs
assert_true(
    strpos($execute_src, '<input type="hidden" name="flagged_log_ids"') !== false,
    'tce_test_execute.php must pass flagged_log_ids hidden input in exam form and termination forms.'
);

// ===========================================================================
// Section 4: Sticky Exam Status Header & Progress Bar
// ===========================================================================

// 4.1 Sticky exam header container
assert_true(
    strpos($execute_src, 'class="exam_sticky_bar"') !== false
    && strpos($execute_src, 'id="exam_sticky_bar"') !== false,
    'tce_test_execute.php must render sticky exam status header (.exam_sticky_bar).'
);

// 4.2 Current question index and total questions
assert_true(
    strpos($execute_src, 'id="sticky_curr_num"') !== false
    && strpos($execute_src, 'sticky_qnum') !== false,
    'Sticky bar must show current question number and total count (e.g. Question X of Y).'
);

// 4.3 Live progress bar and answered count
assert_true(
    strpos($execute_src, 'sticky_progress_bar') !== false
    && strpos($execute_src, 'id="sticky_progress_fill"') !== false
    && strpos($execute_src, 'id="sticky_progress_text"') !== false,
    'Sticky bar must render progress bar track, fill width percentage, and count text.'
);

// 4.4 Sticky smart timer box and End Exam button
assert_true(
    strpos($execute_src, 'id="sticky_timer_box"') !== false
    && strpos($execute_src, 'id="sticky_timer_display"') !== false
    && strpos($execute_src, 'id="btn_open_review"') !== false,
    'Sticky bar must render sticky timer display box and End Exam review button.'
);

// 4.5 Helper function F_getTestUserStats
assert_true(
    strpos($fn_test_src, 'function F_getTestUserStats(') !== false,
    'tce_functions_test.php must define F_getTestUserStats helper returning total, answered, unanswered, and progress.'
);

// ===========================================================================
// Section 5: Smart Timer Urgency Indicators in timer.js
// ===========================================================================

// 5.1 Timer sticky DOM update
assert_true(
    strpos($timer_js_src, 'document.getElementById(\'sticky_timer_display\')') !== false,
    'timer.js must update sticky_timer_display DOM element in both countdown and clock modes.'
);

// 5.2 Timer urgency thresholds (< 300s warning, < 60s critical)
assert_true(
    strpos($timer_js_src, 'total_rem_seconds <= 60') !== false
    && strpos($timer_js_src, 'timer_critical') !== false,
    'timer.js must apply timer_critical class when remaining time is 60 seconds or less.'
);
assert_true(
    strpos($timer_js_src, 'total_rem_seconds <= 300') !== false
    && strpos($timer_js_src, 'timer_warning') !== false,
    'timer.js must apply timer_warning class when remaining time is 300 seconds (5 mins) or less.'
);

// 5.3 Clock mode support
assert_true(
    strpos($timer_js_src, 'sticky_timer.innerHTML = \'\' + hour + \':\' + minute + \':\' + second;') !== false,
    'timer.js must update sticky timer with clock time when in clock mode.'
);

// 5.4 Regression invariants preserved
assert_true(
    strpos($timer_js_src, 'var tf = document.getElementById(\'testform\');') !== false
    && strpos($timer_js_src, 'var timerform = document.getElementById(\'timerform\');') !== false
    && strpos($timer_js_src, 'setInterval(FJ_timer, 500)') !== false,
    'timer.js must preserve regression test invariants (tf, timerform, setInterval reference).'
);

// ===========================================================================
// Section 6: Pre-Submission Review Summary & Modal
// ===========================================================================

// 6.1 Server-side confirmation screen review summary
assert_true(
    strpos($execute_src, 'review_confirm_wrapper') !== false
    && strpos($execute_src, 'review_summary_card') !== false
    && strpos($execute_src, 'card_answered') !== false
    && strpos($execute_src, 'card_unanswered') !== false
    && strpos($execute_src, 'card_flagged') !== false,
    'tce_test_execute.php termination confirmation screen must display structured review summary cards.'
);

// 6.2 Server-side confirmation jump buttons for unanswered and flagged questions
assert_true(
    strpos($execute_src, 'class="review_jump_chip chip_unanswered"') !== false
    && strpos($execute_src, 'class="review_jump_chip chip_flagged"') !== false,
    'Termination review screen must provide 1-click jump buttons for unanswered and flagged questions.'
);

// 6.3 Client-side review modal structure
assert_true(
    strpos($execute_src, 'id="review_modal_backdrop"') !== false
    && strpos($execute_src, 'class="review_modal_dialog"') !== false
    && strpos($execute_src, 'class="modal_title"') !== false
    && strpos($execute_src, 'id="modal_stat_answered"') !== false
    && strpos($execute_src, 'id="modal_stat_unanswered"') !== false
    && strpos($execute_src, 'id="modal_stat_flagged"') !== false,
    'tce_test_execute.php must render pre-submission review modal with real-time stats.'
);

// 6.4 Client-side JavaScript controllers
assert_true(
    strpos($execute_src, 'function FJ_toggle_flag(') !== false
    && strpos($execute_src, 'function FJ_open_review_modal(') !== false
    && strpos($execute_src, 'function FJ_close_review_modal(') !== false
    && strpos($execute_src, 'function FJ_modal_jump(') !== false
    && strpos($execute_src, 'function FJ_modal_confirm_submit(') !== false,
    'tce_test_execute.php must include JavaScript controllers for modal opening, closing, jumping, and submission.'
);

// 6.5 LocalStorage synchronization
assert_true(
    strpos($execute_src, 'localStorage.getItem(\'tce_flags_\'') !== false
    && strpos($execute_src, 'localStorage.setItem(\'tce_flags_\'') !== false,
    'JavaScript controllers must synchronize flag state with browser localStorage.'
);

// ===========================================================================
// Section 7: Modern Stylesheet Verification
// ===========================================================================

$required_css_rules = [
    '.exam_sticky_bar',
    '.sticky_progress_bar',
    '.sticky_progress_fill',
    '.sticky_timer_box',
    '.sticky_timer_box.timer_warning',
    '.sticky_timer_box.timer_critical',
    '@keyframes timer_pulse_warn',
    '@keyframes timer_pulse_crit',
    '.btn_end_exam',
    '.btn_flag',
    '.btn_flag.is_flagged',
    '.qpalette_box',
    '.qpalette_grid',
    '.qpalette_chip',
    '.qpalette_chip.chip_answered',
    '.qpalette_chip.chip_unanswered',
    '.qpalette_chip.chip_current',
    '.qpalette_chip.chip_flagged',
    '.chip_flag_icon',
    '.option_badge',
    '.clear_selection_box',
    '.clear_selection_link',
    '.review_summary_card',
    '.review_stats_grid',
    '.review_stat_card',
    '.review_jump_chip',
    '.review_modal_backdrop',
    '.review_modal_dialog',
    '.btn_modal_cancel',
    '.btn_modal_submit',
];

foreach ($required_css_rules as $css_rule) {
    assert_true(
        strpos($css_src, $css_rule) !== false,
        "default.css must define stylesheet rule for $css_rule"
    );
}

// ===========================================================================
// Summary
// ===========================================================================

echo "\n------------------------------------------------------------\n";
if (!empty($failures)) {
    echo "FAILED: " . count($failures) . " assertions failed.\n";
    exit(1);
} else {
    echo "SUCCESS: All candidate exam UX integrity assertions passed!\n";
    exit(0);
}
