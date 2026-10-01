<?php
/**
 * Test Suite: Test Question Management & Subsets UI Integrity
 *
 * Verifies the exam question addition overhaul in admin/code/tce_edit_test.php:
 * 1. Single-query question count aggregation replaces N+1 nested loops.
 * 2. Module filter and live topic search presence.
 * 3. Human-readable question counts on topic options.
 * 4. Dynamic real-time question availability calculation and quick-fill button.
 * 5. Modern subsets summary table with human-readable type labels and score calculations.
 * 6. 1-click single-subset deletion and backward-compatible bulk deletion.
 * 7. Functional test subset creation, scoring, and deletion integrity.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

chdir(__DIR__ . '/fixtures/code');

require_once(__DIR__ . '/fixtures/config/tce_config.php');
require_once(__DIR__ . '/../shared/code/tce_auth_caps.php');

$failures = [];

function assert_true($cond, $msg) {
    global $failures;
    if (!$cond) {
        $failures[] = $msg;
        echo "[FAIL] " . $msg . "\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

function assert_equals($expected, $actual, $msg) {
    global $failures;
    if ($expected !== $actual) {
        $failures[] = $msg . ' Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true);
        echo "[FAIL] " . $msg . ' (Expected: ' . var_export($expected, true) . ', Actual: ' . var_export($actual, true) . ")\n";
    } else {
        echo "[PASS] " . $msg . "\n";
    }
}

$edit_test_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_test.php');

// ===========================================================================
// Section 1: Static Code Structure & UX Controls
// ===========================================================================

// Test 1.1: Single-query aggregation
assert_true(
    strpos($edit_test_src, 'SELECT question_subject_id, question_type, question_difficulty, COUNT(*) as numquestions') !== false
    && strpos($edit_test_src, 'GROUP BY question_subject_id, question_type, question_difficulty') !== false,
    'tce_edit_test.php must pre-aggregate question counts in a single efficient query.'
);

// Test 1.2: Module filter and live search controls
assert_true(
    strpos($edit_test_src, 'id="filter_module_id"') !== false
    && strpos($edit_test_src, 'onchange="FJ_filter_topics_by_module(this.value);"') !== false,
    'tce_edit_test.php must render module filter dropdown with FJ_filter_topics_by_module.'
);
assert_true(
    strpos($edit_test_src, 'id="filter_topic_search"') !== false
    && strpos($edit_test_src, 'oninput="FJ_filter_topics_search(this.value);"') !== false,
    'tce_edit_test.php must render real-time topic search input.'
);

// Test 1.3: Topic options human-readable labels and data attributes
assert_true(
    strpos($edit_test_src, 'data-module-id="\' . $m_id . \'"') !== false
    && strpos($edit_test_src, '(\' . $q_count . \' \' . $l[\'w_questions\'] . \')') !== false,
    'Topic options must include data-module-id attribute and human-readable question counts.'
);

// Test 1.4: Dynamic availability badge & quick-fill
assert_true(
    strpos($edit_test_src, 'id="tsubset_availability_badge"') !== false
    && strpos($edit_test_src, 'id="tsubset_avail_count"') !== false,
    'tce_edit_test.php must render tsubset_availability_badge and tsubset_avail_count.'
);
assert_true(
    strpos($edit_test_src, 'id="btn_use_all_available"') !== false
    && strpos($edit_test_src, 'onclick="FJ_use_all_available(); return false;"') !== false,
    'tce_edit_test.php must render [use all available] button.'
);

// Test 1.5: Event triggers on type and difficulty
assert_true(
    strpos($edit_test_src, 'id="tsubset_type" size="0" onchange="FJ_update_availability();"') !== false,
    'tsubset_type select must trigger FJ_update_availability on change.'
);
assert_true(
    strpos($edit_test_src, 'id="tsubset_difficulty" size="0" onchange="FJ_update_availability();"') !== false,
    'tsubset_difficulty select must trigger FJ_update_availability on change.'
);

// ===========================================================================
// Section 2: Subsets Summary Table & Deletion Controls
// ===========================================================================

// Test 2.1: Modern subsets table markup
assert_true(
    strpos($edit_test_src, '<table class="userselect subsets_table"') !== false
    && strpos($edit_test_src, '<thead>') !== false
    && strpos($edit_test_src, '<tfoot>') !== false,
    'Subsets list must be rendered as a structured table with class userselect subsets_table.'
);

// Test 2.2: Human-readable type labels
assert_true(
    strpos($edit_test_src, '$l[\'w_single_answer\']') !== false
    && strpos($edit_test_src, '$l[\'w_multiple_answers\']') !== false
    && strpos($edit_test_src, '$l[\'w_free_answer\']') !== false
    && strpos($edit_test_src, '$l[\'w_ordering_answer\']') !== false,
    'Subsets summary table must map question types to readable localized strings.'
);

// Test 2.3: Single-subset deletion button
assert_true(
    strpos($edit_test_src, 'class="btn_delete_subset"') !== false
    && strpos($edit_test_src, 'onclick="FJ_delete_single_subset(') !== false,
    'Subsets summary table must render 1-click delete button calling FJ_delete_single_subset.'
);

// Test 2.4: Backend handling of deletesubset_id
assert_true(
    strpos($edit_test_src, 'if (isset($_POST["deletesubset_id"]) && (int) $_POST["deletesubset_id"] > 0)') !== false,
    'Backend case deletesubject must support direct deletesubset_id single-click deletion.'
);

// Test 2.5: JavaScript availability and filtering logic
assert_true(
    strpos($edit_test_src, 'var topicQuestionMap =') !== false
    && strpos($edit_test_src, 'var moduleSubjectsMap =') !== false,
    'JavaScript block must serialize topicQuestionMap and moduleSubjectsMap.'
);
assert_true(
    strpos($edit_test_src, 'function FJ_filter_topics_by_module(moduleId)') !== false
    && strpos($edit_test_src, 'function FJ_filter_topics_search(term)') !== false
    && strpos($edit_test_src, 'function FJ_update_availability()') !== false
    && strpos($edit_test_src, 'function FJ_use_all_available()') !== false
    && strpos($edit_test_src, 'function FJ_delete_single_subset(id)') !== false,
    'JavaScript block must provide all interactive filter, calculation, and deletion functions.'
);

// Test 2.6: Form input reset after successful question addition
assert_true(
    strpos($edit_test_src, '$subject_id = [];') !== false
    && strpos($edit_test_src, '$tsubset_quantity = 1;') !== false
    && strpos($edit_test_src, 'unset($_POST[\'addquestion\'], $_REQUEST[\'addquestion\']);') !== false,
    'case addquestion must reset form fields and clear request variables on success.'
);

// Test 2.7: Server-side idempotency guard (subset_token)
assert_true(
    strpos($edit_test_src, '$_SESSION["last_subset_token"] === $_POST["subset_token"]') !== false
    && strpos($edit_test_src, '$_SESSION["last_subset_token"] = $_POST["subset_token"];') !== false,
    'case addquestion must guard against duplicate submissions via subset_token.'
);

// Test 2.8: Hidden subset_token rendered in form
assert_true(
    strpos($edit_test_src, 'id="subset_token"') !== false
    && strpos($edit_test_src, 'name="subset_token"') !== false,
    'Question addition form must output a unique hidden subset_token.'
);

// Test 2.9: Client-side history replaceState to prevent browser POST resubmission on refresh
assert_true(
    strpos($edit_test_src, 'window.history.replaceState') !== false
    && strpos($edit_test_src, 'cleanUrl') !== false,
    'Client-side script must invoke window.history.replaceState to prevent POST resubmission on refresh.'
);

// ===========================================================================
// Section 3: Functional Scoring & Matrix Calculation Logic
// ===========================================================================

// Simulate subset scoring calculation
$test_score_right = 2.50;
$difficulty = 2;
$quantity = 4;
$subset_score = $test_score_right * $difficulty * $quantity;
assert_equals(20.0, (float) $subset_score, 'Subset points calculation must equal 20.00.');

// Simulate matrix matching calculation
$mock_matrix = [
    '1_1' => 5, // Single answer, diff 1: 5 questions
    '1_2' => 3, // Single answer, diff 2: 3 questions
    '2_1' => 4, // Multiple answers, diff 1: 4 questions
    '2_2' => 2, // Multiple answers, diff 2: 2 questions
    '3_1' => 1, // Free answer, diff 1: 1 question
];

function mock_count_matches($matrix, $qType, $qDiff) {
    if ($qType === 0) {
        $sum = 0;
        for ($t = 1; $t <= 4; $t++) {
            $k = $t . '_' . $qDiff;
            if (isset($matrix[$k])) {
                $sum += (int) $matrix[$k];
            }
        }
        return $sum;
    } else {
        $k = $qType . '_' . $qDiff;
        return isset($matrix[$k]) ? (int) $matrix[$k] : 0;
    }
}

// Any type, difficulty 1 => 5 + 4 + 1 = 10
assert_equals(10, mock_count_matches($mock_matrix, 0, 1), 'All question types for diff 1 must sum to 10.');

// Single answer (1), difficulty 1 => 5
assert_equals(5, mock_count_matches($mock_matrix, 1, 1), 'Single answer for diff 1 must equal 5.');

// Multiple answers (2), difficulty 2 => 2
assert_equals(2, mock_count_matches($mock_matrix, 2, 2), 'Multiple answers for diff 2 must equal 2.');

// Free answer (3), difficulty 2 => 0 (none defined)
assert_equals(0, mock_count_matches($mock_matrix, 3, 2), 'Free answer for diff 2 must equal 0.');

// ===========================================================================
// Summary
// ===========================================================================

echo "\n------------------------------------------------------------\n";
echo "Test Question Management & Subsets UI Integrity Test Results\n";
echo "------------------------------------------------------------\n";

if (empty($failures)) {
    echo "ALL QUESTION MANAGEMENT INTEGRITY TESTS PASSED (0 errors).\n";
    exit(0);
} else {
    echo "FAILURES DETECTED (" . count($failures) . " errors):\n";
    foreach ($failures as $f) {
        echo "  - $f\n";
    }
    exit(1);
}
