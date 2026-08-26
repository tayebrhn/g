<?php
// Verify sample_exam_questions.tsv parses exactly like TCExam's importer
// (F_TSVQuestionImporter uses: fgetcsv($fp, 0, "\t", '"'))
// and that all structural invariants for single-choice import hold.

$file = __DIR__ . DIRECTORY_SEPARATOR . 'sample_exam_questions.tsv';
$fp = fopen($file, 'r');
if ($fp === false) {
    fwrite(STDERR, "cannot open $file\n");
    exit(1);
}

$errors = [];
$modules = 0;
$topics = 0;
$questions = 0;
$answers = 0;

$curModule = null;
$curTopic = null;

// dedup trackers (mirror importer uniqueness constraints)
$moduleNames = [];                 // module_name unique globally
$subjectNamesByModule = [];        // subject_name unique per module
$questionDescBySubject = [];       // question_description unique per subject
$answerDescByQuestion = [];        // answer_description unique per question

$curQ = null;                      // ['type'=>..,'right'=>int,'ansCount'=>int,'desc'=>..]

function flushQuestion(&$curQ, &$errors)
{
    if ($curQ === null) {
        return;
    }
    if ($curQ['type'] !== 'S') {
        $errors[] = "Question not single-choice (type={$curQ['type']}): {$curQ['desc']}";
    }
    if ($curQ['ansCount'] !== 4) {
        $errors[] = "Question does not have 4 answers ({$curQ['ansCount']}): {$curQ['desc']}";
    }
    if ($curQ['right'] !== 1) {
        $errors[] = "Question must have exactly 1 correct answer (has {$curQ['right']}): {$curQ['desc']}";
    }
    $curQ = null;
}

while (($row = fgetcsv($fp, 0, "\t", '"')) !== false) {
    if (!isset($row[0])) {
        continue;
    }
    switch ($row[0]) {
        case 'M':
            flushQuestion($curQ, $errors);
            $curModule = $row[2] ?? '';
            $curTopic = null;
            if (isset($moduleNames[$curModule])) {
                $errors[] = "Duplicate module name: $curModule";
            }
            $moduleNames[$curModule] = true;
            $subjectNamesByModule[$curModule] = [];
            $modules++;
            break;
        case 'S':
            flushQuestion($curQ, $errors);
            $curTopic = ($curModule . '||' . ($row[2] ?? ''));
            $name = $row[2] ?? '';
            if (isset($subjectNamesByModule[$curModule][$name])) {
                $errors[] = "Duplicate topic '$name' in module '$curModule'";
            }
            $subjectNamesByModule[$curModule][$name] = true;
            $questionDescBySubject[$curTopic] = [];
            $topics++;
            break;
        case 'Q':
            flushQuestion($curQ, $errors);
            $desc = $row[2] ?? '';
            $type = $row[4] ?? '';
            if (isset($questionDescBySubject[$curTopic][$desc])) {
                $errors[] = "Duplicate question in topic '$curTopic': $desc";
            }
            $questionDescBySubject[$curTopic][$desc] = true;
            $qkey = $curTopic . '||' . $desc;
            $answerDescByQuestion[$qkey] = [];
            $curQ = ['type' => $type, 'right' => 0, 'ansCount' => 0, 'desc' => $desc, 'key' => $qkey];
            $questions++;
            break;
        case 'A':
            if ($curQ === null) {
                $errors[] = "Answer with no active question: " . implode('|', $row);
                break;
            }
            $adesc = $row[2] ?? '';
            $isright = (int) ($row[4] ?? 0);
            $qkey = $curQ['key'];
            if (isset($answerDescByQuestion[$qkey][$adesc])) {
                $errors[] = "Duplicate answer '$adesc' in question: {$curQ['desc']}";
            }
            $answerDescByQuestion[$qkey][$adesc] = true;
            $curQ['right'] += $isright;
            $curQ['ansCount']++;
            $answers++;
            break;
        default:
            // header/blank lines ignored, just like the importer
            break;
    }
}
flushQuestion($curQ, $errors);
fclose($fp);

echo "Parsed  modules=$modules topics=$topics questions=$questions answers=$answers\n";

if ($errors === []) {
    echo "RESULT: OK - all invariants hold (single-choice, 4 answers, exactly 1 correct, no duplicate keys).\n";
    exit(0);
}

echo "RESULT: " . count($errors) . " problem(s) found:\n";
foreach (array_slice($errors, 0, 50) as $e) {
    echo "  - $e\n";
}
exit(1);
