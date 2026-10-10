<?php
/**
 * Test Suite: Rich Text Editor Removal Across Project
 *
 * Verifies that legacy proprietary markup/rich-text editor toolbars,
 * preview popups, and tag insertion scripts are completely eliminated
 * across subject, question, answer, and test editing interfaces in favor
 * of standard, clean text inputs.
 */

declare(strict_types=1);

error_reporting(E_ERROR);

if (!defined('K_NEWLINE')) {
    define('K_NEWLINE', PHP_EOL);
}

chdir(__DIR__ . '/fixtures/code');
require_once(__DIR__ . '/fixtures/config/tce_config.php');
$l = ['a_meta_charset' => 'UTF-8'];
require_once(__DIR__ . '/../shared/code/tce_functions_form.php');
require_once(__DIR__ . '/../admin/code/tce_functions_tcecode_editor.php');

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

echo "Running Rich Text Editor Removal Tests...\n";
echo "------------------------------------------------------------\n";

$subject_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_subject.php');
$question_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_question.php');
$answer_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_answer.php');
$test_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_test.php');

// ===========================================================================
// Section 1: Subject Editor (tce_edit_subject.php)
// ===========================================================================

assert_true(
    strpos($subject_src, 'inserttag.js') === false,
    'tce_edit_subject.php must not include inserttag.js.'
);

assert_true(
    strpos($subject_src, 'tce_functions_tcecode_editor.php') === false,
    'tce_edit_subject.php must not require tce_functions_tcecode_editor.php.'
);

assert_true(
    strpos($subject_src, 'tcecodeEditorTagButtons') === false,
    'tce_edit_subject.php must not call tcecodeEditorTagButtons.'
);

assert_true(
    strpos($subject_src, 'tce_preview_tcecode.php') === false,
    'tce_edit_subject.php must not link to tce_preview_tcecode.php.'
);

assert_true(
    strpos($subject_src, 'FJ_update_selection') === false,
    'tce_edit_subject.php must not attach FJ_update_selection.'
);

assert_true(
    strpos($subject_src, "getFormRowTextBox('subject_description'") !== false,
    'tce_edit_subject.php must use getFormRowTextBox for subject_description.'
);

// ===========================================================================
// Section 2: Question Editor (tce_edit_question.php)
// ===========================================================================

assert_true(
    strpos($question_src, 'inserttag.js') === false,
    'tce_edit_question.php must not include inserttag.js.'
);

assert_true(
    strpos($question_src, 'tce_functions_tcecode_editor.php') === false,
    'tce_edit_question.php must not require tce_functions_tcecode_editor.php.'
);

assert_true(
    strpos($question_src, 'tcecodeEditorTagButtons') === false,
    'tce_edit_question.php must not call tcecodeEditorTagButtons.'
);

assert_true(
    strpos($question_src, 'tce_preview_tcecode.php') === false,
    'tce_edit_question.php must not link to tce_preview_tcecode.php.'
);

assert_true(
    strpos($question_src, 'FJ_update_selection') === false,
    'tce_edit_question.php must not attach FJ_update_selection.'
);

assert_true(
    strpos($question_src, "getFormRowTextBox('question_description'") !== false,
    'tce_edit_question.php must use getFormRowTextBox for question_description.'
);

assert_true(
    strpos($question_src, 'name="question_explanation"') !== false
    && strpos($question_src, 'tcecodeEditorTagButtons(\'form_questioneditor\', \'question_explanation\')') === false,
    'tce_edit_question.php must render explanation textarea without rich text editor buttons.'
);

// ===========================================================================
// Section 3: Answer Editor (tce_edit_answer.php)
// ===========================================================================

assert_true(
    strpos($answer_src, 'inserttag.js') === false,
    'tce_edit_answer.php must not include inserttag.js.'
);

assert_true(
    strpos($answer_src, 'tce_functions_tcecode_editor.php') === false,
    'tce_edit_answer.php must not require tce_functions_tcecode_editor.php.'
);

assert_true(
    strpos($answer_src, 'tcecodeEditorTagButtons') === false,
    'tce_edit_answer.php must not call tcecodeEditorTagButtons.'
);

assert_true(
    strpos($answer_src, 'tce_preview_tcecode.php') === false,
    'tce_edit_answer.php must not link to tce_preview_tcecode.php.'
);

assert_true(
    strpos($answer_src, 'FJ_update_selection') === false,
    'tce_edit_answer.php must not attach FJ_update_selection.'
);

assert_true(
    strpos($answer_src, "getFormRowTextBox('answer_description'") !== false,
    'tce_edit_answer.php must use getFormRowTextBox for answer_description.'
);

assert_true(
    strpos($answer_src, 'name="answer_explanation"') !== false
    && strpos($answer_src, 'tcecodeEditorTagButtons(\'form_answereditor\', \'answer_explanation\')') === false,
    'tce_edit_answer.php must render explanation textarea without rich text editor buttons.'
);

// ===========================================================================
// Section 4: Test Editor (tce_edit_test.php)
// ===========================================================================

assert_true(
    strpos($test_src, 'tce_functions_tcecode_editor.php') === false,
    'tce_edit_test.php must not require tce_functions_tcecode_editor.php.'
);

// ===========================================================================
// Section 5: Toolbar Functions & Form Helpers
// ===========================================================================

assert_true(
    tcecodeEditorTagButtons('form_test', 'field_test') === '',
    'tcecodeEditorTagButtons must return empty string.'
);

assert_true(
    getImageButton('bold', '[b]', 'bold.gif') === '',
    'getImageButton must return empty string.'
);

$customTextBoxHtml = getFormRowTextBox('sample_field', 'Sample Label', 'Sample Tip', 'Sample Value', false, '', 10, 60);

assert_true(
    strpos($customTextBoxHtml, 'rows="10"') !== false
    && strpos($customTextBoxHtml, 'cols="60"') !== false
    && strpos($customTextBoxHtml, 'Sample Value') !== false,
    'getFormRowTextBox must respect custom row and column counts.'
);

// ===========================================================================
// Summary
// ===========================================================================

echo "------------------------------------------------------------\n";
if (!empty($failures)) {
    echo "FAILED: " . count($failures) . " assertions failed.\n";
    exit(1);
} else {
    echo "SUCCESS: All 20 Rich Text Editor Removal assertions passed!\n";
    exit(0);
}
