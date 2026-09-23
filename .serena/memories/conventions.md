# Code conventions

## PHP
- Procedural style; **every shared function is prefixed `F_`** (e.g. `F_db_query`, `F_print_error`, `F_escape_sql`, `F_getUserLevelLabel`). Multiple unrelated helpers live in large files like `shared/code/tce_functions_general.php`.
- Docblocks use `/** ... */` with `@package`/`@author`/`@since`; files start with a banner comment (`// File name`, `// Begin`, `// Description`, copyright, `// END OF FILE`).
- Constants: `K_*` prefix, defined with `define()`. Tiers/auth: `K_AUTH_*`. Tables: `K_TABLE_*`. Paths: `K_PATH_*`. Level labels use `F_getUserLevelLabel()`.
- `K_NEWLINE` is used at end of echoed HTML lines instead of `"\n"`.
- Comparisons for level checks use `>=` against a `K_AUTH_*` tier constant, never a bare number. See `mem:auth`.
- Request handling: pages read globals created by the `$_POST` extraction loop at the bottom of `shared/config/tce_config.php` (keys are sanitized to lowercase `[a-z0-9_\[\]]`; keys starting with `_` or an uppercase letter are skipped). `$_REQUEST`/`$_SESSION`/`$_COOKIE` are accessed directly.
- Include order is config-first; **authorization must be required before any output** and after `$pagelevel` is set.

## Style / formatting
- Indentation: **4 spaces**. Entry `if (...)` conditions use the TCExam style with `and`/`or` keywords.
- Recent commits followed a conventional-commit style (`feat:`, `fix:`, `style:`, `chore(i18n):`); CHANGELOG.TXT entries are tab-indented bullets.
- No comments unless they add non-obvious value; user-facing text belongs in the language resources, not hardcoded.

## DB / SQL
- Table/field names come from `K_TABLE_*` constants and snake_case columns.
- Escape all interpolated values with `F_escape_sql($db, $value)`; use `F_empty_to_null()` / `F_zero_to_null()` for nullable columns.
- The anonymous user is `user_id = 1` and must be excluded from user listings (`user_id > 1`).
- `K_TABLE_SESSIONS` doubles as a brute-force attempt store (rows keyed by client fingerprint).

## Output / i18n
- All user-facing strings must come from the `$l` array (TMX resources); never hardcode English in PHP/HTML. See `mem:i18n`.
- XHTML 1.0 Strict + UTF-8; escape with `htmlspecialchars(..., ENT_NOQUOTES, $l['a_meta_charset'])`.
