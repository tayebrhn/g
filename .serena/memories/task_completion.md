# Definition of done / verification

There is no linter, formatter, or PHPUnit suite configured in this checkout. Verify by:

1. **Syntax-check every edited PHP file:**
   ```powershell
   php -l <changed-file>.php
   ```
2. **Run the DB-free regression tests** (they must pass and need no database):
   ```powershell
   php test/menu_authorization.php
   php test/authorization_tiers.php
   php test/modify_authority.php
   php test/capability_matrix.php
   php test/online_users_tracker_rows.php
   ```
   `menu_authorization.php` checks admin menu visibility per capability mask and per legacy level; `authorization_tiers.php` checks the capability bits, the visibility/read-only helpers, the editors' read-only guard and that mutating pages use the `F_isAuthorizedToModify*()` predicates; `modify_authority.php` stubs the DB and checks the modify predicates (owner/shared-group/K_PERM_ADMIN; GLOBAL_VIEW view-only even at rank 10) plus the emailed-results token TTL; `capability_matrix.php` checks the level→mask mapping, the all-of/any-of semantics, every admin page's `$pageperm` and the menu capability validity; `online_users_tracker_rows.php` checks the online-users visibility guard.
3. **For authorization changes**, also read `PERMISSIONS.md` and keep it in sync; the capability constants live in `shared/code/tce_auth_caps.php`, the rank labels in `shared/code/tce_auth_tiers.php`, the page gates in each admin page's `$pageperm` and `admin/code/tce_page_menu.php` — update them and the test scripts together.
4. **For UI-text changes**, strings must be routed through the `$l` resources; keep within the `UX_CONTENT_AUDIT.md` glossary/style rules (sentence case, verb-first buttons, no ALL CAPS, no internals in user copy).
5. **For DB-related changes**, there is no automated migration runner; schema files under `install/` are the reference. Do not assume a live DB is available to the agent.

If the user provides a different lint/test command, record it here.
