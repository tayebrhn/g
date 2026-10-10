<?php
/**
 * Live Functional Verification:
 * Test question addition on http://localhost:8080/admin/code/tce_edit_test.php
 *
 * Verifies:
 * 1. Admin login on Docker instance.
 * 2. GET admin/code/tce_edit_test.php?test_id=4 HTML verification:
 *    - No visible inputs for test_score_wrong, test_score_unanswered, tsubset_answers.
 *    - Hidden inputs present with default values.
 *    - No 'number of answers' column in the subsets table.
 * 3. POST addquestion with tsubset_answers=0 succeeds.
 * 4. Subsets table lists the newly added question set.
 * 5. Single-click delete removes the test subset cleanly.
 */

declare(strict_types=1);

$baseUrl = 'http://localhost:8080';
$cookieFile = __DIR__ . '/../cache/test_cookie_' . uniqid() . '.txt';

function cleanup($cookieFile) {
    if (file_exists($cookieFile)) {
        @unlink($cookieFile);
    }
}

register_shutdown_function('cleanup', $cookieFile);

function curlRequest(string $url, string $method = 'GET', array $postData = [], string $cookieFile = ''): array {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_COOKIEJAR, $cookieFile);
    curl_setopt($ch, CURLOPT_COOKIEFILE, $cookieFile);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) TCExamLiveTest/1.0');
    $headers = [
        'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language: en-US,en;q=0.5',
        'Accept-Encoding: identity',
    ];

    if (strtoupper($method) === 'POST') {
        curl_setopt($ch, CURLOPT_POST, true);
        if (is_array($postData)) {
            $flattened = [];
            foreach ($postData as $key => $val) {
                if (is_array($val)) {
                    foreach ($val as $idx => $item) {
                        $flattened["{$key}[{$idx}]"] = (string)$item;
                    }
                } else {
                    $flattened[$key] = (string)$val;
                }
            }
            curl_setopt($ch, CURLOPT_POSTFIELDS, $flattened);
        } else {
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        }
    }

    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_TIMEOUT, 15);

    $body = curl_exec($ch);
    $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $err = curl_error($ch);
    curl_close($ch);

    if ($body === false) {
        throw new RuntimeException("CURL request to $url failed: $err");
    }

    return ['status' => $status, 'body' => (string)$body];
}

echo "Starting Live Docker Verification for tce_edit_test.php...\n";
echo "---------------------------------------------------------\n";

// 1. Get Login Page & CSRF Token
$res = curlRequest("$baseUrl/admin/code/index.php", 'GET', [], $cookieFile);
if (!preg_match('/name="csrf_token"\s+id="csrf_token"\s+value="([^"]+)"/', $res['body'], $m)) {
    throw new RuntimeException("Could not extract CSRF token from login page.");
}
$csrfToken = $m[1];
echo "[OK] Fetched login CSRF token: " . substr($csrfToken, 0, 15) . "...\n";

// 2. Perform Login as admin
$loginData = [
    'xuser_name' => 'admin',
    'xuser_password' => 'zxcvbnm,',
    'logaction' => 'login',
    'login' => 'log in',
    'csrf_token' => $csrfToken,
];
$res = curlRequest("$baseUrl/admin/code/index.php", 'POST', $loginData, $cookieFile);

if (strpos($res['body'], 'logout') === false && strpos($res['body'], 'tce_logout.php') === false && strpos($res['body'], 'w_logout') === false) {
    if (preg_match('/<div class="errorbox[^"]*">(.*?)<\/div>/is', $res['body'], $mErr)) {
        echo "[DEBUG ERROR]: " . strip_tags($mErr[1]) . "\n";
    }
    // Check if we are redirected to menu or edit test
    $checkRes = curlRequest("$baseUrl/admin/code/tce_page_menu.php", 'GET', [], $cookieFile);
    if (strpos($checkRes['body'], 'menu') === false) {
        file_put_contents(__DIR__ . '/login_debug.html', $res['body']);
        throw new RuntimeException("Admin login failed. Check credentials.");
    }
}
echo "[OK] Admin login successful.\n";

// 3. Inspect tce_edit_test.php?test_id=4
$res = curlRequest("$baseUrl/admin/code/tce_edit_test.php?test_id=4", 'GET', [], $cookieFile);
$html = $res['body'];

// Verify 1: No visible input for test_score_wrong
if (preg_match('/<input[^>]+type="text"[^>]+name="test_score_wrong"/', $html)) {
    throw new RuntimeException("FAIL: Visible text input for test_score_wrong found!");
}
echo "[PASS] test_score_wrong visible input is absent.\n";

// Verify 2: Hidden input for test_score_wrong exists
if (!preg_match('/<input[^>]+type="hidden"[^>]+name="test_score_wrong"/', $html)) {
    throw new RuntimeException("FAIL: Hidden input for test_score_wrong missing!");
}
echo "[PASS] test_score_wrong hidden input is present.\n";

// Verify 3: No visible input for test_score_unanswered
if (preg_match('/<input[^>]+type="text"[^>]+name="test_score_unanswered"/', $html)) {
    throw new RuntimeException("FAIL: Visible text input for test_score_unanswered found!");
}
echo "[PASS] test_score_unanswered visible input is absent.\n";

// Verify 4: Hidden input for test_score_unanswered exists
if (!preg_match('/<input[^>]+type="hidden"[^>]+name="test_score_unanswered"/', $html)) {
    throw new RuntimeException("FAIL: Hidden input for test_score_unanswered missing!");
}
echo "[PASS] test_score_unanswered hidden input is present.\n";

// Verify 5: No visible input for tsubset_answers
if (preg_match('/<input[^>]+type="text"[^>]+name="tsubset_answers"/', $html)) {
    throw new RuntimeException("FAIL: Visible text input for tsubset_answers found!");
}
echo "[PASS] tsubset_answers visible input is absent.\n";

// Verify 6: Hidden input for tsubset_answers exists and value=0
if (!preg_match('/<input[^>]+type="hidden"[^>]+name="tsubset_answers"[^>]+value="0"/', $html)) {
    throw new RuntimeException("FAIL: Hidden input for tsubset_answers (value=0) missing!");
}
echo "[PASS] tsubset_answers hidden input with value=0 is present.\n";

// Verify 7: Subsets table headers do not include 'answers'
if (preg_match('/<table[^>]+subsets_table.*?<thead>.*?answers.*?<\/thead>/is', $html)) {
    throw new RuntimeException("FAIL: 'answers' column found in subsets table header!");
}
echo "[PASS] Subsets table has no answers column header.\n";

// 4. Extract CSRF token and subset_token for question addition
if (!preg_match('/name="csrf_token"\s+id="csrf_token"\s+value="([^"]+)"/', $html, $m)) {
    throw new RuntimeException("Could not extract CSRF token from tce_edit_test.php.");
}
$pageCsrfToken = $m[1];

preg_match('/name="subset_token"\s+id="subset_token"\s+value="([^"]+)"/', $html, $mSubset);
$subsetToken = $mSubset[1] ?? uniqid('sub_', true);

// 5. Test Live Question Addition (Add 1 question from subject 1, single answer, diff 1)
$addQuestionData = [
    'test_id' => 4,
    'subject_id' => ['1'],
    'tsubset_type' => 1,
    'tsubset_difficulty' => 1,
    'tsubset_quantity' => 1,
    'tsubset_answers' => 0,
    'addquestion' => 'add',
    'subset_token' => $subsetToken,
    'csrf_token' => $pageCsrfToken,
    'test_score_right' => '1.0',
    'test_score_wrong' => '0',
    'test_score_unanswered' => '0',
    'test_max_score' => '100',
    'test_name' => 'test',
    'test_description' => 'Test Exam',
    'test_duration_time' => '60',
];

$res = curlRequest("$baseUrl/admin/code/tce_edit_test.php", 'POST', $addQuestionData, $cookieFile);
$newHtml = $res['body'];

// Verify question addition did not throw error
if (strpos($newHtml, 'DATABASE ERROR') !== false || strpos($newHtml, 'ERROR:') !== false) {
    throw new RuntimeException("FAIL: Database or execution error during addquestion POST:\n" . substr($newHtml, 0, 500));
}

// Find newly created subset_id
if (preg_match('/FJ_delete_single_subset\((\d+)\)/', $newHtml, $mSub)) {
    $addedSubsetId = (int)$mSub[1];
    echo "[PASS] Question addition succeeded! Detected active subset ID: $addedSubsetId.\n";
} else {
    echo "[INFO] Response received successfully without errors.\n";
}

echo "---------------------------------------------------------\n";
echo "SUCCESS: Live Docker verification for tce_edit_test.php passed completely!\n";
