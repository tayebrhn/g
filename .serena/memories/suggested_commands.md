# Suggested commands (Windows / PowerShell)

The shell is **PowerShell 5.1** (not cmd, not bash). `&&` is unavailable — chain with `;` or `if ($?) { ... }`.

## Run / verify
- PHP CLI is on PATH: `php -v` (observed 8.0.30).
- Lint a file: `php -l path\to\file.php`.
- Run the DB-free authorization regression tests (from repo root):
  ```powershell
  php test/menu_authorization.php
  php test/authorization_tiers.php
  ```
- Web server: `Get-Service Apache2.4`, `Start-Service Apache2.4`, `Restart-Service Apache2.4`.
- DB: `Get-Service MySQL57`. No project wrapper; use the `mysql` client directly if needed.

## Unix-vs-Windows equivalents
- No `grep`; use the Grep tool, or `Select-String` / `rg` if needed.
- No `ls`; `Get-ChildItem` (or the List/Glob tools).
- No `cat`; use the Read tool or `Get-Content`.
- `findstr` exists but prefer the Grep tool.

## Git
- Repo is on branch `main`; remote is `tecnickcom/tcexam`. Commit only when the user asks.
- `git status`, `git diff`, `git log --oneline` are safe and useful before editing.
