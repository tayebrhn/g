# TCExam Production Offline Server Deployment Guide

This package provides a **100% self-contained, air-gapped production deployment** for TCExam. It is pre-configured for dedicated exam centers, local area networks, or portable test servers with **zero internet connection required**.

---

## What Is Inside This Folder

| File / Folder | Purpose |
|---|---|
| `tcexam-offline-bundle.tar` | Pre-packaged Docker images (`tcexam-app:latest`, `nginx:alpine`, `mariadb:10.11`). No internet downloads or building needed. |
| `docker-compose.yml` | Production container orchestration configured for high reliability and zero external dependencies. |
| `nginx/default.conf` | Production reverse proxy, security filters, caching, and FastCGI timeouts. |
| `.env.example` | Production environment defaults (ports 80 and 8080, security secrets). |
| `start-production.bat` | **Windows 1-Click Launcher** (loads images, creates `.env`, starts cluster, verifies health). |
| `start-production.sh` | **Linux 1-Click Launcher** (loads images, creates `.env`, starts cluster, verifies health). |
| `apply-patch.bat` / `.sh` | **1-Click Patch & Update Utility** (takes pre-patch backup, loads new image, recreates containers with zero data loss). |
| `stop-production.bat` / `.sh` | Gracefully shuts down all services. |
| `backup-database.bat` / `.sh` | 1-click snapshot of the exam database into a dated `.sql` backup file. |

---

## 1. Prerequisites on the Offline Server

- **Docker Desktop** (for Windows) OR **Docker Engine + Docker Compose** (for Linux).
- Ensure Docker is running.
- **No internet connection is required.**

---

## 2. Deploying & Starting TCExam

### Option A: Windows Server / Exam Laptop
Simply double-click:
```cmd
start-production.bat
```

### Option B: Linux Server (Ubuntu, Debian, RHEL, Rocky)
Make the script executable and run:
```bash
chmod +x *.sh
./start-production.sh
```

### What Happens Automatically:
1. Docker checks if images are loaded; if not, it automatically imports `tcexam-offline-bundle.tar` (`docker load`).
2. Generates `.env` from `.env.example` if not already present.
3. Boots MariaDB, PHP-FPM, and Nginx in the background (`restart: always`).
4. On the very first launch, MariaDB is automatically populated with the full TCExam database schema and initial data.
5. Verifies health checks and displays the access URLs.

---

## 3. Accessing the System

Once started, open your web browser:

| Portal | URL | Credentials |
|---|---|---|
| **Candidate Portal (Port 80)** | `http://localhost/public/code/index.php` | Public candidate access |
| **Alternative Port (Port 8080)** | `http://localhost:8080/public/code/index.php` | Fallback if port 80 is occupied |
| **Administrator Suite** | `http://localhost/admin/code/index.php` | **User:** `admin`<br>**Password:** `1234` |

> **Note:** The server listens simultaneously on both **Port 80** and **Port 8080**, so typing either `http://localhost/public/code/index.php` or `http://localhost:8080/public/code/index.php` connects seamlessly.

---

## 4. Customizing Network Ports (Zero Rebuilding Required)

By default, the server binds to **both Port 80 and Port 8080** simultaneously. If your server already uses port 80 or 8080 for other software (like IIS, Apache, Skype, or another application), you can change the ports in seconds:

1. Open `.env` (or copy `.env.example` to `.env`) in the `offline-deployment/` directory.
2. Edit the port variables:
   ```dotenv
   # Main web port (e.g. 80, 8081, 8888)
   APP_PORT=8888

   # Alternative web port (e.g. 8080, 9090)
   APP_ALT_PORT=9090
   ```
3. Restart or start the server:
   - **Windows:** Double-click `start-production.bat`
   - **Linux:** Run `./start-production.sh`

All startup and patching scripts dynamically read your custom ports and display the updated URLs automatically!

---

## 5. Connecting Candidate PCs in the Exam Room (LAN)

To allow other computers on the local network (Wi-Fi or Ethernet switch) to take exams:

1. Find the server's local IP address:
   - **Windows:** Open command prompt and run `ipconfig` (e.g. `192.168.1.100`)
   - **Linux:** Run `ip a` or `hostname -I`
2. Ensure Windows Firewall or `ufw` permits inbound traffic on your configured port (default 80):
   - **Windows:** Add an inbound rule in Windows Defender Firewall for TCP Port 80 (or your custom `APP_PORT`).
   - **Linux:** Run `sudo ufw allow 80/tcp` (or `sudo ufw allow <APP_PORT>/tcp`).
3. On candidate computers, open the browser and navigate to:
   ```text
   http://<SERVER_IP>/public/code/index.php
   ```
   *(Or `http://<SERVER_IP>:<APP_PORT>/public/code/index.php` if using a non-standard port).*

---

## 6. Daily Operations & Maintenance

### Graceful Shutdown
To stop services cleanly between exam sessions:
- **Windows:** Double-click `stop-production.bat`
- **Linux:** Run `./stop-production.sh`

### Database Backups After Exams
To archive candidate test results, answer sheets, and scores:
- **Windows:** Double-click `backup-database.bat`
- **Linux:** Run `./backup-database.sh`
- All backups are saved to the `backups/` directory as timestamped SQL files (e.g., `backups/tcexam_backup_20261009_143000.sql`).

### Resetting to Fresh Database
To clear all exam data and reset to a clean installation:
```bash
docker compose down -v
```
Then run `start-production.bat` (or `./start-production.sh`) again.

---

## 7. Applying Code Updates & Security Patches

Whenever a new version, bug fix, or security update is released:

1. **Rebuild on Dev Machine**: On an internet-connected development PC, run `.\docker\build-offline-bundle.ps1` (or `./docker/build-offline-bundle.sh` or `make offline-bundle`).
2. **Transfer**: Copy the newly generated `tcexam-offline-bundle.tar` into this server's `offline-deployment/` folder, replacing the older file.
3. **Apply Update (Zero Data Loss)**:
   - **Windows:** Double-click `apply-patch.bat`
   - **Linux:** Run `./apply-patch.sh`

### What the Patch Utility Does:
- Automatically dumps a pre-patch database backup into `backups/`.
- Loads the updated container image into the local Docker engine.
- Recreates the `app` and `web` containers using the new image (`docker compose up -d --force-recreate app web`).
- **Data Safety**: All database tables, questions, user accounts, and test results reside in persistent named volumes (`db_data`) and remain **100% untouched and preserved**.

