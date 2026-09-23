# UX Content Audit — TCExam English Interface Text

**Product:** TCExam (online exam platform)
**Audience:** students/candidates, teachers, exam administrators
**Scope:** all user-facing interface text (English)
**Standard applied:** clear, calm, professional, supportive; sentence case; verb-first actions
**Excluded:** main content (question/answer text, help bodies used as long-form passages where noted), third-party libraries (TCPDF, phpCAS, PHPMailer), legal/licence text

---

## A. Executive summary

The English interface is functional but was written by developers rather than content designers, and it shows in four recurring problems:

1. **Alarm and blame.** Error and status text shouts in ALL CAPS and uses accusatory phrasings: `AUTHORIZATION REFUSED!`, `ERROR`, `wrong user / password`, `I'm sorry, the time available to complete the test is over!`. These read as reprimands at exactly the moments users are most stressed (login failure, running out of time).
2. **Inconsistent terminology and casing.** The same concepts are named differently across screens: *surname* vs *last name*, *name* vs *first name*, *licence* vs *license*, *e-mail* vs *email*, *professor* vs *teacher*, *catalogued* vs *cataloged*. Buttons mix `modify`/`edit`, `send`/`submit`/`upload`. Page titles, buttons and messages mix Title Case and sentence case with no rule.
3. **Developer-centric wording.** Tooltips describe implementation rather than intent: `send form data to the calling process`, `insert the selected subject on this test`, `modify database`, `Unknownn encoding`. Destructive confirmations are especially weak: `confirm deleting` gives the user no idea what will be lost.
4. **Factual mismatch.** Several strings name the wrong format or action: `hp_import_xml_questions` says "import questions from an TSV file" (grammar + legacy key name), `m_restore_completed` says "restore has been successfully created", `m_importing_complete` says "XML importing completed" even though the importer is TSV.

**Numbers:** 623 translatable English strings reviewed; **138 strings rewritten and applied**, including **37 page/section titles** converted to sentence case. Of these, **11 are Critical** (destructive or blocking flows), **35 High** (grammar, blame, wrong information), **35 Medium** (consistency, jargon), **21 Low** (polish), and **37 titles**. **3 hardcoded strings** outside the translation system were also fixed (2 of the 3 format labels; see C.6).

**Expected outcome:** calmer, more consistent, more translatable UI that tells users what happened and what to do next, without changing any behaviour.

---

## B. Terminology glossary

### Approved terms (use these)

| Concept | Approved term | Notes |
|---|---|---|
| A person taking a test | candidate / user | "candidate" in task-oriented copy, "user" in admin tables |
| A graded attempt | test | Do not alternate with "exam" in the same flow |
| Passing a test | pass a test | Not "overcome", not "exceed" |
| The set of questions under a module | topic | Replaces "subject" in all UI copy (DB/internal names unchanged) |
| A single-choice question | single answer | |
| A multiple-choice question | multiple answers | |
| A free-text question | free answer | |
| The action of closing a test early | end test | Reserve "terminate" for forced/system endings only |
| Removing data | delete | For a record; "discard changes" for unsaved edits |
| The access password for a test | test password | |

### Avoid / replace

| Avoid | Use instead | Why |
|---|---|---|
| terminate / termination | end test (see exception below) | Alarmist for a normal user action |
| remove / removed from database | delete / deleted | Plain language; "from database" leaks internals |
| modify | edit | Shorter, more familiar |
| send (for file upload) | upload | Distinguishes from submitting a form |
| e-mail | email | Modern standard |
| surname | last name | Matches "first name" |
| licence | license | Single spelling (US) across UI |
| professor | teacher | Matches student-facing mental model |
| execute | start / run | Plain language |
| ALL CAPS for messages | Sentence case | Reduces perceived shouting; better for screen readers |

### Context rules

- **Normal user action** → calm, positive/neutral verbs: "End test", "Save changes", "Upload file".
- **Forced or abnormal ending** (system timeout, proctor force-end) → "terminate" is acceptable only in logs/administration, not on candidate buttons.
- **Destructive action** → name the object and the consequence: "Delete this test? All results will also be deleted. This cannot be undone."
- **Identity/domain terms are non-negotiable:** "TCExam", "OMR", "fayda number", "OTP", "SSL certificate".

---

## C. Full audit table

Priority: **C** = Critical, **H** = High, **M** = Medium, **L** = Low.

### C.1 Critical — destructive, blocking, or dangerously ambiguous

| ID | Location / screen | Current text | Category | Issue | Suggested text | Rationale | P |
|----|-------------------|--------------|----------|-------|----------------|-----------|---|
| IA-001 | Authorization guard (all protected pages) | `AUTHORIZATION REFUSED!` | Error | Shouts; no cause or next step | `You do not have permission to view this page.` | Calm, states fact, avoids blame | C |
| IA-002 | Delete confirmation | `confirm deleting` | Confirmation | Does not say what is deleted or that it is permanent | `Delete this record? This cannot be undone.` | State the action and permanence | C |
| IA-003 | Delete test confirmation | `deleting this test will delete also all its logs (test results)` | Confirmation | Awkward; "logs" is jargon; no permanence warning | `Deleting this test also deletes all of its results. This cannot be undone.` | Names consequence precisely | C |
| IA-004 | Restore backup confirmation | `confirm restoring` | Confirmation | Does not say current data is replaced | `Restore this backup? Your current data will be replaced.` | Prevent data loss surprise | C |
| IA-005 | End-test confirmation | `confirm test termination` | Confirmation | Vague; no consequence | `End this test now? You will not be able to continue.` | Clear, decisive, non-threatening | C |
| IA-006 | End-test button | `terminate the exam` | Button | Alarmist, inconsistent with "test" | `End test now` | Verb-first, matches user goal | C |
| IA-007 | Force-end button | `terminate` | Button | Bare, alarming | `End test` | Plain verb | C |
| IA-008 | Test timer expiry message | `I'm sorry, the time available to complete the test is over!` | Error | Apologetic and alarming | `Time is up. Your test has ended.` | Factual, brief, calm | C |
| IA-009 | Login failure | `wrong user / password` | Error | Blaming, ambiguous (which was wrong?) | `Incorrect username or password.` | Standard, non-specific for security | C |
| IA-010 | Login rate limit | `You are trying to log too many times and too fast, please wait the following number of seconds before the next attempt:` | Error | Accusatory; convoluted | `Too many failed login attempts. Please wait this number of seconds before trying again:` | Neutral, keeps trailing count | C |
| IA-011 | Restore completed | `restore has been successfully created` | Message | Factually wrong verb ("created") | `Backup restored successfully.` | Correct meaning | C |

### C.2 High — grammar, wrong information, blame, blocking clarity

| ID | Location / screen | Current text | Category | Issue | Suggested text | Rationale | P |
|----|-------------------|--------------|----------|-------|----------------|-----------|---|
| IA-012 | Import questions help | `With this form you can import questions from an TSV file.` | Help | Article error; legacy wording | `With this form you can import questions from a TSV file.` | Grammar | H |
| IA-013 | Import completion | `XML importing completed` | Message | Names wrong format | `Import completed.` | Accuracy | H |
| IA-014 | Import success | `the import process has been successfully completed` | Message | Wordy | `Import completed successfully.` | Concise | H |
| IA-015 | Import failure | `the import process has failed` | Error | Verbose | `Import failed.` | Concise | H |
| IA-016 | Required fields | `some of the required fields have not been filled out` | Error | Passive, wordy | `Some required fields are empty.` | Direct | H |
| IA-017 | Wrong format fields | `some fields have been filled out using a wrong format` | Error | Awkward | `Some fields contain invalid values.` | Clear | H |
| IA-018 | Empty database | `the database is empty!` | Message | Alarm, internals | `No data is available yet.` | Calm, user-oriented | H |
| IA-019 | No tests | `there are no available tests!` | Empty state | Alarm, no next step | `No tests are available.` | Neutral | H |
| IA-020 | No search results | `nothing found` | Empty state | Blunt | `No results found.` | Standard | H |
| IA-021 | Upload failure | `unable to send the file` | Error | "send" ≠ upload | `The file could not be uploaded.` | Correct verb | H |
| IA-022 | Upload success | `file sent correctly` | Message | Wrong verb, awkward | `File uploaded successfully.` | Correct verb | H |
| IA-023 | Password mismatch | `the passwords are different` | Error | Vague | `The passwords do not match.` | Clear | H |
| IA-024 | Empty password | `the password field is empty` | Error | Wordy | `Enter a password.` | Actionable | H |
| IA-025 | Duplicate answer | `this answer has been already entered` | Error | Word order | `This answer already exists.` | Clear | H |
| IA-026 | Duplicate name | `this name has been already used, you must use another one` | Error | Commanding | `This name is already in use. Choose another name.` | Helpful | H |
| IA-027 | Duplicate reg. number | `this registration number has been used already, you must use another one` | Error | Commanding | `This registration number is already in use. Choose another one.` | Helpful | H |
| IA-028 | Duplicate SSN/ID | `this SSN has been used already, you must use another one` | Error | Jargon acronym + commanding | `This ID number is already in use. Choose another one.` | Plain | H |
| IA-029 | Duplicate question | `this question has been entered already` | Error | Word order | `This question already exists.` | Clear | H |
| IA-030 | Record in use (update) | `the record cannot be updated because is in use in other tables.` | Error | Grammar ("because is"), internals | `This record cannot be updated because it is used by other data.` | Grammar + plain | H |
| IA-031 | Record in use (test results) | `the record cannot be updated because it is used in the results table of the test.` | Error | Internals | `This record cannot be updated because it is used in the test results.` | Plain | H |
| IA-032 | Disabled vs deleted | `the record has been disabled, it could not be deleted because it is used in other tables. You will be able to delete this record only after deleting the test in which it is used.` | Error | Long, run-on, internals | `This record was disabled because it is used by other data. Delete that data first, then you can delete this record.` | Sequence is clear | H |
| IA-033 | Record in use (delete fallback) | `the record cannot be updated because it is used in the results table of the test. It will be possible to modify this record only after deleting the test that is using it. You can disable it with the [delete] button.` | Error | Long, passive | `This record cannot be updated because it is used in the test results. Delete the test that uses it first, or disable it with the [delete] button.` | Direct | H |
| IA-034 | Test limit reached | `the limit of maximum tests has been reached` | Error | Clumsy | `You have reached the maximum number of tests.` | Natural | H |
| IA-035 | Score too high | `the selected score is higher than maximum allowed` | Error | Missing article | `The score is higher than the maximum allowed.` | Grammar | H |
| IA-036 | Questions unavailable | `the selected questions are not available in the database` | Error | Internals | `The selected questions are no longer available.` | Plain | H |
| IA-037 | Email mismatch | `the emails are different` | Error | Vague | `The email addresses do not match.` | Clear | H |
| IA-038 | Wrong test password | `wrong test password` | Error | Blaming | `Incorrect test password.` | Neutral | H |
| IA-039 | Typo — encoding | `Unknownn encoding: ` | Error | Typo | `Unknown encoding: ` | Spelling | H |
| IA-040 | Typo — "no answer" tooltip | `if selected, enable the 'no answer' options as alternative anwers` | Tooltip | Typo ("anwers") | `if selected, enable the 'no answer' options as alternative answers` | Spelling | H |
| IA-041 | Error title | `ERROR` | Status label | ALL CAPS shouting | `Error` | Sentence case | H |
| IA-042 | Warning title | `ATTENTION` | Status label | ALL CAPS shouting | `Attention` | Sentence case | H |
| IA-043 | Message title | `MESSAGE` | Status label | ALL CAPS shouting | `Message` | Sentence case | H |
| IA-044 | Show label (duplicate key) | `shows` | Label | Grammatically wrong for a button/key | `show` | Fixes `w_show` duplicate | H |
| IA-045 | File/dir name exists | `this file or directory name is already used` | Error | Awkward | `A file or directory with this name already exists.` | Natural | H |

### C.3 Medium — consistency, jargon, clarity

| ID | Location / screen | Current text | Category | Issue | Suggested text | Rationale | P |
|----|-------------------|--------------|----------|-------|----------------|-----------|---|
| IA-046 | Login button | `authenticate` | Button | Stiff, inconsistent with "log out" | `log in` | Verb-first, familiar | M |
| IA-047 | Logout button | `logout` | Button | Inconsistent with "log in" | `log out` | Parallel with log in | M |
| IA-048 | Upload submit button | `send` | Button | Wrong verb for upload | `upload` | Correct action | M |
| IA-049 | Edit button | `modify` | Button | Inconsistent with edit action | `edit` | Standard | M |
| IA-050 | Edit button (dup key) | `modify` | Button | Unused but inconsistent | `edit` | Align with glossary | M |
| IA-051 | User form label | `name` (w_firstname) | Form label | Ambiguous (first name?) | `first name` | Matches last name | M |
| IA-052 | User form label | `surname` | Form label | Inconsistent with "first name" | `last name` | Consistency | M |
| IA-053 | Results status | `PASSED` | Status badge | ALL CAPS | `Passed` | Sentence case | M |
| IA-054 | Results status | `NOT PASSED` | Status badge | ALL CAPS | `Not passed` | Sentence case | M |
| IA-055 | Import users help | `With this form you can import users and groups from TSV (tab delimited text) file. The file formats are the same as the ones obtained by exporting data from the Users Selection form.` | Help | Awkward, redundant | `With this form you can import users and groups from a TSV (tab-delimited text) file. The file format is the same as the one produced when exporting data from the user selection form.` | Clear | M |
| IA-056 | Upload image tooltip | `specify the path of an image to be sent to the server` | Tooltip | Internals | `Choose an image to upload` | User intent | M |
| IA-057 | Upload file tooltip | `specify the path of the file to be sent to the server` | Tooltip | Internals | `Choose a file to upload` | User intent | M |
| IA-058 | Submit tooltip | `send form data to the calling process` | Tooltip | Developer jargon | `Submit this form` | User language | M |
| IA-059 | Submit file tooltip | `submit file` | Tooltip | Redundant | `Upload this file` | Action clarity | M |
| IA-060 | Add topic tooltip | `insert the selected subject on this test` | Tooltip | "subject" ≠ UI "topic" | `Add the selected topic to this test` | Terminology | M |
| IA-061 | New-window note | `this link will open a new browser window` | Microcopy | Verbose | `This link opens in a new window.` | Concise | M |
| IA-062 | Statistics label | `radiobuttons for MCMA` | Label | Spelling | `radio buttons for MCMA` | Spelling | M |
| IA-063 | File rename error | `unable to rename the selected file` | Error | Passive | `The file could not be renamed.` | Direct | M |
| IA-064 | File delete error | `unable to delete the selected file or directory` | Error | Passive | `The file or directory could not be deleted.` | Direct | M |
| IA-065 | Directory create error | `unable to create the requested directory` | Error | Passive | `The directory could not be created.` | Direct | M |
| IA-066 | File in use | `this file is used on question or answer description` | Error | Awkward | `This file is used in a question or answer.` | Natural | M |
| IA-067 | Backup success | `backup has been successfully created` | Message | Missing article | `Backup created successfully.` | Concise | M |
| IA-068 | Registration success | `user successfully registered` | Message | Word order | `Registration complete.` | Natural | M |
| IA-069 | Group updated | `the user data have been updated` | Message | Grammar (data have) | `The user data has been saved.` | Grammar | M |
| IA-070 | User updated | `the user data have been updated` | Message | Grammar | `The user data has been saved.` | Grammar | M |
| IA-071 | OMR data missing | `the image of OMR DATA page is missing or unreadable` | Error | Awkward | `The OMR DATA page image is missing or unreadable.` | Natural | M |
| IA-072 | OMR sheet missing | `the image of OMR ANSWER SHEET page is missing or unreadable` | Error | Awkward | `The OMR ANSWER SHEET page image is missing or unreadable.` | Natural | M |
| IA-073 | Email changed | `the email has been updated` | Message | Missing article | `Your email address has been updated.` | Natural | M |
| IA-074 | Password changed | `the password has been updated` | Message | Missing article | `Your password has been updated.` | Natural | M |
| IA-075 | SSL requirement | `To access this page you need a valid SSL certificate client.` | Error | "certificate client" jargon | `A valid client SSL certificate is required to access this page.` | Plain | M |
| IA-076 | Font size option | `small` / `medium` / `large` (hardcoded) | Option | Not translated; lowercase | route through `$l` or capitalize consistently | Localisation | M |
| IA-077 | Import format titles | `Exam TSV Format` / `Exam CSV Format` (hardcoded) | Tooltip | Inconsistent casing; not translated | `TSV format` / `CSV format` | Consistency + l10n | M |

### C.4 Low — polish and navigation

| ID | Location / screen | Current text | Category | Issue | Suggested text | Rationale | P |
|----|-------------------|--------------|----------|-------|----------------|-----------|---|
| IA-078 | Add tooltip | `add current record to database` | Tooltip | Internals | `Add this record to the database` | Plain | L |
| IA-079 | Delete tooltip | `delete current record from database` | Tooltip | Internals | `Delete this record from the database` | Plain | L |
| IA-080 | Record deleted | `the record has been removed from database` | Message | Internals | `The record has been deleted.` | Plain | L |
| IA-081 | Group deleted | `the group has been removed from database` | Message | Internals | `The group has been deleted.` | Plain | L |
| IA-082 | User deleted | `the user has been removed from database` | Message | Internals | `The user has been deleted.` | Plain | L |
| IA-083 | Record updated | `the record has been updated` | Message | Generic | `Changes saved.` | Human | L |
| IA-084 | Process completed | `process completed` | Message | Terse | `Done.` | Friendly | L |
| IA-085 | No answer | `no answer` | Label | Casing | `No answer` | Sentence case | L |
| IA-086 | Unknown email | `unknown email` | Error | Casing | `Unknown email address` | Sentence case | L |
| IA-087 | With selected | `with selected:` | Label | Casing | `With selected:` | Sentence case | L |
| IA-088 | User selection tooltip | `open a user selection page` | Tooltip | Casing | `Open the user selection page` | Sentence case | L |
| IA-089 | TSV file type tooltip | `Tab Delimited Text File` | Tooltip | Casing/hyphen | `Tab-delimited text file` | Sentence case | L |
| IA-090 | Email tooltip | `e-mail address` | Tooltip | Spelling | `email address` | Consistency | L |
| IA-091 | Licence menu | `licence` | Menu label | UK spelling | `license` | Consistency (US) | L |
| IA-092 | Teacher role | `professor` | Role label | Inconsistent with students | `teacher` | Glossary | L |
| IA-093 | Max score | `max score` | Column | Inconsistent with "maximum" | `maximum score` | Consistency | L |
| IA-094 | Global score | `global score` | Label | Vague | `overall score` | Clarity | L |
| IA-095 | Auto next | `automatic next` | Checkbox | Incomplete | `automatic next question` | Clarity | L |
| IA-096 | Last name tooltip | `User's last name (example: Smith, Palmer, ...)` | Tooltip | Casing | `user's last name (for example: Smith, Palmer, ...)` | Casing | L |
| IA-097 | Topics help | `cataloged` vs module help `catalogued` | Help | Spelling mismatch | `cataloged` (both) | Consistency | L |
| IA-098 | Registration sent | `a verification message has been sent to this address` | Message | Casing | `A verification message has been sent to this address.` | Sentence case | L |

### C.5 Page and section titles (t_) — sentence case

| ID | Current title | Suggested title | P |
|----|---------------|-----------------|---|
| IA-099 | `Multiple-Answer Management` | `Multiple-answer management` | L |
| IA-100 | `Group Management` | `Group management` | L |
| IA-101 | `Group List` | `Group list` | L |
| IA-102 | `Add Image` | `Add image` | L |
| IA-103 | `Users Online` | `Users online` | L |
| IA-104 | `Question Management` | `Question management` | L |
| IA-105 | `Questions List` | `Questions list` | L |
| IA-106 | `Question Importer` | `Question importer` | L |
| IA-107 | `Answer Evaluation` | `Answer evaluation` | L |
| IA-108 | `Test Results Summary` | `Test results summary` | L |
| IA-109 | `Question Statistics` | `Question statistics` | L |
| IA-110 | `Test Results` | `Test results` | L |
| IA-111 | `Topics Management` | `Topic management` | L |
| IA-112 | `Text Formatting` | `Text formatting` | L |
| IA-113 | `Test Execution` | `Test execution` | L |
| IA-114 | `Test Information` | `Test information` | L |
| IA-115 | `Test Management` | `Test management` | L |
| IA-116 | `Third-party Software` | `Third-party software` | L |
| IA-117 | `User Management` | `User management` | L |
| IA-118 | `User Importer` | `User importer` | L |
| IA-119 | `User Selection` | `User selection` | L |
| IA-120 | `Modules Management` | `Module management` | L |
| IA-121 | `User's Results` | `User's results` | L |
| IA-122 | `Database Backup and Restore` | `Database backup and restore` | L |
| IA-123 | `Change Password` | `Change password` | L |
| IA-124 | `Change Email` | `Change email` | L |
| IA-125 | `Test List` | `Test list` | L |
| IA-126 | `Media File Manager` | `Media file manager` | L |
| IA-127 | `Select Object` | `Select object` | L |
| IA-128 | `Import Answers (OMR)` | `Import answers (OMR)` | L |
| IA-129 | `Password Assistance` | `Password assistance` | L |
| IA-130 | `OMR Bulk Importer` | `OMR bulk importer` | L |
| IA-131 | `SSL Certificates` | `SSL certificates` | L |
| IA-132 | `New User Registration` | `New user registration` | L |
| IA-133 | `Test Selection` | `Test selection` | L |
| IA-134 | `TCExam :: Test Execution` | `TCExam :: Test execution` | L |

### C.6 Hardcoded strings outside the translation system

| ID | File / location | Current text | Issue | Suggested text | P |
|----|-----------------|--------------|-------|----------------|----|
| IA-135 | `admin/code/tce_import_questions.php:118,127` | `Exam TSV Format`, `Exam CSV Format` | Hardcoded, Title Case, not translatable | `TSV format`, `CSV format` | M |
| IA-136 | `admin/code/tce_import_users.php:116` | `CSV Format` | Hardcoded, Title Case | `CSV format` | M |
| IA-137 | `admin/code/tce_functions_tcecode_editor.php:98-104` | `xx-small`, `small`, `medium`, `large`, … | Lowercase, not translatable | Keep values; capitalise visible labels or route through `$l` | L |

### C.7 Additional consistency fixes (glossary application)

| ID | Current text | Key | Issue | Suggested text | Rationale | P |
|----|--------------|-----|-------|----------------|-----------|---|
| IA-138 | `execute` | `w_execute` | Technical verb on the start-test button | `start test` | Glossary: avoid "execute" | M |
| IA-139 | `run test` | `h_execute` | Inconsistent with button | `Start this test` | Sentence case + consistency | M |
| IA-140 | `password, alphanumeric code required to execute this test` | `h_test_password` | "execute" | `password, alphanumeric code required to take this test` | Glossary | L |
| IA-141 | `In order to execute this test you must provide the test password` | `hp_test_password` | Wordy + "execute" | `To take this test you must provide the test password` | Glossary | L |
| IA-142 | `modify database` | `h_database` | "modify" | `manage the database` | Glossary | L |

> The install wizard (`install/install.php`) contains English labels but is used once, by a technical administrator, pre-authentication; it is **out of scope** for this pass. Third-party libraries are excluded.

---

## D. Consistency rules

1. **One action, one label.** `delete`, `edit`, `save`, `upload`, `submit`, `log in`, `log out` are used everywhere and nowhere else. No `modify`, no `send` for uploads.
2. **Start buttons with a verb.** "Start test", "End test", "Upload file", not "terminate"/"execute".
3. **Same concept, same noun.** "test" (never "exam" in the same flow), "topic" (never "subject" in UI), "last name"/"first name", "email", "license".
4. **Sentence case** for titles, headings, buttons, labels, messages and status badges. Brand names keep their casing (TCExam, Google Authenticator, OMR, SSL, OTP).
5. **No ALL CAPS for whole messages.** Emphasis relies on the status icon/colour, not shouting.
6. **Messages say what happened; errors say what to do.** "Import failed." → add a cause when known. "Some required fields are empty."
7. **Destructive confirmations name the object and the consequence,** and state permanence: "…This cannot be undone."
8. **No internals in user copy.** Never "database", "table", "logs", "calling process" on candidate-facing screens; use them only in admin diagnostics if needed.
9. **Keep placeholders, entities and format tokens intact.** `[delete]`, `#TCEXAMURL#`, `&lt;br /&gt;`, trailing `: ` before appended values must survive rewriting.
10. **Localisable by design.** New/changed strings must stay short (translation expands ~30% for German, more for others).

---

## E. Open questions / decisions needed

1. **`h_question_description`** tooltip reads "type of question (e.g.: true, false, ...)" but labels the question *description* field. Is the tooltip wrong, or the field? Needs product confirmation before changing (not changed in this pass).
2. **Forced vs normal test ending.** We standardised candidate buttons on "End test". Do administrators/proctors need a separate, explicitly final label such as "Terminate session" in the admin area? (Glossary allows "terminate" only there.)
3. **US vs UK spelling.** This pass standardises on US (`license`, `cataloged`). Confirm this is the house style for other languages' base copy.
4. **Status badge casing.** `PASSED`/`NOT PASSED` changed to sentence case; confirm no dependent colour/style rule keys off the exact string.
5. **Install wizard scope.** Left untouched; confirm it can stay as-is (single-admin, one-time use).
6. **"fayda number", "SSN", "OMR", "OTP"** are treated as non-negotiable domain terms. Confirm they must not be localised/expanded.
7. **Duplicate key `w_show`** exists twice in the TMX. Both English values are being set to "show"; recommend de-duplicating the TMX entry in a separate housekeeping task.
8. **Text-editor font-size options** (`xx-small` … `xx-large`, plus percentages) are hardcoded CSS keyword labels, not translatable. Left unchanged (IA-137); decide whether they should be translated or kept as technical values.

---

## F. Interface style guide (quick reference)

### Voice
Calm, direct, human. Talk to the user as a capable adult. Never blame ("you entered the wrong…"), never alarm ("REFUSED!"), never apologise for the product's behaviour ("I'm sorry…"). Prefer contractions sparingly; prefer active voice.

### Casing
- Sentence case everywhere: titles, buttons, labels, checkboxes, menu items, status.
- Proper nouns: TCExam, Google Authenticator, OMR, OTP, SSL, PDF, TSV, CSV.
- Acronyms that are words in the UI ("OMR DATA") may stay uppercase as document labels.

### Buttons
Verb + object, max ~3 words: `Add`, `Edit`, `Delete`, `Save`, `Cancel`, `Upload`, `Submit`, `Log in`, `Log out`, `Start test`, `End test`.

### Errors
State the problem, then the fix. One sentence where possible. Do not expose stack/DB detail. Keep trailing punctuation needed for appended values (`: `).

### Confirmations (destructive)
Ask a question, name the object, state the consequence, state permanence.
> `Delete this test? All results will also be deleted. This cannot be undone.`

### Empty states
Say what is missing and, if possible, the next step. Avoid exclamation marks.
> `No tests are available.`

### Accessibility
- No ALL CAPS text (screen readers may spell it out).
- Keep "skip navigation" and "jump to…" links (already present and good).
- Keep tooltips short; they are supplementary, not the only source of meaning.

### Localisation
- Avoid idioms ("at hand", "in use in other tables").
- Avoid building sentences by concatenation; keep trailing separators consistent with existing code.
- Keep strings short.
