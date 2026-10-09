# TCExam Developer Guide & Quickstart

Welcome to the TCExam development environment! This project provides a **1-command, zero-configuration development profile** using Docker Compose.

Any developer on Windows, macOS, or Linux can clone this repository and spin up a fully functioning, live-reloading PHP 8.2 + MariaDB + Nginx environment in under 60 seconds without installing PHP or MySQL locally.

---

## 1. Quick Start (1-Command Launch)

### Prerequisites
- **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (Windows / macOS) or **Docker Engine + Docker Compose** (Linux). Ensure Docker is running.

### Start the Server

- **Windows (Command Prompt / Double-Click)**:
  ```cmd
  dev.bat
  ```
- **Windows (PowerShell)**:
  ```powershell
  .\dev.ps1
  ```
- **macOS / Linux**:
  ```bash
  chmod +x dev.sh
  ./dev.sh
  ```
- **Using Make**:
  ```bash
  make dev
  ```

The script automatically initializes your `.env` configuration, launches the containers, and waits for health checks to pass.

---

## 2. Portals & Default Credentials

Once the server is running, access the portals in your browser:

| Portal | URL | Credentials |
|---|---|---|
| **Candidate Portal** | [http://localhost:8080/public/code/index.php](http://localhost:8080/public/code/index.php) | Public access |
| **Administrator Suite** | [http://localhost:8080/admin/code/index.php](http://localhost:8080/admin/code/index.php) | **User:** `admin`<br>**Password:** `1234` |
| **Health Check Probe** | [http://localhost:8080/health.txt](http://localhost:8080/health.txt) | Returns `OK` (HTTP 200) |

---

## 3. Database GUI Access

The development profile exposes the MariaDB service on your host machine:

- **Host:** `localhost`
- **Port:** `3306` (or `${DB_PORT_FORWARD:-3306}`)
- **Database:** `tcexam`
- **Username:** `tcexam`
- **Password:** `tcexam_secret_pass`
- **Root Password:** `root_secret_pass`

You can connect directly using any database client:
- **TablePlus**
- **DBeaver**
- **HeidiSQL**
- **PhpStorm / VS Code Database Tools**
- **MySQL CLI:** `docker compose exec db mariadb -u tcexam -ptcexam_secret_pass tcexam` (or `make db`)

---

## 4. Key Development Features

### 🔄 Live Hot-Reloading
The root codebase is mounted directly into both the Nginx web container (`web`) and the PHP-FPM execution container (`app`).
- Any edit you make to PHP files, templates, styles, or JavaScript is immediately live in your browser.
- No container rebuilding (`docker compose build`) is required during development.

### 🐛 Verbose Error Reporting
Development settings are loaded from [`docker/php/php-dev.ini`](file:///C:/Apache24/htdocs/tcexam/docker/php/php-dev.ini):
- `display_errors = On`
- `display_startup_errors = On`
- `error_reporting = E_ALL`
- Syntax errors and uncaught exceptions are rendered directly on screen with file paths and line numbers instead of generic blank 500 error pages.

### ⚡ Instant OPcache Invalidation
- `opcache.validate_timestamps = 1`
- `opcache.revalidate_freq = 0`
- PHP code caches are revalidated on every HTTP request so changes appear instantly without restarting PHP-FPM.

### 🧬 Automated Database Seeding
On initial launch with an empty database volume, [`docker/bootstrap.php`](file:///C:/Apache24/htdocs/tcexam/docker/bootstrap.php) automatically imports:
1. `install/mysql_db_structure.sql` (Tables, views, foreign keys)
2. `install/db_data.sql` (Default administrative account, test groups, levels)

---

## 5. Daily Development Cheat Sheet

| Task | Command |
|---|---|
| **Start dev environment** | `./dev.sh` or `dev.bat` or `make dev` |
| **Stop dev environment** | `docker compose down` or `make down` |
| **View live PHP logs** | `docker compose logs -f app` or `make logs-app` |
| **View web/nginx logs** | `docker compose logs -f web` |
| **Run bash inside PHP container** | `docker compose exec app sh` or `make sh` |
| **Access MariaDB CLI** | `docker compose exec db mariadb -u tcexam -ptcexam_secret_pass tcexam` |
| **Run integrity test suite** | `php test/test_docker_configuration_integrity.php` or `make test` |
| **Reset database to blank state** | `docker compose down -v` then `./dev.sh` (or `dev.bat`) |

---

## 6. Easy Port Customization & Configuration

Port configuration is completely decoupled from Docker compose files. All settings live in a single `.env` file in the repository root.

### Available Port Settings (`.env`)

| Variable | Default | Purpose |
|---|---|---|
| `APP_PORT` | `8080` (or `80`) | Main host web port for Nginx (serves candidate portal & admin suite) |
| `APP_ALT_PORT` | `8080` | Secondary / alternative web port mapped simultaneously |
| `DB_PORT_FORWARD` | `3307` | Host port for MariaDB GUI client connections (e.g., TablePlus, DBeaver) |

> [!NOTE]
> Why is MariaDB mapped to host port `3307` instead of `3306` by default in development?
> Many developer machines already have a native MySQL, MariaDB, or XAMPP instance listening on host port `3306`. By defaulting `DB_PORT_FORWARD=3307`, TCExam avoids port collision errors while still allowing direct external GUI database access.

### How to Change Ports:
1. Open `.env` in the repository root.
2. Adjust your desired ports:
   ```dotenv
   APP_PORT=8888
   APP_ALT_PORT=9090
   DB_PORT_FORWARD=3308
   APP_URL=http://localhost:8888
   ```
3. Restart using your standard launcher:
   - **Windows:** `dev.bat` or `.\dev.ps1`
   - **Linux / macOS:** `./dev.sh`
   - **Make:** `make dev`

All startup launchers automatically read your new `.env` settings, wait for health checks on the new port, and print the exact clickable URLs into your terminal!

---

## 7. Troubleshooting & Permissions

### Permission Issues on Linux
If you encounter file permission warnings when the container writes to `cache/` or `admin/backup/`:
```bash
chmod -R 775 cache admin/backup
```

### Viewing Real-Time Logs
If something is not behaving as expected:
```bash
# View PHP-FPM execution errors and logs
docker compose logs -f app

# View Nginx access & error logs
docker compose logs -f web

# View MariaDB database logs
docker compose logs -f db
```
