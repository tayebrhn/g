# Authorization model

Full spec: `PERMISSIONS.md` (authoritative, keep in sync). Five axes: **page access**, **edit vs read-only**, **row-level visibility**, **modify authority**, **rank (precedence)**. Since 2026-09-24 the admin area is capability-based, **non-cumulative**: a higher capability never includes a lower one.

## Capabilities (page access + functional rights)
- `tce_users.user_perms` bitmask; bits defined in `shared/code/tce_auth_caps.php` (loaded for both areas via `tce_functions_general.php` and file-level requires in `tce_functions_authorization.php` / `tce_functions_menu.php`): `K_PERM_VIEW_CONTENT`(1), `K_PERM_EDIT_CONTENT`(2), `K_PERM_OPERATOR`(4), `K_PERM_MANAGE_IDENTITY`(8), `K_PERM_GLOBAL_VIEW`(16), `K_PERM_BACKUP`(32), `K_PERM_ADMIN`(64); `K_PERM_ALL` = 127.
- Admin pages declare `$pageperm = K_PERM_*` then include `tce_authorization.php`, which denies when `! F_user_can_any($pageperm)` (authenticated → access-denied page; anonymous → login form). `$pageperm = 0` = no capability required (emailed-results token path in `tce_pdf_results.php`).
- Public (test-taker) pages keep the `$pagelevel` numeric threshold; `tce_page_info.php` is level 0 by design.
- Menu `admin/code/tce_page_menu.php` uses `'perm' => K_PERM_*` keys; renderer `F_menu_link` checks `F_user_can_any()` when `perm` is set, else falls back to the `level` key (login/logout/public). Public menu shows the admin link when the mask is non-zero.

## Rank (user_level, 0-10)
- Grants **no** page/data access; only precedence: user-list filters `user_level < own` (SQL in edit_user/select/xml/tsv/omr importers), "target must be lower rank" in `F_isAuthorizedUserRecord`, grant ceilings in user editor/importers (`min(own - 1, …)`; `K_PERM_ADMIN` unrestricted), owner-candidate list (`user_level >= K_AUTH_ADMINISTRATOR`).

## Helpers (shared/code/tce_functions_authorization.php)
- `F_user_perms()` = `session_user_perms`, falling back to `F_cumulative_perms_for_level(session_user_level)` for pre-upgrade sessions (mapping: 2→1, 3→3, 5→7, 6→15, 9→63, 10→127, else 0).
- `F_user_can($perm)` = all bits held; `F_user_can_any($perm)` = any bit held.
- `F_is_readonly_content()` = `! F_user_can(K_PERM_EDIT_CONTENT)`; `F_has_global_view()` = `F_user_can(K_PERM_GLOBAL_VIEW)`.
- Visibility: `F_isAuthorizedUser()` → `F_isAuthorizedRecord(K_PERM_GLOBAL_VIEW, …)`: capability, or owner, or real-owner shared group. `F_getAuthorizedUsers()` / `F_visible_user_ids()`.
- Modify: `F_isAuthorizedToModify()` → `F_isAuthorizedRecord(K_PERM_ADMIN, …)` (new record `$id <= 0` always modifiable); `F_isAuthorizedToModifyUser/Group()` (admin/code/tce_functions_user_select.php) = self/own-group, or lower rank + shared group, or `K_PERM_ADMIN`.
- In-file gates: owner-reassign selects, file-manager root (`F_getAuthorizedDirs`), OMR importer scope and the `< K_AUTH_OPERATOR` upload/delete gates are `F_user_can(K_PERM_ADMIN|K_PERM_OPERATOR)` now.
- Key invariant: **GLOBAL_VIEW sees everything but only its own/shared-group records are modifiable; K_PERM_ADMIN alone opens no content page** — grant what the account needs.

## Session
- `session_user_perms` set at the 3 login paths in `tce_authorization.php` (with `?? F_cumulative_perms_for_level()` fallback for pre-migration DBs); per-request refresh block re-reads `SELECT *` from `tce_users` when `K_CHECK_USER_PER_REQUEST` (shared/config/tce_config.php, default true) — grants/demotions/deletions apply immediately; deleted user falls back to anonymous.
- SSL client-cert gate: applies to capability-gated admin pages and level-gated pages ≥ `K_AUTH_SSL_LEVEL`.

## User editor / provisioning
- `tce_edit_user.php`: capability checkboxes (`user_perms[]`), labels via `F_getCapabilityLabel` / `w_cap_*` TMX keys (+ `w_capabilities` heading). Grant rules: non-`K_PERM_ADMIN` editors may only grant capabilities they hold; bits they cannot grant are **preserved** on the target (`(new & own) | (current & ~own)`); own mask frozen. Update keeps current mask when the form omits the field.
- XML user import/export carries `<perms>` (default: derived from rank); TSV keeps its column format, mask derived from rank; same ceiling rules in `tce_import_users.php`.
- Alt-auth (SSL/HTTP-BASIC/CAS/Shibboleth/RADIUS/LDAP): `K_*_USER_PERMS` config constants (default 0; fallback cumulative-from-level) wired through `tce_altauth.php` and the provisioning INSERT.

## DB
- `user_perms` added to the 3 install structure SQLs + `db_data.sql` (admin seeded with 127); upgrade scripts `install/upgrade/{mysql,postgresql,oracle}/*_db_upgrade_16to17.sql` add the column and seed masks **behavior-preserving** (CASE mapping above). `K_AUTH_*` tier constants remain defined (legacy compat, marked LEGACY in the config files) but no shipped page references them.

## Emailed results token
- `F_getResultsToken()` / `F_checkResultsToken()` (password-hash over `r<testuser>|<test>|<user>|<ts>|K_RANDOM_SECURITY`; TTL `K_RESULTS_LINK_TTL` default 30 days). The PDF is fetched server-side from admin `tce_pdf_results.php` (`$pageperm 0` when `email` param present) and **attached** to the mail; noindex/no-store headers on the token path. Public `tce_pdf_results.php` has no pagelevel (0) and binds the token to the session user.

## Answer keys in the result reports (added 2026-09-24)
- `F_canSeeAnswerKeys($subject_id)` (shared/code/tce_functions_authorization.php), memoized per subject per request: the correct answers and the question/answer explanations inside a result report belong to the **question author** = owner of the question's SUBJECT (`F_isAuthorizedUser(K_TABLE_SUBJECTS, 'subject_id', $subject_id, 'subject_user_id')`), a group peer, or a `K_PERM_GLOBAL_VIEW` holder. Anonymous sessions (`session_user_id <= 1`, incl. the emailed-results token path) and unknown subjects fail closed.
- Switch `K_RESTRICT_ANSWER_KEYS` (shared/config(.default)/tce_config.php, default true; undefined = restricted). When false, whoever can open the report sees the key (legacy).
- Renderers that consult it and hide the marks when false: `F_printUserTestStat()` (test_stats; admin `tce_show_result_user.php` + public `tce_show_result_user.php`), the inline loop in `public/code/tce_test_results.php`, `TCPDFEX::printUserTestDetails()` (PDF + emailed attachment), and the per-answer `<correct>/<wrong>` counters of `admin/code/tce_xml_question_stats.php`. Hidden mode shows only the candidate's selections (neutral `onbox`/`offbox`), no star, no correct ordering position, no explanations. XML/JSON result exports carry no keys (already aggregate-only).
- Out of scope (authoring/OMR, test-owner gated): `tce_pdf_testgen.php` still embeds the key as hidden white text for OMR grading.
- Regression test: `php test/answer_key_visibility.php` and `... disabled` (source assertions require the renderers to call the helper).

## Known limitations
- Group sharing symmetric, all-or-nothing; results belong to the test, not the group; anonymous-owned (user_id 1) content visible only to GLOBAL_VIEW; a non-ADMIN editor cannot strip capabilities it does not hold (preserved instead).

## Regression tests (DB-free, from repo root)
`php test/menu_authorization.php` (menu per mask + legacy level fallback), `php test/authorization_tiers.php` (bits distinct, helpers vs masks, editor read-only guard, $pageperm assertions), `php test/modify_authority.php` (modify predicates per mask + token TTL + fallback), `php test/capability_matrix.php` (level→mask mapping, all-of/any-of semantics, every admin page's `$pageperm`, menu capability validity), `php test/online_users_tracker_rows.php`. `test/README.md` lists the browser checks with capability-mask accounts.
