# Authorization model

Full spec: `PERMISSIONS.md` (authoritative, keep in sync). Three independent axes: **page access**, **edit vs read-only**, **row-level visibility**.

## Page access
- Each page sets `$pagelevel = K_AUTH_*` then `require_once('../../shared/code/tce_authorization.php')`.
- `tce_authorization.php` denies when `$_SESSION['session_user_level'] < $pagelevel` (strictly `<`; threshold semantics are `>=`). It also handles login, brute-force delay, SSL client-cert check (`K_AUTH_SSL_LEVEL`), and test-password.
- Menu `admin/code/tce_page_menu.php` uses the same constants, so a menu entry appears iff the page is reachable.
- Public area page levels are all `1` (`public/config/tce_auth.php`); admin link shown from `K_ADMIN_LINK` (5).

## Levels (cumulative ladder)
`0` anonymous · `1` registered · `2` `K_AUTH_VIEW_CONTENT` (read-only editors) · `3` `K_AUTH_EDIT_CONTENT` (author content/media/import) · `5` `K_AUTH_OPERATOR` (tests/results/OMR/SSL/online) · `6` `K_AUTH_MANAGE_IDENTITY` (users/groups) · `9` `K_AUTH_GLOBAL_VIEW` + `K_AUTH_SITE_ADMIN` (all-group visibility, backup) · `10` `K_AUTH_ADMINISTRATOR` (system update, reassign owners, any level). Levels **4, 7, 8 are intentionally unused**.

## Where values live
- Numeric values: `admin/config/tce_auth.php` (`K_AUTH_VIEW_CONTENT`, `K_AUTH_EDIT_CONTENT`, `K_AUTH_MANAGE_IDENTITY`, `K_AUTH_GLOBAL_VIEW`, `K_AUTH_SITE_ADMIN`, plus legacy `K_AUTH_ADMIN_*`).
- Fallback defaults + names: `shared/code/tce_auth_tiers.php` (defines each tier only `if (!defined(...))`, so install config wins). Defaults reproduce pre-tier behaviour so code-only upgrades never widen rights.
- Labels: `F_getUserLevelLabel($level, $with_number)` uses `w_level_*` keys with built-in English fallback; unassigned levels render `unused`; unknown level falls back to its number.
- `K_DATABASE_TYPE` and table constants: `shared/config/tce_db_config.php`.

## Row-level visibility
- `F_isAuthorizedUser($table, $id_field, $id, $owner_field)` true if: global view (level >= `K_AUTH_GLOBAL_VIEW`), or owner, or owner is a real user (`owner_id > 1`) sharing a group.
- `F_getAuthorizedUsers()` / `F_visible_user_ids()` return the visible user-id list. Group sharing is symmetric and all-or-nothing (no per-record ACL).
- `F_has_global_view()` = "sees all groups"; `>= K_AUTH_ADMINISTRATOR` = "may do anything". Do not conflate them (a historical bug that was fixed).
- `F_is_readonly_content()` gates the four content editors (`tce_edit_module|subject|question|answer.php`): below `K_AUTH_EDIT_CONTENT` they discard submitted actions and omit edit buttons.

## Known limitations
- Level changes only apply at next login (`session_user_level` is not re-read; sessions slide on every request).
- Content owned by anonymous user (id 1) is visible only to global-view users.
- Results belong to the test, not a group.

## Regression tests
`test/menu_authorization.php` and `test/authorization_tiers.php` (DB-free). `test/README.md` lists the equivalent browser checks.
