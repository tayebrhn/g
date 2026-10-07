# TCExam — Feature List

**Computer-Based Assessment (CBA) software** for creating, delivering, scoring
and reporting online exams, tests, quizzes and surveys.

This list describes the features available in **this distribution** (version
16.6.1, capability-based authorization). Each section names the screens or
configuration switches that implement the feature. Line references and the
directory layout are in the other guides: [PERMISSIONS.md](PERMISSIONS.md),
[IMPORT_EXPORT.md](IMPORT_EXPORT.md), [DEPLOYMENT.md](DEPLOYMENT.md),
[SECURITY.md](SECURITY.md), [UPGRADE.TXT](UPGRADE.TXT).

## 1. Content authoring

* **Hierarchical question bank**: modules → subjects (topics) → questions →
  answers, each with an enable/disable flag and a manual position.
* **Four question types**
  * single answer (single choice) — `question_type = 1`
  * multiple answers (multiple choice) — `2`
  * free answer (free text, rated manually) — `3`
  * ordering answer (assign the right sequence position to each answer) — `4`
* **Per-question delivery options**: timer, full-screen mode, inline answers,
  auto-next, difficulty level (1–5), question and answer explanations.
* **Answer options**: correct/incorrect flag, explanation, display position,
  optional keyboard shortcut key (letter keys for fast answering), and the
  "no answer" option.
* **Rich content with TceCode**: a light markup language rendered in a
  sandboxed preview (`tce_preview_tcecode.php`, `tce_colorpicker.php`) that
  supports formatting, links, images, multimedia and mathematical formulas
  (LaTeX / MathML via `shared/config/tce_latex.php`).
* **Media library**: per-user file manager (`tce_filemanager.php`), image and
  file picker (`tce_select_mediafile.php`), MIME-type aware upload
  (`tce_functions_upload.php`, `shared/config/tce_mime.php`); files are stored
  under `cache/uid/<user id>/`.
* **Copy questions** between subjects and modules (`F_question_copy`).
* **Bulk question import** (XML and TSV) with dry, duplicate-safe merging —
  see [IMPORT_EXPORT.md](IMPORT_EXPORT.md).

## 2. Test / exam engine

Tests are assembled from selected subjects and configured per test
(`tce_edit_test.php`; fields in the `tce_tests` table).

* **Question selection pools per subject**: fixed set, or random selection of
  *N* questions by type (`tce_test_subject_set`) — enables **unique tests per
  candidate**.
* **Randomisation**: shuffle question selection, shuffle question order,
  shuffle answer selection, shuffle answer order, and configurable order
  modes.
* **Scheduling and access control**
  * begin date/time and end date/time
  * total duration (countdown) and per-question timers
  * allowed client IP range (`test_ip_range`)
  * optional test password
  * assignment to **groups** (only members can take the test)
  * optional SSL client-certificate requirement per test
  * repeatable / single-attempt tests
  * logout on timeout
* **Scoring**: points for right/wrong/unanswered answers, negative marking,
  maximum score, pass threshold, and partial scoring for multiple-choice
  multiple-answer questions; single-choice rendered as radio buttons
  (`test_mcma_radio`).
* **Test-taker aids**: question navigator/palette, comments, answer change before
  submission, answer review, flag for review.

## 3. Test taking (public area)

* Separate public (candidate) area: `public/code/` (`tce_test_start.php`,
  `tce_test_execute.php`, `tce_test_results.php`).
* Self-registration with optional e-mail confirmation, or administrator-created
  accounts.
* Takes one question at a time with progress navigation, timers, inline
  answers and auto-next as configured.
* Immediate result page and/or e-mailed report, according to the test settings.
* Candidates can always view **their own** results and transcripts
  (`tce_test_allresults.php`, `tce_show_result_user.php`, `tce_pdf_results.php`).

## 4. Results, statistics and reporting

* **Per-user result page**: score, percentage, pass/fail, right/wrong/
  unanswered counts, per-question breakdown, answer text and reaction time
  (`tce_show_result_user.php`, `tce_show_result_allusers.php`).
* **Filters**: by test, group, user, and date range; the visible scope follows
  the current user's capabilities and groups.
* **Statistic indexes**: test-level statistics (score distribution, averages)
  and per-question statistics (`tce_xml_question_stats.php`, `tce_testuser_stat`
  table).
* **Manual rating** of free-text answers (`tce_edit_rating.php`).
* **Exports**
  * PDF result reports (`tce_pdf_results.php`, admin and public)
  * TSV result exports (`tce_tsv_result_allusers.php`)
  * XML / JSON result exports (`tce_xml_results.php`,
    `tce_xml_user_results.php`)
  * XML / JSON question, question-statistics, user and answer exports
* **E-mail reports** with the PDF report attached, delivered to each candidate
  (`tce_functions_email_reports.php`, `tce_email_results.php`).
* **Answer-key protection**: the correct answers inside every result report
  (HTML, PDF and the e-mailed attachment, plus the per-answer counters of the
  question-statistics export) are visible only to the question author — the
  owner of the question's subject, a group peer, or a global-view user.
  Operators who own a test assembled from other authors' questions, and the
  test-takers reading their own report, see only their own selections.
  Controlled by `K_RESTRICT_ANSWER_KEYS` (default on; see PERMISSIONS.md
  section 5).
* **Capability-token download links**: an e-mailed report URL carries a
  time-limited hash token so the recipient does not need to log in; the
  response is marked `noindex`/`no-store` and the token expires after
  `K_RESULTS_LINK_TTL` (default 30 days, see PERMISSIONS.md section 8).

## 6. Users, groups and identity

* **User management**: create, edit, delete, enable/disable, search and select
  (`tce_edit_user.php`, `tce_select_users.php`, `tce_select_users_popup.php`).
* **Groups**: create/edit/delete groups and manage membership
  (`tce_edit_group.php`); group-based content visibility and test assignment.
* **Self-service**: registration with optional e-mail verification
  (`tce_user_registration.php`, `tce_user_verification.php`), password reset
  (`tce_password_reset.php`), change e-mail and password
  (`tce_user_change_email.php`, `tce_user_change_password.php`).
* **Profiles** carry name, e-mail, birth date/place, registration number and
  fiscal code / SSN (all available for import/export and matching).
* **Two-factor login (TOTP)**: optional one-time-password/Google-Authenticator
  support (`K_OTP_LOGIN`, per-user OTP key + QR code in the user editor).
* **Virtual keyboard** for kiosk / shared workstations
  (`K_ENABLE_VIRTUAL_KEYBOARD`).
* **Online users**: live list of active sessions with their rank label
  (`tce_show_online_users.php`, `tce_functions_users_online.php`).
* **Bulk user import/export** (XML, JSON, TSV) with group creation and
  duplicate matching — see [IMPORT_EXPORT.md](IMPORT_EXPORT.md).

## 7. Authentication and single sign-on

* Local account authentication (bcrypt password hashing).
* **Alternate identity sources**, each configurable and independently switchable
  (`shared/code/tce_altauth.php`, `shared/config/tce_*.php`):
  * LDAP / Active Directory
  * RADIUS
  * CAS (Central Authentication Service)
  * Shibboleth
  * HTTP Basic authentication
  * SSL client certificates
* Automatic account provisioning from the external source, with configurable
  rank, capability mask (`K_*_USER_PERMS`) and group (`K_*_USER_GROUP_ID`),
  optional group re-synchronisation (`K_USER_GROUP_RSYNC`).
* Custom authentication hooks (`shared/config/custom_auth/`,
  `K_CUSTOM_AUTH_METHODS`).

## 8. Authorization and permissions

* **Capability-based model** (`PERMISSIONS.md`): seven independent capability
  bits per account (`tce_users.user_perms`) — view content, edit content,
  operator, manage identity, global view, backup, administrator. Capabilities
  are independent (a higher one never implies a lower one).
* **Ranks** (`user_level`) used only for precedence: which accounts an identity
  administrator may manage, the maximum rank and capabilities it may grant.
* **Page access** per capability; **read-only** content mode;
  **row-level visibility** through group sharing; and a separate
  **modify-authority** check (only `K_PERM_ADMIN` may modify other users'
  records).
* **Session freshness**: with `K_CHECK_USER_PER_REQUEST` the rank and
  capabilities are re-read at every request, so grants, demotions and account
  removals apply without a new login.
* Easy deployment and migration from the legacy level ladder — the
  `16to17` upgrade scripts preserve every account's rights (UPGRADE.TXT).

## 9. Internationalisation, theming and accessibility

* UTF-8 throughout, with language resources in **TMX** format
  (`shared/config/lang/language_tmx.xml`); this checkout ships the English
  resources, the mechanism is language-independent and supports additional
  translation files.
* **Right-to-left** layout support and a language selector
  (`K_LANGUAGE_SELECTOR`).
* **Themes** for both areas: `default`, `exam` (admin and public) and
  `picoman` (public), selected by `K_ADMIN_THEME` / `K_PUBLIC_THEME` and
  implemented as interchangeable PHP layout files
  (`*/config/theme/*.php`).
* Markup targets **XHTML 1.0 Strict** with accessibility in mind (W3C WAI);
  the text UI is kept translation-friendly and free of developer jargon.

## 10. System administration

* **Database backup and restore** from the browser (MySQL / PostgreSQL,
  POSIX hosts; `tce_edit_backup.php`).
* **Update check** against the vendor update server (`tce_update.php`).
* **SSL certificate management** for test access control
  (`tce_edit_sslcerts.php`; tables `tce_sslcerts`, `tce_testsslcerts`).
* **Configuration** through per-area config files
  (`admin/config/`, `public/config/`, `shared/config/`) covering database,
  paths, e-mail, security, session handling, test behaviour, registration,
  password policy, PDF output (including digital signatures) and more.
* **Logging** of PHP/application errors (`K_USE_ERROR_LOG`) and of client-side
  errors optionally reported to the server (`K_ENABLE_JSERRORS`).
* **Custom import/export extensions**: stubs to plug institution-specific
  formats (`tce_import_custom.php`, `tce_export_custom.php`).

## 11. Data interchange and integration

* **Open formats** for everything: **TSV** (spreadsheet-friendly), **XML**,
  **JSON** and **PDF**.
* Machine-readable exports of questions, question statistics, users, results
  and per-user results, selected with `?format=XML|JSON`.
* Documented import formats for questions and users, with structured,
  repeatable imports — see [IMPORT_EXPORT.md](IMPORT_EXPORT.md).
* Permalink/no-login report access through the signed capability token.

## 12. Security

* Password hashing with PHP `password_hash()` (bcrypt), never stored in clear
  text and never exported.
* CSRF protection on every state-changing form (`csrf_token`).
* Login brute-force delay (`K_BRUTE_FORCE_DELAY_RATIO`) with persisted wait
  times.
* Optional session-hijacking fingerprint (`K_CHECK_SESSION_FINGERPRINT`,
  header-based so it survives proxies) plus secure/HttpOnly/SameSite cookie
  flags (`K_COOKIE_*`).
* Capability checks on every admin page, on every row (visibility) and on
  every mutation (modify authority), all enforced server-side.
* Answer-key isolation: the correct answers are withheld from result reports
  (and from the question-statistics export) unless the viewer is the question
  author or a global-view user (`F_canSeeAnswerKeys()`,
  `K_RESTRICT_ANSWER_KEYS`).
* Tokenised e-mailed reports with expiry and `noindex`/`no-store` response
  headers.
* See [SECURITY.md](SECURITY.md) for the reporting policy and hardening notes.

## 13. Deployment and operations

* Runs on LAMP or the supported Windows stack; the repository ships a complete
  **deployment kit** ([DEPLOYMENT.md](DEPLOYMENT.md)):
  * one-shot node installer (Nginx + `php-cgi` + NSSM services),
  * zero-downtime release switching and rollback,
  * post-deployment smoke tests,
  * load-balancer configuration (Nginx, with a HAProxy alternative).
* The application is **stateless across nodes** (sessions live in the
  database), so horizontal scaling and load balancing need no sticky sessions.
* Behavior-preserving database upgrade scripts for MySQL, PostgreSQL and
  Oracle.
* Database-free regression test suite under `test/` (authorization, capability
  matrix, menus, online-users guard).

## 14. Technology and licensing

* **PHP** web application using **MySQL / PostgreSQL / Oracle** and any modern
  web server (Apache or Nginx).
* Third-party components bundled for convenience: PHPMailer, TCPDF, phpCAS,
  a RADIUS client, the DHTML Calendar and a JavaScript virtual keyboard
  (see README.md for authors and licenses).
* TCExam is free open-source software distributed under the **GNU-AGPLv3**
  license (see LICENSE.TXT).
