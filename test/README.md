# Local authorization checks

Run the database-free authorization regression tests from the repository root:

```powershell
php test/menu_authorization.php
php test/authorization_tiers.php
php test/modify_authority.php
php test/capability_matrix.php
php test/online_users_tracker_rows.php
```

`menu_authorization.php` verifies the Users, Modules, and Tests landing-page menus for the representative capability masks and for the legacy level fallback: a mask never includes another capability (an OPERATOR-only account sees no content editor, and an EDIT_CONTENT-only account does not unlock the read-only editors). `authorization_tiers.php` verifies that the capability constants are distinct bits, that the visibility/read-only helpers match the masks on every combination, that the content editors cannot be modified without the EDIT_CONTENT capability, and that every mutating page gates changes with the `F_isAuthorizedToModify*()` predicates. `modify_authority.php` stubs the database functions and verifies that the modify predicates accept owner / shared-group / K_PERM_ADMIN access, that a GLOBAL_VIEW user can see a record but not modify it (even at the maximum rank), and that the emailed-results capability token validates only within its time to live. `capability_matrix.php` verifies the legacy level-to-mask mapping, the all-of/any-of semantics of `F_user_can()`, that every admin page declares its capability in `$pageperm` and that the menu entries reference defined capabilities. `online_users_tracker_rows.php` verifies the online-users visibility guard. None of the tests creates accounts, authenticates, or modifies the database.

The admin PDF/XML export endpoints are also required to pass their configured page-level authorization checks; direct anonymous requests must receive the authentication page.

For a browser-based local check, use a non-production database, run the upgrade SQL first, and create separate accounts with the following capability masks (the rank can be set freely, it grants no right). Verify that:

- an account without capabilities reaches no admin page and sees no admin link in the public area;
- VIEW_CONTENT only opens the Modules editors without any update/add/delete button and rejects a forced `menu_mode` submission;
- EDIT_CONTENT only reaches the question importer and the file manager but not the editors nor the question list;
- OPERATOR only reaches the Tests section and the question list, and nothing else;
- MANAGE_IDENTITY only reaches the Users section, and only lists the users of the same groups with a lower rank;
- GLOBAL_VIEW sees the data of every group in read mode, but the editors show no update/add/delete buttons on records it does not own and reject a forced `menu_mode` submission;
- BACKUP only reaches the backup page;
- ADMIN only reaches the system update page, the owner reassignment selects and the file-manager root; it does NOT open the content or users pages unless the matching capabilities are also granted;
- only an account holding a capability may grant it, and the capabilities of a user edited by a lesser administrator are preserved;
- removing a capability or an account takes effect on the current session immediately (no re-login required);
- migrating a level-based database preserves everyone's rights exactly (see UPGRADE.TXT).

Do not use default or shared credentials.
