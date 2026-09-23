# Tech stack

- **Language:** PHP (procedural, global functions). `VERSION` = 16.6.1.
- **Runtime observed on this machine:** PHP 8.0.30 (ZTS, Windows). Upstream targets PHP 7+; some code still guards `PHP_VERSION_ID < 50300`.
- **DB:** MySQL (config `K_DATABASE_TYPE='MYSQL'`), also supports POSTGRESQL and ORACLE via the DAL. Local MySQL 5.7. Port 3306. Default schema/prefix `tcexam` / `tce_`.
- **Web server:** Apache 2.4 (service `Apache2.4`); the app is served from `C:\Apache24\htdocs\tcexam`. `K_PATH_HOST='http://localhost:8080'` in local config (note: host says :8080 while Apache2.4 is the installed service).
- **Dependency management:** none. No `composer.json`, no `vendor/`, no `package.json`, no npm. Third-party libs are vendored under `shared/` (TCPDF, PHPMailer, phpCAS, radius, jscalendar, vk).
- **Build tooling:** none in this checkout. Upstream `CONTRIBUTING.md` says run `make buildall`; there is no `Makefile` here. `.gitignore` reserves `ecs.php`, `rector.php`, `phpstan.neon`, `phpunit.xml` — none present.
- **Testing:** no PHPUnit in this checkout; tests are hand-rolled PHP scripts under `test/`.
- **Editor/agent config present:** `opencode.json` (opencode MCP: serena), `.qwen/settings.json`.
