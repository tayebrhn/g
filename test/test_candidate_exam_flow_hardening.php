<?php
/**
 * Test Suite: Candidate Exam Flow Hardening & Submission Resilience
 *
 * Verifies:
 * 1. Existence and integrity of tce_test_finished.php receipt page.
 * 2. Presence of digital verification token computation.
 * 3. Modal direct submission (forceterminate=1).
 * 4. Timer timeout auto-submit includes forceterminate=1 and guards navigation.
 * 5. Server-side forceterminate and finish=1 handling and target routing.
 * 6. Completed test fallback routing to results or finished receipt.
 */

$test_failures = [];

function assert_true($condition, $message) {
    global $test_failures;
    if ($condition) {
        echo "[PASS] $message\n";
    } else {
        echo "[FAIL] $message\n";
        $test_failures[] = $message;
    }
}

echo "Running Candidate Exam Flow Hardening tests...\n";
echo "------------------------------------------------------------\n";

// 1. Inspect tce_test_finished.php
$finished_file = __DIR__ . '/../public/code/tce_test_finished.php';
assert_true(file_exists($finished_file), 'tce_test_finished.php must exist.');

$finished_src = file_get_contents($finished_file);

assert_true(
    strpos($finished_src, '$pagelevel = K_AUTH_PUBLIC_TEST_RESULTS;') !== false,
    'tce_test_finished.php must require K_AUTH_PUBLIC_TEST_RESULTS authentication level.'
);

assert_true(
    strpos($finished_src, 'hash(\'sha256\', $token_payload)') !== false
    || strpos($finished_src, 'hash(\'sha256\'') !== false,
    'tce_test_finished.php must compute cryptographic verification token reference.'
);

assert_true(
    strpos($finished_src, 'Examination Successfully Submitted') !== false,
    'tce_test_finished.php must display Examination Successfully Submitted banner.'
);

assert_true(
    strpos($finished_src, 'Digital Verification Reference:') !== false,
    'tce_test_finished.php must display Digital Verification Reference label.'
);

assert_true(
    strpos($finished_src, 'Official Submission Details') !== false,
    'tce_test_finished.php must display structured official submission details.'
);

// 2. Inspect tce_test_execute.php for modal direct submission
$execute_file = __DIR__ . '/../public/code/tce_test_execute.php';
$execute_src = file_get_contents($execute_file);

assert_true(
    strpos($execute_src, 'function FJ_modal_confirm_submit()') !== false
    && strpos($execute_src, "inp.name = 'forceterminate';") !== false,
    'FJ_modal_confirm_submit must set inp.name to forceterminate for direct 1-click submission.'
);

// 3. Inspect tce_test_execute.php for timeout and forceterminate handling
assert_true(
    strpos($execute_src, '$is_timeout_finish = (isset($_REQUEST[\'finish\']) && $_REQUEST[\'finish\'] > 0);') !== false
    && strpos($execute_src, '$is_force_terminate = ! empty($_REQUEST[\'forceterminate\']);') !== false,
    'tce_test_execute.php must detect both forceterminate and finish=1 timeout triggers.'
);

assert_true(
    strpos($execute_src, 'F_terminateUserTest($test_id);') !== false,
    'tce_test_execute.php must lock test via F_terminateUserTest on submission.'
);

assert_true(
    strpos($execute_src, "('tce_test_finished.php?testid=' . \$test_id)") !== false,
    'tce_test_execute.php must route confidential tests to tce_test_finished.php.'
);

// 4. Inspect completed test fallback routing in tce_test_execute.php
assert_true(
    (strpos($execute_src, "\$mtu['testuser_status'] >= 4") !== false || strpos($execute_src, "testuser_status >= 4") !== false)
    && strpos($execute_src, "tce_test_finished.php?testid=") !== false,
    'tce_test_execute.php must route locked/finished tests to tce_test_finished.php or results instead of raw index.php.'
);

// 5. Inspect timer.js timeout submission logic
$timer_file = __DIR__ . '/../shared/jscripts/timer.js';
$timer_src = file_get_contents($timer_file);

assert_true(
    strpos($timer_src, "inpForce.name = 'forceterminate';") !== false
    && strpos($timer_src, "inpForce.value = '1';") !== false,
    'timer.js must attach forceterminate=1 when submitting form on timeout.'
);

assert_true(
    strpos($timer_src, "if (!tf || !tf.finish || tf.finish.value == 0)") !== false,
    'timer.js must guard window.location.replace to prevent canceling in-flight POST submission.'
);

echo "------------------------------------------------------------\n";
if (empty($test_failures)) {
    echo "SUCCESS: All 12 Candidate Exam Flow Hardening assertions passed!\n";
    exit(0);
} else {
    echo "FAILED: " . count($test_failures) . " assertions failed.\n";
    exit(1);
}
