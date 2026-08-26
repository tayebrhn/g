<?php

//============================================================+
// File name   : generate_sample_exam_tsv.php
// Description : Generate sample single-choice questions for TCExam
//               in the native TSV import format.
//
//               Output: 3 modules x 2 topics x 21 questions = 126
//               single-choice (type "S") questions, each with 1 correct
//               and 3 wrong answers. All questions are deterministic and
//               provably correct (arithmetic / conversions), so the file
//               is safe sample data for testing the exam engine.
//
// Usage       : php generate_sample_exam_tsv.php
//               (writes sample_exam_questions.tsv next to this script)
//
// TSV format follows admin/code/tce_tsv_questions.php (export) and is
// imported by admin/code/tce_import_questions.php (F_TSVQuestionImporter).
//============================================================+

$TAB = "\t";
$NL  = "\n";

/**
 * Build 3 distinct integer distractors close to $correct (all >= 0, != correct).
 */
function distractors_num(int $correct): array
{
    $out = [];
    foreach ([$correct + 1, $correct - 1, $correct + 2, $correct - 2, $correct + 3, $correct + 5, $correct + 10] as $c) {
        if ($c < 0 || $c === $correct || in_array($c, $out, true)) {
            continue;
        }
        $out[] = $c;
        if (count($out) === 3) {
            break;
        }
    }
    return $out;
}

/**
 * Build 3 distinct binary-string distractors for decimal $n (!= decbin($n)).
 */
function distractors_bin(int $n): array
{
    $correct = decbin($n);
    $out = [];
    foreach ([$n + 1, $n - 1, $n + 2, $n + 3, $n + 5] as $c) {
        if ($c < 0) {
            continue;
        }
        $b = decbin($c);
        if ($b === $correct || in_array($b, $out, true)) {
            continue;
        }
        $out[] = $b;
        if (count($out) === 3) {
            break;
        }
    }
    return $out;
}

/**
 * Place the correct value into a rotating slot among 3 distractors.
 * Returns array of ['desc','isright','pos'] rows (4 answers).
 */
function build_answers($correct, array $distractors, int $qindex): array
{
    $slot = ($qindex - 1) % 4; // 0..3, rotates the correct answer position
    $opts = $distractors;      // exactly 3 items
    array_splice($opts, $slot, 0, [$correct]); // insert correct -> 4 items
    $rows = [];
    foreach ($opts as $i => $val) {
        $rows[] = [
            'desc'    => (string) $val,
            'isright' => ($i === $slot ? 1 : 0),
            'pos'     => $i + 1,
        ];
    }
    return $rows;
}

/**
 * Return 21 question definitions for a given topic generator type.
 * Each item: ['text','expl','correct','distractors'].
 */
function make_questions(string $type): array
{
    $items = [];
    for ($i = 1; $i <= 21; $i++) {
        switch ($type) {
            case 'add': {
                $a = 10 + $i;
                $b = $i;
                $correct = $a + $b;
                $items[] = [
                    'text'        => "What is $a plus $b?",
                    'expl'        => "$a + $b = $correct.",
                    'correct'     => $correct,
                    'distractors' => distractors_num($correct),
                ];
                break;
            }
            case 'mul': {
                $a = $i + 1;
                $b = $i + 2;
                $correct = $a * $b;
                $items[] = [
                    'text'        => "What is $a multiplied by $b?",
                    'expl'        => "$a multiplied by $b equals $correct.",
                    'correct'     => $correct,
                    'distractors' => distractors_num($correct),
                ];
                break;
            }
            case 'pow': {
                $n = $i;
                $correct = (int) pow(2, $n);
                $items[] = [
                    'text'        => "What is 2 to the power of $n?",
                    'expl'        => "2^$n = $correct.",
                    'correct'     => $correct,
                    'distractors' => distractors_num($correct),
                ];
                break;
            }
            case 'bin': {
                $n = $i + 4; // 5..25
                $correct = decbin($n);
                $items[] = [
                    'text'        => "What is the decimal number $n written in binary (base 2)?",
                    'expl'        => "$n in binary is $correct.",
                    'correct'     => $correct,
                    'distractors' => distractors_bin($n),
                ];
                break;
            }
            case 'metric': {
                $k = $i + 1; // 2..22
                $correct = $k * 1000;
                $items[] = [
                    'text'        => "How many metres are there in $k kilometres?",
                    'expl'        => "$k km = $correct m.",
                    'correct'     => $correct,
                    'distractors' => distractors_num($correct),
                ];
                break;
            }
            case 'time': {
                $m = $i + 1; // 2..22
                $correct = $m * 60;
                $items[] = [
                    'text'        => "How many seconds are there in $m minutes?",
                    'expl'        => "$m min = $correct s.",
                    'correct'     => $correct,
                    'distractors' => distractors_num($correct),
                ];
                break;
            }
        }
    }
    return $items;
}

$modules = [
    [
        'name'   => 'Sample Test Exam A - Arithmetic',
        'topics' => [
            ['name' => 'A1 - Addition',       'desc' => 'Single-choice addition questions (sample test data).',       'gen' => 'add'],
            ['name' => 'A2 - Multiplication', 'desc' => 'Single-choice multiplication questions (sample test data).', 'gen' => 'mul'],
        ],
    ],
    [
        'name'   => 'Sample Test Exam B - Computing',
        'topics' => [
            ['name' => 'B1 - Powers of Two',  'desc' => 'Single-choice powers-of-two questions (sample test data).',  'gen' => 'pow'],
            ['name' => 'B2 - Binary Numbers', 'desc' => 'Single-choice binary conversion questions (sample test data).', 'gen' => 'bin'],
        ],
    ],
    [
        'name'   => 'Sample Test Exam C - Units and Conversions',
        'topics' => [
            ['name' => 'C1 - Metric Length',  'desc' => 'Single-choice metric length conversion questions (sample test data).', 'gen' => 'metric'],
            ['name' => 'C2 - Time',           'desc' => 'Single-choice time conversion questions (sample test data).',          'gen' => 'time'],
        ],
    ],
];

// ---- build TSV --------------------------------------------------------

$out = '';

// column-description header rows (ignored on import: first field != M/S/Q/A)
$out .= 'M=MODULE'   . $TAB . 'module_enabled' . $TAB . 'module_name' . $NL;
$out .= 'S=SUBJECT'  . $TAB . 'subject_enabled' . $TAB . 'subject_name' . $TAB . 'subject_description' . $NL;
$out .= 'Q=QUESTION' . $TAB . 'question_enabled' . $TAB . 'question_description' . $TAB . 'question_explanation' . $TAB . 'question_type' . $TAB . 'question_difficulty' . $TAB . 'question_position' . $TAB . 'question_timer' . $TAB . 'question_fullscreen' . $TAB . 'question_inline_answers' . $TAB . 'question_auto_next' . $NL;
$out .= 'A=ANSWER'   . $TAB . 'answer_enabled' . $TAB . 'answer_description' . $TAB . 'answer_explanation' . $TAB . 'answer_isright' . $TAB . 'answer_position' . $TAB . 'answer_keyboard_key' . $NL;
$out .= $NL;

$stats = ['modules' => 0, 'topics' => 0, 'questions' => 0, 'answers' => 0, 'right' => 0];

foreach ($modules as $mod) {
    $out .= 'M' . $TAB . '1' . $TAB . $mod['name'] . $NL;
    $stats['modules']++;

    foreach ($mod['topics'] as $topic) {
        $out .= 'S' . $TAB . '1' . $TAB . $topic['name'] . $TAB . $topic['desc'] . $NL;
        $stats['topics']++;

        $questions = make_questions($topic['gen']);
        $qpos = 1;
        foreach ($questions as $q) {
            // Q: enabled, description, explanation, type=S, difficulty=1, position, timer, fullscreen, inline_answers, auto_next
            $out .= 'Q' . $TAB . '1' . $TAB . $q['text'] . $TAB . $q['expl'] . $TAB . 'S' . $TAB . '1' . $TAB . $qpos . $TAB . '0' . $TAB . '0' . $TAB . '0' . $TAB . '0' . $NL;
            $stats['questions']++;

            $answers = build_answers($q['correct'], $q['distractors'], $qpos);
            foreach ($answers as $a) {
                // A: enabled, description, explanation(empty), isright, position, keyboard_key(empty)
                $out .= 'A' . $TAB . '1' . $TAB . $a['desc'] . $TAB . '' . $TAB . $a['isright'] . $TAB . $a['pos'] . $TAB . '' . $NL;
                $stats['answers']++;
                $stats['right'] += $a['isright'];
            }
            $qpos++;
        }
    }
}

$outfile = __DIR__ . DIRECTORY_SEPARATOR . 'sample_exam_questions.tsv';
file_put_contents($outfile, $out);

echo "Wrote: $outfile\n";
echo "Modules:   {$stats['modules']}\n";
echo "Topics:    {$stats['topics']}\n";
echo "Questions: {$stats['questions']}\n";
echo "Answers:   {$stats['answers']}\n";
echo "Correct answers (must equal question count): {$stats['right']}\n";

//============================================================+
// END OF FILE
//============================================================+
