# Configuration layers

Config is layered and include-order-sensitive. Pages start at their own area's `tce_config.php`, which pulls in `tce_auth.php` (area-local) then the shared config.

## Include chain
- Admin page: `admin/config/tce_config.php` -> `admin/config/tce_auth.php` + `shared/config/tce_config.php`. Then `shared/config/tce_db_config.php`, `shared/code/tce_db_connect.php`, `shared/code/tce_functions_general.php`, and PHP `ini_set`s.
- Public page: `public/config/tce_config.php` -> `public/config/tce_auth.php` + `shared/config/tce_config.php`; then DB config/connect + general functions.
- `shared/config/tce_config.php` -> `tce_paths.php`, `tce_general_constants.php`, `tce_functions_errmsg.php`, `tce_tmx.php`; instantiates `TMXResourceBundle` into `$l`; runs the `$_POST` extraction loop.

## What is version-controlled (important)
`.gitignore` ignores `admin/config/*`, `public/config/*`, and **all of `shared/config/`**, with exceptions:
- **Tracked:** `admin/config/tce_auth.php`, `public/config/tce_auth.php` (the AUTHORIZATION TIERS block).
- **NOT tracked (deployment-local):** everything else under `shared/config/` (including `tce_config.php`, `tce_paths.php`, `tce_db_config.php`, `tce_general_constants.php`, `tce_email_config.php`, `tce_ldap.php`, `tce_radius.php`, `tce_httpbasic.php`, `tce_cas.php`, `tce_ssl.php`, `tce_shibboleth.php`, `tce_user_registration.php`, `tce_pdf.php`, `tce_latex.php`, `tce_mime.php`), plus `admin/config/tce_config.php` and `public/config/tce_config.php`.
- Consequence: editing a tracked config is permanent; editing an untracked one affects only this install. Check `git ls-files` before assuming a config file is committed.

## Local values observed (this machine)
- `K_PATH_HOST='http://localhost:8080'`, `K_PATH_TCEXAM='/tcexam/'`, `K_PATH_MAIN='C:/Apache24/htdocs/tcexam/'`, `K_STANDARD_PORT=80`.
- DB: MYSQL, host `localhost`, port 3306, db `tcexam`, table prefix `tce_`.
- Language: only `en` available; `K_USER_LANG` resolved from `?lang=`/`SessionUserLang` cookie/`K_LANGUAGE`.

## Themes
- `K_ADMIN_THEME` / `K_PUBLIC_THEME` (`admin|public/config/theme/<name>.php`, stylesheets at `admin|public/styles/<name>.css` + `_rtl.css`). Currently `exam`. See `mem:ui` for the full theme system.
