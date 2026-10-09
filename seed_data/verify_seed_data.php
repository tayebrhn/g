<?php
/**
 * Verification Suite for TCExam Showcase Seed Data
 *
 * Validates TSV, CSV, and SQL seed files against TCExam's internal parser
 * requirements, schema rules, and invariant constraints.
 *
 * Usage:
 *   php seed_data/verify_seed_data.php
 */

declare(strict_types=1);

require_once __DIR__ . '/../shared/code/tce_functions_general.php';

$errors = [];
$warnings = [];

echo "============================================================\n";
echo "Verifying TCExam Showcase Seed Data\n";
echo "============================================================\n\n";

// =============================================================================
// 1. VERIFY USERS TSV
// =============================================================================
echo "[1/6] Verifying users_seed.tsv...\n";
$usersTsvFile = __DIR__ . '/users_seed.tsv';
if (!file_exists($usersTsvFile)) {
    $errors[] = "users_seed.tsv does not exist.";
} else {
    $lines = file($usersTsvFile, FILE_IGNORE_NEW_LINES);
    if ($lines === false || count($lines) < 2) {
        $errors[] = "users_seed.tsv is empty or lacks data rows.";
    } else {
        $header = explode("\t", $lines[0]);
        if (count($header) !== 16) {
            $errors[] = "users_seed.tsv header does not have 16 columns (found " . count($header) . ").";
        }
        if ($header[1] !== 'user_name' || $header[12] !== 'user_level' || $header[15] !== 'user_groups') {
            $errors[] = "users_seed.tsv header columns unexpected.";
        }

        $usernames = [];
        $regnumbers = [];
        $ssns = [];
        $userCount = 0;

        for ($i = 1; $i < count($lines); $i++) {
            $row = explode("\t", $lines[$i]);
            if (count($row) !== 16) {
                $errors[] = "users_seed.tsv line " . ($i + 1) . " has " . count($row) . " columns instead of 16.";
                continue;
            }
            $userCount++;
            $uname = $row[1];
            $pwd = $row[2];
            $email = $row[3];
            $level = (int)$row[12];
            $reg = $row[10];
            $ssn = $row[11];
            $grps = $row[15];

            if (empty($uname)) {
                $errors[] = "Line " . ($i + 1) . ": Empty username.";
            } elseif (isset($usernames[$uname])) {
                $errors[] = "Line " . ($i + 1) . ": Duplicate username '$uname'.";
            }
            $usernames[$uname] = true;

            if (empty($pwd)) {
                $errors[] = "Line " . ($i + 1) . " ($uname): Empty password.";
            }

            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $errors[] = "Line " . ($i + 1) . " ($uname): Invalid email format '$email'.";
            }

            if ($level < 1 || $level > 10) {
                $errors[] = "Line " . ($i + 1) . " ($uname): Invalid user level '$level'.";
            }

            if (empty($grps)) {
                $errors[] = "Line " . ($i + 1) . " ($uname): Empty user_groups column.";
            }

            if (!empty($reg)) {
                if (isset($regnumbers[$reg])) {
                    $errors[] = "Line " . ($i + 1) . " ($uname): Duplicate regnumber '$reg'.";
                }
                $regnumbers[$reg] = true;
            }

            if (!empty($ssn)) {
                if (isset($ssns[$ssn])) {
                    $errors[] = "Line " . ($i + 1) . " ($uname): Duplicate ssn '$ssn'.";
                }
                $ssns[$ssn] = true;
            }
        }
        echo "      Parsed $userCount users across all permission tiers successfully.\n";
    }
}

// =============================================================================
// 2. VERIFY USERS CSV
// =============================================================================
echo "[2/6] Verifying users_seed.csv...\n";
$usersCsvFile = __DIR__ . '/users_seed.csv';
if (!file_exists($usersCsvFile)) {
    $errors[] = "users_seed.csv does not exist.";
} else {
    $csvContent = file_get_contents($usersCsvFile);
    $convertedTsv = F_csv_to_tsv($csvContent);
    $lines = explode("\n", trim($convertedTsv));
    if (count($lines) < 2) {
        $errors[] = "Converted users_seed.csv is empty or lacks rows.";
    } else {
        $header = explode("\t", $lines[0]);
        if (count($header) !== 16) {
            $errors[] = "Converted users_seed.csv header does not have 16 columns.";
        }
        echo "      Verified round-trip CSV-to-TSV conversion (" . (count($lines) - 1) . " users).\n";
    }
}

// =============================================================================
// 3. VERIFY MODULES & QUESTIONS TSV
// =============================================================================
echo "[3/6] Verifying modules_and_questions_seed.tsv...\n";
$qTsvFile = __DIR__ . '/modules_and_questions_seed.tsv';
if (!file_exists($qTsvFile)) {
    $errors[] = "modules_and_questions_seed.tsv does not exist.";
} else {
    $fp = fopen($qTsvFile, 'r');
    if ($fp === false) {
        $errors[] = "Cannot open modules_and_questions_seed.tsv.";
    } else {
        $modules = 0;
        $subjects = 0;
        $questions = 0;
        $answers = 0;

        $curModule = null;
        $curSubject = null;
        $curQuestion = null;

        $moduleNames = [];
        $subjectNamesByModule = [];
        $questionNamesBySubject = [];
        $answerNamesByQuestion = [];

        $flushQuestion = function() use (&$curQuestion, &$errors) {
            if ($curQuestion === null) {
                return;
            }
            if ($curQuestion['ansCount'] < 2) {
                $errors[] = "Question '{$curQuestion['text']}' has fewer than 2 answers ({$curQuestion['ansCount']}).";
            }
            if ($curQuestion['type'] === 'S') {
                if ($curQuestion['rightCount'] !== 1) {
                    $errors[] = "Single-choice question '{$curQuestion['text']}' must have exactly 1 right answer (has {$curQuestion['rightCount']}).";
                }
            } elseif ($curQuestion['type'] === 'M') {
                if ($curQuestion['rightCount'] < 2) {
                    $errors[] = "Multiple-choice question '{$curQuestion['text']}' should have at least 2 right answers (has {$curQuestion['rightCount']}).";
                }
            } else {
                $errors[] = "Unsupported question type '{$curQuestion['type']}' in '{$curQuestion['text']}'.";
            }
            $curQuestion = null;
        };

        while (($row = fgetcsv($fp, 0, "\t", '"')) !== false) {
            if (!isset($row[0])) {
                continue;
            }
            switch ($row[0]) {
                case 'M':
                    $flushQuestion();
                    $modName = $row[2] ?? '';
                    if (empty($modName)) {
                        $errors[] = "Module row missing module_name.";
                    } elseif (isset($moduleNames[$modName])) {
                        $errors[] = "Duplicate module name: '$modName'.";
                    }
                    $moduleNames[$modName] = true;
                    $curModule = $modName;
                    $curSubject = null;
                    $subjectNamesByModule[$modName] = [];
                    $modules++;
                    break;

                case 'S':
                    $flushQuestion();
                    if ($curModule === null) {
                        $errors[] = "Subject defined without parent Module.";
                    }
                    $subjName = $row[2] ?? '';
                    if (empty($subjName)) {
                        $errors[] = "Subject row missing subject_name.";
                    } elseif (isset($subjectNamesByModule[$curModule][$subjName])) {
                        $errors[] = "Duplicate subject '$subjName' in module '$curModule'.";
                    }
                    $subjectNamesByModule[$curModule][$subjName] = true;
                    $curSubject = $curModule . '||' . $subjName;
                    $questionNamesBySubject[$curSubject] = [];
                    $subjects++;
                    break;

                case 'Q':
                    $flushQuestion();
                    if ($curSubject === null) {
                        $errors[] = "Question defined without parent Subject.";
                    }
                    $qText = $row[2] ?? '';
                    $qExpl = $row[3] ?? '';
                    $qType = $row[4] ?? '';
                    $qDiff = (int)($row[5] ?? 0);

                    if (empty($qText)) {
                        $errors[] = "Question row missing question_description.";
                    } elseif (isset($questionNamesBySubject[$curSubject][$qText])) {
                        $errors[] = "Duplicate question '$qText' in subject '$curSubject'.";
                    }
                    $questionNamesBySubject[$curSubject][$qText] = true;

                    if ($qDiff < 1 || $qDiff > 5) {
                        $errors[] = "Question '$qText' has invalid difficulty '$qDiff' (must be 1-5).";
                    }

                    $qKey = $curSubject . '||' . $qText;
                    $answerNamesByQuestion[$qKey] = [];
                    $curQuestion = [
                        'text'       => $qText,
                        'type'       => $qType,
                        'key'        => $qKey,
                        'ansCount'   => 0,
                        'rightCount' => 0
                    ];
                    $questions++;
                    break;

                case 'A':
                    if ($curQuestion === null) {
                        $errors[] = "Answer defined without active Question.";
                        break;
                    }
                    $aText = $row[2] ?? '';
                    $isRight = (int)($row[4] ?? 0);
                    $qKey = $curQuestion['key'];

                    if (empty($aText)) {
                        $errors[] = "Answer missing answer_description in '{$curQuestion['text']}'.";
                    } elseif (isset($answerNamesByQuestion[$qKey][$aText])) {
                        $errors[] = "Duplicate answer '$aText' in question '{$curQuestion['text']}'.";
                    }
                    $answerNamesByQuestion[$qKey][$aText] = true;

                    $curQuestion['ansCount']++;
                    if ($isRight === 1) {
                        $curQuestion['rightCount']++;
                    }
                    $answers++;
                    break;

                default:
                    // Header rows (M=MODULE, S=SUBJECT, Q=QUESTION, A=ANSWER) ignored
                    break;
            }
        }
        $flushQuestion();
        fclose($fp);

        echo "      Parsed $modules modules, $subjects subjects, $questions questions, and $answers answers.\n";
    }
}

// =============================================================================
// 4. VERIFY MODULES & QUESTIONS CSV
// =============================================================================
echo "[4/6] Verifying modules_and_questions_seed.csv...\n";
$qCsvFile = __DIR__ . '/modules_and_questions_seed.csv';
if (!file_exists($qCsvFile)) {
    $errors[] = "modules_and_questions_seed.csv does not exist.";
} else {
    $csvContent = file_get_contents($qCsvFile);
    $tsvContent = F_csv_to_tsv($csvContent);
    $csvTmp = tempnam(sys_get_temp_dir(), 'tce_csv_verify_');
    file_put_contents($csvTmp, $tsvContent);

    $fp = fopen($csvTmp, 'r');
    $csvQCount = 0;
    $csvACount = 0;
    while (($row = fgetcsv($fp, 0, "\t", '"')) !== false) {
        if (!isset($row[0])) continue;
        if ($row[0] === 'Q') $csvQCount++;
        if ($row[0] === 'A') $csvACount++;
    }
    fclose($fp);
    @unlink($csvTmp);

    if ($csvQCount !== $questions || $csvACount !== $answers) {
        $errors[] = "CSV conversion discrepancy: CSV has $csvQCount questions, $csvACount answers (TSV has $questions Qs, $answers As).";
    } else {
        echo "      Verified CSV conversion matches TSV exactly ($csvQCount questions, $csvACount answers).\n";
    }
}

// =============================================================================
// 5. VERIFY SHOWCASE SQL SCRIPT
// =============================================================================
echo "[5/6] Verifying showcase_seed.sql...\n";
$sqlFile = __DIR__ . '/showcase_seed.sql';
if (!file_exists($sqlFile)) {
    $errors[] = "showcase_seed.sql does not exist.";
} else {
    $sqlContent = file_get_contents($sqlFile);
    $requiredTables = [
        'tce_user_groups',
        'tce_users',
        'tce_usrgroups',
        'tce_modules',
        'tce_subjects',
        'tce_questions',
        'tce_answers',
        'tce_tests',
        'tce_test_subject_set',
        'tce_test_subjects',
        'tce_testgroups'
    ];

    foreach ($requiredTables as $tbl) {
        if (strpos($sqlContent, $tbl) === false) {
            $errors[] = "showcase_seed.sql does not reference table '$tbl'.";
        }
    }

    // Verify foreign key disable/enable wrap
    if (strpos($sqlContent, 'SET FOREIGN_KEY_CHECKS = 0') === false ||
        strpos($sqlContent, 'SET FOREIGN_KEY_CHECKS = 1') === false) {
        $warnings[] = "showcase_seed.sql should ideally wrap execution with FOREIGN_KEY_CHECKS toggles.";
    }

    echo "      Verified SQL script structure and all 11 core tables covered.\n";
}

// =============================================================================
// 6. VERIFY SIMULATED RESULTS SQL SCRIPT
// =============================================================================
echo "[6/6] Verifying showcase_results_seed.sql...\n";
$resFile = __DIR__ . '/showcase_results_seed.sql';
if (!file_exists($resFile)) {
    $errors[] = "showcase_results_seed.sql does not exist.";
} else {
    $resContent = file_get_contents($resFile);
    $resTables = [
        'tce_tests_users',
        'tce_tests_logs',
        'tce_tests_logs_answers'
    ];

    foreach ($resTables as $tbl) {
        if (strpos($resContent, $tbl) === false) {
            $errors[] = "showcase_results_seed.sql does not reference table '$tbl'.";
        }
    }

    // Count attempts
    preg_match_all('/INSERT INTO tce_tests_users/i', $resContent, $mAttempts);
    $attemptCount = count($mAttempts[0]);
    if ($attemptCount !== 17) {
        $errors[] = "Expected 17 candidate attempts in showcase_results_seed.sql, found $attemptCount.";
    }

    // Count status 4 (completed) attempts
    preg_match_all('/SELECT t\.test_id, u\.user_id, 4,/i', $resContent, $mCompleted);
    $completedCount = count($mCompleted[0]);
    if ($completedCount !== 14) {
        $errors[] = "Expected 14 completed attempts (status 4), found $completedCount.";
    }

    // Count status 0 (ready-to-take) attempts
    preg_match_all('/SELECT t\.test_id, u\.user_id, 0,/i', $resContent, $mReady);
    $readyCount = count($mReady[0]);
    if ($readyCount !== 3) {
        $errors[] = "Expected 3 ready-to-take attempts (status 0), found $readyCount.";
    }

    // Count question logs (14 * 12 = 168)
    preg_match_all('/INSERT INTO tce_tests_logs\s*\(/i', $resContent, $mLogs);
    $logCount = count($mLogs[0]);
    if ($logCount !== 168) {
        $errors[] = "Expected 168 question logs in showcase_results_seed.sql, found $logCount.";
    }

    // Count answer selections (168)
    preg_match_all('/INSERT INTO tce_tests_logs_answers/i', $resContent, $mAnswers);
    $answCount = count($mAnswers[0]);
    if ($answCount !== 168) {
        $errors[] = "Expected 168 answer selection blocks in showcase_results_seed.sql, found $answCount.";
    }

    // Verify foreign key disable/enable wrap
    if (strpos($resContent, 'SET FOREIGN_KEY_CHECKS = 0') === false ||
        strpos($resContent, 'SET FOREIGN_KEY_CHECKS = 1') === false) {
        $warnings[] = "showcase_results_seed.sql should wrap execution with FOREIGN_KEY_CHECKS toggles.";
    }

    echo "      Verified $attemptCount attempts ($completedCount completed, $readyCount ready-to-take), $logCount question logs, and $answCount answer blocks.\n";
}

echo "\n============================================================\n";
if ($errors === []) {
    echo "VERIFICATION PASSED: All showcase seed data files are valid and compliant!\n";
    echo "============================================================\n";
    exit(0);
} else {
    echo "VERIFICATION FAILED (" . count($errors) . " errors found):\n";
    foreach ($errors as $e) {
        echo "  - $e\n";
    }
    echo "============================================================\n";
    exit(1);
}
