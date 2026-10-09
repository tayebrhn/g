<?php
/**
 * Showcase Seed Data Generator for TCExam
 *
 * Generates ready-to-import TSV and CSV files, as well as a direct SQL seed,
 * for showcasing TCExam with rich educational data:
 * - Users with varying roles (Administrators, Authors, Operators, Candidates)
 * - User groups / cohorts
 * - Modules, Subjects, Single-Choice and Multiple-Choice Questions with explanations
 * - Ready-to-take Certification Exams with topic assignments and group permissions
 *
 * Usage:
 *   php seed_data/generate_seed_data.php
 */

declare(strict_types=1);

require_once __DIR__ . '/../shared/code/tce_functions_general.php';
require_once __DIR__ . '/../shared/code/tce_auth_caps.php';

echo "Generating TCExam showcase seed data...\n";

// =============================================================================
// 1. DATA DEFINITIONS
// =============================================================================

$defaultPassword = 'Password123!';
$passwordHash = password_hash($defaultPassword, PASSWORD_BCRYPT, ['cost' => 10]);

// Ensure hash works
if (!password_verify($defaultPassword, $passwordHash)) {
    throw new RuntimeException("Generated hash failed verification");
}

// User groups
$groups = [
    'System Administrators'    => 'System Administrators with full access',
    'Academic Registry'        => 'Identity managers and registrar staff',
    'Exam Proctors'            => 'Test supervisors and examiners',
    'Instructors'              => 'Teaching faculty and question authors',
    'Computer Science Faculty' => 'CS department course staff',
    'Cybersecurity Faculty'    => 'Cybersecurity department course staff',
    'CS101-Morning'            => 'Intro to CS - Morning Cohort',
    'CS101-Evening'            => 'Intro to CS - Evening Cohort',
    'CyberSec-Cohort-A'        => 'Cybersecurity Specialists 2026 Cohort A'
];

// Seed Users
// Columns: user_id, user_name, user_password, user_email, user_regdate, user_ip,
//          user_firstname, user_lastname, user_birthdate, user_birthplace,
//          user_regnumber, user_ssn, user_level, user_verifycode, user_otpkey, user_groups
$users = [
    // Administrators (Level 10)
    [
        'username'   => 'admin_alice',
        'password'   => $defaultPassword,
        'email'      => 'alice.admin@example.com',
        'regdate'    => '2026-01-10 08:30:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Alice',
        'lastname'   => 'Vance',
        'birthdate'  => '1988-04-12',
        'birthplace' => 'San Francisco',
        'regnumber'  => 'ADM-001',
        'ssn'        => 'SSN-ADM-001',
        'level'      => 10,
        'groups'     => ['System Administrators']
    ],
    // Identity Managers (Level 6)
    [
        'username'   => 'manager_linda',
        'password'   => $defaultPassword,
        'email'      => 'linda.registrar@example.com',
        'regdate'    => '2026-01-12 09:15:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Linda',
        'lastname'   => 'Martinez',
        'birthdate'  => '1985-07-22',
        'birthplace' => 'Chicago',
        'regnumber'  => 'REG-001',
        'ssn'        => 'SSN-REG-001',
        'level'      => 6,
        'groups'     => ['Academic Registry']
    ],
    // Test Operators / Proctors (Level 5)
    [
        'username'   => 'operator_david',
        'password'   => $defaultPassword,
        'email'      => 'david.proctor@example.com',
        'regdate'    => '2026-01-15 10:00:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'David',
        'lastname'   => 'Proctor',
        'birthdate'  => '1990-11-05',
        'birthplace' => 'Boston',
        'regnumber'  => 'OPR-001',
        'ssn'        => 'SSN-OPR-001',
        'level'      => 5,
        'groups'     => ['Exam Proctors']
    ],
    [
        'username'   => 'operator_sarah',
        'password'   => $defaultPassword,
        'email'      => 'sarah.examiner@example.com',
        'regdate'    => '2026-01-15 10:30:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Sarah',
        'lastname'   => 'Jenkins',
        'birthdate'  => '1992-03-18',
        'birthplace' => 'Seattle',
        'regnumber'  => 'OPR-002',
        'ssn'        => 'SSN-OPR-002',
        'level'      => 5,
        'groups'     => ['Exam Proctors']
    ],
    // Content Authors / Instructors (Level 3)
    [
        'username'   => 'prof_miller',
        'password'   => $defaultPassword,
        'email'      => 'robert.miller@example.com',
        'regdate'    => '2026-01-18 11:00:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Robert',
        'lastname'   => 'Miller',
        'birthdate'  => '1979-09-14',
        'birthplace' => 'New York',
        'regnumber'  => 'FAC-CS-001',
        'ssn'        => 'SSN-FAC-001',
        'level'      => 3,
        'groups'     => ['Instructors', 'Computer Science Faculty']
    ],
    [
        'username'   => 'prof_chen',
        'password'   => $defaultPassword,
        'email'      => 'emily.chen@example.com',
        'regdate'    => '2026-01-18 11:30:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Emily',
        'lastname'   => 'Chen',
        'birthdate'  => '1984-12-03',
        'birthplace' => 'Austin',
        'regnumber'  => 'FAC-CS-002',
        'ssn'        => 'SSN-FAC-002',
        'level'      => 3,
        'groups'     => ['Instructors', 'Computer Science Faculty']
    ],
    [
        'username'   => 'prof_garcia',
        'password'   => $defaultPassword,
        'email'      => 'carlos.garcia@example.com',
        'regdate'    => '2026-01-18 12:00:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Carlos',
        'lastname'   => 'Garcia',
        'birthdate'  => '1981-06-27',
        'birthplace' => 'Miami',
        'regnumber'  => 'FAC-SEC-001',
        'ssn'        => 'SSN-FAC-003',
        'level'      => 3,
        'groups'     => ['Instructors', 'Cybersecurity Faculty']
    ],
    // Candidates - Cohort CS101-Morning (Level 1)
    [
        'username'   => 'alex.taylor',
        'password'   => $defaultPassword,
        'email'      => 'alex.taylor@example.com',
        'regdate'    => '2026-02-01 09:00:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Alex',
        'lastname'   => 'Taylor',
        'birthdate'  => '2004-02-14',
        'birthplace' => 'Denver',
        'regnumber'  => 'STU-2026-101',
        'ssn'        => 'SSN-STU-101',
        'level'      => 1,
        'groups'     => ['CS101-Morning']
    ],
    [
        'username'   => 'brenda.wright',
        'password'   => $defaultPassword,
        'email'      => 'brenda.wright@example.com',
        'regdate'    => '2026-02-01 09:05:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Brenda',
        'lastname'   => 'Wright',
        'birthdate'  => '2003-08-21',
        'birthplace' => 'Atlanta',
        'regnumber'  => 'STU-2026-102',
        'ssn'        => 'SSN-STU-102',
        'level'      => 1,
        'groups'     => ['CS101-Morning']
    ],
    [
        'username'   => 'kevin.patel',
        'password'   => $defaultPassword,
        'email'      => 'kevin.patel@example.com',
        'regdate'    => '2026-02-01 09:10:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Kevin',
        'lastname'   => 'Patel',
        'birthdate'  => '2004-11-30',
        'birthplace' => 'Houston',
        'regnumber'  => 'STU-2026-103',
        'ssn'        => 'SSN-STU-103',
        'level'      => 1,
        'groups'     => ['CS101-Morning']
    ],
    [
        'username'   => 'maria.santos',
        'password'   => $defaultPassword,
        'email'      => 'maria.santos@example.com',
        'regdate'    => '2026-02-01 09:15:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Maria',
        'lastname'   => 'Santos',
        'birthdate'  => '2003-05-19',
        'birthplace' => 'San Diego',
        'regnumber'  => 'STU-2026-104',
        'ssn'        => 'SSN-STU-104',
        'level'      => 1,
        'groups'     => ['CS101-Morning']
    ],
    [
        'username'   => 'james.wilson',
        'password'   => $defaultPassword,
        'email'      => 'james.wilson@example.com',
        'regdate'    => '2026-02-01 09:20:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'James',
        'lastname'   => 'Wilson',
        'birthdate'  => '2004-09-08',
        'birthplace' => 'Dallas',
        'regnumber'  => 'STU-2026-105',
        'ssn'        => 'SSN-STU-105',
        'level'      => 1,
        'groups'     => ['CS101-Morning']
    ],
    // Candidates - Cohort CS101-Evening (Level 1)
    [
        'username'   => 'sophia.kim',
        'password'   => $defaultPassword,
        'email'      => 'sophia.kim@example.com',
        'regdate'    => '2026-02-02 17:00:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Sophia',
        'lastname'   => 'Kim',
        'birthdate'  => '2002-10-11',
        'birthplace' => 'Portland',
        'regnumber'  => 'STU-2026-201',
        'ssn'        => 'SSN-STU-201',
        'level'      => 1,
        'groups'     => ['CS101-Evening']
    ],
    [
        'username'   => 'daniel.novak',
        'password'   => $defaultPassword,
        'email'      => 'daniel.novak@example.com',
        'regdate'    => '2026-02-02 17:05:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Daniel',
        'lastname'   => 'Novak',
        'birthdate'  => '2001-04-25',
        'birthplace' => 'Phoenix',
        'regnumber'  => 'STU-2026-202',
        'ssn'        => 'SSN-STU-202',
        'level'      => 1,
        'groups'     => ['CS101-Evening']
    ],
    [
        'username'   => 'fatima.zahra',
        'password'   => $defaultPassword,
        'email'      => 'fatima.zahra@example.com',
        'regdate'    => '2026-02-02 17:10:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Fatima',
        'lastname'   => 'Zahra',
        'birthdate'  => '2003-01-30',
        'birthplace' => 'Detroit',
        'regnumber'  => 'STU-2026-203',
        'ssn'        => 'SSN-STU-203',
        'level'      => 1,
        'groups'     => ['CS101-Evening']
    ],
    [
        'username'   => 'lucas.silva',
        'password'   => $defaultPassword,
        'email'      => 'lucas.silva@example.com',
        'regdate'    => '2026-02-02 17:15:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Lucas',
        'lastname'   => 'Silva',
        'birthdate'  => '2002-07-16',
        'birthplace' => 'Philadelphia',
        'regnumber'  => 'STU-2026-204',
        'ssn'        => 'SSN-STU-204',
        'level'      => 1,
        'groups'     => ['CS101-Evening']
    ],
    [
        'username'   => 'olivia.brown',
        'password'   => $defaultPassword,
        'email'      => 'olivia.brown@example.com',
        'regdate'    => '2026-02-02 17:20:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Olivia',
        'lastname'   => 'Brown',
        'birthdate'  => '2003-12-05',
        'birthplace' => 'Charlotte',
        'regnumber'  => 'STU-2026-205',
        'ssn'        => 'SSN-STU-205',
        'level'      => 1,
        'groups'     => ['CS101-Evening']
    ],
    // Candidates - Cohort CyberSec-Cohort-A (Level 1)
    [
        'username'   => 'marcus.vance',
        'password'   => $defaultPassword,
        'email'      => 'marcus.vance@example.com',
        'regdate'    => '2026-02-05 08:30:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Marcus',
        'lastname'   => 'Vance',
        'birthdate'  => '2000-06-12',
        'birthplace' => 'Minneapolis',
        'regnumber'  => 'SEC-2026-301',
        'ssn'        => 'SSN-SEC-301',
        'level'      => 1,
        'groups'     => ['CyberSec-Cohort-A']
    ],
    [
        'username'   => 'priya.sharma',
        'password'   => $defaultPassword,
        'email'      => 'priya.sharma@example.com',
        'regdate'    => '2026-02-05 08:35:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Priya',
        'lastname'   => 'Sharma',
        'birthdate'  => '2001-09-28',
        'birthplace' => 'San Jose',
        'regnumber'  => 'SEC-2026-302',
        'ssn'        => 'SSN-SEC-302',
        'level'      => 1,
        'groups'     => ['CyberSec-Cohort-A']
    ],
    [
        'username'   => 'elena.rostova',
        'password'   => $defaultPassword,
        'email'      => 'elena.rostova@example.com',
        'regdate'    => '2026-02-05 08:40:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Elena',
        'lastname'   => 'Rostova',
        'birthdate'  => '1999-03-15',
        'birthplace' => 'Orlando',
        'regnumber'  => 'SEC-2026-303',
        'ssn'        => 'SSN-SEC-303',
        'level'      => 1,
        'groups'     => ['CyberSec-Cohort-A']
    ],
    [
        'username'   => 'tariq.mansoor',
        'password'   => $defaultPassword,
        'email'      => 'tariq.mansoor@example.com',
        'regdate'    => '2026-02-05 08:45:00',
        'ip'         => '127.0.0.1',
        'firstname'  => 'Tariq',
        'lastname'   => 'Mansoor',
        'birthdate'  => '2000-11-20',
        'birthplace' => 'Columbus',
        'regnumber'  => 'SEC-2026-304',
        'ssn'        => 'SSN-SEC-304',
        'level'      => 1,
        'groups'     => ['CyberSec-Cohort-A']
    ]
];

// Modules, Subjects, Questions, Answers
$curriculum = [
    [
        'name'     => 'Computer Science & Web Engineering',
        'enabled'  => 1,
        'subjects' => [
            [
                'name'        => 'Web Protocols & Client-Server Architecture',
                'description' => 'HTTP/HTTPS protocols, RESTful API architecture, browser security, cookies, and CORS.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?',
                        'explanation' => 'HTTP 201 Created indicates successful request completion resulting in the creation of one or more new resources.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => '201 Created', 'right' => 1, 'expl' => 'Correct. 201 specifically signifies new resource creation.'],
                            ['desc' => '200 OK', 'right' => 0, 'expl' => '200 indicates standard success, but not specifically resource creation.'],
                            ['desc' => '204 No Content', 'right' => 0, 'expl' => '204 signifies success with no response body.'],
                            ['desc' => '301 Moved Permanently', 'right' => 0, 'expl' => '301 is a redirection status code.']
                        ]
                    ],
                    [
                        'text'        => 'What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?',
                        'explanation' => 'SOP prevents a script loaded from one origin from accessing document contents or DOM from another origin without authorization.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'To prevent scripts from one origin from reading private DOM data or responses from another origin', 'right' => 1, 'expl' => 'Correct. SOP is a core browser security boundary isolating web origins.'],
                            ['desc' => 'To compress HTTP payloads and optimize network latency', 'right' => 0, 'expl' => 'Payload compression is handled by gzip/brotli encoding, not SOP.'],
                            ['desc' => 'To enforce automatic renewal of TLS/SSL certificates', 'right' => 0, 'expl' => 'Certificate renewal is managed at the server/ACME level.'],
                            ['desc' => 'To synchronize JavaScript variables between client tabs', 'right' => 0, 'expl' => 'Tab synchronization uses BroadcastChannel or localStorage events.']
                        ]
                    ],
                    [
                        'text'        => 'Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?',
                        'explanation' => 'The Access-Control-Allow-Origin response header indicates whether the response can be shared with requesting code from the given origin.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Access-Control-Allow-Origin', 'right' => 1, 'expl' => 'Correct. This header declares permitted client origins.'],
                            ['desc' => 'Content-Security-Policy', 'right' => 0, 'expl' => 'CSP governs resource loading restrictions to prevent XSS.'],
                            ['desc' => 'Strict-Transport-Security', 'right' => 0, 'expl' => 'HSTS enforces HTTPS connections.'],
                            ['desc' => 'X-Frame-Options', 'right' => 0, 'expl' => 'X-Frame-Options controls framing to prevent clickjacking.']
                        ]
                    ],
                    [
                        'text'        => 'How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?',
                        'explanation' => 'Cookies are automatically attached to matching HTTP request headers sent to the server, while localStorage remains strictly on the client until JavaScript accesses it.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client', 'right' => 1, 'expl' => 'Correct. Cookies are sent with HTTP headers; localStorage is never automatically transmitted.'],
                            ['desc' => 'Cookies store up to 50 MB of data, while localStorage stores only 4 KB', 'right' => 0, 'expl' => 'Inverse: Cookies hold ~4KB while localStorage holds ~5-10MB.'],
                            ['desc' => 'localStorage expires as soon as the browser tab closes, while Cookies never expire', 'right' => 0, 'expl' => 'sessionStorage expires on tab close; localStorage persists indefinitely.'],
                            ['desc' => 'Cookies are only accessible over WebSockets, while localStorage works over HTTP', 'right' => 0, 'expl' => 'Cookies are native to standard HTTP requests.']
                        ]
                    ],
                    [
                        'text'        => 'Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)',
                        'explanation' => 'An idempotent HTTP method can be executed multiple times without changing the server outcome beyond the initial execution. GET, PUT, and DELETE are idempotent; POST is not.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'GET', 'right' => 1, 'expl' => 'GET is both safe and idempotent.'],
                            ['desc' => 'PUT', 'right' => 1, 'expl' => 'PUT replaces state; multiple identical PUTs yield the same server state.'],
                            ['desc' => 'DELETE', 'right' => 1, 'expl' => 'DELETE is idempotent; repeating deletion results in the resource being absent.'],
                            ['desc' => 'POST', 'right' => 0, 'expl' => 'POST creates subordinate resources; repeating POST typically creates multiple distinct records.']
                        ]
                    ],
                    [
                        'text'        => 'Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)',
                        'explanation' => 'Content-Security-Policy restricts executable script sources, Strict-Transport-Security enforces HTTPS, and X-Content-Type-Options blocks MIME sniffing.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Content-Security-Policy', 'right' => 1, 'expl' => 'CSP mitigates XSS by restricting allowed script sources.'],
                            ['desc' => 'Strict-Transport-Security', 'right' => 1, 'expl' => 'HSTS enforces encrypted transport and blocks SSL-stripping.'],
                            ['desc' => 'X-Content-Type-Options', 'right' => 1, 'expl' => 'Blocks MIME sniffing attacks by requiring nosniff.'],
                            ['desc' => 'User-Agent', 'right' => 0, 'expl' => 'User-Agent is a client request header identifying the browser software.']
                        ]
                    ]
                ]
            ],
            [
                'name'        => 'Database Engineering & Relational SQL',
                'description' => 'Relational database schema design, indexing, transactions, ACID properties, and JOIN operations.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'Which database constraint guarantees that a column contains unique values and cannot store NULL values?',
                        'explanation' => 'A PRIMARY KEY constraint uniquely identifies each record and enforces uniqueness along with an implicit NOT NULL rule.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'PRIMARY KEY', 'right' => 1, 'expl' => 'Correct. Enforces uniqueness and rejects NULL values.'],
                            ['desc' => 'FOREIGN KEY', 'right' => 0, 'expl' => 'FOREIGN KEY enforces referential integrity to another table.'],
                            ['desc' => 'CHECK', 'right' => 0, 'expl' => 'CHECK validates values against a Boolean expression.'],
                            ['desc' => 'DEFAULT', 'right' => 0, 'expl' => 'DEFAULT supplies a fallback value when none is provided.']
                        ]
                    ],
                    [
                        'text'        => 'Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?',
                        'explanation' => 'A LEFT OUTER JOIN preserves every row from the left table regardless of whether a matching record exists in the right table.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'LEFT JOIN (LEFT OUTER JOIN)', 'right' => 1, 'expl' => 'Correct. Returns all left table rows plus matched right rows.'],
                            ['desc' => 'INNER JOIN', 'right' => 0, 'expl' => 'INNER JOIN only returns rows where keys match in both tables.'],
                            ['desc' => 'RIGHT JOIN (RIGHT OUTER JOIN)', 'right' => 0, 'expl' => 'RIGHT JOIN preserves all right table rows.'],
                            ['desc' => 'CROSS JOIN', 'right' => 0, 'expl' => 'CROSS JOIN produces the Cartesian product of both tables.']
                        ]
                    ],
                    [
                        'text'        => 'In relational database transactions, what does the "I" in ACID stand for?',
                        'explanation' => 'ACID stands for Atomicity, Consistency, Isolation, and Durability. Isolation ensures concurrent transactions do not interfere with each other.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Isolation', 'right' => 1, 'expl' => 'Correct. Isolation governs transaction concurrency and visibility levels.'],
                            ['desc' => 'Integrity', 'right' => 0, 'expl' => 'Integrity is a general goal, but "I" stands for Isolation.'],
                            ['desc' => 'Indexation', 'right' => 0, 'expl' => 'Indexing is a performance mechanism, not an ACID property.'],
                            ['desc' => 'Idempotence', 'right' => 0, 'expl' => 'Idempotence is an API and distributed systems concept.']
                        ]
                    ],
                    [
                        'text'        => 'Which tree data structure is most commonly utilized by relational database storage engines for table indexing?',
                        'explanation' => 'B-Tree and B+ Tree structures maintain sorted keys with balanced height, providing logarithmic search, range scan, and insertion performance.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'B-Tree (and B+ Tree)', 'right' => 1, 'expl' => 'Correct. B-Trees minimize disk I/O and support fast equality and range lookups.'],
                            ['desc' => 'Binary Min-Heap', 'right' => 0, 'expl' => 'Heaps are optimized for priority queue extraction (min/max), not search.'],
                            ['desc' => 'Trie (Prefix Tree)', 'right' => 0, 'expl' => 'Tries are used for string autocomplete and dictionary lookups.'],
                            ['desc' => 'Splay Tree', 'right' => 0, 'expl' => 'Splay trees do not guarantee balanced disk block access.']
                        ]
                    ],
                    [
                        'text'        => 'Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)',
                        'explanation' => 'DDL statements define or alter the structure of database objects (CREATE, ALTER, DROP, TRUNCATE). INSERT and UPDATE are DML.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'CREATE TABLE', 'right' => 1, 'expl' => 'DDL command defining schema objects.'],
                            ['desc' => 'ALTER TABLE', 'right' => 1, 'expl' => 'DDL command modifying table structures.'],
                            ['desc' => 'DROP TABLE', 'right' => 1, 'expl' => 'DDL command removing schema objects.'],
                            ['desc' => 'INSERT INTO', 'right' => 0, 'expl' => 'INSERT is a Data Manipulation Language (DML) command.']
                        ]
                    ],
                    [
                        'text'        => 'Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)',
                        'explanation' => 'To achieve 3NF, the relation must already satisfy 2NF, and every non-prime attribute must depend directly and non-transitively on the candidate key.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'The table must be in Second Normal Form (2NF)', 'right' => 1, 'expl' => 'Normal forms are hierarchical; 3NF requires 2NF compliance.'],
                            ['desc' => 'There must be no transitive dependencies of non-key attributes on candidate keys', 'right' => 1, 'expl' => 'Every non-key attribute must depend directly on the key.'],
                            ['desc' => 'Every column must contain at least three foreign keys', 'right' => 0, 'expl' => 'Foreign keys are not required for normalization tiers.'],
                            ['desc' => 'The table must never store numeric values', 'right' => 0, 'expl' => 'Normalization does not dictate data types.']
                        ]
                    ]
                ]
            ],
            [
                'name'        => 'Data Structures & Algorithmic Complexity',
                'description' => 'Asymptotic complexity (Big-O), search and sort algorithms, stacks, queues, and tree structures.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'What is the average time complexity for searching a key in a properly dimensioned Hash Map?',
                        'explanation' => 'Hash maps compute bucket indices via hash functions, achieving constant O(1) time complexity on average.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'O(1)', 'right' => 1, 'expl' => 'Correct. Hash tables offer O(1) average lookup time.'],
                            ['desc' => 'O(log n)', 'right' => 0, 'expl' => 'O(log n) is typical of balanced search trees and binary search.'],
                            ['desc' => 'O(n)', 'right' => 0, 'expl' => 'O(n) represents linear scans and worst-case hash collisions.'],
                            ['desc' => 'O(n log n)', 'right' => 0, 'expl' => 'O(n log n) is standard for comparison-based sorting.']
                        ]
                    ],
                    [
                        'text'        => 'Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?',
                        'explanation' => 'A Queue enqueues elements at the back and dequeues them from the front, ensuring FIFO ordering.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'Queue', 'right' => 1, 'expl' => 'Correct. Queues adhere to First-In, First-Out.'],
                            ['desc' => 'Stack', 'right' => 0, 'expl' => 'Stacks follow Last-In, First-Out (LIFO).'],
                            ['desc' => 'Binary Search Tree', 'right' => 0, 'expl' => 'BSTs order elements hierarchically by key value.'],
                            ['desc' => 'Max-Heap', 'right' => 0, 'expl' => 'Heaps organize elements based on priority ordering.']
                        ]
                    ],
                    [
                        'text'        => 'What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?',
                        'explanation' => 'Binary search halves the remaining candidate space in each comparison, yielding O(log n) worst-case time complexity.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'O(log n)', 'right' => 1, 'expl' => 'Correct. Logarithmic time complexity.'],
                            ['desc' => 'O(1)', 'right' => 0, 'expl' => 'O(1) is the best-case (finding the element at the midpoint immediately).'],
                            ['desc' => 'O(n)', 'right' => 0, 'expl' => 'O(n) is the complexity of linear search.'],
                            ['desc' => 'O(n^2)', 'right' => 0, 'expl' => 'O(n^2) is characteristic of quadratic algorithms like bubble sort.']
                        ]
                    ],
                    [
                        'text'        => 'Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?',
                        'explanation' => 'Merge Sort achieves guaranteed O(n log n) worst-case performance by recursively dividing and merging, while preserving relative order for equal elements.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Merge Sort', 'right' => 1, 'expl' => 'Correct. Merge sort is stable and guarantees O(n log n) in all cases.'],
                            ['desc' => 'Quick Sort', 'right' => 0, 'expl' => 'Quick sort degrades to O(n^2) in the worst case and is unstable in standard form.'],
                            ['desc' => 'Heap Sort', 'right' => 0, 'expl' => 'Heap sort achieves O(n log n) but is not a stable sort.'],
                            ['desc' => 'Selection Sort', 'right' => 0, 'expl' => 'Selection sort runs in O(n^2) time.']
                        ]
                    ],
                    [
                        'text'        => 'Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)',
                        'explanation' => 'AVL trees and Red-Black trees are self-balancing binary search trees that maintain logarithmic height through tree rotations.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'AVL Tree', 'right' => 1, 'expl' => 'AVL trees strictly enforce height balance differences <= 1.'],
                            ['desc' => 'Red-Black Tree', 'right' => 1, 'expl' => 'Red-Black trees use color rules to guarantee balanced depth.'],
                            ['desc' => 'Unbalanced Binary Search Tree', 'right' => 0, 'expl' => 'Standard BSTs can degenerate into linked lists with O(n) height.'],
                            ['desc' => 'Prefix Trie', 'right' => 0, 'expl' => 'Tries are tree structures for string retrieval, not self-balancing BSTs.']
                        ]
                    ],
                    [
                        'text'        => 'Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)',
                        'explanation' => 'Depth-First Search (detecting back-edges using recursion stack states) and Kahn\'s algorithm (topological sorting using in-degrees) can both detect cycles.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Depth-First Search (DFS) with node visitation states (White/Gray/Black)', 'right' => 1, 'expl' => 'A back-edge encountered during DFS indicates a directed cycle.'],
                            ['desc' => 'Kahn\'s Algorithm (Topological Sort with vertex in-degree tracking)', 'right' => 1, 'expl' => 'If topological sort cannot process all vertices, a cycle exists.'],
                            ['desc' => 'Dijkstra\'s Shortest Path Algorithm', 'right' => 0, 'expl' => 'Dijkstra computes single-source shortest paths on weighted graphs.'],
                            ['desc' => 'Huffman Encoding Tree Generation', 'right' => 0, 'expl' => 'Huffman coding creates prefix-free trees for lossless compression.']
                        ]
                    ]
                ]
            ]
        ]
    ],
    [
        'name'     => 'Cybersecurity & Network Defense',
        'enabled'  => 1,
        'subjects' => [
            [
                'name'        => 'Network Security & Cryptographic Foundations',
                'description' => 'Symmetric vs asymmetric encryption, cryptographic hashing, digital certificates, and TLS handshakes.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'What is the essential architectural distinction between symmetric and asymmetric cryptography?',
                        'explanation' => 'Symmetric encryption employs one shared secret key for encryption and decryption. Asymmetric cryptography utilizes mathematically paired public and private keys.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'Symmetric uses one shared secret key; asymmetric uses a public/private key pair', 'right' => 1, 'expl' => 'Correct. Core definition of both cryptographic paradigms.'],
                            ['desc' => 'Symmetric encryption operates only on hardware tokens; asymmetric is software-only', 'right' => 0, 'expl' => 'Both paradigms can run in software or dedicated hardware.'],
                            ['desc' => 'Symmetric algorithms cannot encrypt binary data', 'right' => 0, 'expl' => 'Symmetric ciphers routinely encrypt arbitrary binary streams.'],
                            ['desc' => 'Asymmetric keys are always 64 bits in length', 'right' => 0, 'expl' => 'Asymmetric keys range from 256 bits (ECC) to 4096 bits (RSA).']
                        ]
                    ],
                    [
                        'text'        => 'Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?',
                        'explanation' => 'SHA-256 (part of the SHA-2 family) remains cryptographically secure against collision attacks. MD5 and SHA-1 have proven collision weaknesses.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'SHA-256', 'right' => 1, 'expl' => 'Correct. SHA-256 offers 256-bit collision resistance.'],
                            ['desc' => 'MD5', 'right' => 0, 'expl' => 'MD5 has broken collision resistance and must not be used for security.'],
                            ['desc' => 'SHA-1', 'right' => 0, 'expl' => 'SHA-1 has demonstrated practical collision vulnerabilities.'],
                            ['desc' => 'CRC32', 'right' => 0, 'expl' => 'CRC32 is an error-detecting code, not a cryptographic hash.']
                        ]
                    ],
                    [
                        'text'        => 'Why is it critical to combine a cryptographic salt with user passwords before hashing?',
                        'explanation' => 'Salting introduces a unique pseudorandom value per password, preventing attacks using precomputed rainbow tables and ensuring identical passwords produce distinct hashes.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'To defend against rainbow table lookups and ensure identical passwords produce unique hashes', 'right' => 1, 'expl' => 'Correct. Defeats precomputed dictionary and rainbow table lookups.'],
                            ['desc' => 'To accelerate server password hashing computations', 'right' => 0, 'expl' => 'Salting does not accelerate hashing; key derivation functions are deliberately tuned to be slow.'],
                            ['desc' => 'To allow system administrators to decrypt cleartext passwords for recovery', 'right' => 0, 'expl' => 'Hashes are one-way functions; salting does not enable decryption.'],
                            ['desc' => 'To compress password lengths to fit fixed database column sizes', 'right' => 0, 'expl' => 'Cryptographic hashes already produce fixed-length outputs.']
                        ]
                    ],
                    [
                        'text'        => 'During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?',
                        'explanation' => 'The server presents an X.509 digital certificate digitally signed by a trusted Certificate Authority (CA) whose root certificate resides in the client trust store.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'An X.509 digital certificate issued and signed by a trusted Certificate Authority (CA)', 'right' => 1, 'expl' => 'Correct. CA digital signatures validate the server identity and public key.'],
                            ['desc' => 'The client\'s local MAC address broadcasted over ARP', 'right' => 0, 'expl' => 'MAC addresses only exist on local physical link layers.'],
                            ['desc' => 'The HTTP session cookie set by a previous request', 'right' => 0, 'expl' => 'Session cookies are application-layer artifacts and do not validate TLS endpoints.'],
                            ['desc' => 'The reverse DNS PTR record of the client router', 'right' => 0, 'expl' => 'DNS PTR records are unauthenticated and easily spoofed.']
                        ]
                    ],
                    [
                        'text'        => 'Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)',
                        'explanation' => 'RSA, ECDSA, and Diffie-Hellman are asymmetric algorithms. AES is a symmetric block cipher.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'RSA', 'right' => 1, 'expl' => 'Asymmetric encryption and digital signature algorithm.'],
                            ['desc' => 'ECDSA (Elliptic Curve Digital Signature Algorithm)', 'right' => 1, 'expl' => 'Asymmetric digital signature algorithm based on elliptic curves.'],
                            ['desc' => 'Diffie-Hellman Key Exchange', 'right' => 1, 'expl' => 'Asymmetric protocol for securely establishing shared keys.'],
                            ['desc' => 'AES (Advanced Encryption Standard)', 'right' => 0, 'expl' => 'AES is a symmetric key block cipher.']
                        ]
                    ],
                    [
                        'text'        => 'Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)',
                        'explanation' => 'bcrypt, Argon2id, and PBKDF2 are deliberately designed password hashing algorithms with configurable memory and CPU cost parameters.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'bcrypt', 'right' => 1, 'expl' => 'Features an adaptive cost factor scaling iteration rounds.'],
                            ['desc' => 'Argon2id', 'right' => 1, 'expl' => 'Winner of the Password Hashing Competition; configurable memory and time cost.'],
                            ['desc' => 'PBKDF2', 'right' => 1, 'expl' => 'NIST-approved key derivation function with configurable iteration counts.'],
                            ['desc' => 'MD5', 'right' => 0, 'expl' => 'MD5 is a fast general-purpose hash function unsuitable for passwords.']
                        ]
                    ]
                ]
            ],
            [
                'name'        => 'Application Security & OWASP Top 10',
                'description' => 'SQL injection defenses, Cross-Site Scripting (XSS), CSRF mitigation, and least privilege access controls.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'What is the single most effective primary defense against SQL Injection vulnerabilities in application code?',
                        'explanation' => 'Parameterized queries (prepared statements) ensure user input is treated strictly as data rather than executable SQL syntax.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'Parameterized queries (Prepared Statements) with bound parameters', 'right' => 1, 'expl' => 'Correct. Pre-compiles SQL grammar and treats parameters purely as literals.'],
                            ['desc' => 'Client-side HTML input maxlength attributes', 'right' => 0, 'expl' => 'Client-side constraints are trivially bypassed by intercepting proxies.'],
                            ['desc' => 'Encoding database tables using Base64', 'right' => 0, 'expl' => 'Base64 is an encoding, not an encryption or security defense.'],
                            ['desc' => 'Replacing single quotes with double quotes via regular expressions', 'right' => 0, 'expl' => 'Ad-hoc regex blacklists frequently miss evasion bypasses.']
                        ]
                    ],
                    [
                        'text'        => 'Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?',
                        'explanation' => 'Cross-Site Request Forgery (CSRF) tricks an authenticated browser into submitting unauthorized requests to a vulnerable application.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Cross-Site Request Forgery (CSRF)', 'right' => 1, 'expl' => 'Correct. CSRF exploits automatic transmission of session credentials.'],
                            ['desc' => 'Server-Side Request Forgery (SSRF)', 'right' => 0, 'expl' => 'SSRF induces the backend server to make unauthorized requests.'],
                            ['desc' => 'Buffer Overflow', 'right' => 0, 'expl' => 'Buffer overflow is a memory safety vulnerability.'],
                            ['desc' => 'Directory Traversal', 'right' => 0, 'expl' => 'Directory traversal exploits dot-dot-slash paths to access files.']
                        ]
                    ],
                    [
                        'text'        => 'What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?',
                        'explanation' => 'Stored XSS persists malicious script into database records, which then executes in the browser of any user who views the infected page.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Malicious scripts execute in the context of victim user sessions, allowing cookie theft and account takeover', 'right' => 1, 'expl' => 'Correct. XSS executes attacker JavaScript within the victim\'s trusted browser session.'],
                            ['desc' => 'Attacking code can recompile the server-side PHP binary on disk', 'right' => 0, 'expl' => 'XSS executes in the client browser, not on the server operating system.'],
                            ['desc' => 'Hardware motherboards on client devices suffer permanent physical damage', 'right' => 0, 'expl' => 'XSS is a logical browser scripting vulnerability.'],
                            ['desc' => 'Database indices are automatically wiped after every query', 'right' => 0, 'expl' => 'Database integrity is affected by SQL injection, not XSS.']
                        ]
                    ],
                    [
                        'text'        => 'What is the definition of the "Principle of Least Privilege" in information security architecture?',
                        'explanation' => 'Every subject (user, process, or system) must be granted only the minimum permissions necessary to complete authorized functions.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Granting entities only the minimum privileges essential to perform their authorized functions', 'right' => 1, 'expl' => 'Correct. Minimizes the potential attack surface and blast radius.'],
                            ['desc' => 'Granting full root administrator access to all employees to avoid productivity delays', 'right' => 0, 'expl' => 'Direct violation of security principles.'],
                            ['desc' => 'Disabling password requirements on internal local area networks', 'right' => 0, 'expl' => 'Weakens access controls.'],
                            ['desc' => 'Requiring all servers to run on single-core CPU processors', 'right' => 0, 'expl' => 'Hardware specifications are unrelated to privilege management.']
                        ]
                    ],
                    [
                        'text'        => 'Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)',
                        'explanation' => 'Context-sensitive output encoding, robust Content Security Policies (CSP), and the HttpOnly flag on sensitive cookies protect against XSS exploitation.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Context-aware output escaping and HTML encoding before rendering data', 'right' => 1, 'expl' => 'Neutralizes executable characters like <, >, and quotes in user content.'],
                            ['desc' => 'Enforcing a strict Content-Security-Policy (CSP) restricting inline script execution', 'right' => 1, 'expl' => 'Prevents unauthorized scripts from executing even if injected.'],
                            ['desc' => 'Marking session cookies with the HttpOnly attribute', 'right' => 1, 'expl' => 'Blocks client-side JavaScript (document.cookie) from reading the session token.'],
                            ['desc' => 'Disabling all database foreign key constraints', 'right' => 0, 'expl' => 'Foreign key constraints have no bearing on XSS mitigation.']
                        ]
                    ],
                    [
                        'text'        => 'Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)',
                        'explanation' => 'Multi-factor authentication (MFA), progressive rate limiting/delays, and screening against known breached passwords safeguard authentication endpoints.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Multi-Factor Authentication (MFA / 2FA)', 'right' => 1, 'expl' => 'Requires a secondary factor beyond passwords, stopping credential stuffing.'],
                            ['desc' => 'Rate limiting and progressive login attempt throttling', 'right' => 1, 'expl' => 'Limits automated high-volume guess attempts per IP and account.'],
                            ['desc' => 'Screening passwords against known compromised password databases (HaveIBeenPwned)', 'right' => 1, 'expl' => 'Prevents users from choosing passwords already leaked in breaches.'],
                            ['desc' => 'Logging plaintext passwords into unencrypted server log files', 'right' => 0, 'expl' => 'Severe security vulnerability exposing credentials.']
                        ]
                    ]
                ]
            ]
        ]
    ],
    [
        'name'     => 'Cloud Infrastructure & DevOps Practices',
        'enabled'  => 1,
        'subjects' => [
            [
                'name'        => 'Containerization & Docker Fundamentals',
                'description' => 'Container vs VM architecture, Dockerfiles, volumes, networking, and multi-stage image builds.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?',
                        'explanation' => 'Containers share the host operating system kernel and isolate processes using cgroups and namespaces, whereas VMs run a complete guest OS on top of a hypervisor.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'Containers share the host OS kernel; VMs each run a full guest operating system via a hypervisor', 'right' => 1, 'expl' => 'Correct. Containers are lightweight process isolations sharing the host kernel.'],
                            ['desc' => 'Containers require dedicated physical network cards for each running instance', 'right' => 0, 'expl' => 'Containers use virtual bridge networks created by Docker daemon.'],
                            ['desc' => 'Virtual machines can only run on Linux, while containers run on any device', 'right' => 0, 'expl' => 'Hypervisors run on all major server operating systems.'],
                            ['desc' => 'Containers execute exclusively in volatile RAM and cannot write to disk', 'right' => 0, 'expl' => 'Containers write to copy-on-write storage layers and persistent volumes.']
                        ]
                    ],
                    [
                        'text'        => 'In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?',
                        'explanation' => 'RUN executes commands during image build time to commit new image layers. CMD defines the default command and arguments executed when a container starts.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'RUN executes at build time to create image layers; CMD defines default container runtime execution', 'right' => 1, 'expl' => 'Correct. RUN builds the image; CMD sets the container entry process.'],
                            ['desc' => 'RUN is only executed on Linux hosts; CMD is only executed on Windows hosts', 'right' => 0, 'expl' => 'Both instructions are cross-platform Dockerfile standards.'],
                            ['desc' => 'CMD commits changes to Git; RUN commits changes to Docker Hub', 'right' => 0, 'expl' => 'Neither instruction interacts directly with Git or Docker Hub.'],
                            ['desc' => 'RUN deletes existing layers; CMD restores layers from cache', 'right' => 0, 'expl' => 'Neither instruction manages cache restoration in this manner.']
                        ]
                    ],
                    [
                        'text'        => 'Which mechanism is recommended for persisting database data across Docker container recreation and restarts?',
                        'explanation' => 'Docker Volumes and Bind Mounts store data on host filesystems independently of the container lifecycle, ensuring persistence.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Docker Named Volumes or Bind Mounts', 'right' => 1, 'expl' => 'Correct. Volumes decouple persistent data from container lifetimes.'],
                            ['desc' => 'The ephemeral container writable layer', 'right' => 0, 'expl' => 'The writable layer is destroyed when the container is removed.'],
                            ['desc' => 'Hardcoding data directly into Dockerfile ENV variables', 'right' => 0, 'expl' => 'Environment variables are for configuration, not persistent database storage.'],
                            ['desc' => 'Rebuilding the image on every database write operation', 'right' => 0, 'expl' => 'Impractical and violates immutability principles.']
                        ]
                    ],
                    [
                        'text'        => 'What is the primary operational advantage of multi-stage Docker builds?',
                        'explanation' => 'Multi-stage builds allow developers to use compilers, SDKs, and intermediate tools in early stages, copying only the final compiled artifacts into a lightweight, secure production image.',
                        'type'        => 'S',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'Drastically reducing final production image sizes and attack surface by leaving build tooling behind', 'right' => 1, 'expl' => 'Correct. Compilers and headers are omitted from the minimal runtime image.'],
                            ['desc' => 'Allowing containers to run without an underlying operating system kernel', 'right' => 0, 'expl' => 'Containers always rely on the host operating system kernel.'],
                            ['desc' => 'Enabling containers to bypass network port exposure rules', 'right' => 0, 'expl' => 'Network rules remain governed by the container runtime.'],
                            ['desc' => 'Converting Docker images into virtual floppy disk files', 'right' => 0, 'expl' => 'Unrelated legacy storage technology.']
                        ]
                    ],
                    [
                        'text'        => 'Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)',
                        'explanation' => 'Namespaces provide isolated process, network, user, and mount views. Control Groups (cgroups) meter and enforce limits on CPU, memory, and I/O resources.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Linux Kernel Namespaces (PID, NET, MNT, IPC, UTS, USER)', 'right' => 1, 'expl' => 'Provides view isolation for processes, networks, and filesystems.'],
                            ['desc' => 'Linux Control Groups (cgroups)', 'right' => 1, 'expl' => 'Enforces CPU, memory, disk I/O, and resource consumption boundaries.'],
                            ['desc' => 'Hardware Hypervisor Type-1 firmware', 'right' => 0, 'expl' => 'Bare-metal hypervisors (ESXi, Xen) are used for full VMs, not containers.'],
                            ['desc' => 'Direct BIOS ROM flashing', 'right' => 0, 'expl' => 'BIOS flashing is motherboard firmware maintenance.']
                        ]
                    ],
                    [
                        'text'        => 'Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)',
                        'explanation' => 'docker run creates and starts a container; docker stop halts execution gracefully; docker rm deletes stopped containers.',
                        'type'        => 'M',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'docker run', 'right' => 1, 'expl' => 'Creates and starts a container process.'],
                            ['desc' => 'docker stop', 'right' => 1, 'expl' => 'Sends SIGTERM and gracefully halts container processes.'],
                            ['desc' => 'docker rm', 'right' => 1, 'expl' => 'Removes one or more stopped containers from disk.'],
                            ['desc' => 'docker push-kernel', 'right' => 0, 'expl' => 'Not a valid Docker command.']
                        ]
                    ]
                ]
            ],
            [
                'name'        => 'CI/CD Automation & Version Control (Git)',
                'description' => 'Git branching strategies, commit history hygiene, automated CI/CD pipelines, and semantic versioning.',
                'enabled'     => 1,
                'questions'   => [
                    [
                        'text'        => 'Which Git command creates a new branch and immediately switches your active working tree to it?',
                        'explanation' => 'git checkout -b <name> (or the modern git switch -c <name>) creates the branch and checks it out in a single step.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'git checkout -b <branch-name> (or git switch -c <branch-name>)', 'right' => 1, 'expl' => 'Correct. Combines branch creation and checkout.'],
                            ['desc' => 'git merge --create <branch-name>', 'right' => 0, 'expl' => 'git merge joins branches, it does not create and switch to them.'],
                            ['desc' => 'git push --new-branch <branch-name>', 'right' => 0, 'expl' => 'git push uploads commits to a remote repository.'],
                            ['desc' => 'git commit --branch <branch-name>', 'right' => 0, 'expl' => 'git commit records changes, not branch creation.']
                        ]
                    ],
                    [
                        'text'        => 'What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?',
                        'explanation' => 'git merge ties branch histories together preserving true commit timestamps and producing a merge commit; git rebase moves the branch base, creating a linear history.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'git merge preserves exact history with a merge commit; git rebase rewrites commits linearly on the base branch', 'right' => 1, 'expl' => 'Correct. Merge keeps branch topology; rebase linearizes commit history.'],
                            ['desc' => 'git merge deletes uncommitted files, while git rebase stashes them permanently', 'right' => 0, 'expl' => 'Neither command automatically destroys uncommitted files.'],
                            ['desc' => 'git rebase can only be used on GitHub servers, not locally', 'right' => 0, 'expl' => 'git rebase is a native local Git command.'],
                            ['desc' => 'git merge converts all commits into binary patches', 'right' => 0, 'expl' => 'Git natively stores commits as tree and commit objects.']
                        ]
                    ],
                    [
                        'text'        => 'What is the primary objective of Continuous Integration (CI) in software development teams?',
                        'explanation' => 'CI aims to integrate developer working copies into a shared mainline several times a day, accompanied by automated building and testing to catch regressions early.',
                        'type'        => 'S',
                        'difficulty'  => 1,
                        'answers'     => [
                            ['desc' => 'Frequently merging code into a shared mainline with automated building and testing to surface defects early', 'right' => 1, 'expl' => 'Correct. Early automated defect detection is the hallmark of CI.'],
                            ['desc' => 'Eliminating the requirement for developers to write unit tests', 'right' => 0, 'expl' => 'CI relies heavily on developer-written unit tests to validate builds.'],
                            ['desc' => 'Replacing version control repositories with periodic email attachments', 'right' => 0, 'expl' => 'CI requires automated source control.'],
                            ['desc' => 'Automatically deploying untested code directly to customer servers', 'right' => 0, 'expl' => 'Deploying untested code violates CI/CD quality gates.']
                        ]
                    ],
                    [
                        'text'        => 'According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?',
                        'explanation' => 'SemVer format is MAJOR.MINOR.PATCH. A MAJOR version bump signifies backwards-incompatible breaking API changes.',
                        'type'        => 'S',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'MAJOR (e.g., 1.4.2 -> 2.0.0)', 'right' => 1, 'expl' => 'Correct. MAJOR version changes denote incompatible public API modifications.'],
                            ['desc' => 'MINOR (e.g., 1.4.2 -> 1.5.0)', 'right' => 0, 'expl' => 'MINOR denotes backwards-compatible new functionality.'],
                            ['desc' => 'PATCH (e.g., 1.4.2 -> 1.4.3)', 'right' => 0, 'expl' => 'PATCH denotes backwards-compatible bug fixes.'],
                            ['desc' => 'BUILD metadata (e.g., 1.4.2+2026)', 'right' => 0, 'expl' => 'Build metadata does not denote compatibility semantics.']
                        ]
                    ],
                    [
                        'text'        => 'Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)',
                        'explanation' => 'Automated unit/integration test suites, static analysis/linters, and security vulnerability scans are standard quality gates in CI.',
                        'type'        => 'M',
                        'difficulty'  => 2,
                        'answers'     => [
                            ['desc' => 'Automated unit and integration test suites', 'right' => 1, 'expl' => 'Verifies functionality and guards against regression.'],
                            ['desc' => 'Static code analysis and linter checks', 'right' => 1, 'expl' => 'Enforces code style and spots syntax/semantic bugs.'],
                            ['desc' => 'Dependency security vulnerability scanning (SAST/SCA)', 'right' => 1, 'expl' => 'Identifies vulnerable third-party dependencies before merging.'],
                            ['desc' => 'Physical hardware burn-in testing of developer laptops', 'right' => 0, 'expl' => 'Developer laptop burn-in is not part of software CI pipelines.']
                        ]
                    ],
                    [
                        'text'        => 'Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)',
                        'explanation' => 'git rebase, git commit --amend, and git reset --hard alter commit SHAs and history, disrupting peers if performed on shared branches.',
                        'type'        => 'M',
                        'difficulty'  => 3,
                        'answers'     => [
                            ['desc' => 'git rebase', 'right' => 1, 'expl' => 'Rewrites commit parentage and produces new commit SHAs.'],
                            ['desc' => 'git commit --amend', 'right' => 1, 'expl' => 'Replaces the most recent commit with a revised commit SHA.'],
                            ['desc' => 'git reset --hard', 'right' => 1, 'expl' => 'Moves HEAD and discards commits and working tree modifications.'],
                            ['desc' => 'git status', 'right' => 0, 'expl' => 'Read-only command displaying working tree status.']
                        ]
                    ]
                ]
            ]
        ]
    ]
];

// Showcase Tests
$tests = [
    [
        'name'        => 'CS101: Web & Database Engineering Certification Exam',
        'description' => 'Comprehensive assessment covering Web Protocols, Relational Database Engineering, and Core Algorithmic Complexity. 12 questions selected across all CS subjects.',
        'duration'    => 45, // minutes
        'max_score'   => 12.0,
        'threshold'   => 8.4, // 70% passing
        'subjects'    => [
            'Web Protocols & Client-Server Architecture' => 4,
            'Database Engineering & Relational SQL'      => 4,
            'Data Structures & Algorithmic Complexity'   => 4
        ],
        'groups'      => ['CS101-Morning', 'CS101-Evening']
    ],
    [
        'name'        => 'SEC201: Cybersecurity Fundamentals & Network Defense',
        'description' => 'Security assessment covering cryptographic principles, TLS protocols, and OWASP Top 10 web application defenses. 12 questions selected across cybersecurity subjects.',
        'duration'    => 40,
        'max_score'   => 12.0,
        'threshold'   => 9.0, // 75% passing
        'subjects'    => [
            'Network Security & Cryptographic Foundations' => 6,
            'Application Security & OWASP Top 10'          => 6
        ],
        'groups'      => ['CyberSec-Cohort-A']
    ],
    [
        'name'        => 'OPS301: Cloud Infrastructure & DevOps Readiness',
        'description' => 'Practical assessment on containerization principles, Docker lifecycle management, CI/CD pipelines, and Git workflows. 12 questions.',
        'duration'    => 30,
        'max_score'   => 12.0,
        'threshold'   => 8.4, // 70% passing
        'subjects'    => [
            'Containerization & Docker Fundamentals'      => 6,
            'CI/CD Automation & Version Control (Git)'     => 6
        ],
        'groups'      => ['CS101-Morning', 'CS101-Evening', 'CyberSec-Cohort-A']
    ]
];

// =============================================================================
// 2. GENERATE USERS TSV & CSV
// =============================================================================

$userTsvLines = [];
// Header row matching tce_tsv_users.php
$userTsvLines[] = implode("\t", [
    'user_id',
    'user_name',
    'user_password',
    'user_email',
    'user_regdate',
    'user_ip',
    'user_firstname',
    'user_lastname',
    'user_birthdate',
    'user_birthplace',
    'user_regnumber',
    'user_ssn',
    'user_level',
    'user_verifycode',
    'user_otpkey',
    'user_groups'
]);

$uid = 100;
foreach ($users as $u) {
    ++$uid;
    $userTsvLines[] = implode("\t", [
        (string)$uid,
        F_text_to_tsv($u['username']),
        F_text_to_tsv($u['password']),
        F_text_to_tsv($u['email']),
        F_text_to_tsv($u['regdate']),
        F_text_to_tsv($u['ip']),
        F_text_to_tsv($u['firstname']),
        F_text_to_tsv($u['lastname']),
        F_text_to_tsv($u['birthdate']),
        F_text_to_tsv($u['birthplace']),
        F_text_to_tsv($u['regnumber']),
        F_text_to_tsv($u['ssn']),
        (string)$u['level'],
        '', // verifycode
        '', // otpkey
        F_text_to_tsv(implode(',', $u['groups']))
    ]);
}

$userTsvContent = implode("\n", $userTsvLines) . "\n";
file_put_contents(__DIR__ . '/users_seed.tsv', $userTsvContent);
echo "  [OK] Created users_seed.tsv (" . count($users) . " users)\n";

// Generate matching CSV using TCExam's converter
$userCsvContent = F_tsv_to_csv($userTsvContent);
file_put_contents(__DIR__ . '/users_seed.csv', $userCsvContent);
echo "  [OK] Created users_seed.csv\n";


// =============================================================================
// 3. GENERATE MODULES, SUBJECTS, QUESTIONS & ANSWERS TSV & CSV
// =============================================================================

$qTsvLines = [];
// Header lines matching tce_tsv_questions.php
$qTsvLines[] = "M=MODULE\tmodule_enabled\tmodule_name";
$qTsvLines[] = "S=SUBJECT\tsubject_enabled\tsubject_name\tsubject_description";
$qTsvLines[] = "Q=QUESTION\tquestion_enabled\tquestion_description\tquestion_explanation\tquestion_type\tquestion_difficulty\tquestion_position\tquestion_timer\tquestion_fullscreen\tquestion_inline_answers\tquestion_auto_next";
$qTsvLines[] = "A=ANSWER\tanswer_enabled\tanswer_description\tanswer_explanation\tanswer_isright\tanswer_position\tanswer_keyboard_key";

$totalModules = 0;
$totalSubjects = 0;
$totalQuestions = 0;
$totalAnswers = 0;

$keyLetters = ['A', 'B', 'C', 'D'];

foreach ($curriculum as $mod) {
    ++$totalModules;
    $qTsvLines[] = implode("\t", [
        'M',
        (string)$mod['enabled'],
        F_text_to_tsv($mod['name'])
    ]);

    foreach ($mod['subjects'] as $subj) {
        ++$totalSubjects;
        $qTsvLines[] = implode("\t", [
            'S',
            (string)$subj['enabled'],
            F_text_to_tsv($subj['name']),
            F_text_to_tsv($subj['description'])
        ]);

        foreach ($subj['questions'] as $qIdx => $q) {
            ++$totalQuestions;
            $qTsvLines[] = implode("\t", [
                'Q',
                '1', // question_enabled
                F_text_to_tsv($q['text']),
                F_text_to_tsv($q['explanation']),
                $q['type'],
                (string)$q['difficulty'],
                (string)($qIdx + 1), // question_position
                '0', // question_timer
                '0', // question_fullscreen
                '0', // question_inline_answers
                '0'  // question_auto_next
            ]);

            // For single choice questions, let's rotate answer order slightly based on question index
            // so the correct answer isn't always in position 1
            $ansList = $q['answers'];
            if ($q['type'] === 'S') {
                $shift = $qIdx % count($ansList);
                // Rotate array
                for ($s = 0; $s < $shift; ++$s) {
                    $item = array_shift($ansList);
                    $ansList[] = $item;
                }
            }

            foreach ($ansList as $aIdx => $ans) {
                ++$totalAnswers;
                $key = $keyLetters[$aIdx] ?? '';
                $qTsvLines[] = implode("\t", [
                    'A',
                    '1', // answer_enabled
                    F_text_to_tsv($ans['desc']),
                    F_text_to_tsv($ans['expl']),
                    (string)$ans['right'],
                    (string)($aIdx + 1), // answer_position
                    $key
                ]);
            }
        }
    }
}

$qTsvContent = implode("\n", $qTsvLines) . "\n";
file_put_contents(__DIR__ . '/modules_and_questions_seed.tsv', $qTsvContent);
echo "  [OK] Created modules_and_questions_seed.tsv ($totalModules modules, $totalSubjects subjects, $totalQuestions questions, $totalAnswers answers)\n";

// Generate matching CSV using TCExam's converter
$qCsvContent = F_tsv_to_csv($qTsvContent);
file_put_contents(__DIR__ . '/modules_and_questions_seed.csv', $qCsvContent);
echo "  [OK] Created modules_and_questions_seed.csv\n";


// =============================================================================
// 4. GENERATE COMPLETE SQL SEED SCRIPT
// =============================================================================

$sql = "-- =============================================================================\n";
$sql .= "-- TCExam Showcase Seed Script\n";
$sql .= "-- Generated: " . date('Y-m-d H:i:s') . "\n";
$sql .= "-- Default User Password: " . $defaultPassword . "\n";
$sql .= "-- =============================================================================\n\n";

$sql .= "SET FOREIGN_KEY_CHECKS = 0;\n\n";

// Groups
$sql .= "-- -----------------------------------------------------------------------------\n";
$sql .= "-- 1. User Groups\n";
$sql .= "-- -----------------------------------------------------------------------------\n";
foreach ($groups as $gName => $gDesc) {
    $sql .= "INSERT INTO tce_user_groups (group_name) VALUES ('" . addslashes($gName) . "')\n";
    $sql .= "  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);\n";
}
$sql .= "\n";

// Users
$sql .= "-- -----------------------------------------------------------------------------\n";
$sql .= "-- 2. Users (Hashed password for: " . $defaultPassword . ")\n";
$sql .= "-- -----------------------------------------------------------------------------\n";
foreach ($users as $u) {
    $perms = F_cumulative_perms_for_level((int)$u['level']);
    $sql .= "INSERT INTO tce_users (\n";
    $sql .= "  user_name, user_password, user_email, user_regdate, user_ip,\n";
    $sql .= "  user_firstname, user_lastname, user_birthdate, user_birthplace,\n";
    $sql .= "  user_regnumber, user_ssn, user_level, user_perms\n";
    $sql .= ") VALUES (\n";
    $sql .= "  '" . addslashes($u['username']) . "',\n";
    $sql .= "  '" . addslashes($passwordHash) . "',\n";
    $sql .= "  '" . addslashes($u['email']) . "',\n";
    $sql .= "  '" . addslashes($u['regdate']) . "',\n";
    $sql .= "  '" . addslashes($u['ip']) . "',\n";
    $sql .= "  '" . addslashes($u['firstname']) . "',\n";
    $sql .= "  '" . addslashes($u['lastname']) . "',\n";
    $sql .= "  '" . addslashes($u['birthdate']) . "',\n";
    $sql .= "  '" . addslashes($u['birthplace']) . "',\n";
    $sql .= "  '" . addslashes($u['regnumber']) . "',\n";
    $sql .= "  '" . addslashes($u['ssn']) . "',\n";
    $sql .= "  " . (int)$u['level'] . ",\n";
    $sql .= "  " . (int)$perms . "\n";
    $sql .= ") ON DUPLICATE KEY UPDATE\n";
    $sql .= "  user_password=VALUES(user_password),\n";
    $sql .= "  user_email=VALUES(user_email),\n";
    $sql .= "  user_level=VALUES(user_level),\n";
    $sql .= "  user_perms=VALUES(user_perms);\n\n";

    // Link User to Groups
    foreach ($u['groups'] as $grp) {
        $sql .= "INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)\n";
        $sql .= "SELECT u.user_id, g.group_id\n";
        $sql .= "FROM tce_users u, tce_user_groups g\n";
        $sql .= "WHERE u.user_name='" . addslashes($u['username']) . "' AND g.group_name='" . addslashes($grp) . "';\n";
    }
    $sql .= "\n";
}

// Modules, Subjects, Questions, Answers
$sql .= "-- -----------------------------------------------------------------------------\n";
$sql .= "-- 3. Modules, Subjects, Questions, and Answers\n";
$sql .= "-- -----------------------------------------------------------------------------\n";

foreach ($curriculum as $mod) {
    $sql .= "-- Module: " . $mod['name'] . "\n";
    $sql .= "INSERT INTO tce_modules (module_name, module_enabled, module_user_id)\n";
    $sql .= "VALUES ('" . addslashes($mod['name']) . "', " . (int)$mod['enabled'] . ", 1)\n";
    $sql .= "ON DUPLICATE KEY UPDATE module_enabled=VALUES(module_enabled);\n\n";

    foreach ($mod['subjects'] as $subj) {
        $sql .= "-- Subject: " . $subj['name'] . "\n";
        $sql .= "INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)\n";
        $sql .= "SELECT m.module_id, '" . addslashes($subj['name']) . "', '" . addslashes($subj['description']) . "', " . (int)$subj['enabled'] . ", 1\n";
        $sql .= "FROM tce_modules m WHERE m.module_name='" . addslashes($mod['name']) . "' LIMIT 1;\n\n";

        foreach ($subj['questions'] as $qIdx => $q) {
            $qtypeNum = ($q['type'] === 'S' ? 1 : ($q['type'] === 'M' ? 2 : 1));
            $sql .= "INSERT INTO tce_questions (\n";
            $sql .= "  question_subject_id, question_description, question_explanation,\n";
            $sql .= "  question_type, question_difficulty, question_enabled, question_position\n";
            $sql .= ")\n";
            $sql .= "SELECT s.subject_id, '" . addslashes($q['text']) . "', '" . addslashes($q['explanation']) . "',\n";
            $sql .= "  " . $qtypeNum . ", " . (int)$q['difficulty'] . ", 1, " . ($qIdx + 1) . "\n";
            $sql .= "FROM tce_subjects s\n";
            $sql .= "JOIN tce_modules m ON s.subject_module_id=m.module_id\n";
            $sql .= "WHERE m.module_name='" . addslashes($mod['name']) . "' AND s.subject_name='" . addslashes($subj['name']) . "'\n";
            $sql .= "LIMIT 1;\n\n";

            $ansList = $q['answers'];
            if ($q['type'] === 'S') {
                $shift = $qIdx % count($ansList);
                for ($s = 0; $s < $shift; ++$s) {
                    $item = array_shift($ansList);
                    $ansList[] = $item;
                }
            }

            foreach ($ansList as $aIdx => $ans) {
                $key = $keyLetters[$aIdx] ?? '';
                $sql .= "INSERT INTO tce_answers (\n";
                $sql .= "  answer_question_id, answer_description, answer_explanation,\n";
                $sql .= "  answer_isright, answer_enabled, answer_position, answer_keyboard_key\n";
                $sql .= ")\n";
                $sql .= "SELECT q.question_id, '" . addslashes($ans['desc']) . "', '" . addslashes($ans['expl']) . "',\n";
                $sql .= "  " . (int)$ans['right'] . ", 1, " . ($aIdx + 1) . ", " . ($key ? ord($key) : "NULL") . "\n";
                $sql .= "FROM tce_questions q\n";
                $sql .= "JOIN tce_subjects s ON q.question_subject_id=s.subject_id\n";
                $sql .= "WHERE s.subject_name='" . addslashes($subj['name']) . "' AND q.question_description='" . addslashes($q['text']) . "'\n";
                $sql .= "LIMIT 1;\n";
            }
            $sql .= "\n";
        }
    }
}

// Showcase Exams
$sql .= "-- -----------------------------------------------------------------------------\n";
$sql .= "-- 4. Showcase Certification Exams\n";
$sql .= "-- -----------------------------------------------------------------------------\n";

foreach ($tests as $t) {
    $sql .= "-- Test: " . $t['name'] . "\n";
    $sql .= "INSERT INTO tce_tests (\n";
    $sql .= "  test_name, test_description, test_begin_time, test_end_time, test_duration_time,\n";
    $sql .= "  test_ip_range, test_results_to_users, test_report_to_users,\n";
    $sql .= "  test_score_right, test_score_wrong, test_score_unanswered, test_max_score,\n";
    $sql .= "  test_user_id, test_score_threshold, test_random_questions_select,\n";
    $sql .= "  test_random_questions_order, test_random_answers_select, test_random_answers_order,\n";
    $sql .= "  test_comment_enabled, test_menu_enabled, test_noanswer_enabled, test_mcma_radio,\n";
    $sql .= "  test_repeatable, test_mcma_partial_score, test_logout_on_timeout\n";
    $sql .= ") VALUES (\n";
    $sql .= "  '" . addslashes($t['name']) . "',\n";
    $sql .= "  '" . addslashes($t['description']) . "',\n";
    $sql .= "  '2026-01-01 00:00:00', '2030-12-31 23:59:59', " . (int)$t['duration'] . ",\n";
    $sql .= "  '*.*.*.*', 1, 1,\n";
    $sql .= "  1.000, 0.000, 0.000, " . number_format($t['max_score'], 3, '.', '') . ",\n";
    $sql .= "  1, " . number_format($t['threshold'], 3, '.', '') . ", 1,\n";
    $sql .= "  1, 1, 1,\n";
    $sql .= "  1, 1, 1, 1,\n";
    $sql .= "  1, 1, 0\n";
    $sql .= ") ON DUPLICATE KEY UPDATE\n";
    $sql .= "  test_description=VALUES(test_description),\n";
    $sql .= "  test_max_score=VALUES(test_max_score),\n";
    $sql .= "  test_score_threshold=VALUES(test_score_threshold);\n\n";

    // Test Subject Sets
    foreach ($t['subjects'] as $subjName => $qty) {
        $sql .= "-- Link topic '" . $subjName . "' ($qty questions) to test '" . $t['name'] . "'\n";
        $sql .= "INSERT INTO tce_test_subject_set (\n";
        $sql .= "  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers\n";
        $sql .= ")\n";
        $sql .= "SELECT t.test_id, 0, 0, " . (int)$qty . ", 4\n";
        $sql .= "FROM tce_tests t WHERE t.test_name='" . addslashes($t['name']) . "' LIMIT 1;\n\n";

        $sql .= "INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)\n";
        $sql .= "SELECT LAST_INSERT_ID(), s.subject_id\n";
        $sql .= "FROM tce_subjects s WHERE s.subject_name='" . addslashes($subjName) . "' LIMIT 1;\n\n";
    }

    // Assign Groups to Test
    foreach ($t['groups'] as $grpName) {
        $sql .= "INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)\n";
        $sql .= "SELECT t.test_id, g.group_id\n";
        $sql .= "FROM tce_tests t, tce_user_groups g\n";
        $sql .= "WHERE t.test_name='" . addslashes($t['name']) . "' AND g.group_name='" . addslashes($grpName) . "';\n";
    }
    $sql .= "\n";
}

$sql .= "SET FOREIGN_KEY_CHECKS = 1;\n";
$sql .= "-- =============================================================================\n";
$sql .= "-- End of Showcase Seed Script\n";
$sql .= "-- =============================================================================\n";

file_put_contents(__DIR__ . '/showcase_seed.sql', $sql);
echo "  [OK] Created showcase_seed.sql (" . count($tests) . " tests configured)\n";


// =============================================================================
// 5. GENERATE SIMULATED EXAM ATTEMPTS & ANALYTICS SQL SEED
// =============================================================================

// Map subject names to their questions
$questionsBySubject = [];
foreach ($curriculum as $mod) {
    foreach ($mod['subjects'] as $subj) {
        $questionsBySubject[$subj['name']] = $subj['questions'];
    }
}

// Assemble test question banks matching test subject allocations
$testQuestionBanks = [];
foreach ($tests as $t) {
    $tName = $t['name'];
    $bank = [];
    foreach ($t['subjects'] as $subjName => $qty) {
        $subjQuestions = $questionsBySubject[$subjName] ?? [];
        for ($qi = 0; $qi < $qty && isset($subjQuestions[$qi]); $qi++) {
            $bank[] = [
                'subject_name' => $subjName,
                'question'     => $subjQuestions[$qi]
            ];
        }
    }
    $testQuestionBanks[$tName] = $bank;
}

// Simulated exam attempts configuration
$simulatedResults = [
    [
        'test_name'   => 'CS101: Web & Database Engineering Certification Exam',
        'candidates'  => [
            [
                'username'   => 'sophia.kim',
                'status'     => 4,
                'start_time' => '2026-02-15 14:00:00',
                'duration_m' => 24,
                'comment'    => 'Official certification exam completed. Grade: Honors (100.0%).',
                'wrong_idx'  => [] // 12/12 (100.0%) - PASSED (Honors)
            ],
            [
                'username'   => 'alex.taylor',
                'status'     => 4,
                'start_time' => '2026-02-15 10:00:00',
                'duration_m' => 28,
                'comment'    => 'Official certification exam completed. Grade: Honors (91.7%).',
                'wrong_idx'  => [7] // 11/12 (91.7%) - PASSED (Honors)
            ],
            [
                'username'   => 'daniel.novak',
                'status'     => 4,
                'start_time' => '2026-02-15 18:00:00',
                'duration_m' => 35,
                'comment'    => 'Official certification exam completed. Grade: Pass (83.3%).',
                'wrong_idx'  => [3, 11] // 10/12 (83.3%) - PASSED
            ],
            [
                'username'   => 'fatima.zahra',
                'status'     => 4,
                'start_time' => '2026-02-15 18:05:00',
                'duration_m' => 31,
                'comment'    => 'Official certification exam completed. Grade: Pass (83.3%).',
                'wrong_idx'  => [6, 9] // 10/12 (83.3%) - PASSED
            ],
            [
                'username'   => 'brenda.wright',
                'status'     => 4,
                'start_time' => '2026-02-15 10:05:00',
                'duration_m' => 38,
                'comment'    => 'Official certification exam completed. Grade: Pass (75.0%).',
                'wrong_idx'  => [3, 7, 10] // 9/12 (75.0%) - PASSED
            ],
            [
                'username'   => 'maria.santos',
                'status'     => 4,
                'start_time' => '2026-02-15 10:10:00',
                'duration_m' => 40,
                'comment'    => 'Official certification exam completed. Grade: Pass (75.0%).',
                'wrong_idx'  => [2, 6, 11] // 9/12 (75.0%) - PASSED
            ],
            [
                'username'   => 'kevin.patel',
                'status'     => 4,
                'start_time' => '2026-02-15 10:15:00',
                'duration_m' => 42,
                'comment'    => 'Official certification exam completed. Grade: Failed (58.3%).',
                'wrong_idx'  => [1, 3, 5, 7, 10] // 7/12 (58.3%) - FAILED
            ],
            [
                'username'   => 'lucas.silva',
                'status'     => 4,
                'start_time' => '2026-02-15 18:10:00',
                'duration_m' => 44,
                'comment'    => 'Official certification exam completed. Grade: Failed (50.0%).',
                'wrong_idx'  => [1, 2, 4, 7, 9, 11] // 6/12 (50.0%) - FAILED
            ],
            [
                'username'   => 'james.wilson',
                'status'     => 0, // Assigned / Ready to take
                'start_time' => '2026-02-15 09:00:00',
                'duration_m' => 0,
                'comment'    => 'Assigned - Candidate ready to begin exam session.',
                'wrong_idx'  => []
            ],
            [
                'username'   => 'olivia.brown',
                'status'     => 0, // Assigned / Ready to take
                'start_time' => '2026-02-15 17:00:00',
                'duration_m' => 0,
                'comment'    => 'Assigned - Candidate ready to begin exam session.',
                'wrong_idx'  => []
            ]
        ]
    ],
    [
        'test_name'   => 'SEC201: Cybersecurity Fundamentals & Network Defense',
        'candidates'  => [
            [
                'username'   => 'priya.sharma',
                'status'     => 4,
                'start_time' => '2026-02-18 11:00:00',
                'duration_m' => 22,
                'comment'    => 'Official certification exam completed. Grade: Honors (100.0%).',
                'wrong_idx'  => [] // 12/12 (100.0%) - PASSED (Honors)
            ],
            [
                'username'   => 'marcus.vance',
                'status'     => 4,
                'start_time' => '2026-02-18 11:05:00',
                'duration_m' => 26,
                'comment'    => 'Official certification exam completed. Grade: Honors (91.7%).',
                'wrong_idx'  => [5] // 11/12 (91.7%) - PASSED (Honors)
            ],
            [
                'username'   => 'elena.rostova',
                'status'     => 4,
                'start_time' => '2026-02-18 11:10:00',
                'duration_m' => 37,
                'comment'    => 'Official certification exam completed. Grade: Failed (66.7%).',
                'wrong_idx'  => [3, 5, 8, 10] // 8/12 (66.7%) - FAILED
            ],
            [
                'username'   => 'tariq.mansoor',
                'status'     => 0, // Assigned / Ready to take
                'start_time' => '2026-02-18 10:00:00',
                'duration_m' => 0,
                'comment'    => 'Assigned - Candidate ready to begin exam session.',
                'wrong_idx'  => []
            ]
        ]
    ],
    [
        'test_name'   => 'OPS301: Cloud Infrastructure & DevOps Readiness',
        'candidates'  => [
            [
                'username'   => 'marcus.vance',
                'status'     => 4,
                'start_time' => '2026-02-22 15:00:00',
                'duration_m' => 16,
                'comment'    => 'Official certification exam completed. Grade: Honors (100.0%).',
                'wrong_idx'  => [] // 12/12 (100.0%) - PASSED (Honors)
            ],
            [
                'username'   => 'alex.taylor',
                'status'     => 4,
                'start_time' => '2026-02-22 15:05:00',
                'duration_m' => 19,
                'comment'    => 'Official certification exam completed. Grade: Pass (83.3%).',
                'wrong_idx'  => [4, 10] // 10/12 (83.3%) - PASSED
            ],
            [
                'username'   => 'daniel.novak',
                'status'     => 4,
                'start_time' => '2026-02-22 15:10:00',
                'duration_m' => 25,
                'comment'    => 'Official certification exam completed. Grade: Pass (75.0%).',
                'wrong_idx'  => [3, 6, 9] // 9/12 (75.0%) - PASSED
            ]
        ]
    ]
];

$resSql = "-- =============================================================================\n";
$resSql .= "-- TCExam Simulated Exam Results & Analytics Seed Script\n";
$resSql .= "-- Generated: " . date('Y-m-d H:i:s') . "\n";
$resSql .= "-- Populates tce_tests_users, tce_tests_logs, and tce_tests_logs_answers\n";
$resSql .= "-- =============================================================================\n\n";
$resSql .= "SET FOREIGN_KEY_CHECKS = 0;\n\n";

$weights = [0.85, 1.10, 0.95, 1.20, 0.75, 1.05, 1.15, 0.90, 1.10, 0.80, 1.25, 0.90];
$totalCompletedAttempts = 0;
$totalReadyAttempts = 0;
$totalLogsInserted = 0;

foreach ($simulatedResults as $resTest) {
    $testName = $resTest['test_name'];
    $bank = $testQuestionBanks[$testName] ?? [];
    $resSql .= "-- -----------------------------------------------------------------------------\n";
    $resSql .= "-- Test: " . $testName . "\n";
    $resSql .= "-- -----------------------------------------------------------------------------\n\n";

    foreach ($resTest['candidates'] as $candIdx => $cand) {
        $username = $cand['username'];
        $status = (int)$cand['status'];
        $startTime = $cand['start_time'];
        $durationMin = (int)$cand['duration_m'];
        $comment = $cand['comment'];
        $wrongIndices = $cand['wrong_idx'];

        if ($status === 4) {
            $totalCompletedAttempts++;
        } else {
            $totalReadyAttempts++;
        }

        $resSql .= "-- Attempt: $username | Status: $status | Duration: " . ($status === 4 ? $durationMin . "m" : "N/A") . "\n";
        $resSql .= "INSERT INTO tce_tests_users (\n";
        $resSql .= "  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment\n";
        $resSql .= ") SELECT t.test_id, u.user_id, $status, '$startTime', '" . addslashes($comment) . "'\n";
        $resSql .= "FROM tce_tests t, tce_users u\n";
        $resSql .= "WHERE t.test_name='" . addslashes($testName) . "' AND u.user_name='" . addslashes($username) . "'\n";
        $resSql .= "ON DUPLICATE KEY UPDATE\n";
        $resSql .= "  testuser_status=VALUES(testuser_status),\n";
        $resSql .= "  testuser_creation_time=VALUES(testuser_creation_time),\n";
        $resSql .= "  testuser_comment=VALUES(testuser_comment);\n\n";

        // If status is 0 (ready to take), no question logs are recorded yet
        if ($status !== 4) {
            continue;
        }

        $resSql .= "SELECT tu.testuser_id INTO @curr_testuser_id\n";
        $resSql .= "FROM tce_tests_users tu\n";
        $resSql .= "JOIN tce_tests t ON tu.testuser_test_id=t.test_id\n";
        $resSql .= "JOIN tce_users u ON tu.testuser_user_id=u.user_id\n";
        $resSql .= "WHERE t.test_name='" . addslashes($testName) . "' AND u.user_name='" . addslashes($username) . "' AND tu.testuser_status=$status\n";
        $resSql .= "LIMIT 1;\n\n";

        // Calculate time distribution per question
        $totalDurationSec = $durationMin * 60;
        $qSeconds = [];
        for ($w = 0; $w < 11; $w++) {
            $qSeconds[$w] = (int)round($weights[$w] * ($totalDurationSec / 12));
        }
        $qSeconds[11] = $totalDurationSec - array_sum($qSeconds);

        $currentOffsetSec = 0;
        $startTimestamp = strtotime($startTime);

        foreach ($bank as $qIdx => $qItem) {
            $totalLogsInserted++;
            $q = $qItem['question'];
            $qText = $q['text'];
            $qType = $q['type'];
            $isWrong = in_array($qIdx, $wrongIndices, true);

            $durThisQ = $qSeconds[$qIdx] ?? 60;
            $dispTime = date('Y-m-d H:i:s', $startTimestamp + $currentOffsetSec);
            $changeTime = date('Y-m-d H:i:s', $startTimestamp + $currentOffsetSec + $durThisQ);
            $reactionMs = $durThisQ * 1000;
            $currentOffsetSec += $durThisQ;

            $score = $isWrong ? '0.000' : '1.000';

            // Determine selected answers
            $selectedDescs = [];
            if (!$isWrong) {
                // Correct answer(s)
                foreach ($q['answers'] as $a) {
                    if ((int)$a['right'] === 1) {
                        $selectedDescs[] = $a['desc'];
                    }
                }
            } else {
                // Candidate chose incorrect option(s)
                if ($qType === 'S') {
                    $wrongOpts = [];
                    foreach ($q['answers'] as $a) {
                        if ((int)$a['right'] === 0) {
                            $wrongOpts[] = $a['desc'];
                        }
                    }
                    $pickIdx = ($candIdx + $qIdx) % count($wrongOpts);
                    $selectedDescs[] = $wrongOpts[$pickIdx];
                } else {
                    // For multiple choice, pick partial or incorrect combination
                    $correctOpts = [];
                    $wrongOpts = [];
                    foreach ($q['answers'] as $a) {
                        if ((int)$a['right'] === 1) {
                            $correctOpts[] = $a['desc'];
                        } else {
                            $wrongOpts[] = $a['desc'];
                        }
                    }
                    if (!empty($correctOpts) && !empty($wrongOpts)) {
                        $selectedDescs[] = $correctOpts[0];
                        $selectedDescs[] = $wrongOpts[0];
                    }
                }
            }

            // Insert question log
            $qOrder = $qIdx + 1;
            $resSql .= "INSERT INTO tce_tests_logs (\n";
            $resSql .= "  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,\n";
            $resSql .= "  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,\n";
            $resSql .= "  testlog_reaction_time, testlog_order, testlog_num_answers\n";
            $resSql .= ") SELECT\n";
            $resSql .= "  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,\n";
            $resSql .= "  $score, '$dispTime', '$dispTime', '$changeTime',\n";
            $resSql .= "  $reactionMs, $qOrder, 4\n";
            $resSql .= "FROM tce_questions q\n";
            $resSql .= "WHERE q.question_description='" . addslashes($qText) . "'\n";
            $resSql .= "LIMIT 1\n";
            $resSql .= "ON DUPLICATE KEY UPDATE\n";
            $resSql .= "  testlog_score=VALUES(testlog_score),\n";
            $resSql .= "  testlog_display_time=VALUES(testlog_display_time),\n";
            $resSql .= "  testlog_change_time=VALUES(testlog_change_time),\n";
            $resSql .= "  testlog_reaction_time=VALUES(testlog_reaction_time),\n";
            $resSql .= "  testlog_order=VALUES(testlog_order);\n\n";

            $resSql .= "SELECT tl.testlog_id INTO @curr_testlog_id\n";
            $resSql .= "FROM tce_tests_logs tl\n";
            $resSql .= "JOIN tce_questions q ON tl.testlog_question_id=q.question_id\n";
            $resSql .= "WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='" . addslashes($qText) . "'\n";
            $resSql .= "LIMIT 1;\n\n";

            // Insert answer selections
            $whenClauses = [];
            foreach ($selectedDescs as $sDesc) {
                $whenClauses[] = "WHEN a.answer_description='" . addslashes($sDesc) . "' THEN 1";
            }
            $caseSql = !empty($whenClauses) ? "CASE " . implode(" ", $whenClauses) . " ELSE 0 END" : "0";

            $resSql .= "INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)\n";
            $resSql .= "SELECT @curr_testlog_id, a.answer_id, $caseSql, a.answer_position\n";
            $resSql .= "FROM tce_answers a\n";
            $resSql .= "JOIN tce_questions q ON a.answer_question_id=q.question_id\n";
            $resSql .= "WHERE q.question_description='" . addslashes($qText) . "'\n";
            $resSql .= "ON DUPLICATE KEY UPDATE\n";
            $resSql .= "  logansw_selected=VALUES(logansw_selected),\n";
            $resSql .= "  logansw_order=VALUES(logansw_order);\n\n";
        }
    }
}

$resSql .= "SET FOREIGN_KEY_CHECKS = 1;\n";
$resSql .= "-- =============================================================================\n";
$resSql .= "-- End of Showcase Results Seed Script\n";
$resSql .= "-- =============================================================================\n";

file_put_contents(__DIR__ . '/showcase_results_seed.sql', $resSql);
echo "  [OK] Created showcase_results_seed.sql ($totalCompletedAttempts completed attempts, $totalReadyAttempts ready-to-take attempts, $totalLogsInserted question logs)\n";

// Support bundling results into showcase_seed.sql if --with-results is passed
if (isset($argv) && (in_array('--with-results', $argv, true) || in_array('--all', $argv, true))) {
    $bundledSql = $sql . "\n" . $resSql;
    file_put_contents(__DIR__ . '/showcase_seed.sql', $bundledSql);
    echo "  [OK] Bundled results directly into showcase_seed.sql (--with-results flag specified)\n";
}

echo "All showcase seed files generated successfully!\n";

