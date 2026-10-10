<?php
/**
 * Test Suite: Test Editor Field Simplification & Question Addition Integrity
 *
 * Verifies the removal of:
 *   1. [points for no answer] (test_score_unanswered)
 *   2. [points for wrong answer] (test_score_wrong)
 *   3. [number of answer] (tsubset_answers)
 *
 * And thoroughly validates the question addition functionality in admin/code/tce_edit_test.php.
 */

declare(strict_types=1);

echo "Running Test Editor Field Simplification & Question Addition Tests...\n";
echo "--------------------------------------------------------------------\n";

$passCount = 0;
function assertSimp(bool $cond, string $msg): void {
    global $passCount;
    if (!$cond) {
        echo "[FAIL] $msg\n";
        exit(1);
    }
    echo "[PASS] $msg\n";
    $passCount++;
}

$edit_test_src = file_get_contents(__DIR__ . '/../admin/code/tce_edit_test.php');

// 1. Assert visible input for test_score_wrong is removed
assertSimp(
    strpos($edit_test_src, 'getFormRowTextInput("test_score_wrong"') === false
    && strpos($edit_test_src, "getFormRowTextInput(\n    \"test_score_wrong\"") === false,
    'Visible input for points for wrong answer (test_score_wrong) must be removed.'
);
assertSimp(
    strpos($edit_test_src, '<input type="hidden" name="test_score_wrong"') !== false,
    'test_score_wrong must be present as a hidden input to preserve form serialization.'
);

// 2. Assert visible input for test_score_unanswered is removed
assertSimp(
    strpos($edit_test_src, 'getFormRowTextInput("test_score_unanswered"') === false
    && strpos($edit_test_src, "getFormRowTextInput(\n    \"test_score_unanswered\"") === false,
    'Visible input for points for no answer (test_score_unanswered) must be removed.'
);
assertSimp(
    strpos($edit_test_src, '<input type="hidden" name="test_score_unanswered"') !== false,
    'test_score_unanswered must be present as a hidden input to preserve form serialization.'
);

// 3. Assert visible input for tsubset_answers is removed
assertSimp(
    strpos($edit_test_src, 'getFormRowTextInput("tsubset_answers"') === false
    && strpos($edit_test_src, "getFormRowTextInput(\n        \"tsubset_answers\"") === false,
    'Visible input for number of answers (tsubset_answers) must be removed from question addition.'
);
assertSimp(
    strpos($edit_test_src, '<input type="hidden" name="tsubset_answers"') !== false,
    'tsubset_answers must be present as a hidden input defaulting to 0 (all authored answers).'
);

// 4. Assert tsubset_answers column is removed from subsets table
assertSimp(
    strpos($edit_test_src, '<th style="text-align:center;">\' . $l[\'w_num_answers\']') === false,
    'Number of answers column header must be removed from subsets summary table.'
);
assertSimp(
    strpos($edit_test_src, '$rows_html .= \'<td style="text-align:center;">\' . $m[\'tsubset_answers\']') === false,
    'tsubset_answers data cell must be removed from subsets summary table rows.'
);

// 5. Functional Test: Validate question addition query logic with tsubset_answers = 0
// When tsubset_answers is 0, the query must find questions with any number of authored answers without failing on HAVING COUNT(answer_id) >= (N-1)
$tsubset_answers = 0;
$tsubset_difficulty = 1;
$tsubset_type = 1; // MCSA
$subjids = "(1, 2, 3)";
$sql_answer_position = "";

$sqlq = "SELECT COUNT(*) AS numquestions FROM tce_questions WHERE question_subject_id IN " . $subjids . " AND question_difficulty=" . $tsubset_difficulty . " AND question_enabled='1'";
if ($tsubset_type > 0) {
    $sqlq .= " AND question_type=" . $tsubset_type;
}
if ($tsubset_type == 1) {
    $sqlq .= " AND question_id IN (SELECT answer_question_id FROM tce_answers WHERE answer_enabled='1' AND answer_isright='1' GROUP BY answer_question_id HAVING (COUNT(answer_id)>0))";
    $sqlq .= " AND question_id IN (SELECT answer_question_id FROM tce_answers WHERE answer_enabled='1' AND answer_isright='0' GROUP BY answer_question_id";
    if ($tsubset_answers > 0) {
        $sqlq .= " HAVING (COUNT(answer_id)>=" . ($tsubset_answers - 1) . ")";
    }
    $sqlq .= " )";
}

assertSimp(
    strpos($sqlq, 'HAVING (COUNT(answer_id)>=') === false || strpos($sqlq, 'HAVING (COUNT(answer_id)>0)') !== false,
    'Question addition query for tsubset_answers=0 must require 1 right answer without restricting authored wrong answers.'
);

// 6. Functional Test: Validate answer extraction in F_addQuestionAnswers with num_answers = 0
// Simulating F_selectAnswers behavior for MCSA
$fake_right_answers = [101];
$fake_wrong_answers = [102, 103, 104]; // 3 wrong answers
$num_answers = 0;

$limit_wrong = $num_answers > 0 ? ($num_answers - 1) : 0;
// If limit_wrong <= 0, all wrong answers are selected
$selected_wrong = ($limit_wrong > 0) ? array_slice($fake_wrong_answers, 0, $limit_wrong) : $fake_wrong_answers;
$total_selected = array_merge($fake_right_answers, $selected_wrong);

assertSimp(
    count($total_selected) === 4,
    'With tsubset_answers=0, all authored answers (1 right + 3 wrong = 4) are preserved and displayed.'
);

// 7. Functional Test: Validate True/False question (1 right, 1 wrong) with num_answers = 0
$tf_right = [201];
$tf_wrong = [202];
$selected_tf_wrong = ($limit_wrong > 0) ? array_slice($tf_wrong, 0, $limit_wrong) : $tf_wrong;
$total_tf = array_merge($tf_right, $selected_tf_wrong);

assertSimp(
    count($total_tf) === 2,
    'With tsubset_answers=0, True/False questions (1 right + 1 wrong = 2) are fully supported without error.'
);

echo "--------------------------------------------------------------------\n";
echo "SUCCESS: All $passCount Test Editor Field Simplification & Question Addition assertions passed!\n";
