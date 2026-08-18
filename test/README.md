# Local authorization checks

Run the database-free menu authorization regression test from the repository root:

```powershell
php test/menu_authorization.php
```

It verifies the Users, Modules, and Tests landing-page menus at access levels 0, 5, and 10 using the production menu definitions. It does not create accounts, authenticate, or modify the database.

The admin PDF/XML export endpoints are also required to pass their configured page-level authorization checks; direct anonymous requests must receive the authentication page.

For a browser-based local check, use a non-production database and create separate accounts with levels 1, 5, and 10. Verify that level 1 cannot access the admin landing pages, level 5 can access Modules and Tests only, and level 10 can access all three. Do not use default or shared credentials.
