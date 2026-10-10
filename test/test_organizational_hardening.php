<?php

//============================================================+
// File name   : test_organizational_hardening.php
// Description : Unit and regression assertions for Organizational
//               Hardening, PII Privacy, and Academic Stripping.
//============================================================+

declare(strict_types=1);

echo "Running Organizational Hardening & PII Protection tests...\n";
echo "------------------------------------------------------------\n";

$passCount = 0;
function assertOrgRule(bool $condition, string $description): void
{
    global $passCount;
    if (!$condition) {
        echo "[FAIL] $description\n";
        exit(1);
    }
    echo "[PASS] $description\n";
    $passCount++;
}

// 1. Check user registration config
require_once __DIR__ . '/../shared/config/tce_user_registration.php';
assertOrgRule(defined('K_USRREG_ENABLED') && K_USRREG_ENABLED === false, 'K_USRREG_ENABLED must be false for enterprise invite-only provisioning.');
assertOrgRule(isset($regfields['user_birthdate']) && $regfields['user_birthdate'] === 0, 'user_birthdate must be disabled (0) in registration fields.');
assertOrgRule(isset($regfields['user_birthplace']) && $regfields['user_birthplace'] === 0, 'user_birthplace must be disabled (0) in registration fields.');
assertOrgRule(isset($regfields['user_ssn']) && $regfields['user_ssn'] === 0, 'user_ssn must be disabled (0) in registration fields.');

// 2. Check SSL workstation certs config & guard
require_once __DIR__ . '/../shared/config/tce_ssl.php';
assertOrgRule(defined('K_ENABLE_SSLCERTS') && K_ENABLE_SSLCERTS === false, 'K_ENABLE_SSLCERTS must be defined and false.');

$sslcertsFile = file_get_contents(__DIR__ . '/../admin/code/tce_edit_sslcerts.php');
assertOrgRule(strpos($sslcertsFile, "K_ENABLE_SSLCERTS") !== false, 'tce_edit_sslcerts.php must guard against K_ENABLE_SSLCERTS being disabled.');

// 3. Check PDF header defaults
require_once __DIR__ . '/../shared/config/tce_pdf.php';
assertOrgRule(defined('PDF_HEADER_TITLE') && strpos(PDF_HEADER_TITLE, 'School name') === false, 'PDF_HEADER_TITLE must not contain "School name".');

// 4. Check user editor PII suppression & Employee ID display
$editUserFile = file_get_contents(__DIR__ . '/../admin/code/tce_edit_user.php');
assertOrgRule(strpos($editUserFile, "echo getFormRowTextInput('user_regnumber', \$l['w_regcode']") !== false, 'tce_edit_user.php must display user_regnumber row.');
$posReg = strpos($editUserFile, "echo getFormRowTextInput('user_regnumber'");
$posHiddenDiv = strpos($editUserFile, '<div style="display:none;">', $posReg);
$posBirth = strpos($editUserFile, "echo getFormRowTextInput('user_birthdate'", $posHiddenDiv);
$posPlace = strpos($editUserFile, "echo getFormRowTextInput('user_birthplace'", $posHiddenDiv);
$posSsn = strpos($editUserFile, "echo getFormRowTextInput('user_ssn'", $posHiddenDiv);
assertOrgRule($posReg < $posHiddenDiv && $posHiddenDiv < $posBirth && $posBirth < $posPlace && $posPlace < $posSsn, 'tce_edit_user.php must keep user_birthdate, birthplace, and SSN inside the hidden PII div while user_regnumber is visible.');

// 5. Check test editor SSL cert suppression
$editTestFile = file_get_contents(__DIR__ . '/../admin/code/tce_edit_test.php');
assertOrgRule(strpos($editTestFile, "defined('K_ENABLE_SSLCERTS') && K_ENABLE_SSLCERTS") !== false, 'tce_edit_test.php must guard the SSL certificate selector with K_ENABLE_SSLCERTS.');

// 6. Check user select table display of Employee / Candidate ID
$userSelectFile = file_get_contents(__DIR__ . '/../admin/code/tce_functions_user_select.php');
assertOrgRule(strpos($userSelectFile, "F_select_table_header_element('user_regnumber'") !== false, 'tce_functions_user_select.php must render user_regnumber in table header.');
assertOrgRule(strpos($userSelectFile, "htmlspecialchars(\$m['user_regnumber']") !== false, 'tce_functions_user_select.php must render user_regnumber data cell.');

// 7. Check language terminology rebranding
$cachedLang = file_get_contents(__DIR__ . '/../cache/lang/language_tmx_en.php');
assertOrgRule(strpos($cachedLang, "\$tmx['w_regcode']='Employee / Candidate ID';") !== false, 'w_regcode must be translated to Employee / Candidate ID in cached language.');
assertOrgRule(strpos($cachedLang, "\$tmx['w_teacher']='Evaluator / Examiner';") !== false, 'w_teacher must be translated to Evaluator / Examiner in cached language.');
assertOrgRule(strpos($cachedLang, "level 1 a basic user (e.g.: a candidate or employee)") !== false, 'hp_edit_user must refer to candidate or employee instead of student.');

echo "------------------------------------------------------------\n";
echo "SUCCESS: All $passCount Organizational Hardening assertions passed!\n";
