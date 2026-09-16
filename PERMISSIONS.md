# TCExam — User Levels and Permissions

This document describes how TCExam decides **who can open which page**, **who can
change what**, and **who can see whose data**.

The published documentation on http://www.tcexam.org remains the general
reference; this file documents the authorization model as implemented here.

## 1. The three axes

Authorization is enforced by three independent mechanisms. Changing one does not
change the others:

| Axis | Question it answers | Enforced by |
| --- | --- | --- |
| **Page access** | May I open this page at all? | `$pagelevel` compared to `$_SESSION['session_user_level']` in `shared/code/tce_authorization.php` |
| **Edit vs read-only** | May I modify the records I can see? | `F_is_readonly_content()` inside the content editors |
| **Row-level visibility** | Which records/users are visible to me? | `F_has_global_view()` plus group sharing (`F_isAuthorizedUser()`, `F_getAuthorizedUsers()`, `F_select_*_sql()`) |

## 2. The levels

Levels are integers stored in `tce_users.user_level` and copied into the session
at login. Thresholds are compared with `>=`, so **each level inherits all the
powers of the levels below it**.

| Level | Role | Constant | Adds |
| --- | --- | --- | --- |
| 0 | anonymous | — | public area: browse tests |
| 1 | registered user | — | execute tests, view **own** results |
| 2 | viewer | `K_AUTH_VIEW_CONTENT` | open the content editors in **read-only** mode; TCEcode preview |
| 3 | content author | `K_AUTH_EDIT_CONTENT` | create/edit modules, subjects, questions, answers; media files; bulk question import |
| 4 | *unused* | — | — |
| 5 | examiner / operator | `K_AUTH_OPERATOR` | author tests, view/export results, rate free-text answers, import OMR, SSL certificates, online users |
| 6 | identity administrator | `K_AUTH_MANAGE_IDENTITY` | create/edit/delete users and groups, group membership, user import/export |
| 7, 8 | *unused* | — | — |
| 9 | site administrator | `K_AUTH_GLOBAL_VIEW`, `K_AUTH_SITE_ADMIN` | see the data of **every** group; backups |
| 10 | administrator | `K_AUTH_ADMINISTRATOR` | system update; reassign record owners; unrestricted level assignment |

Levels 4, 7 and 8 are deliberately unassigned. Assigning them has no effect
distinct from the level below.

Because the ladder is cumulative, a "read everything but change nothing" role
cannot be expressed above level 2: any level high enough to see everything is
also high enough to change something. Genuinely orthogonal roles would require a
separate flag rather than a level.

### Level labels

The user editor (`tce_edit_user.php`) renders the level dropdown as
`<number> - <role name>` — for example `3 - content author` — and names the
unassigned levels `unused`, so an administrator cannot mistake them for a real
duty. The submitted value remains the plain number. The same label is used in
the user list and its popup (`tce_functions_user_select.php`) and in the
online-users table (`tce_functions_users_online.php`); the exports stay numeric.

`F_getUserLevelLabel($level, $with_number)` (in `shared/code/tce_auth_tiers.php`)
returns the name, prefixing it with the level number when `$with_number` is
true. It uses the `w_level_*` language keys when they are defined and otherwise
falls back to the built-in English names, so the label is always available even
in installations whose language resources predate the tiers. Levels without an
assigned responsibility are named `unused`, and an unknown level falls back to
its number so the result is never empty. The label is HTML-escaped at the point
of rendering.

| Level | Language key | Built-in name |
| --- | --- | --- |
| 0 | `w_level_anonymous` | anonymous |
| 1 | `w_level_registered` | registered user |
| 2 | `w_level_viewer` | viewer (read-only) |
| 3 | `w_level_author` | content author |
| 4, 7, 8 | `w_level_unused` | unused |
| 5 | `w_level_examiner` | examiner |
| 6 | `w_level_identity` | identity administrator |
| 9 | `w_level_siteadmin` | site administrator |
| 10 | `w_level_admin` | administrator |

To translate the labels, add these keys to the language resources
(`shared/config/lang/language_tmx.xml` and the other language files — note that
the TMX sources are not version-controlled). Any key that is missing or empty
falls back to the built-in name.

## 3. Where the levels are configured

| File | Role |
| --- | --- |
| `admin/config/tce_auth.php` | The `AUTHORIZATION TIERS` block sets the numeric value of each tier. Version-controlled. |
| `shared/code/tce_auth_tiers.php` | Defines the tier *names* and their fallback defaults, and documents the ladder. Loaded for both the admin and public areas via `shared/code/tce_functions_general.php`. |
| `public/config/tce_auth.php` | Page levels for the public area (all `1`, i.e. registered users). Version-controlled. |

The other files under `admin/config/`, `public/config/` and `shared/config/`
are **not** version-controlled because they hold deployment-specific settings
and credentials (`tce_db_config.php`, `tce_email_config.php`, `tce_ldap.php`,
`tce_radius.php`, `tce_httpbasic.php`, `tce_cas.php`).

To redistribute responsibilities, change the tier values in
`admin/config/tce_auth.php`. Installation configurations that predate the tiers
fall back to the defaults in `shared/code/tce_auth_tiers.php`, which reproduce
the behaviour that existed before the tiers were introduced — so upgrading the
code alone never widens anyone's rights.

The older `K_AUTH_ADMIN_*` constants (e.g. `K_AUTH_ADMIN_USERS`,
`K_AUTH_ADMIN_QUESTIONS`, `K_AUTH_BACKUP`) are still defined for compatibility
but are no longer referenced by the pages, which use the tier constants.

## 4. How page access is enforced

Every admin page declares the minimum level required to open it, then includes
the central authorization script:

```php
require_once('../config/tce_config.php');

$pagelevel = K_AUTH_VIEW_CONTENT;
require_once('../../shared/code/tce_authorization.php');
```

`tce_authorization.php` refuses the request when
`$_SESSION['session_user_level'] < $pagelevel`. The admin menu
(`admin/code/tce_page_menu.php`) uses the same values, so a menu entry appears
exactly when the page behind it is reachable.

The anonymous user is stored as `user_id = 1` and is excluded from user lists
(`user_id > 1`).

## 5. Row-level visibility

### The visibility predicate

`F_isAuthorizedUser($table, $id_field, $id, $owner_field)` returns true when
**any** of these holds:

1. the user has global view (`F_has_global_view()`, level ≥ 9), or
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

Several checks used to be written as `>= K_AUTH_ADMINISTRATOR`, which conflated
"sees everything" with "may do anything". They are now split:

| Concern | Uses | Effect |
| --- | --- | --- |
| Seeing all groups' content, results, users, groups and files | `F_has_global_view()` | level ≥ 9 (global view) |
| Reassigning a record's owner; assigning any user level; the file-manager root; system update | `>= K_AUTH_ADMINISTRATOR` | level 10 only |

### Consequences per data type

| Data | Visibility rule |
| --- | --- |
| Modules, subjects, questions, answers, tests | owned by you or by a user sharing a group with you |
| Test results | a non-administrator can only request results for users who executed a test that the user is authorized to see (`F_isAuthorizedResultUser()`); the data itself is filtered by the tests the user may see |
| Test-takers' results in the UI | the user and group filters list only the users within the current user's scope |
| Users and groups | administrators see all; otherwise only lower-level users sharing a group (`F_isAuthorizedEditorForUser()`), and only the user's own groups |
| Online users | only the users the current user is allowed to manage |
| Multimedia files | stored per user under `cache/uid/<user id>/`; a user reaches the directories of the users visible to them |
| Students' own results | the public results page redirects unless the requested test-user record belongs to the session user |

## 6. Read-only access (level 2)

The four content editors (`tce_edit_module.php`, `tce_edit_subject.php`,
`tce_edit_question.php`, `tce_edit_answer.php`) open at `K_AUTH_VIEW_CONTENT`.
When `F_is_readonly_content()` is true (level below `K_AUTH_EDIT_CONTENT`) they:

* discard the submitted action, so no add/update/delete is performed even if a
  `menu_mode` value is posted directly;
* render the record without the update/add/delete/clear buttons.

Read-only mode applies to content authoring only. Test authoring (`tce_edit_test.php`)
and the user editors remain unavailable below their own tiers.

## 7. Page reference

Minimum level for each admin page, grouped by tier.

**Level 2 — `K_AUTH_VIEW_CONTENT`**

`tce_menu_modules.php`, `tce_edit_module.php`, `tce_edit_subject.php`,
`tce_edit_question.php`, `tce_edit_answer.php`, `tce_preview_tcecode.php`

**Level 3 — `K_AUTH_EDIT_CONTENT`**

`tce_import_questions.php`, `tce_filemanager.php`, `tce_select_mediafile.php`

**Level 5 — `K_AUTH_OPERATOR`** (also `K_AUTH_INDEX`)

`index.php`, `tce_menu_tests.php`, `tce_edit_test.php`, `tce_select_tests.php`,
`tce_select_tests_popup.php`, `tce_pdf_testgen.php`, `tce_edit_rating.php`,
`tce_show_result_user.php`, `tce_show_result_allusers.php`,
`tce_tsv_result_allusers.php`, `tce_xml_results.php`,
`tce_xml_user_results.php`, `tce_email_results.php`,
`tce_xml_question_stats.php`, `tce_show_all_questions.php`,
`tce_xml_questions.php`, `tce_tsv_questions.php`, `tce_pdf_all_questions.php`,
`tce_popup_test_info.php`, `tce_edit_sslcerts.php`, `tce_show_online_users.php`,
`tce_import_omr_answers.php`, `tce_import_omr_bulk.php`

**Level 6 — `K_AUTH_MANAGE_IDENTITY`**

`tce_menu_users.php`, `tce_edit_user.php`, `tce_select_users.php`,
`tce_select_users_popup.php`, `tce_edit_group.php`, `tce_import_users.php`,
`tce_tsv_users.php`, `tce_xml_users.php`

**Level 9 — `K_AUTH_SITE_ADMIN`**

`tce_edit_backup.php`

**Level 10 — `K_AUTH_ADMINISTRATOR`**

`tce_update.php`

`tce_page_info.php` uses `K_AUTH_ADMIN_INFO` (0) but is not linked from the menu.

## 8. The public area

The public area is for test-takers. Levels 0, 1, 2 and above may all reach it
(`public/config/tce_auth.php`). A registered user executes the tests assigned to
their groups, gated additionally by IP range, SSL certificate and test access
settings, and can only view their own results. The admin link appears from level
`K_ADMIN_LINK` (5).

## 9. Upgrading and migration

Levels 2–4 previously behaved exactly like level 1, and levels 6–9 exactly like
level 5. Accounts holding those levels therefore change behaviour on upgrade.

Audit them and reset to preserve the previous behaviour, then re-grant the new
roles explicitly:

```sql
UPDATE tce_users SET user_level = 5 WHERE user_level BETWEEN 6 AND 9;
UPDATE tce_users SET user_level = 1 WHERE user_level BETWEEN 2 AND 4;
```

See `UPGRADE.TXT` for the full notes.

## 10. Known limitations

* **Level changes take effect at the next login.** `session_user_level` is
  written when the session is created and is not re-read from `tce_users`
  afterwards, and the session expiry slides on every request. Demoting,
  disabling or deleting an account does not terminate an active session.
* **Group membership is edited from the user form**, so an identity
  administrator also assigns group membership. There is no separate
  group-membership right.
* **Content whose owner is the anonymous user (`user_id = 1`) is only visible to
  global-view users**, because the group-sharing rule requires a real owner.
* **Results belong to the test, not to a group.** Anyone authorized on a test
  can see the results of all its candidates, including candidates outside their
  own groups.
* The `K_AUTH_ADMIN_*` constants are retained but unused; editing them no longer
  changes anything.

## 11. Verifying

The repository ships database-free regression tests:

```powershell
php test/menu_authorization.php
php test/authorization_tiers.php
```

They check the menu visibility per level, that the ladder is correctly ordered,
that the visibility/read-only helpers agree with the tiers, and that the content
editors keep their read-only guard. `test/README.md` lists the equivalent
browser checks to run against a non-production database with accounts at each
level.
