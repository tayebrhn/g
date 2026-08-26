# Sample Test Exam Data (TSV)

Sample question bank for exercising the TCExam engine (create test → assign → take → score).

## Contents

`sample_exam_questions.tsv` — TCExam native TSV import file:

| Module | Topics | Questions/topic | Type |
|--------|--------|-----------------|------|
| Sample Test Exam A - Arithmetic | A1 - Addition, A2 - Multiplication | 21 | single choice |
| Sample Test Exam B - Computing | B1 - Powers of Two, B2 - Binary Numbers | 21 | single choice |
| Sample Test Exam C - Units and Conversions | C1 - Metric Length, C2 - Time | 21 | single choice |

- **3 modules × 2 topics × 21 = 126 questions**, **504 answers**.
- Every question is **single choice** (type `S`) with 4 options and exactly **1 correct** answer.
- All questions are deterministic and provably correct (arithmetic / conversions), so it is safe throwaway test data.
- Modules, topics, questions and answers are all created **enabled** on import.

## How to import

1. Log in to the TCExam admin panel.
2. Go to **Questions → Import Questions**.
3. Leave the format set to **TSV**.
4. Upload `sample_exam_questions.tsv` and submit.

The importer auto-creates the modules and topics by name (or reuses them if they already exist) and skips any question/answer that already exists, so re-importing is safe.

## Regenerate / resize

`generate_sample_exam_tsv.php` builds the TSV. Edit the loop bound (`$i <= 21`) or the
`$modules` array, then run:

```
php generate_sample_exam_tsv.php
```

`verify_sample_exam_tsv.php` re-parses the output exactly like TCExam's importer
(`fgetcsv($fp, 0, "\t", '"')`) and asserts every question is single-choice with 4
answers, exactly one correct, and no duplicate keys:

```
php verify_sample_exam_tsv.php
```

## TSV format reference

Row types (tab-separated), matching `admin/code/tce_tsv_questions.php`:

- `M` → `module_enabled`, `module_name`
- `S` → `subject_enabled`, `subject_name`, `subject_description`
- `Q` → `question_enabled`, `question_description`, `question_explanation`, `question_type` (`S`/`M`/`T`/`O`), `question_difficulty`, `question_position`, `question_timer`, `question_fullscreen`, `question_inline_answers`, `question_auto_next`
- `A` → `answer_enabled`, `answer_description`, `answer_explanation`, `answer_isright`, `answer_position`, `answer_keyboard_key`

The leading `M=MODULE` / `S=SUBJECT` / `Q=QUESTION` / `A=ANSWER` header rows are ignored on import.
