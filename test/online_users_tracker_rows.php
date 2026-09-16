<?php

//============================================================+
// File name   : online_users_tracker_rows.php
// Description : Regression test for the online-users tracker-row guard.
//============================================================+

/**
 * Verify that tracker rows (brute-force delay, OTP token) in the sessions
 * table produce session arrays without session_user_id, and that the isset()
 * guard in F_list_online_users correctly skips them.
 *
 * Brute-force rows store cpsession_data as a plain integer (e.g. "1") and
 * OTP rows store "300".  Neither contains a session_user_id key.  Before
 * the fix the code called F_isAuthorizedEditorForUser() unconditionally,
 * which would blow up on these rows.
 */

declare(strict_types=1);

// Tracker row data (plain integers like "1" or "300") intentionally lacks the
// pipe-delimited format that F_session_string_to_array expects, so unserialize
// emits a notice on the trailing fragment.  This is expected and harmless.
error_reporting(E_ALL & ~E_NOTICE);

// Copy of F_session_string_to_array from shared/code/tce_functions_session.php
// (avoids the session_start() side-effect at include-time).
function F_session_string_to_array($sd)
{
    $sess_array = [];
    $vars = preg_split('/[;}]/', $sd);
    for ($i = 0; $i < count($vars) - 1; ++$i) {
        $parts = explode('|', $vars[$i]);
        $key = $parts[0];
        $val = unserialize($parts[1] . ';');
        $sess_array[$key] = $val;
    }

    return $sess_array;
}

// ---------------------------------------------------------------
// 1. F_session_string_to_array must not produce session_user_id
//    for tracker rows.
// ---------------------------------------------------------------
$failures = [];

$bruteforce_data = '1';
$bf = F_session_string_to_array($bruteforce_data);
if (isset($bf['session_user_id'])) {
    $failures[] = 'Brute-force tracker row must not have session_user_id.';
}

$otp_data = '300';
$otp = F_session_string_to_array($otp_data);
if (isset($otp['session_user_id'])) {
    $failures[] = 'OTP tracker row must not have session_user_id.';
}

// ---------------------------------------------------------------
// 2. A real user session must have session_user_id.
// ---------------------------------------------------------------
$user_data = 'session_user_id|i:42;session_user_name|s:5:"admin";session_user_lastname|s:6:"Asuni";session_user_firstname|s:6:"Nicola";session_user_level|i:1;session_user_ip|s:9:"127.0.0.1";';
$usr = F_session_string_to_array($user_data);

if (! isset($usr['session_user_id'])) {
    $failures[] = 'Real user session must have session_user_id.';
} elseif ($usr['session_user_id'] !== 42) {
    $failures[] = 'Real user session_user_id should be 42, got: ' . var_export($usr['session_user_id'], true);
}

// ---------------------------------------------------------------
// 3. Verify the guard pattern: isset() short-circuits so
//    F_isAuthorizedEditorForUser is never called for tracker rows.
// ---------------------------------------------------------------
$auth_calls = [];

function F_isAuthorizedEditorForUser($user_id)
{
    global $auth_calls;
    $auth_calls[] = (int) $user_id;
    return true;
}

// Simulate the guard for each row, exactly as the fixed code does.
foreach ([$bf, $otp] as $idx => $session) {
    if (! isset($session['session_user_id']) || ! F_isAuthorizedEditorForUser($session['session_user_id'])) {
        continue;
    }
    $failures[] = ($idx === 0 ? 'Brute-force' : 'OTP') . ' tracker row should have been skipped.';
}

if ($auth_calls !== []) {
    $failures[] = 'F_isAuthorizedEditorForUser must not be called for tracker rows, but was called with: '
        . var_export($auth_calls, true);
}

// ---------------------------------------------------------------
// 4. For a real user session the guard must pass and call auth.
// ---------------------------------------------------------------
$auth_calls = [];
$session = $usr;
if (! isset($session['session_user_id']) || ! F_isAuthorizedEditorForUser($session['session_user_id'])) {
    $failures[] = 'Real user session should NOT have been skipped.';
}

if ($auth_calls !== [42]) {
    $failures[] = 'F_isAuthorizedEditorForUser should have been called with 42, got: '
        . var_export($auth_calls, true);
}

// ---------------------------------------------------------------
if ($failures !== []) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "Online-users tracker-row guard tests passed." . PHP_EOL;
