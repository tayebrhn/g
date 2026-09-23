# TCExam Import/Export Guide

This guide explains how to move data in and out of TCExam using **TSV files** (Tab-Separated Values). A TSV file is a plain text file where each line is a row of data and columns are separated by tab characters — the same thing your spreadsheet program uses when you copy and paste cells.

TSV files open directly in Microsoft Excel, Google Sheets, and LibreOffice Calc, so you can bulk-edit questions or users in a spreadsheet and load them back into TCExam.

---

## 1. Questions

### 1.1 Exporting questions

Use exporting to back up your question bank, share it with another TCExam installation, or make bulk edits in a spreadsheet.

1. Log in to the **admin area**.
2. Go to **Questions → Show All Questions**.
3. Click one of the **TSV** buttons above the list:
   - **TSV** — only the currently selected topic
   - **TSV Module** — the whole module
   - **TSV All** — every module
4. Your browser downloads a `.tsv` file. Keep the `.tsv` extension — do not rename it to `.txt` or `.xls`.

### 1.2 Understanding the exported file

Open the file in your spreadsheet program (see section 4 for how). The first four lines are **column headers** — the importer ignores them, so leave them alone. Every line after that describes one item and starts with a single letter:

| First column | Meaning | What the rest of the line holds |
|---|---|---|
| `M` | A module | enabled, name |
| `S` | A topic inside the last module | enabled, name, description |
| `Q` | A question inside the last topic | enabled, description, explanation, type, difficulty, position, timer, and other display options |
| `A` | An answer to the last question | enabled, description, explanation, correct/incorrect, position, keyboard key |

Lines must appear in order: a module before its topics, topics before their questions, questions before their answers. When you add new content in a spreadsheet, keep that nesting in mind — a `Q` line always belongs to the `S` line above it, and so on.

**Columns for `Q` lines:**

| Column | What to enter |
|---|---|
| enabled | `1` = active, `0` = hidden |
| description | The question text |
| explanation | Shown after answering (may be empty) |
| type | `S` = single choice, `M` = multiple choice, `T` = true/false, `O` = ordering |
| difficulty | A number from 1 to 5 |
| position | Sort order (may be empty) |
| timer | Seconds to answer (0 = no limit) |
| fullscreen, inline answers, auto next | `1` = on, `0` = off |

**Columns for `A` lines:**

| Column | What to enter |
|---|---|
| enabled | `1` = active, `0` = hidden |
| description | The answer text |
| explanation | Optional feedback for this answer |
| is right | `1` = correct answer, `0` = wrong answer |
| position | Display order of the answers |
| keyboard key | Optional shortcut key (e.g. `A`, `B`) |

> **True/false questions** still need their two answers written as `A` lines, with `1` on the correct one.

### 1.3 Importing questions

1. Log in to the **admin area**.
2. Go to **Questions → Import Questions**.
3. Make sure **TSV** is the selected format.
4. Click **Browse** and pick your `.tsv` file.
5. Click **send**.

**What happens on import:**

- Modules and topics that **already exist** (same name) are reused — no duplicates are created.
- Questions and answers that already exist are **skipped**.
- Because of this, importing the same file twice is safe. To *change* an existing question, edit it in the admin area instead — re-importing will not update it.

**Common mistakes to avoid:**

- Removing the four header lines at the top (the importer tolerates this, but keeping them documents your columns).
- Typing the type letters in lowercase — use capital `S`, `M`, `T`, `O`.
- Putting an `A` line before its `Q` line, or a `Q` line before its `S` line.
- Adding blank lines in the middle of the file — they are ignored, but a line with only spaces is not.

---

## 2. Users

### 2.1 Exporting users

1. Log in to the **admin area**.
2. Go to the **user selection** page and run a search (leave the search box empty to list everyone you are allowed to see).
3. Click the **TSV** button.
4. Your browser downloads a file listing every matching user, one per line.

**Columns in the exported file:**

| Column | Meaning |
|---|---|
| user_id | Internal ID number |
| user_name | Login name |
| user_password | Always **blank** — passwords cannot be exported |
| user_email | Email address |
| user_regdate | Registration date/time |
| user_ip | IP address used at registration |
| user_firstname, user_lastname | Real name |
| user_birthdate, user_birthplace | Profile information |
| user_regnumber, user_ssn | Registration number / ID number |
| user_level | Numeric access level |
| user_verifycode, user_otpkey | Verification and two-factor fields |
| user_groups | Group names, separated by commas |

### 2.2 Importing users

Use importing to create many accounts at once (for example, a new class of students) instead of typing them one by one.

1. Prepare your file: export users once (as above) to get a correctly structured file, then edit it in a spreadsheet — or build a new file using the same columns, with a header line first.
2. Go to **Users → Import Users** in the admin area.
3. Select **TSV** as the format.
4. Click **Browse**, pick your file, and click **send**.

**Rules:**

- The **first line is treated as a header** and skipped — always keep it.
- The password column is ignored. New accounts must use password recovery or a password set by an administrator.
- A user is matched by **username, registration number, or SSN**. If one matches an existing account, the account is **updated** instead of duplicated.
- Groups listed in the last column are created if they do not exist, and the user is added to them.
- If you are not a full administrator, you can only import users into your own groups and at a lower access level than your own.

---

## 3. Test results

Results are **export only** — you cannot import them back.

1. Go to the **results page** for the test you are interested in.
2. Filter by group, user, or date range if you want a smaller file.
3. Click the **TSV** button.
4. The download contains:
   - A summary table with one line per user and their scores.
   - If several users took the test, a `<<< DETAILS >>>` marker followed by a detailed per-user breakdown (each section starts with `### USER <id>`).

Open it in your spreadsheet program to grade on paper or archive it.

---

## 4. Editing TSV files in a spreadsheet

### 4.1 Opening the file

| Program | How |
|---|---|
| **Microsoft Excel** | Double-click the `.tsv` file, or drag it onto an open Excel window. Excel recognises the tab separator automatically. |
| **Google Sheets** | File → Import → Upload, then choose **Tab** as the separator. |
| **LibreOffice Calc** | Double-click the file; confirm **Tab** in the delimiter dialog. |

### 4.2 Saving your changes

Always save back as a **tab-delimited text file**:

- **Excel:** File → Save As → format **Text (Tab delimited) (*.txt)** is *not* what you want; instead choose **Unicode Text (*.txt)** or rename the file back to `.tsv` afterwards. The simplest option is **Text (Tab delimited)** — if Excel names it `.txt`, just rename the extension to `.tsv` before importing. When Excel warns about format features, click **Yes** to keep the tab-delimited format.
- **Google Sheets:** File → Download → **Tab-separated values (.tsv)**.
- **LibreOffice Calc:** File → Save As → file type **Text CSV**, then set the field delimiter to **{Tab}** and rename the extension to `.tsv`.

> Never save as **Excel Workbook (.xlsx)** — TCExam cannot read it.

### 4.3 Spreadsheet pitfalls

Spreadsheets sometimes "helpfully" reformat your data and break it silently:

- **Question text like `3+4` or `1/2`** may be turned into a formula or a date. Before typing, select those columns and set their cell format to **Text**.
- **Leading zeros** (e.g. ID numbers like `007`) are stripped as numbers. Format the column as Text first.
- **Multi-line text**: press Alt+Enter inside a cell instead of the Tab key; a raw line break inside the file will split one row into two broken rows.
- **Empty trailing cells** in a line are fine — TCExam preserves them.

---

## 5. Frequently asked questions

**Can I import the same file more than once?**
Yes, for questions. Existing questions and answers are skipped, so nothing is duplicated. Users, however, are *updated* if a username/regnumber/SSN matches, so re-importing does apply your edits there.

**Can I import questions into a specific module?**
Yes — modules and topics in the file are matched **by name**. If the name already exists, the questions go into it; if not, it is created.

**Why were some of my questions skipped?**
A question with exactly the same text already exists in that topic. Change the wording slightly, or delete the old one first.

**Can I move questions between TCExam servers?**
Yes. Export with **TSV All**, then import the file on the other server.

**My import fails with no error. What did I break?**
Check that: every data line still starts with `M`, `S`, `Q`, or `A`; the file was saved as tab-delimited text (not .xlsx); and no line lost or gained columns compared to the header rows.

**What is the difference between the buttons TSV, TSV Module and TSV All?**
They control **how much** is exported: the current topic, the entire module, or the whole question bank. The file format is identical.
