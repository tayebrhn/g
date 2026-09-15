# Local authorization checks

Run the database-free authorization regression tests from the repository root:

```powershell
php test/menu_authorization.php
php test/authorization_tiers.php
```

`menu_authorization.php` verifies the Users, Modules, and Tests landing-page menus at access levels 0, 1, 2, 3, 5, 6, 9, and 10 using the production menu definitions. `authorization_tiers.php` verifies that the tier ladder is ordered, that the visibility/read-only helpers match the tiers on every level, and that the content editors cannot be modified at the read-only tier. Neither test creates accounts, authenticates, or modifies the database.

The admin PDF/XML export endpoints are also required to pass their configured page-level authorization checks; direct anonymous requests must receive the authentication page.

For a browser-based local check, use a non-production database and create separate accounts with levels 1, 2, 3, 5, 6, 9, and 10. Verify that:

- level 1 cannot access the admin landing pages;
- level 2 opens the Modules editors without any update/add/delete button and rejects a forced `menu_mode` submission;
- level 3 additionally reaches the question importer and the file manager;
- level 5 reaches Modules and Tests only, and no longer lists out-of-scope users in the results filters;
- level 6 reaches the Users section but only the users of the same groups with a lower level;
- level 9 and 10 reach everything, level 9 without the system update page.

Do not use default or shared credentials.
