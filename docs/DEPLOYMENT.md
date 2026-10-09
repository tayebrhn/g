# TCExam — Production Installation and Deployment Guide

TCExam provides two enterprise-grade production deployment models:

| Deployment Model | Best Suited For | Operating System | Setup Complexity |
|---|---|---|---|
| **Track 1: Offline Containerized Cluster (Recommended)** | Dedicated exam rooms, air-gapped test centers, standalone servers, or rapid container deployments. | Windows, Linux, macOS (Docker) | **1-Click** (Zero internet or manual build required) |
| **Track 2: Bare-Metal Windows Service Cluster** | Institutional Windows Server infrastructure requiring native Windows services, SMB shares, and zero-downtime rolling releases. | Windows Server 2019 / 2022 | Multi-step PowerShell automation (`deploy\`) |

---

# Track 1: Offline Air-Gapped Containerized Cluster (Recommended)

The **offline production container deployment** is located in [`offline-deployment/`](offline-deployment/). It is 100% self-contained and pre-packaged for servers with **no internet access**, **no Docker Hub access**, and **no build dependencies**.

### Key Architecture Features
* **Zero Internet & Zero Build**: All 3 production images (`tcexam-app:latest`, `nginx:alpine`, `mariadb:10.11`) are pre-baked into `tcexam-offline-bundle.tar` (~404 MB).
* **Simultaneous Port 80 & 8080**: Both standard HTTP port 80 and port 8080 are exposed simultaneously, preventing `ERR_CONNECTION_REFUSED` errors regardless of which URL users navigate to.
* **Auto-Bootstrapping Database**: On initial launch, MariaDB 10.11 automatically provisions the complete database schema (`install/mysql_db_structure.sql`) and initial data (`install/db_data.sql`).
* **LAN Exam Delivery**: Client computers across the exam room network connect directly to `http://<SERVER_IP>/public/code/index.php`.
* **Automated Post-Exam Backups**: 1-click script dumps candidate submissions, answer sheets, and grades into timestamped `.sql` files.

### 1-Click Deployment Instructions

1. Copy the entire [`offline-deployment/`](offline-deployment/) folder to the target server (via USB drive or network share).
2. Launch the cluster:
   * **Windows Server / Exam Laptop**: Double-click `start-production.bat`
   * **Linux Server (Ubuntu / Debian / RHEL)**: Run `./start-production.sh`
3. Access the portals:
   * **Candidate Portal (Port 80)**: `http://localhost/public/code/index.php`
   * **Alternative Port (Port 8080)**: `http://localhost:8080/public/code/index.php`
   * **Administrator Suite**: `http://localhost/admin/code/index.php` (User: `admin` | Password: `1234`)
   * **Exam Room Network (LAN)**: `http://<SERVER_IP>/public/code/index.php`
4. Post-exam maintenance:
   * **Backup Database**: Double-click `backup-database.bat` (or `./backup-database.sh`)
   * **Stop Cluster**: Double-click `stop-production.bat` (or `./stop-production.sh`)

### Customizing Network Ports
By default, the offline cluster listens simultaneously on both **Port 80** and **Port 8080**. If either port is occupied by another service on the offline server (e.g., IIS or another web service):
1. Open `offline-deployment/.env`.
2. Change `APP_PORT` or `APP_ALT_PORT`:
   ```dotenv
   APP_PORT=8888
   APP_ALT_PORT=9090
   ```
3. Restart via `start-production.bat` (or `./start-production.sh`). The launchers dynamically detect the change and display the new URLs.

### Applying Code Updates & Security Patches Offline
Whenever you update code or fix bugs on your development workstation:
1. **Build & Package**: Run `.\docker\build-offline-bundle.ps1` (or `./docker/build-offline-bundle.sh` on Linux / `make offline-bundle`).
2. **Transfer**: Copy the updated `offline-deployment/tcexam-offline-bundle.tar` to the target server.
3. **Apply**: On the offline server, double-click `apply-patch.bat` (or `./apply-patch.sh`).
   * Automatically creates a pre-patch database backup.
   * Recreates the application container with the new image.
   * **100% of candidate test sessions, questions, and grading data are preserved** in persistent volumes.

For complete details on the offline containerized setup, see [`offline-deployment/README.md`](../offline-deployment/README.md).

---

# Track 2: Bare-Metal Windows Service Cluster (NSSM & PHP-CGI)

This track installs TCExam on Windows production servers using Nginx,
`php-cgi.exe` (the Windows FastCGI process model — PHP-FPM is Unix-only),
NSSM-managed Windows services and, for high availability, an Nginx load
balancer in front of two or more application nodes.

Everything is automated by the scripts in `deploy\`:

| File | Purpose |
| --- | --- |
| `deploy\install-node.ps1` | one-shot installer for a node (single server, HA backend or load balancer) |
| `deploy\deploy-release.ps1` | deploys a new release with a zero-downtime junction switch |
| `deploy\rollback-release.ps1` | rolls a node back to a previous release |
| `deploy\verify-deployment.ps1` | post-deployment smoke tests |
| `deploy\nginx\app-node.conf` | nginx template: application node |
| `deploy\nginx\lb-node.conf` | nginx template: load balancer |
| `deploy\haproxy\haproxy.cfg` | HAProxy template (Linux VM alternative) |
| `deploy\php\php-production.ini` | PHP production overrides |
| `health.txt` | static liveness file used by the load balancer health checks |

## 1. Topology (Track 2)

```
                       Internet
                          |
                    [ load balancer ]        TLS termination, round-robin
                    lb01  (nginx, Windows)   (no sticky sessions needed:
                          |                  sessions live in the database)
              +-----------+-----------+
              |                       |
        [ app node 1 ]         [ app node 2 ]     nginx + php-cgi, TCExam code
           app01                   app02         C:\tcexam\current -> release
              |                       |
              +-----+---------+-------+
                    |         |
              [ MySQL ]   [ SMB share ]           db01: tcexam database
                                                  \\filesrv\tcexam-media: question
                                                  media + backups (shared)
```

Why this works without sticky sessions:

* PHP sessions are stored in MySQL (`TCExamSessionHandler`), so every
  node can serve every request.
* The session fingerprint uses HTTP headers only, never the client IP,
  so proxies and load balancers do not invalidate it.
* `K_RANDOM_SECURITY` is the only cross-node secret: it seeds session IDs,
  CSRF tokens and emailed-result tokens, and **must be identical on every
  node** (the installer generates one and prints it — save it in the vault).
* The only shared mutable state are the media and backup folders, hence the
  SMB share (mounted as directory junctions inside each release).

For a **single server** the same components collapse onto one machine:
`install-node.ps1 -Mode standalone` configures nginx to terminate TLS itself
and no load balancer or share is needed.

## 2. Prerequisites

Install on every node (download once, keep the installers):

1. **PHP 8.0+ NTS (Non Thread Safe), VC x64** — <https://windows.php.net/download/>
   (`php-cgi.exe` ships with it). Extract to `C:\php` and add the
   `ext\` directory requirements: enable the extensions used by TCExam
   (see `shared/config/tce_config.php` notes; at minimum `mysqli`,
   `openssl`, `gd`, `mbstring`, `xml`).
2. **Nginx for Windows** — <https://nginx.org/en/download.html>.
   Extract to `C:\nginx`.
3. **NSSM** (service manager) — <https://nssm.cc/download>. Put `nssm.exe`
   in `C:\tools`.
4. **MySQL 8 client tools** (`mysql.exe`) on at least one node, or use the
   MySQL server host.
5. The **TCExam release**: a git checkout (or extracted archive) of the
   version to deploy, e.g. `C:\build\tcexam`.
6. A TLS certificate (full chain PEM + key) for the public hostname,
   e.g. `exam.example.org`.

Run everything from an **elevated PowerShell**.

## 3. Part A — single-server installation (quick start)

```powershell
# from an elevated PowerShell, with the release at C:\build\tcexam
cd C:\build\tcexam\deploy

.\install-node.ps1 -SourceDir C:\build\tcexam -NssmExe C:\tools\nssm.exe `
    -Mode standalone `
    -PublicUrl https://exam.example.org `
    -DbUser tcexam -DbPassword '<db password>' `
    -SslCert C:\tls\fullchain.pem -SslKey C:\tls\privkey.pem
```

The script creates `C:\tcexam\releases\initial`, provisions
`config\` from the `config.default` templates, applies your values,
configures `php.ini`, writes `nginx.conf`, registers the **TCexamPHP**
and **TCexamNGINX** services, opens the firewall and starts everything.

Then:

```powershell
# 1. create the database (section 5) and apply the schema
#    -- or, for an existing installation, run the upgrade script first!

# 2. verify
powershell -File C:\tcexam\current\deploy\verify-deployment.ps1 `
    -BaseUrl https://exam.example.org
```

Finally **change the seeded `admin` password immediately** (its bcrypt hash
ships in the repository: `install\db_data.sql`) and log in to the admin
area to confirm.

## 4. Part B — highly available cluster

### 4.1 Shared media (file server)

On the file server (may be the database host) create a share with two
folders and grant modify rights to the app nodes' machine or service
accounts:

```
\\filesrv\tcexam-media\uid      question media of every user
\\filesrv\tcexam-media\backup   the backup page output
```

### 4.2 Application nodes (app01, app02)

Run on each node:

```powershell
.\install-node.ps1 -SourceDir C:\build\tcexam -NssmExe C:\tools\nssm.exe `
    -Mode backend -PublicUrl https://exam.example.org `
    -DbHost db01 -DbUser tcexam -DbPassword '<db password>' `
    -MediaShare \\filesrv\tcexam-media `
    -AllowedCidr 10.0.0.10
```

* `-AllowedCidr 10.0.0.10` is the load balancer IP: the firewall rule then
  accepts HTTP only from it, and nginx restores the real client IPs from
  `X-Forwarded-For` (needed by the test IP-range feature).
* The installer prints the generated `K_RANDOM_SECURITY` on **app01**:
  pass the same value explicitly on app02 and on every later node:

```powershell
    ... -RandomSecurity '<value printed by app01>'
```

### 4.3 Load balancer (lb01)

```powershell
.\install-node.ps1 -SourceDir C:\build\tcexam -NssmExe C:\tools\nssm.exe `
    -Mode loadbalancer -PublicUrl https://exam.example.org `
    -SslCert C:\tls\fullchain.pem -SslKey C:\tls\privkey.pem `
    -AppNodes '10.0.0.11:80','10.0.0.12:80'
```

This registers only the **TCexamNGINX** service with the load-balancer
configuration (`deploy\nginx\lb-node.conf`): TLS termination, HTTP→HTTPS
redirect, HSTS, round-robin with passive health checks. Point the DNS
`exam.example.org` at lb01 and verify with `verify-deployment.ps1`
against the public URL — repeated runs hit both nodes.

HAProxy alternative: HAProxy has no Windows build. If you prefer it, run
it on a small Linux VM using `deploy\haproxy\haproxy.cfg`, which adds
**active** health checks on `/health.txt`; the rest of this guide is
unchanged.

## 5. Database

### 5.1 Fresh installation

On the MySQL host, create the database and a dedicated account (never
`root`; allow only the app nodes):

```sql
CREATE DATABASE tcexam CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'tcexam'@'10.0.0.11' IDENTIFIED BY '<db password>';
CREATE USER 'tcexam'@'10.0.0.12' IDENTIFIED BY '<db password>';
GRANT ALL PRIVILEGES ON tcexam.* TO 'tcexam'@'10.0.0.11';
GRANT ALL PRIVILEGES ON tcexam.* TO 'tcexam'@'10.0.0.12';
FLUSH PRIVILEGES;
```

Then load the schema and the seed data from a release:

```powershell
mysql --host db01 -u tcexam -p tcexam < C:\tcexam\current\install\mysql_db_structure.sql
mysql --host db01 -u tcexam -p tcexam < C:\tcexam\current\install\db_data.sql
```

`db_data.sql` seeds the `admin` account (rank 10, every capability) with a
**publicly known password hash** — change it at the first login, and audit
the seeded capability masks in the user editor.

### 5.2 Upgrading an existing installation

**Schema first, code later** — the upgrade scripts are backward compatible:

```powershell
mysql --host db01 -u tcexam -p tcexam < C:\tcexam\current\install\upgrade\mysql\mysql_db_upgrade_16to17.sql
```

The `16to17` script adds the `user_perms` capability bitmask and derives the
initial masks from the legacy user levels, **preserving everyone's rights
exactly** (see PERMISSIONS.md section 10 and UPGRADE.TXT). The new code also
tolerates a not-yet-migrated schema on read paths, but apply the migration
in the same maintenance window as the code deployment.

For PostgreSQL or Oracle use the matching script under
`install\upgrade\postgresql\` or `install\upgrade\oracle\`.

## 6. Configuration reference

Files provisioned by the installer (all inside the release tree; carried
over automatically by `deploy-release.ps1`):

| File | Keys you must review |
| --- | --- |
| `shared\config\tce_paths.php` | `K_PATH_HOST` (public URL), `K_PATH_TCEXAM` (`/`), `K_PATH_MAIN` (points at `C:/tcexam/current/`) |
| `shared\config\tce_db_config.php` | `K_DATABASE_*` (host, port, name, user, password) |
| `shared\config\tce_general_constants.php` | `K_RANDOM_SECURITY` (identical on every node, never rotate casually) |
| `shared\config\tce_config.php` | `K_CHECK_USER_PER_REQUEST` (keep `true`: grants and demotions apply immediately), cookie flags, brute-force ratio |
| `admin\config\` / `public\config\` | page access levels, themes, e-mail settings |

The two tracked files `admin\config\tce_auth.php` and
`public\config\tce_auth.php` come from the release itself (they now only
keep legacy constants) and are never carried over between releases.

## 7. Deploying a new release (rolling, zero downtime)

On each application node, one node at a time (the load balancer keeps
serving the others):

```powershell
# 1. if the release notes mention a database upgrade, apply it FIRST (section 5.2)

# 2. deploy the code
powershell -File C:\tcexam\current\deploy\deploy-release.ps1 `
    -SourceDir C:\build\tcexam-abc123 -Tag abc123

# 3. verify the node, then repeat on the next node
powershell -File C:\tcexam\current\deploy\verify-deployment.ps1 -BaseUrl https://exam.example.org
```

`deploy-release.ps1` copies the release to `C:\tcexam\releases\<tag>`,
carries over the deployment configuration and the media junctions, flips
the `current` junction, restarts the services (the PHP restart also
re-reads the code for OPcache, which runs with
`opcache.validate_timestamps=0`) and waits for the health endpoint.

Rollback:

```powershell
powershell -File C:\tcexam\current\deploy\rollback-release.ps1           # list releases
powershell -File C:\tcexam\current\deploy\rollback-release.ps1 -Tag abc123
```

The database is not rolled back: TCExam upgrade scripts are written so the
previous code keeps working against the migrated schema.

## 8. Operations

* **Backups**: schedule a nightly task on the DB host:
  `mysqldump --single-transaction -u tcexam -p tcexam > \\filesrv\tcexam-media\backup\db-<date>.sql`
  The database holds the source of truth (users, capability masks,
  questions, tests, results, sessions). Retain as per policy; test restores.
* **Logs**: per node, `C:\tcexam\logs\` (PHP errors, service output) and the
  nginx logs under `C:\nginx\logs\`. The application also writes
  `admin\log\` and `public\log\` inside the release tree.
* **Monitoring**: poll `/health.txt` (static, cheap) frequently; poll the
  deep check `/admin/code/tce_page_info.php` (a PHP hit that opens a
  database session) at most once a minute.
* **Updates**: read `UPGRADE.TXT` and the release notes, apply the database
  upgrade scripts (section 5.2), then roll the release (section 7).
* **Session growth**: expired sessions are garbage-collected on session
  close; monitor the `tce_sessions` row count if you expect very large
  concurrent test sessions.

## 9. Security checklist

* [ ] `install\` removed from the release (the installer does it; nginx also
      returns 404 for `/install/` and `/admin/backup/`).
* [ ] HTTPS only; HSTS sent by the load balancer; cookies have the
      `secure`/`httponly` flags set by `K_COOKIE_*` in the production
      templates.
* [ ] The seeded `admin` password changed; every seeded account audited in
      the user editor (capability checkboxes).
* [ ] `K_RANDOM_SECURITY` generated by you (not the printed default),
      stored in the vault, identical on every node.
* [ ] MySQL reachable only from the app nodes; dedicated `tcexam` account.
* [ ] Firewall: 443 (lb) or 80-from-lb only (backends); FastCGI port 9000
      bound to 127.0.0.1; SMB share restricted to the app nodes.
* [ ] Windows: run the services under a dedicated low-privilege account if
      your policy requires it (`nssm set TCexamPHP ObjectName ...`), keep
      the OS and PHP patched, review the PHP error log regularly.
* [ ] Review `SECURITY.md` and PERMISSIONS.md section 11 (known
      limitations) before go-live.

## 10. Troubleshooting

| Symptom | Look at | Typical cause |
| --- | --- | --- |
| 502 from nginx | `C:\tcexam\logs\php-service.err.log` | php-cgi not running (TCexamPHP service) or crashed workers; check `PHP_FCGI_CHILDREN` |
| Blank page / 500 | `C:\tcexam\logs\php-error.log` | missing PHP extension (mysqli, gd, openssl, mbstring) |
| Login loops back to the form | `tce_db_config.php` values; `mysql` connectivity from the node | wrong DB credentials or unreachable DB |
| "You do not have permission…" for everyone after an upgrade | `install\upgrade\*\*_db_upgrade_16to17.sql` applied? | the `user_perms` column is missing; apply the migration (section 5.2) |
| Capability changes have no effect | `K_CHECK_USER_PER_REQUEST` in `shared\config\tce_config.php` | must be `true` (the code refreshes the mask at every request) |
| Emailed result PDFs missing | `K_PATH_HOST` reachable **from the app nodes** | the report generator fetches its own URL over HTTP; point `K_PATH_HOST` at the load balancer VIP |
| LB marks a node down | `curl http://<node>/health.txt` on the node | nginx down or wrong `-AllowedCidr`; check `C:\nginx\logs\error.log` |
| Media files not visible on the other node | `dir C:\tcexam\current\cache` (junctions?) | `uid`/`backup` junctions missing: re-run the share step or `deploy-release.ps1` |
