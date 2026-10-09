# TCExam Showcase Seed Data

This directory contains a complete, production-ready showcase seed package for **TCExam**. It allows developers, administrators, and evaluators to instantly populate a TCExam instance with realistic educational curriculum, users across all permission tiers, and pre-configured certification exams.

---

## 1. File Inventory

| File | Format | Target Destination / Purpose |
|---|---|---|
| `users_seed.tsv` | TSV | Admin Web UI: **Users → Import Users** (Select TSV) |
| `users_seed.csv` | CSV | Admin Web UI: **Users → Import Users** (Select CSV) |
| `modules_and_questions_seed.tsv` | TSV | Admin Web UI: **Questions → Import Questions** (Select TSV) |
| `modules_and_questions_seed.csv` | CSV | Admin Web UI: **Questions → Import Questions** (Select CSV) |
| `showcase_seed.sql` | SQL | Direct database execution (curriculum, users, groups, tests) |
| `showcase_results_seed.sql` | SQL | Direct database execution (simulated student attempts & analytics) |
| `generate_seed_data.php` | PHP | Standalone generator script to rebuild all seed files |
| `verify_seed_data.php` | PHP | Validation suite asserting all TCExam format invariants |
| `import_seed_cli.php` | PHP | Command-line tool to import the SQL seed into MySQL |

---

## 2. Seeded User Accounts

All seeded accounts are created with the default password: **`Password123!`**

### Administrative, Faculty & Operator Roles

| Username | Name | Level | Capabilities | Assigned Group(s) | Primary Responsibilities |
|---|---|:---:|:---:|---|---|
| `admin_alice` | Alice Vance | 10 | Full (127) | `System Administrators` | Global configuration, backups, full administrative access |
| `manager_linda` | Linda Martinez | 6 | Identity (15) | `Academic Registry` | User & group management, candidate registration |
| `operator_david` | David Proctor | 5 | Operator (7) | `Exam Proctors` | Exam supervision, session tracking, grading review |
| `operator_sarah` | Sarah Jenkins | 5 | Operator (7) | `Exam Proctors` | Exam supervision, results analysis |
| `prof_miller` | Dr. Robert Miller | 3 | Author (3) | `Instructors`, `Computer Science Faculty` | Authoring CS questions, subjects, and modules |
| `prof_chen` | Dr. Emily Chen | 3 | Author (3) | `Instructors`, `Computer Science Faculty` | Authoring algorithms and database questions |
| `prof_garcia` | Dr. Carlos Garcia | 3 | Author (3) | `Instructors`, `Cybersecurity Faculty` | Authoring security and network questions |

### Candidate / Student Accounts (Level 1)

| Cohort / Group | Usernames | Default Password |
|---|---|---|
| **`CS101-Morning`** | `alex.taylor`, `brenda.wright`, `kevin.patel`, `maria.santos`, `james.wilson` | `Password123!` |
| **`CS101-Evening`** | `sophia.kim`, `daniel.novak`, `fatima.zahra`, `lucas.silva`, `olivia.brown` | `Password123!` |
| **`CyberSec-Cohort-A`** | `marcus.vance`, `priya.sharma`, `elena.rostova`, `tariq.mansoor` | `Password123!` |

---

## 3. Curriculum & Question Bank Structure

The seed package creates **3 comprehensive modules**, **7 subjects/topics**, **42 questions**, and **168 answers** with full explanations and rotating correct positions:

```
├── Computer Science & Web Engineering
│   ├── Web Protocols & Client-Server Architecture (6 Qs: 4 Single-Choice, 2 Multi-Choice)
│   ├── Database Engineering & Relational SQL (6 Qs: 4 Single-Choice, 2 Multi-Choice)
│   └── Data Structures & Algorithmic Complexity (6 Qs: 4 Single-Choice, 2 Multi-Choice)
│
├── Cybersecurity & Network Defense
│   ├── Network Security & Cryptographic Foundations (6 Qs: 4 Single-Choice, 2 Multi-Choice)
│   └── Application Security & OWASP Top 10 (6 Qs: 4 Single-Choice, 2 Multi-Choice)
│
└── Cloud Infrastructure & DevOps Practices
    ├── Containerization & Docker Fundamentals (6 Qs: 4 Single-Choice, 2 Multi-Choice)
    └── CI/CD Automation & Version Control (Git) (6 Qs: 4 Single-Choice, 2 Multi-Choice)
```

---

## 4. Pre-configured Showcase Exams (Included in `showcase_seed.sql`)

When using the SQL seed, three ready-to-take exams are automatically configured and assigned to the student cohorts:

| Test Name | Duration | Questions | Passing Score | Authorized Groups |
|---|:---:|:---:|:---:|---|
| **CS101: Web & Database Engineering Certification Exam** | 45 min | 12 | 70% (8.4 / 12) | `CS101-Morning`, `CS101-Evening` |
| **SEC201: Cybersecurity Fundamentals & Network Defense** | 40 min | 12 | 75% (9.0 / 12) | `CyberSec-Cohort-A` |
| **OPS301: Cloud Infrastructure & DevOps Readiness** | 30 min | 12 | 70% (8.4 / 12) | `CS101-Morning`, `CS101-Evening`, `CyberSec-Cohort-A` |

---

## 5. Simulated Exam Results & Analytics Showcase

The seed package includes **`showcase_results_seed.sql`**, which generates **14 completed student attempts** across a realistic bell curve, plus **3 ready-to-take candidate sessions** for demonstrating live exam execution:

### Candidate Performance & Grade Distribution

#### 1. CS101: Web & Database Engineering Certification Exam
*Passing threshold: 70% (8.4 / 12 points) | Duration: 45 min*

| Candidate | Cohort | Score | % | Status | Duration |
|---|---|:---:|:---:|:---:|:---:|
| `sophia.kim` | `CS101-Evening` | 12 / 12 | 100.0% | **PASSED** (Honors) | 24 min |
| `alex.taylor` | `CS101-Morning` | 11 / 12 | 91.7% | **PASSED** (Honors) | 28 min |
| `daniel.novak` | `CS101-Evening` | 10 / 12 | 83.3% | **PASSED** | 35 min |
| `fatima.zahra` | `CS101-Evening` | 10 / 12 | 83.3% | **PASSED** | 31 min |
| `brenda.wright` | `CS101-Morning` | 9 / 12 | 75.0% | **PASSED** | 38 min |
| `maria.santos` | `CS101-Morning` | 9 / 12 | 75.0% | **PASSED** | 40 min |
| `kevin.patel` | `CS101-Morning` | 7 / 12 | 58.3% | **FAILED** | 42 min |
| `lucas.silva` | `CS101-Evening` | 6 / 12 | 50.0% | **FAILED** | 44 min |
| `james.wilson` | `CS101-Morning` | — | — | *Ready to Take (Status 0)* | — |
| `olivia.brown` | `CS101-Evening` | — | — | *Ready to Take (Status 0)* | — |

*Summary Statistics: 75% Pass Rate (6/8 passed), Mean: 9.25 / 12 (77.1%), Median: 9.5 / 12, StdDev: 1.83*

#### 2. SEC201: Cybersecurity Fundamentals & Network Defense
*Passing threshold: 75% (9.0 / 12 points) | Duration: 40 min*

| Candidate | Cohort | Score | % | Status | Duration |
|---|---|:---:|:---:|:---:|:---:|
| `priya.sharma` | `CyberSec-Cohort-A` | 12 / 12 | 100.0% | **PASSED** (Honors) | 22 min |
| `marcus.vance` | `CyberSec-Cohort-A` | 11 / 12 | 91.7% | **PASSED** (Honors) | 26 min |
| `elena.rostova` | `CyberSec-Cohort-A` | 8 / 12 | 66.7% | **FAILED** | 37 min |
| `tariq.mansoor` | `CyberSec-Cohort-A` | — | — | *Ready to Take (Status 0)* | — |

*Summary Statistics: 66.7% Pass Rate (2/3 passed), Mean: 10.33 / 12 (86.1%)*

#### 3. OPS301: Cloud Infrastructure & DevOps Readiness
*Passing threshold: 70% (8.4 / 12 points) | Duration: 30 min*

| Candidate | Cohort | Score | % | Status | Duration |
|---|---|:---:|:---:|:---:|:---:|
| `marcus.vance` | `CyberSec-Cohort-A` | 12 / 12 | 100.0% | **PASSED** (Honors) | 16 min |
| `alex.taylor` | `CS101-Morning` | 10 / 12 | 83.3% | **PASSED** | 19 min |
| `daniel.novak` | `CS101-Evening` | 9 / 12 | 75.0% | **PASSED** | 25 min |

*Summary Statistics: 100% Pass Rate (3/3 passed), Mean: 10.33 / 12 (86.1%)*

### Analytics & Reporting Walkthrough

1. **Test Summary & Group Analytics** (`admin/code/tce_show_result_allusers.php`):
   - Log in as `admin_alice` or `operator_david` (`Password123!`).
   - Navigate to **Results → All Users**.
   - Select **CS101: Web & Database Engineering Certification Exam** and click **Select**.
   - View the overall pass rate (75%), mean, median, standard deviation, and ranked candidate table.
2. **Individual Candidate Scorecard & PDF Certificate** (`admin/code/tce_show_result_user.php`):
   - From the results table, click any candidate's number or name (e.g. `sophia.kim` or `alex.taylor`).
   - Inspect question-by-question breakdown, candidate answer selections, and reaction times.
   - Click the **PDF** button to generate and download the official scorecard certificate.
3. **Candidate Self-Service Portal** (`public/code/index.php`):
   - Log in as candidate `sophia.kim` (`Password123!`).
   - Go to **Results** to view her official 100% score and review test questions.
4. **Live Exam Execution Demo**:
   - Log in as candidate `james.wilson` (`Password123!`).
   - His CS101 exam status is `0 (Assigned)`. Click **Execute** on CS101 to take the exam in real-time.

---

## 6. How to Import the Seed Data

### Option A: 1-Click Maintainer Scripts (Recommended for Docker / Production)

From the `offline-deployment/` directory:

```powershell
# Windows
.\seed-database.bat

# Linux / macOS
./seed-database.sh
```

The script interactively asks whether to include simulated candidate attempts and analytics (default: `Y`), or accepts `--with-results` / `--curriculum-only` arguments.

### Option B: CLI Importer (`import_seed_cli.php`)

```powershell
# Import curriculum and pre-configured exams
php seed_data/import_seed_cli.php

# Import curriculum AND simulated student attempts / analytics
php seed_data/import_seed_cli.php --with-results

# Add simulated results to an existing database
php seed_data/import_seed_cli.php --results-only
```

### Option C: Direct MySQL / Docker CLI Execution

```bash
# 1. Load curriculum and exams
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < seed_data/showcase_seed.sql

# 2. Load simulated attempts and analytics
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < seed_data/showcase_results_seed.sql
```

### Option D: Web UI Import (Curriculum and users only)

1. **Users**: Admin Web UI → **Users → Import Users** → Upload `users_seed.tsv` or `users_seed.csv`.
2. **Questions**: Admin Web UI → **Questions → Import Questions** → Upload `modules_and_questions_seed.tsv` or `modules_and_questions_seed.csv`.

---

## 7. Verification & Automated Tests

To verify that all seed files satisfy parser constraints and data integrity invariants:

```powershell
# Run the seed validator (verifies all TSV, CSV, and SQL files)
php seed_data/verify_seed_data.php

# Run the test suite regression check
php test/showcase_seed_integrity.php

# Run Docker configuration and maintainer script tests
php test/test_docker_configuration_integrity.php
```

All test suites return exit code `0` with all assertions passing.

