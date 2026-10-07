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
4. [Docker & Containerized Deployment](#4-docker--containerized-deployment)
5. [Windows Server Production Setup](#5-windows-server-production-setup)
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

## 4. Docker & Containerized Deployment

For teams deploying on Kubernetes, AWS ECS, or Docker Swarm:

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
    image: mariadb:10.11
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: RootDatabasePassword123!
      MYSQL_DATABASE: tcexam
      MYSQL_USER: tcexam_user
      MYSQL_PASSWORD: AppDatabasePassword123!
    volumes:
      - db_data:/var/lib/mysql
      - ./install/mysql_db_structure.sql:/docker-entrypoint-initdb.d/01_structure.sql:ro
      - ./install/db_data.sql:/docker-entrypoint-initdb.d/02_data.sql:ro
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  app:
    build: .
    restart: always
    depends_on:
      - db
    volumes:
      - ./cache:/var/www/tcexam/cache
      - ./shared/config:/var/www/tcexam/shared/config
      - ./admin/backup:/var/www/tcexam/admin/backup
    environment:
      DB_HOST: db
      DB_NAME: tcexam
      DB_USER: tcexam_user
      DB_PASS: AppDatabasePassword123!

  web:
    image: nginx:alpine
    restart: always
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - app
    volumes:
      - ./:/var/www/tcexam:ro
      - ./docker/nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./docker/certs:/etc/nginx/certs:ro

volumes:
  db_data:
```

---

## 5. Windows Server Production Setup

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
