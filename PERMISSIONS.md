# TCExam — Capabilities, Ranks and Permissions

This document describes how TCExam decides **who can open which page**, **who can
change what**, and **who can see whose data**.

The published documentation on http://www.tcexam.org remains the general
reference; this file documents the authorization model as implemented here.

## 1. The model

Authorization is built from an independent **capability mask** plus an
orthogonal **rank**. Capabilities answer "what may this account do?";
the rank answers "which accounts may it manage?".

| Axis | Question it answers | Enforced by |
| --- | --- | --- |
| **Page access** | May I open this page at all? | `$pageperm` (capability bitmask) compared with `F_user_can_any()` in `shared/code/tce_authorization.php`; the public area keeps the `$pagelevel` threshold |
| **Edit vs read-only** | May I modify the records I can see? | `F_is_readonly_content()` inside the content editors (`! F_user_can(K_PERM_EDIT_CONTENT)`) |
| **Row-level visibility** | Which records/users are visible to me? | `F_user_can(K_PERM_GLOBAL_VIEW)` plus group sharing (`F_isAuthorizedUser()`, `F_getAuthorizedUsers()`) |
| **Modify authority** | May I change a record I can see? | `F_isAuthorizedToModify()` and friends (`F_user_can(K_PERM_ADMIN)` instead of the visibility bypass) |
| **Rank** | Which accounts may I manage? | numeric `user_level` comparisons (`user_level < own`, "target must be lower rank") |

**Capabilities are independent**: granting a higher capability never includes
a lower one. An OPERATOR-only account cannot open the content editors; an
ADMIN-only account cannot open any page except the system update, the owner
reassignment selects and the file-manager root. The numeric rank grants no
page and no data access whatsoever.

## 2. The capabilities

The capabilities are bits of the `tce_users.user_perms` integer, defined in
`shared/code/tce_auth_caps.php` (loaded for both areas, not configurable per
installation):

| Bit | Constant | Grants |
| --- | --- | --- |
| 1 | `K_PERM_VIEW_CONTENT` | open the content editors in **read-only** mode; TCEcode preview |
| 2 | `K_PERM_EDIT_CONTENT` | create/edit modules, subjects, questions, answers; media files; bulk question import; file manager |
| 4 | `K_PERM_OPERATOR` | author tests, view/export results, rate free-text answers, import OMR, SSL certificates, online users, question list |
| 8 | `K_PERM_MANAGE_IDENTITY` | create/edit/delete users and groups, group membership, user import/export |
| 16 | `K_PERM_GLOBAL_VIEW` | see the data of **every** group |
| 32 | `K_PERM_BACKUP` | run backups |
| 64 | `K_PERM_ADMIN` | system update; reassign record owners; file-manager root; grant any capability |

`K_PERM_ALL` (127) is the mask of every capability. A mask of 0 means the
account has no administrative capability at all: it can only take tests in
the public area.

The user editor renders one checkbox per capability. An editor may only
grant capabilities it holds itself; the capabilities it cannot grant are
preserved untouched on the edited account. Only `K_PERM_ADMIN` grants
everything.

The session stores the mask in `$_SESSION['session_user_perms']`. With
`K_CHECK_USER_PER_REQUEST` (default true) the rank and the mask are re-read
from the database at every request, so grants, demotions and account removals
take effect immediately; sessions created before the upgrade derive the mask
from their level through `F_cumulative_perms_for_level()`.

### Capability labels

`F_getCapabilityLabel($perm)` (in `shared/code/tce_auth_caps.php`) returns the
capability name for the editor checkboxes, using the `w_cap_*` language keys
when defined and otherwise falling back to the built-in English names, so the
label is always available even in installations whose language resources
predate the capabilities.

## 3. The ranks

The numeric `user_level` (0–10) no longer grants or withholds any capability.
It is used only for precedence:

* an identity administrator may only manage (see, edit, delete, list) users
  of a **lower rank** sharing one of its groups (`F_isAuthorizedUserRecord()`);
* the user lists and exports are filtered with `user_level < own`;
* a non-`K_PERM_ADMIN` editor cannot create or promote an account to a rank
  equal to or higher than its own, and cannot change its own rank or mask;
* `K_PERM_ADMIN` is exempt from every rank restriction.

| Rank | Constant-free value | Role (display only) |
| --- | --- | --- |
| 0 | — | anonymous user |
| 1 | — | registered user |
| 2–8 | — | free (legacy tier labels are kept for display) |
| 9 | — | site administrator (conventional) |
| 10 | `K_AUTH_ADMINISTRATOR` | maximum rank (conventional) |

`F_getUserLevelLabel($level, $with_number)` (in
`shared/code/tce_auth_tiers.php`) still names the levels for the rank
dropdown, the user list and the online-users table, using the `w_level_*`
language keys with built-in English fallbacks.

## 4. How page access is enforced

Every admin page declares the capabilities that grant access, then includes
the central authorization script:

```php
require_once('../config/tce_config.php');

$pageperm = K_PERM_OPERATOR;
require_once('../../shared/code/tce_authorization.php');
```

`tce_authorization.php` refuses the request when the user holds none of the
`$pageperm` bits: an anonymous user gets the login form, an authenticated
user without the capability gets an access-denied page. A `$pageperm` of 0
means "no capability required" (used by the emailed-results token path).
The admin menu (`admin/code/tce_page_menu.php`) uses the same constants, so a
menu entry appears exactly when the page behind it is reachable.

The public (test-taker) pages keep the legacy `$pagelevel` threshold
(`$_SESSION['session_user_level'] >= $pagelevel`), because they only separate
anonymous from registered users. `tce_page_info.php` is intentionally public
(level 0).

The anonymous user is stored as `user_id = 1` and is excluded from user lists
(`user_id > 1`).

## 5. Row-level visibility

### The visibility predicate

`F_isAuthorizedUser($table, $id_field, $id, $owner_field)` returns true when
**any** of these holds:

1. the user holds `K_PERM_GLOBAL_VIEW`, or
2. the user is the owner of the record, or
3. the record's owner is a real user (`owner_id > 1`) **and** shares at least one
   group with the current user.

`F_getAuthorizedUsers($user_id)` returns the comma-separated list of user IDs a
user may see: the user plus everyone sharing at least one group.
`F_visible_user_ids()` is the same helper, named for the visibility use case.

Group sharing is **symmetric and all-or-nothing**: if two users share any single
group, each can see and edit all of the other's content. There is no read-only
or per-record access control at the record level.

### Visibility vs privilege

`F_isAuthorizedUser()` answers "may I **see** this record?" and is used by the
read/export pages. Modifications are checked separately, because a
`K_PERM_GLOBAL_VIEW` user may inspect every group but must not change records
it does not own:

| Concern | Uses | Effect |
| --- | --- | --- |
| Seeing all groups' content, results, users, groups and files | `F_isAuthorizedUser()`, `F_isAuthorizedEditorForUser/Group()`, `F_user_can(K_PERM_GLOBAL_VIEW)` | owner, or a shared group, or `K_PERM_GLOBAL_VIEW` |
| Modifying a record | `F_isAuthorizedToModify()` | owner, or a shared group, or `K_PERM_ADMIN` |
| Modifying a user / a group | `F_isAuthorizedToModifyUser()`, `F_isAuthorizedToModifyGroup()` | self/own group, or lower rank with a shared group, or `K_PERM_ADMIN` |
| Seeing the **answer key** inside a result report | `F_canSeeAnswerKeys()` | owner of the subject the question belongs to, or a shared group, or `K_PERM_GLOBAL_VIEW` |
| Reassigning a record's owner; the file-manager root; system update; granting any capability | `K_PERM_ADMIN` | that capability only |

The modify helpers share the owner and group-sharing rules with the view
predicate, but replace the global-view bypass with the `K_PERM_ADMIN`
capability.

### Answer keys in the result reports

Being allowed to **read** a result report does not imply being allowed to read
the **correct answers**. `F_canSeeAnswerKeys($subject_id)` (in
`shared/code/tce_functions_authorization.php`) decides whether the correct
answers (and the question/answer explanations) of a question are rendered:
they belong to the question author, defined as the **owner of the subject the
question belongs to**, a user **sharing a group** with that owner, or a
`K_PERM_GLOBAL_VIEW` user. Everyone else - an operator who owns only the test,
and also the test-taker reading their own report - sees the question, the
answer options and **their own selections**, but no right/wrong mark, no
correct ordering position and no explanation.

* The rule is applied by every result renderer: the detailed HTML report
  (`F_printUserTestStat()`, used by the admin report and by the public
  "my results" page), the public results page
  (`public/code/tce_test_results.php`), the PDF report and its e-mailed
  attachment (`TCPDFEX::printUserTestDetails()`), and the per-answer counters
  of the question-statistics export (`tce_xml_question_stats.php`).
* Anonymous sessions never see the key: the e-mailed-results capability-token
  path (below) renders the report for an anonymous session, so the key is
  hidden there as well.
* The result is cached per subject for the lifetime of the request.
* Set `K_RESTRICT_ANSWER_KEYS` to `false` (in `shared/config/tce_config.php`)
  to restore the legacy behaviour, in which every report displayed the correct
  answers to whoever could open it. When the constant is missing the
  restriction is on.
* The printable paper-test generator (`tce_pdf_testgen.php`) still embeds the
  answer key as hidden text in the generated PDF (it is the working copy used
  to grade the scanned OMR sheets, and it is restricted to the test owner);
  it is part of the authoring pipeline, not a result report.

### Consequences per data type

| Data | Visibility rule |
| --- | --- |
| Modules, subjects, questions, answers, tests | owned by you or by a user sharing a group with you |
| Test results | a user without `K_PERM_GLOBAL_VIEW` can only request results for users who executed a test the user is authorized to see (`F_isAuthorizedResultUser()`); the data itself is filtered by the tests the user may see |
| Correct answers inside a result report | only the question author (`F_canSeeAnswerKeys()`), see above |
| Test-takers' results in the UI | the user and group filters list only the users within the current user's scope (rank + shared groups) |
| Users and groups | identity administrators see all; otherwise only lower-rank users sharing a group (`F_isAuthorizedEditorForUser()`), and only the user's own groups |
| Online users | only the users the current user is allowed to manage |
| Multimedia files | stored per user under `cache/uid/<user id>/`; a user reaches the directories of the users visible to them; the whole tree is reachable only with `K_PERM_ADMIN` |
| Students' own results | the public results page redirects unless the requested test-user record belongs to the session user |

## 6. Read-only access (VIEW without EDIT)

The four content editors (`tce_edit_module.php`, `tce_edit_subject.php`,
`tce_edit_question.php`, `tce_edit_answer.php`) open at
`K_PERM_VIEW_CONTENT`. When `F_is_readonly_content()` is true (the account
lacks `K_PERM_EDIT_CONTENT`) they:

* discard the submitted action, so no add/update/delete is performed even if a
  `menu_mode` value is posted directly;
* render the record without the update/add/delete/clear buttons.

Read-only mode applies to content authoring only. Test authoring (`tce_edit_test.php`)
and the user editors require their own capabilities.

## 7. Page reference

Capability required for each admin page.

**`K_PERM_ALL` (any administrative account)**

`index.php` (landing dashboard; section launchers displayed conditionally based on capabilities)

**`K_PERM_VIEW_CONTENT`**

`tce_menu_modules.php`, `tce_edit_module.php`, `tce_edit_subject.php`,
`tce_edit_question.php`, `tce_edit_answer.php`, `tce_preview_tcecode.php`,
`tce_colorpicker.php`

**`K_PERM_EDIT_CONTENT`**

`tce_import_questions.php`, `tce_filemanager.php`, `tce_select_mediafile.php`

**`K_PERM_OPERATOR`**

`tce_menu_tests.php`, `tce_edit_test.php`, `tce_select_tests.php`,
`tce_select_tests_popup.php`, `tce_pdf_testgen.php`, `tce_edit_rating.php`,
`tce_show_result_user.php`, `tce_show_result_allusers.php`,
`tce_tsv_result_allusers.php`, `tce_xml_results.php`,
`tce_xml_user_results.php`, `tce_email_results.php`,
`tce_xml_question_stats.php`, `tce_show_all_questions.php`,
`tce_xml_questions.php`, `tce_tsv_questions.php`, `tce_pdf_all_questions.php`,
`tce_popup_test_info.php`, `tce_edit_sslcerts.php`, `tce_show_online_users.php`,
`tce_import_omr_answers.php`, `tce_import_omr_bulk.php`;
`tce_pdf_results.php` drops to "no capability required" when a valid
emailed-results token is present

**`K_PERM_MANAGE_IDENTITY`**

`tce_menu_users.php`, `tce_edit_user.php`, `tce_select_users.php`,
`tce_select_users_popup.php`, `tce_edit_group.php`, `tce_import_users.php`,
`tce_tsv_users.php`, `tce_xml_users.php`

**`K_PERM_BACKUP`**

`tce_edit_backup.php`

**`K_PERM_ADMIN`**

`tce_update.php`

**Level 0 — anonymous**

`tce_page_info.php` uses `K_AUTH_ADMIN_INFO` (0) and is not linked from the menu.
It is intentionally reachable without logging in.

## 8. The public area

The public area is for test-takers and keeps the level thresholds of
`public/config/tce_auth.php` (all `1`, i.e. registered users). A registered
user executes the tests assigned to their groups, gated additionally by IP
range, SSL certificate and test access settings, and can only view their own
results. The admin link appears when the account holds **any** capability.

### Emailed results (capability token)

Result reports are sent by email with the PDF **attached**:
`tce_functions_email_reports.php` fetches `admin/code/tce_pdf_results.php`
server-side with an `email` parameter that acts as a capability token: a
password hash of the test-user id, test id, user id and issue time, seeded
with `K_RANDOM_SECURITY`. When the token is present and valid the page drops
to "no capability required", because the recipient is not required to log
in; the page then sets `noindex`/`private` caching headers. The token expires
after `K_RESULTS_LINK_TTL` seconds (default 30 days), so old attachments must
be re-sent; a request without a valid token falls back to the normal
`K_PERM_OPERATOR` check.

## 9. Where the values live

| File | Role |
| --- | --- |
| `shared/code/tce_auth_caps.php` | The capability bit constants, `F_user_can()`/`F_user_can_any()`, the legacy level-to-mask mapping and the capability labels. Version-controlled, loaded for both areas. |
| `shared/config/tce_config.php` | `K_CHECK_USER_PER_REQUEST` (refresh the rank and the mask at every request). |
| `admin/config/tce_auth.php` | The `K_PERM_*`-independent legacy constants, kept for backward compatibility (`K_AUTH_ADMINISTRATOR`, `K_AUTH_OPERATOR`, the legacy tier and page constants). Version-controlled. |
| `public/config/tce_auth.php` | Page levels for the public area (all `1`, i.e. registered users) and the legacy tier constants. Version-controlled. |
| `shared/code/tce_auth_tiers.php` | Legacy tier fallbacks and the rank labels (`F_getUserLevelLabel`). |

The other files under `admin/config/`, `public/config/` and `shared/config/`
are **not** version-controlled because they hold deployment-specific settings
and credentials (`tce_db_config.php`, `tce_email_config.php`, `tce_ldap.php`,
`tce_radius.php`, `tce_httpbasic.php`, `tce_cas.php`).

The alternate authentication methods (SSL, HTTP-BASIC, CAS, Shibboleth,
RADIUS, LDAP) provision accounts with the rank `K_*_USER_LEVEL` and the
capability mask `K_*_USER_PERMS` of their configuration files (default 0 =
no capability; when the constant is missing the mask is derived from the
configured rank).

## 10. Upgrading and migration

The upgrade to the capability model is **behavior-preserving**. The
`install/upgrade/*/*_db_upgrade_16to17.sql` scripts add the
`tce_users.user_perms` column and derive the initial mask from the current
level, so every account keeps exactly the rights it had:

```sql
UPDATE tce_users SET user_perms = CASE
    WHEN user_level >= 10 THEN 127
    WHEN user_level = 9 THEN 63
    WHEN user_level >= 6 THEN 15
    WHEN user_level >= 5 THEN 7
    WHEN user_level >= 3 THEN 3
    WHEN user_level = 2 THEN 1
    ELSE 0
END;
```

The legacy tier constants (`K_AUTH_VIEW_CONTENT`, `K_AUTH_EDIT_CONTENT`,
`K_AUTH_OPERATOR`, `K_AUTH_MANAGE_IDENTITY`, `K_AUTH_GLOBAL_VIEW`,
`K_AUTH_SITE_ADMIN`, `K_AUTH_ADMINISTRATOR` and the `K_AUTH_ADMIN_*` page
constants) are still defined for backward compatibility but are **not
referenced** by the shipped pages: the pages declare capabilities, and the
rank keeps only the precedence rules. Redistributing responsibilities is now
done per account from the user editor checkboxes, not by editing config
constants.

The XML user export/import carries the mask in a `<perms>` element; TSV files
keep their format and imported users get the mask derived from their rank.

See `UPGRADE.TXT` for the full notes.

## 11. Known limitations

* **A capability never implies another.** Granting `K_PERM_ADMIN` alone does
  not let the account open the content or users pages: grant every capability
  the account needs.
* **Group membership is edited from the user form**, so an identity
  administrator also assigns group membership. There is no separate
  group-membership right.
* **Content whose owner is the anonymous user (`user_id = 1`) is only visible
  to global-view users**, because the group-sharing rule requires a real owner.
* **Results belong to the test, not to a group.** Anyone authorized on a test
  can see the results of all its candidates, including candidates outside their
  own groups.
* **Global view is not global edit.** A `K_PERM_GLOBAL_VIEW` user sees every
  group's data but may modify only records owned by itself or by a user
  sharing one of its groups; modifying another user's record requires
  `K_PERM_ADMIN`.
* An editor without `K_PERM_ADMIN` cannot strip a capability it does not hold:
  those bits are preserved on the edited account (and its own mask is frozen).
* **The answer key follows the question author, not the test owner.** An
  operator who owns a test assembled from another author's questions can read
  the whole report but not the correct answers
  (see `F_canSeeAnswerKeys()` in section 5). Set `K_RESTRICT_ANSWER_KEYS` to
  `false` to restore the previous behaviour.
* **The printed paper test still embeds the key** as hidden text
  (`tce_pdf_testgen.php`), because it doubles as the OMR grading key; it is
  restricted to the test owner.

## 12. Verifying

The repository ships database-free regression tests:

```powershell
php test/menu_authorization.php
php test/authorization_tiers.php
php test/modify_authority.php
php test/capability_matrix.php
php test/answer_key_visibility.php
php test/answer_key_visibility.php disabled
php test/online_users_tracker_rows.php
```

They check the menu visibility per capability mask and per legacy level, that
the capabilities are distinct bits that never include one another, that the
visibility/read-only/modify helpers agree with the masks, that the content
editors keep their read-only guard, that only `K_PERM_ADMIN` modifies other
users' records, that the answer key is hidden from non-authors and anonymous
sessions (and visible when `K_RESTRICT_ANSWER_KEYS` is off), that every admin
page declares `$pageperm`, and that the emailed-results token validates only
within its time to live, with the database functions stubbed. `test/README.md`
lists the equivalent browser checks to run against a non-production database
with accounts at each capability combination.
