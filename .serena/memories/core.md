# TCExam — core map

TCExam is a LAMP web app (Computer-Based Assessment / online exams). No framework, no package manager, no autoloader: plain PHP files with global `F_*` functions, included via **relative paths**.

## Entry points / areas
- `index.php` -> `header('Location: public/code/index.php')`.
- `public/code/` — candidate area (take tests, own results, registration, password reset).
- `admin/code/` — admin area (`index.php` is the dashboard).
- `shared/code/` — shared libraries used by both areas.
- `shared/config/`, `admin/config/`, `public/config/` — configuration.
- `install/` — one-time web installer + DB schema (`install/mysql_db_structure.sql`, `oracle_...`, `postgresql_...`) and `db_data.sql`.
- `test/` — DB-free PHP regression scripts (see `mem:task_completion`).
- `cache/` — per-user media under `cache/uid/<user id>/`; also lang cache. Writable, gitignored.
- `fonts/`, `images/`, `shared/jscripts/`, `shared/tcpdf/`, `shared/phpmailer/`, `shared/cas/`, `shared/radius/` — assets / vendored third-party.

## Critical invariants
- **Relative includes.** Every page does `require_once('../config/tce_config.php')` and `require_once('../../shared/code/...')`. Scripts therefore assume the process CWD equals the script's directory; never rewrite these to absolute paths or run pages from a different CWD.
- Page flow is: config -> global constants -> DB connect -> `require_once('../../shared/code/tce_authorization.php')` (with `$pagelevel` set) -> `tce_page_header.php` -> body -> `tce_page_footer.php`.
- All HTML output is **XHTML 1.0 Strict**, UTF-8, LTR/RTL aware (`$l['a_meta_dir']`). Escape with `htmlspecialchars($s, ENT_NOQUOTES, $l['a_meta_charset'])`.
- SQL is hand-built strings; escape values with `F_escape_sql($db, $v)` and run through `F_db_query($sql, $db)`; DB API is the DAL in `shared/code/tce_db_dal*.php` (function prefix `F_db_*`). Table names come from constants `K_TABLE_*` in `shared/config/tce_db_config.php` (prefix `K_TABLE_PREFIX`, default `tce_`).
- Layout is table-based; CSS lives in `admin/styles/` and `public/styles/`, selected by `K_ADMIN_THEME`/`K_PUBLIC_THEME`. See `mem:ui` for the theme system and the `exam` design-token theme.

## Where to look next
- Authorization model (levels, tiers, row visibility, read-only): `mem:auth`.
- Configuration layers and what is version-controlled: `mem:config`.
- Language/TMX strings and UI-text conventions: `mem:i18n`.
- Code style / naming / DB / output conventions: `mem:conventions`.
- Build/test/lint commands and definition of done: `mem:suggested_commands`, `mem:task_completion`.
- Runtime/tooling versions: `mem:tech_stack`.
