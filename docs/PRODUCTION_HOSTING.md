# TCExam — Production Hosting & Deployment Guide

This guide provides an end-to-end reference for deploying, hardening, scaling, and maintaining **TCExam** in enterprise and institutional production environments (schools, universities, certification bodies, and corporations).

---

## Table of Contents

1. [Architecture & Concurrency Sizing](#1-architecture--concurrency-sizing)
2. [Production Stack Options](#2-production-stack-options)
3. [Ubuntu / Debian Linux Setup (Recommended)](#3-ubuntu--debian-linux-setup-recommended)
   - [System & Firewall Configuration](#step-1-system-packages--firewall)
   - [PHP 8.x & PHP-FPM Installation](#step-2-php-8x--php-fpm)
   - [Nginx Web Server Configuration](#step-3-nginx-web-server)
   - [Apache 2.4 Alternative](#step-3-alternative-apache-24-alternative)
   - [MySQL 8 / MariaDB Database Setup](#step-4-mysql-8--mariadb)
   - [Code Deployment & File Permissions](#step-5-code-deployment--permissions)
   - [Application Configuration](#step-6-application-configuration)
   - [SSL / TLS with Let's Encrypt](#step-7-ssltls-certificates)
4. [Docker & Containerized Production Deployment](#4-docker--containerized-deployment)
   - [Turnkey Docker Architecture](#turnkey-docker-architecture)
   - [Air-Gapped Offline Production Deployment](#air-gapped-offline-production-deployment)
   - [Simultaneous Port 80 & 8080 Configuration](#simultaneous-port-80--8080-configuration)
   - [LAN Exam Delivery in Test Rooms](#lan-exam-delivery-in-test-rooms)
   - [Automated Post-Exam Database Backups](#automated-post-exam-database-backups)
   - [Building, Patching & Updating Offline Images](#building-patching--updating-offline-images)
   - [Multi-Instance Scaling with Dynamic Load Balancing](#multi-instance-scaling-with-dynamic-load-balancing)
5. [Windows Server Production Setup (Bare-Metal)](#5-windows-server-production-setup-bare-metal)
6. [High-Performance CBT Engine Tuning](#6-high-performance-cbt-engine-tuning)
   - [PHP-FPM Worker Pool Tuning](#php-fpm-worker-pool-tuning)
   - [PHP OPcache Configuration](#php-opcache-configuration)
   - [MySQL / MariaDB Optimization](#mysql--mariadb-optimization)
   - [Session Management & Clustering](#session-management--clustering)
7. [Production Security & Hardening Checklist](#7-production-security--hardening-checklist)
8. [Automated Backups & Disaster Recovery](#8-automated-backups--disaster-recovery)
9. [Pre-Exam Load Testing & Health Monitoring](#9-pre-exam-load-testing--health-monitoring)

---

## 1. Architecture & Concurrency Sizing

### Understanding CBT (Computer-Based Testing) Workloads
Unlike standard content websites where traffic is dispersed, CBT platforms experience **extreme synchronized traffic spikes**:
* **Exam Start**: Hundreds or thousands of students submit authentication and test initiation requests within a 3-minute window.
* **During Exam**: Candidates submit answers on every question change (AJAX / POST requests every 30–90 seconds per user).
* **Exam Finish**: Hundreds of candidates hit submission and automated grading algorithms simultaneously.

### Infrastructure Sizing Matrix

| Concurrent Candidates | Web / App Nodes (CPU / RAM) | Database Node (CPU / RAM / SSD) | Web Server / PHP Stack | Recommended Topology |
| :---: | :---: | :---: | :---: | :--- |
| **Up to 100** | 2 vCPU, 4 GB RAM | Shared with App (NVMe SSD) | Single Nginx + PHP-FPM | Standalone VM / VPS |
| **100 – 500** | 4 vCPU, 8 GB RAM | Dedicated 2 vCPU, 8 GB RAM | Single Nginx + PHP-FPM | Dedicated App + Dedicated DB |
| **500 – 2,000** | 2 Nodes × (4 vCPU, 8 GB) | Dedicated 4 vCPU, 16 GB RAM | Load Balancer + 2 App Nodes | Clustered App + Managed DB |
| **2,000 – 10,000+** | 4–6 Nodes × (8 vCPU, 16 GB) | Dedicated 8–16 vCPU, 32 GB RAM (Cluster) | Nginx / HAProxy LB + Autoscaling App | Cloud Cluster (AWS/GCP/Azure) |

---

## 2. Production Stack Options

TCExam runs on standard LAMP/LEMP stacks:
* **Operating System**: Linux (Ubuntu 22.04/24.04 LTS, Debian 12, Rocky Linux / RHEL 9) or Windows Server (2019/2022).
* **PHP Engine**: PHP 8.0, 8.1, 8.2, or 8.3 with PHP-FPM.
* **Web Server**: Nginx (highest concurrency throughput) or Apache 2.4 (with `mpm_event`).
* **Database**: MySQL 8.0+, MariaDB 10.6+, or PostgreSQL 14+.

---

## 3. Ubuntu / Debian Linux Setup (Recommended)

### Step 1: System Packages & Firewall

Update the OS and install base utilities:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ufw curl git unzip htop software-properties-common certbot
```

Configure firewall (UFW) to allow SSH, HTTP, and HTTPS:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

### Step 2: PHP 8.x & PHP-FPM

Install PHP 8.x and the required extensions:

```bash
sudo apt install -y php-fpm php-cli php-mysql php-mbstring php-gd \
                    php-xml php-curl php-zip php-bcmath php-intl php-opcache
```

Verify installed version:
```bash
php -v
```

#### Production `php.ini` Settings
Edit `/etc/php/8.x/fpm/php.ini`:

```ini
; Memory & execution limits (essential for large PDF report generation)
memory_limit = 512M
max_execution_time = 180
max_input_time = 120

; Upload and POST sizes (for importing question banks and bulk users)
upload_max_filesize = 64M
post_max_size = 70M

; Security flags
expose_php = Off
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php_errors.log

; Cookie security
session.cookie_httponly = 1
session.cookie_secure = 1
session.cookie_samesite = "Lax"
session.use_strict_mode = 1
```

Restart PHP-FPM:
```bash
sudo systemctl restart php8.x-fpm
```

---

### Step 3: Nginx Web Server

Install Nginx:
```bash
sudo apt install -y nginx
```

Create a production virtual host `/etc/nginx/sites-available/tcexam`:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name exam.yourdomain.com;

    # Redirect all HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name exam.yourdomain.com;

    root /var/www/tcexam;
    index index.php index.html;

    # SSL Certificates (managed by Certbot)
    ssl_certificate /etc/letsencrypt/live/exam.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/exam.yourdomain.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Max Request Size
    client_max_body_size 70M;

    # Root redirect to candidate portal
    location = / {
        return 302 /public/code/index.php;
    }

    # Liveness check endpoint
    location = /health.txt {
        access_log off;
        try_files /health.txt =200;
    }

    # Restrict sensitive paths and directories
    location ~ ^/(install|test|\.git|shared/config|admin/backup|cache/backup)/ {
        deny all;
        return 404;
    }

    # Static assets caching
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
        access_log off;
    }

    # PHP-FPM Handler
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.x-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;

        fastcgi_read_timeout 180;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
    }

    # Deny access to hidden files (.env, .htaccess, etc.)
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
```

Enable site and test configuration:
```bash
sudo ln -s /etc/nginx/sites-available/tcexam /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

### Step 3 (Alternative): Apache 2.4 Alternative

If using Apache instead of Nginx:

```bash
sudo apt install -y apache2 libapache2-mod-fcgid
sudo a2enmod rewrite ssl headers proxy proxy_fcgi
```

Configure `/etc/apache2/sites-available/tcexam.conf`:

```apache
<VirtualHost *:80>
    ServerName exam.yourdomain.com
    Redirect permanent / https://exam.yourdomain.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName exam.yourdomain.com
    DocumentRoot /var/www/tcexam

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/exam.yourdomain.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/exam.yourdomain.com/privkey.pem

    # Security Headers
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"

    <Directory /var/www/tcexam>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Block sensitive directories
    <DirectoryMatch "^/var/www/tcexam/(install|test|\.git|shared/config|admin/backup)">
        Require all denied
    </DirectoryMatch>

    # PHP-FPM proxy
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.x-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/tcexam_error.log
    CustomLog ${APACHE_LOG_DIR}/tcexam_access.log combined
</VirtualHost>
```

---

### Step 4: MySQL 8 / MariaDB

Install MariaDB or MySQL:
```bash
sudo apt install -y mariadb-server
sudo mysql_secure_installation
```

#### Create Production Database & User
Log in to MySQL as root:
```bash
sudo mysql -u root
```

Execute SQL commands:
```sql
CREATE DATABASE tcexam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create dedicated non-root application user
CREATE USER 'tcexam_user'@'localhost' IDENTIFIED BY 'StrongRandomProductionPassword!2026';

-- Grant required permissions
GRANT ALL PRIVILEGES ON tcexam.* TO 'tcexam_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### Load Schema and Initial Seed Data
From the TCExam root folder:
```bash
mysql -u tcexam_user -p tcexam < /var/www/tcexam/install/mysql_db_structure.sql
mysql -u tcexam_user -p tcexam < /var/www/tcexam/install/db_data.sql
```

> [!WARNING]
> The seeded default administrator password must be changed immediately upon first login!

---

### Step 5: Code Deployment & Permissions

Clone or copy the application to `/var/www/tcexam`:

```bash
sudo git clone https://github.com/tecnickcom/tcexam.git /var/www/tcexam
cd /var/www/tcexam
```

#### Initialize Configurations from Defaults
TCExam ships template configs under `config.default/`. Copy them to active directories:

```bash
sudo cp -r shared/config.default/* shared/config/
sudo cp -r admin/config.default/* admin/config/
sudo cp -r public/config.default/* public/config/
```

#### Set Ownership & Permissions
The web server (`www-data`) needs read access to code and write access only to specific cache and backup folders:

```bash
# Set base ownership
sudo chown -R root:www-data /var/www/tcexam
sudo chmod -R 755 /var/www/tcexam
sudo find /var/www/tcexam -type f -exec chmod 644 {} +

# Grant write access ONLY to runtime directories
sudo chown -R www-data:www-data /var/www/tcexam/cache
sudo chown -R www-data:www-data /var/www/tcexam/shared/config
sudo chown -R www-data:www-data /var/www/tcexam/admin/config
sudo chown -R www-data:www-data /var/www/tcexam/public/config
sudo chown -R www-data:www-data /var/www/tcexam/admin/backup

sudo chmod -R 775 /var/www/tcexam/cache
sudo chmod -R 775 /var/www/tcexam/admin/backup
```

---

### Step 6: Application Configuration

Edit `shared/config/tce_db_config.php`:
```php
define('K_DATABASE_TYPE', 'MYSQL');
define('K_DATABASE_HOST', 'localhost');
define('K_DATABASE_PORT', '3306');
define('K_DATABASE_NAME', 'tcexam');
define('K_DATABASE_USER', 'tcexam_user');
define('K_DATABASE_PASSWORD', 'StrongRandomProductionPassword!2026');
```

Edit `shared/config/tce_paths.php`:
```php
define('K_PATH_HOST', 'https://exam.yourdomain.com');
define('K_PATH_TCEXAM', '/');
define('K_PATH_MAIN', '/var/www/tcexam/');
```

Edit `shared/config/tce_general_constants.php`:
```php
// Generate a unique 64-character random string for your installation
define('K_RANDOM_SECURITY', 'f8a7c29e1d5b4a3c6e80f2149b7d8e3c1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d');
```

Edit `shared/config/tce_config.php`:
```php
// Enforce answer key protection (prevents candidate solution leakage)
define('K_RESTRICT_ANSWER_KEYS', true);

// Keep real-time capability checks active
define('K_CHECK_USER_PER_REQUEST', true);

// Cookie security flags
define('K_COOKIE_SECURE', true);
define('K_COOKIE_HTTPONLY', true);
```

---

### Step 7: SSL/TLS Certificates

Obtain a free, auto-renewing certificate with Let's Encrypt:

```bash
sudo certbot --nginx -d exam.yourdomain.com
```
*(Or `--apache` if using Apache)*.

Test auto-renewal:
```bash
sudo certbot renew --dry-run
```

---

## 4. Docker & Containerized Production Deployment

TCExam includes a production-ready containerization architecture designed for two key operational scenarios:
1. **Online Institutional Clusters**: Standard Docker Compose deployment on connected cloud or on-premise servers.
2. **Air-Gapped Offline Exam Centers**: Standalone, pre-bundled deployment for secure testing rooms, kiosks, and examination laptops with **zero internet connection**.

---

### Turnkey Docker Architecture

The containerized stack consists of three specialized services communicating over an internal bridge network (`tcexam-net`):

```
                     Candidate / Admin Traffic (Ports 80 & 8080)
                                        │
                                        ▼
                           ┌─────────────────────────┐
                           │   web  (Nginx Alpine)   │
                           │ Reverse Proxy & Static  │
                           └────────────┬────────────┘
                                        │ FastCGI (:9000)
                                        ▼
                           ┌─────────────────────────┐
                           │   app  (PHP 8.2-FPM)    │
                           │  Core Assessment Engine │
                           └────────────┬────────────┘
                                        │ TCP (:3306)
                                        ▼
                           ┌─────────────────────────┐
                           │   db   (MariaDB 10.11)  │
                           │ Persistent SQL Storage  │
                           └─────────────────────────┘
```

#### Core Components & Security Hardening:
* **Lightweight Alpine Image (`Dockerfile`)**: Built on `php:8.2-fpm-alpine` (~120 MB total image size) with all 10 required extensions compiled (`gd`, `mysqli`, `pdo_mysql`, `mbstring`, `xml`, `curl`, `zip`, `bcmath`, `intl`, `opcache`).
* **Automated Zero-Touch Bootstrap (`docker/bootstrap.php`)**:
  - Automatically provisions runtime configuration files from `config.default/` if absent.
  - Injects environment variables (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `APP_URL`, `RANDOM_SECURITY`) into TCExam configuration constants.
  - Detects fresh databases and auto-seeds the full schema (`mysql_db_structure.sql`) and initial data (`db_data.sql`).
* **Nginx Reverse Proxy Hardening (`docker/nginx/default.conf`)**:
  - Automatically blocks sensitive directories (`/install/`, `/admin/backup/`, `/cache/backup/`, `shared/config/`, `.git/`, `.env`).
  - Sets FastCGI timeout to `300s` to support long-running test grading and PDF report exports.
  - Implements dynamic internal DNS resolution (`resolver 127.0.0.11 valid=5s`) for seamless `--scale app=N` round-robin load balancing.
* **Persistent Volumes**:
  - `db_data`: Preserves all MariaDB tables, questions, candidates, and examination results.
  - `cache_data`: Stores temporary test sessions, LaTeX formula renders, and uploaded attachments.
  - `backup_data`: Archives administrative database exports.

---

### Air-Gapped Offline Production Deployment

In high-stakes testing, certification exams, and institutional assessments, examination servers are frequently **air-gapped** (disconnected from the public internet to prevent cheating or data exfiltration).

On an offline server:
* `docker pull` will fail because Docker Hub is unreachable.
* `docker compose build` will fail because Alpine cannot reach package mirrors to run `apk add`.

To solve this, TCExam provides a self-contained distribution folder: [`offline-deployment/`](offline-deployment/).

```
offline-deployment/
├── tcexam-offline-bundle.tar     # 404 MB archive containing all 3 Docker images
├── docker-compose.yml            # Image-only production compose (NO build directive)
├── nginx/
│   └── default.conf              # Production reverse proxy & security configuration
├── .env.example                  # Pre-configured production settings (ports 80 & 8080)
├── start-production.bat          # Windows 1-click launcher (loads tar, starts cluster)
├── start-production.sh           # Linux 1-click launcher (loads tar, starts cluster)
├── stop-production.bat / .sh     # Graceful cluster shutdown
├── backup-database.bat / .sh     # 1-click post-exam database backup (.sql)
└── README.md                     # Step-by-step air-gapped deployment handbook
```

#### Step-by-Step Offline Server Setup:

1. **Transfer the Package**:
   Copy the [`offline-deployment/`](offline-deployment/) folder to the offline server via USB flash drive or local LAN share.

2. **Launch the Production Cluster**:
   - **Windows Server / Exam Laptop**: Double-click `start-production.bat`
   - **Linux Server (Ubuntu / Debian / RHEL)**: Run `./start-production.sh`

3. **What the Script Does Automatically**:
   - Imports all three container images directly from `tcexam-offline-bundle.tar` (`docker load`).
   - Copies `.env.example` to `.env` if not already present.
   - Starts MariaDB, PHP-FPM, and Nginx in the background with `restart: always`.
   - Auto-seeds the TCExam schema and default tables on the first run.
   - Runs health checks and outputs the server URLs.

---

### Simultaneous Port 80 & 8080 Configuration

A common source of `ERR_CONNECTION_REFUSED` errors occurs when users type `http://localhost/public/code/index.php` (standard port 80), but the container was configured only for port 8080.

In TCExam's production compose configuration, **both Port 80 and Port 8080 are bound simultaneously**:

```yaml
ports:
  - "${APP_PORT:-80}:80"
  - "${APP_ALT_PORT:-8080}:80"
```

| URL | Port | Behavior |
|---|---|---|
| `http://localhost/public/code/index.php` | Standard HTTP (Port 80) | Connects immediately (standard production URL) |
| `http://localhost:8080/public/code/index.php` | Alternate Port (Port 8080) | Connects immediately (fallback for systems where port 80 is occupied) |
| `http://localhost/admin/code/index.php` | Standard HTTP (Port 80) | Administrator Suite |

---

### LAN Exam Delivery in Test Rooms

To deliver exams across an isolated computer lab or examination room:

1. Find the local IP address of the exam server:
   - **Windows**: Run `ipconfig` (e.g. `192.168.1.50`)
   - **Linux**: Run `ip a` or `hostname -I`
2. Ensure the host firewall permits incoming TCP traffic on Port 80:
   - **Windows**: Add an inbound rule in Windows Defender Firewall for TCP Port 80.
   - **Linux**: Run `sudo ufw allow 80/tcp`.
3. Candidate client computers open their web browsers and navigate to:
   ```text
   http://<SERVER_IP>/public/code/index.php
   ```
   *(e.g., `http://192.168.1.50/public/code/index.php`)*

---

### Automated Post-Exam Database Backups

After an examination session concludes, administrators must archive candidate answers, logs, and score summaries.

The offline deployment includes automated 1-click backup utilities:
- **Windows**: Double-click `backup-database.bat`
- **Linux**: Run `./backup-database.sh`

The script executes a non-blocking `mariadb-dump` and saves a consistent snapshot directly to the `backups/` directory:
```text
backups/tcexam_backup_YYYYMMDD_HHMMSS.sql
```

---

### Building, Patching & Updating Offline Images

Because production Docker containers bake the application codebase directly into the image (`tcexam-app:latest`), any code changes, bug fixes, or security patches must be compiled into a fresh image on an internet-connected development machine and exported to the offline server.

#### Step 1: Build & Package on the Development Machine
On your internet-connected workstation, make your code modifications, then run the automated packaging script:

- **Windows (PowerShell)**:
  ```powershell
  .\docker\build-offline-bundle.ps1
  ```
  *(To force a fresh rebuild without Docker cache, add `-NoCache`)*
- **Linux / macOS**:
  ```bash
  chmod +x docker/build-offline-bundle.sh
  ./docker/build-offline-bundle.sh
  ```
- **Using Make**:
  ```bash
  make offline-bundle
  ```

**What the Script Does:**
1. Rebuilds `tcexam-app:latest` with your updated source code.
2. Verifies and pulls the latest base images (`nginx:alpine`, `mariadb:10.11`).
3. Packages all 3 images into the portable archive `offline-deployment/tcexam-offline-bundle.tar` (~404 MB).

#### Step 2: Transfer to the Offline Server
Copy the updated `tcexam-offline-bundle.tar` file to the target offline server's `offline-deployment/` directory using a USB flash drive or local network share.

#### Step 3: Apply the Patch (Zero Data Loss)
On the offline server, execute the 1-click update utility:

- **Windows Server / Exam Laptop**: Double-click `apply-patch.bat`
- **Linux Server**: Run `./apply-patch.sh`

**What Happens Automatically:**
1. **Safety Backup**: Creates an automatic database snapshot in `backups/pre_patch_backup_YYYYMMDD_HHMMSS.sql`.
2. **Image Import**: Loads the new container images (`docker load -i tcexam-offline-bundle.tar`).
3. **Container Re-creation**: Seamlessly swaps the running `app` and `web` containers with the new image:
   ```bash
   docker compose up -d --force-recreate app web
   ```
4. **Data Preservation Guarantee**: Because the database is stored in the independent named volume `db_data` (and media in `cache_data`), **100% of all candidate accounts, exam questions, active test sessions, and grading results are preserved**.

#### Database Schema Migrations (If Required)
If you are upgrading between major TCExam releases that include database schema changes:
1. Locate the migration file (e.g. `install/upgrade/mysql/mysql_db_upgrade_XtoY.sql`).
2. Run the migration against the running container:
   ```bash
   docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < install/upgrade/mysql/mysql_db_upgrade_XtoY.sql
   ```

---

### Multi-Instance Scaling with Dynamic Load Balancing

TCExam's Nginx configuration includes an embedded DNS resolver (`127.0.0.11`) configured with a 5-second TTL. This allows scaling the PHP application tier on the fly without modifying Nginx configuration or restarting the web server:

```bash
# Scale the PHP-FPM execution engine to 4 worker instances
docker compose up -d --scale app=4
```

Nginx automatically discovers all active `app` container IPs and distributes incoming test requests via round-robin load balancing. Because TCExam stores session data directly in the database (`TCExamSessionHandler`), candidate sessions remain valid across all container instances without requiring sticky sessions.

---

### Graceful Shutdown & Disaster Recovery

- **Stop Services**: Run `stop-production.bat` (Windows) or `./stop-production.sh` (Linux).
- **Restart Services**: Run `start-production.bat` (Windows) or `./start-production.sh` (Linux).
- **Full Factory Reset**: To wipe all candidate data and re-initialize the database from scratch:
  ```bash
  docker compose down -v
  ```
  Then run `start-production.bat` (or `./start-production.sh`) to re-seed a fresh database.

---

## 5. Windows Server Production Setup (Bare-Metal)

If hosting on **Windows Server (2019/2022)**, TCExam provides automated deployment automation in the [`deploy/`](file:///C:/Apache24/htdocs/tcexam/deploy/) directory:

1. **Install Prerequisites**:
   - PHP 8.x NTS x64 extracted to `C:\php`.
   - Nginx for Windows extracted to `C:\nginx`.
   - NSSM service manager in `C:\tools\nssm.exe`.
   - MySQL 8 server.
2. **Execute Automated Node Installer**:
   ```powershell
   cd C:\Apache24\htdocs\tcexam\deploy
   .\install-node.ps1 -SourceDir C:\Apache24\htdocs\tcexam -NssmExe C:\tools\nssm.exe `
       -Mode standalone `
       -PublicUrl https://exam.example.org `
       -DbUser tcexam -DbPassword 'StrongPass123!' `
       -SslCert C:\tls\fullchain.pem -SslKey C:\tls\privkey.pem
   ```
3. *For multi-node clustering and junction-based zero-downtime rolling releases, refer to the full Windows automation guide in [`DEPLOYMENT.md`](file:///C:/Apache24/htdocs/tcexam/DEPLOYMENT.md).*

---

## 6. High-Performance CBT Engine Tuning

### PHP-FPM Worker Pool Tuning

During an exam launch, hundreds of clients query the backend simultaneously. If PHP-FPM runs out of worker processes, requests queue up, resulting in `504 Gateway Timeout` errors.

Edit `/etc/php/8.x/fpm/pool.d/www.conf`:

```ini
; Use dynamic or static process manager
pm = dynamic

; Formula: Available RAM for PHP / 35MB per process
; For an 8 GB server allocating 5 GB to PHP: ~140 workers
pm.max_children = 120
pm.start_servers = 24
pm.min_spare_servers = 12
pm.max_spare_servers = 36

; Recycle workers to prevent memory leaks
pm.max_requests = 1000

; Request timeout guard
request_terminate_timeout = 180s
```

### PHP OPcache Configuration

OPcache stores compiled PHP bytecode in shared memory, reducing CPU overhead by up to 70%:

Edit `/etc/php/8.x/fpm/conf.d/10-opcache.ini`:

```ini
opcache.enable = 1
opcache.enable_cli = 0
opcache.memory_consumption = 256
opcache.interned_strings_buffer = 16
opcache.max_accelerated_files = 20000

; In production, disable timestamp validation for max speed
; (Requires a PHP-FPM reload after code deployments)
opcache.validate_timestamps = 0
opcache.revalidate_freq = 0
opcache.save_comments = 1
```

### MySQL / MariaDB Optimization

Edit `/etc/mysql/my.cnf` (or `/etc/mysql/mariadb.conf.d/50-server.cnf`):

```ini
[mysqld]
# Allocate 60-70% of dedicated DB RAM to InnoDB buffer pool
innodb_buffer_pool_size = 6G
innodb_buffer_pool_instances = 4

# Increase concurrent connections for CBT peaks
max_connections = 500
max_user_connections = 450

# Log buffer and commit flushing
innodb_log_file_size = 512M
innodb_log_buffer_size = 64M

# Flush log once per second (massive I/O reduction during heavy exam writes)
innodb_flush_log_at_trx_commit = 2

# Table cache
table_open_cache = 4000
open_files_limit = 65535
```

Restart MySQL:
```bash
sudo systemctl restart mariadb
```

### Session Management & Clustering

* **Database-Backed Sessions (`TCExamSessionHandler`)**:
  TCExam stores candidate sessions in the `tce_sessions` table in MySQL rather than local filesystem files.
* **No Sticky Sessions Needed**:
  Because sessions live in the central database, you can place 2, 4, or 10 web servers behind an Nginx or HAProxy load balancer using standard round-robin or least-connections balancing without candidates losing their place.
* **Shared Media**:
  Ensure uploaded question media (`cache/` and user upload paths) is shared across nodes using an NFS share, AWS EFS, or directory junctions.

---

## 7. Production Security & Hardening Checklist

Before launching live examinations:

- [ ] **Remove or Block `/install/`**: Ensure `/install/` cannot be reached from the public web.
- [ ] **Default Passwords Changed**: The default `admin` password must be updated immediately upon installation.
- [ ] **Rotate Security Key**: Ensure `K_RANDOM_SECURITY` is customized to a strong, unique 64-character secret.
- [ ] **Answer Key Protection**: Verify `define('K_RESTRICT_ANSWER_KEYS', true);` is enabled in `shared/config/tce_config.php`.
- [ ] **HTTPS Enforced**: All HTTP requests redirect to HTTPS; HSTS header enabled.
- [ ] **Cookie Security**: `K_COOKIE_SECURE = true` and `K_COOKIE_HTTPONLY = true`.
- [ ] **Database Access Restricted**: MySQL listens only on `127.0.0.1` or private VPC IP, not on public interfaces.
- [ ] **Directory Permissions**: Code files owned by `root`, web server has write access only to `cache/` and backup paths.
- [ ] **Error Suppression**: `display_errors = Off` in `php.ini` so database schemas and traces are never displayed to candidates.

---

## 8. Automated Backups & Disaster Recovery

### Automated Database Backup Script

Create `/usr/local/bin/tcexam-backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/var/backups/tcexam"
DATE=$(date +'%Y-%m-%d_%H%M%S')
DB_USER="tcexam_user"
DB_PASS="StrongRandomProductionPassword!2026"
DB_NAME="tcexam"

mkdir -p "$BACKUP_DIR"

# Dump database with consistent transaction snapshot
mysqldump --single-transaction --quick --routines \
    -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_DIR/tcexam_db_$DATE.sql.gz"

# Retain backups for 30 days
find "$BACKUP_DIR" -type f -name "tcexam_db_*.sql.gz" -mtime +30 -delete

# Optional: Sync to remote S3 or offsite server
# aws s3 cp "$BACKUP_DIR/tcexam_db_$DATE.sql.gz" s3://your-backup-bucket/tcexam/
```

Make executable and add to crontab:
```bash
sudo chmod +x /usr/local/bin/tcexam-backup.sh
sudo crontab -e
```

Add nightly cron job (e.g. at 02:00 AM):
```cron
0 2 * * * /usr/local/bin/tcexam-backup.sh > /dev/null 2>&1
```

### Rapid Disaster Recovery Procedure
To restore from backup on a clean server:

```bash
gunzip < /var/backups/tcexam/tcexam_db_YYYY-MM-DD.sql.gz | mysql -u tcexam_user -p tcexam
```

---

## 9. Pre-Exam Load Testing & Health Monitoring

### Health Check Endpoints
Configure external uptime monitors (Uptime Kuma, Pingdom, Datadog):
* **Lightweight Liveness**: `GET https://exam.yourdomain.com/health.txt` (returns `OK`, 0 ms latency, no DB overhead).
* **Deep System & Database Health**: `GET https://exam.yourdomain.com/admin/code/tce_page_info.php` (verifies PHP and database connectivity).

### Pre-Exam Synthetic Load Testing
Before administering high-stakes exams, simulate concurrent load using **Apache Bench** (`ab`) or **k6**:

```bash
# Test 200 concurrent requests against candidate portal
ab -n 5000 -c 200 https://exam.yourdomain.com/public/code/index.php
```

Ensure:
- 0 failed requests.
- 95th percentile response time is under **500 ms**.
- Server CPU load average remains below total vCPU count.

---

*TCExam Production Guide — Engineered for reliable, high-integrity computer-based assessment delivery.*
