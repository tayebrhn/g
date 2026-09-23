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
   ```
   `menu_authorization.php` checks admin menu visibility and page-level guards per user level; `authorization_tiers.php` checks the tier ladder ordering, visibility/read-only helpers, and that content editors keep their read-only guard.
3. **For authorization changes**, also read `PERMISSIONS.md` and keep it in sync; when changing levels/tiers update `admin/config/tce_auth.php`, `public/config/tce_auth.php`, `shared/code/tce_auth_tiers.php`, `admin/code/tce_page_menu.php`, and the relevant test scripts together.
4. **For UI-text changes**, strings must be routed through the `$l` resources; keep within the `UX_CONTENT_AUDIT.md` glossary/style rules (sentence case, verb-first buttons, no ALL CAPS, no internals in user copy).
5. **For DB-related changes**, there is no automated migration runner; schema files under `install/` are the reference. Do not assume a live DB is available to the agent.

If the user provides a different lint/test command, record it here.
