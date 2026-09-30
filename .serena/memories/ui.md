# Theme / styling system

## How a theme is selected
`K_ADMIN_THEME` (admin, in `admin/config/tce_config.php`) and `K_PUBLIC_THEME` (public, in `public/config/tce_config.php`) drive three things:
1. Stylesheet URL: `K_TCEXAM_STYLE = K_PATH_STYLE_SHEETS.<theme>.css` and `K_TCEXAM_STYLE_RTL = ...<theme>_rtl.css` (same for `K_SITE_STYLE*` in the public area). The XHTML header picks LTR/RTL from `$l['a_meta_dir']` and appends `?v=<filemtime>` of the resolved file for cache-busting (`admin|public/code/tce_xhtml_header.php`).
2. Footer include: `include('../config/theme/<theme>.php')` (`admin|public/code/tce_page_footer.php`). A missing include warns, so every theme name needs `admin/config/theme/<name>.php` and `public/config/theme/<name>.php`.
3. `K_PATH_STYLE_SHEETS` is `'../styles/'` (relative to `*/code/`).

## What is tracked
`admin/styles/` and `public/styles/` are **tracked**; `admin/config/*` and `public/config/*` are **gitignored** (except `tce_auth.php`). So stylesheets commit, but the theme constants and `config/theme/*.php` includes are local to each install (this is also true of the pre-existing `default` theme).

## Themes
- `default` — original theme plus a hand-rolled "Modern default theme refinements" layer appended to `admin|public/styles/default.css` (green `#69bf70` / orange `#f9a34c`, literal hex, ~2 duplicated layers per file). Untouched / fallback.
- `exam` — added 2026-09-23. Blue/indigo design-token theme. Per area it is three tracked files:
  - `exam.css` / `exam_rtl.css` — entry points that `@import "default.css"` / `"default_rtl.css"` then `@import "exam-core.css?v=1"`.
  - `exam-core.css` — all `--tce-*` tokens + component overrides (header, menu, buttons, forms, tables, messages, exam answer options, results, vendor accents). Uses logical properties (`margin-inline-*`, `border-inline-start`, `text-align: start/end`), so one core serves LTR and RTL.
  - `admin|public/config/theme/exam.php` — empty-by-design include so the theme resolves in the footer.
- `picoman` (public only) — vendored Pico.css-based mobile theme (`public/styles/picoman.css`).

## Gotchas
- The `admin|public/code/tce_xhtml_header.php` stylesheets loader (added 2026-09-25) reads the theme entry css, extracts its `@import` targets and emits a direct `<link rel="stylesheet">` per file (same order, each with its own `?v=<mtime>`), so all layers are fetched in parallel - no flash of unstyled header. Entries without `@import` (picoman) or unreadable/broken references fall back to linking the entry itself. `exam-core.css` is therefore cache-busted automatically: no manual `?v=` bumping anymore.
- `exam-core.css` overrides rely on load order (linked after `default.css`) and matching selectors; `default`'s `.disabled*` rules use `!important` and are countered in kind.

## Chrome conventions (2026-09-25)
- Header brand title renders `K_TCEXAM_TITLE` (admin) / `K_SITE_TITLE` (public) - per-install brand, set to 'EEU Exam' in this deployment's config files; no hardcoded title in code.
- Locked checkboxes use the real `disabled` attribute (`getFormRowCheckBox` + the capability checkboxes in `tce_edit_user.php`); the helper's hidden field keeps submitting the frozen value.
- Form section dividers use `getFormRowVertDiv($title)` -> `.rowtitle` class (rule in all four base stylesheets), no inline styles.
- Integrity markers (base64 `K_KEY_SECURITY` copyright in meta description + footer comment, `<!-- Exam19730104 -->` head comment) are intentional and documented in code comments.
- `meta name="author"` comes from `K_TCEXAM_AUTHOR`/`K_SITE_AUTHOR`; the `tcexam_level` meta was removed.
- Skip navigation: `#topofdoc`, `#menusection`, `#timersection` anchors are live (id only, no `name=`).
- The installer (`install/install.php`) hardcodes `admin/styles/default.css`; it is one-time and pre-auth, left alone.
