<?php
//============================================================+
// File name   : tce_test_finished.php
// Begin       : 2026-10-10
//
// Description : Verified candidate exam completion receipt.
//               Displayed when candidate completes an exam
//               with confidential/deferred results.
//============================================================+

require_once('../config/tce_config.php');

$pagelevel = K_AUTH_PUBLIC_TEST_RESULTS;
require_once('../../shared/code/tce_authorization.php');
require_once('../../shared/code/tce_functions_form.php');
require_once('../../shared/code/tce_functions_tcecode.php');
require_once('../../shared/code/tce_functions_test.php');
require_once('../../shared/code/tce_functions_test_stats.php');

$user_id = (int) $_SESSION['session_user_id'];

if (isset($_REQUEST['testid']) && $_REQUEST['testid'] > 0) {
    $test_id = (int) $_REQUEST['testid'];
} else {
    header('Location: index.php');
    exit;
}

// Fetch test metadata
$testdata = F_getTestData($test_id);
if (! $testdata) {
    header('Location: index.php');
    exit;
}

// If results are open to users, provide immediate redirect option or link
$results_enabled = F_getBoolean($testdata['test_results_to_users']);

// Fetch latest testuser session for this candidate
$sqltu = 'SELECT * FROM ' . K_TABLE_TEST_USER . '
    WHERE testuser_test_id=' . $test_id . '
        AND testuser_user_id=' . $user_id . '
    ORDER BY testuser_id DESC
    LIMIT 1';

$testuser_id = 0;
$tu_data = null;
if ($rtu = F_db_query($sqltu, $db)) {
    if ($mtu = F_db_fetch_array($rtu)) {
        $testuser_id = (int) $mtu['testuser_id'];
        $tu_data = $mtu;
    }
}

if ($testuser_id == 0) {
    header('Location: index.php');
    exit;
}

// Fetch candidate user details
$candidate_name = '';
$candidate_reg = '';
$candidate_email = '';
$sqlu = 'SELECT user_firstname, user_lastname, user_name, user_email, user_regnumber
    FROM ' . K_TABLE_USERS . ' WHERE user_id=' . $user_id . ' LIMIT 1';
if ($ru = F_db_query($sqlu, $db)) {
    if ($mu = F_db_fetch_array($ru)) {
        $candidate_name = trim($mu['user_firstname'] . ' ' . $mu['user_lastname']);
        if (empty($candidate_name)) {
            $candidate_name = $mu['user_name'];
        }
        $candidate_reg = $mu['user_regnumber'] ?? '';
        $candidate_email = $mu['user_email'] ?? '';
    }
}

// Compute question statistics
$user_stats = F_getTestUserStats($test_id, $user_id);
$total_questions = $user_stats['total'];
$answered_questions = $user_stats['answered'];
$unanswered_questions = $user_stats['unanswered'];

// Timing statistics
$start_time_str = $tu_data['testuser_creation_time'] ?? '';
$start_ts = !empty($start_time_str) ? strtotime($start_time_str) : time();

// Fetch completion timestamp from latest test log entry or current time
$sqllast = 'SELECT MAX(testlog_change_time) AS end_time FROM ' . K_TABLE_TESTS_LOGS . ' WHERE testlog_testuser_id=' . $testuser_id;
$end_time_str = date(K_TIMESTAMP_FORMAT);
if ($rlast = F_db_query($sqllast, $db)) {
    if ($mlast = F_db_fetch_array($rlast)) {
        if (!empty($mlast['end_time'])) {
            $end_time_str = $mlast['end_time'];
        }
    }
}
$end_ts = strtotime($end_time_str);
$duration_seconds = max(0, $end_ts - $start_ts);
$duration_min = floor($duration_seconds / 60);
$duration_sec = $duration_seconds % 60;
$duration_str = sprintf('%d min %02d sec', $duration_min, $duration_sec);

// Cryptographic submission verification reference token
$token_payload = $testuser_id . '_' . $user_id . '_' . $start_time_str . '_' . (defined('K_RANDOM_SECURITY') ? K_RANDOM_SECURITY : 'tcexam');
$raw_hash = strtoupper(hash('sha256', $token_payload));
$verification_ref = substr($raw_hash, 0, 4) . '-' . substr($raw_hash, 4, 4) . '-' . substr($raw_hash, 8, 4) . '-' . substr($raw_hash, 12, 4);

$thispage_title = $l['w_terminate_exam'] . ': ' . htmlspecialchars($testdata['test_name'], ENT_QUOTES, $l['a_meta_charset']);
require_once('../code/tce_page_header.php');
?>
<div class="container">
    <div class="review_summary_card receipt_card">
        <div class="receipt_banner" style="text-align:center; padding: 20px 10px; border-bottom: 2px solid #eef3ee; margin-bottom: 20px;">
            <div style="font-size: 48px; line-height: 1; margin-bottom: 12px; color: #2e6933;">&#10004;</div>
            <h2 style="color: #2e6933; margin: 0 0 6px 0; font-size: 1.5em;">Examination Successfully Submitted</h2>
            <p style="color: #666; margin: 0; font-size: 0.95em;">Your answers have been securely recorded and encrypted in the examination database.</p>
        </div>

        <div class="review_stats_grid">
            <div class="review_stat_card card_answered">
                <span class="stat_value"><?php echo $answered_questions; ?></span>
                <span class="stat_label">Questions Answered</span>
            </div>
            <div class="review_stat_card card_unanswered">
                <span class="stat_value"><?php echo $unanswered_questions; ?></span>
                <span class="stat_label">Questions Omitted</span>
            </div>
            <div class="review_stat_card" style="background:#eef6fc; border: 1px solid #b8daff; color: #004085;">
                <span class="stat_value"><?php echo $total_questions; ?></span>
                <span class="stat_label">Total Questions</span>
            </div>
        </div>

        <div class="receipt_details_box" style="background: #fbfcfb; border: 1px solid #e2e8e2; border-radius: 8px; padding: 18px 20px; margin-bottom: 20px;">
            <h3 style="margin-top: 0; margin-bottom: 14px; font-size: 1.1em; color: #333; border-bottom: 1px solid #edf0ed; padding-bottom: 8px;">Official Submission Details</h3>
            <table style="width: 100%; border-collapse: collapse; font-size: 0.95em;">
                <tr>
                    <td style="padding: 6px 0; color: #666; width: 35%;"><strong>Exam:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><strong><?php echo htmlspecialchars($testdata['test_name'], ENT_QUOTES, $l['a_meta_charset']); ?></strong></td>
                </tr>
                <tr>
                    <td style="padding: 6px 0; color: #666;"><strong>Candidate:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><?php echo htmlspecialchars($candidate_name, ENT_QUOTES, $l['a_meta_charset']); ?> (<?php echo htmlspecialchars($_SESSION['session_user_name'], ENT_QUOTES, $l['a_meta_charset']); ?>)</td>
                </tr>
                <?php if (!empty($candidate_reg)): ?>
                <tr>
                    <td style="padding: 6px 0; color: #666;"><strong>Registration No:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><?php echo htmlspecialchars($candidate_reg, ENT_QUOTES, $l['a_meta_charset']); ?></td>
                </tr>
                <?php endif; ?>
                <tr>
                    <td style="padding: 6px 0; color: #666;"><strong>Start Time:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><?php echo htmlspecialchars($start_time_str, ENT_QUOTES, $l['a_meta_charset']); ?></td>
                </tr>
                <tr>
                    <td style="padding: 6px 0; color: #666;"><strong>Submission Time:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><?php echo htmlspecialchars($end_time_str, ENT_QUOTES, $l['a_meta_charset']); ?></td>
                </tr>
                <tr>
                    <td style="padding: 6px 0; color: #666;"><strong>Total Time Taken:</strong></td>
                    <td style="padding: 6px 0; color: #111;"><?php echo htmlspecialchars($duration_str, ENT_QUOTES, $l['a_meta_charset']); ?></td>
                </tr>
            </table>
        </div>

        <div class="receipt_token_box" style="background: #f4f6f8; border: 1px dashed #4a7751; border-radius: 8px; padding: 14px 18px; margin-bottom: 24px; text-align: center;">
            <span style="display: block; font-size: 0.82em; color: #555; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px;">Digital Verification Reference:</span>
            <span style="font-family: monospace; font-size: 1.3em; font-weight: bold; letter-spacing: 0.12em; color: #2e6933;"><?php echo $verification_ref; ?></span>
        </div>

        <div class="receipt_notice" style="background: #fff8e6; border: 1px solid #ffeeba; border-radius: 8px; padding: 12px 16px; margin-bottom: 24px; color: #856404; font-size: 0.9em; line-height: 1.5;">
            <strong>Proctored Grading Notice:</strong> Immediate score feedback for this examination is restricted by the examiner. Your final official grade and report will be compiled by the faculty and made accessible once review concludes.
        </div>

        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
            <?php if ($results_enabled): ?>
            <a href="tce_test_results.php?testid=<?php echo $test_id; ?>" class="xmlbutton" style="background: #2e6933; color: #fff; font-weight: bold; text-decoration: none; padding: 10px 22px; border-radius: 6px; display: inline-block;">View Detailed Results &raquo;</a>
            <?php endif; ?>
            <a href="index.php" class="xmlbutton" style="background: #555; color: #fff; text-decoration: none; padding: 10px 22px; border-radius: 6px; display: inline-block;">&larr; Return to Candidate Portal</a>
        </div>
    </div>
</div>
<?php
require_once('../code/tce_page_footer.php');
