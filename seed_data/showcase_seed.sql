-- =============================================================================
-- TCExam Showcase Seed Script
-- Generated: 2026-10-09 16:30:29
-- Default User Password: Password123!
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 1. User Groups
-- -----------------------------------------------------------------------------
INSERT INTO tce_user_groups (group_name) VALUES ('System Administrators')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('Academic Registry')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('Exam Proctors')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('Instructors')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('Computer Science Faculty')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('Cybersecurity Faculty')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('CS101-Morning')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('CS101-Evening')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);
INSERT INTO tce_user_groups (group_name) VALUES ('CyberSec-Cohort-A')
  ON DUPLICATE KEY UPDATE group_name=VALUES(group_name);

-- -----------------------------------------------------------------------------
-- 2. Users (Hashed password for: Password123!)
-- -----------------------------------------------------------------------------
INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'admin_alice',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'alice.admin@example.com',
  '2026-01-10 08:30:00',
  '127.0.0.1',
  'Alice',
  'Vance',
  '1988-04-12',
  'San Francisco',
  'ADM-001',
  'SSN-ADM-001',
  10,
  127
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='admin_alice' AND g.group_name='System Administrators';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'manager_linda',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'linda.registrar@example.com',
  '2026-01-12 09:15:00',
  '127.0.0.1',
  'Linda',
  'Martinez',
  '1985-07-22',
  'Chicago',
  'REG-001',
  'SSN-REG-001',
  6,
  15
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='manager_linda' AND g.group_name='Academic Registry';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'operator_david',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'david.proctor@example.com',
  '2026-01-15 10:00:00',
  '127.0.0.1',
  'David',
  'Proctor',
  '1990-11-05',
  'Boston',
  'OPR-001',
  'SSN-OPR-001',
  5,
  7
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='operator_david' AND g.group_name='Exam Proctors';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'operator_sarah',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'sarah.examiner@example.com',
  '2026-01-15 10:30:00',
  '127.0.0.1',
  'Sarah',
  'Jenkins',
  '1992-03-18',
  'Seattle',
  'OPR-002',
  'SSN-OPR-002',
  5,
  7
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='operator_sarah' AND g.group_name='Exam Proctors';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'prof_miller',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'robert.miller@example.com',
  '2026-01-18 11:00:00',
  '127.0.0.1',
  'Robert',
  'Miller',
  '1979-09-14',
  'New York',
  'FAC-CS-001',
  'SSN-FAC-001',
  3,
  3
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_miller' AND g.group_name='Instructors';
INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_miller' AND g.group_name='Computer Science Faculty';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'prof_chen',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'emily.chen@example.com',
  '2026-01-18 11:30:00',
  '127.0.0.1',
  'Emily',
  'Chen',
  '1984-12-03',
  'Austin',
  'FAC-CS-002',
  'SSN-FAC-002',
  3,
  3
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_chen' AND g.group_name='Instructors';
INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_chen' AND g.group_name='Computer Science Faculty';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'prof_garcia',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'carlos.garcia@example.com',
  '2026-01-18 12:00:00',
  '127.0.0.1',
  'Carlos',
  'Garcia',
  '1981-06-27',
  'Miami',
  'FAC-SEC-001',
  'SSN-FAC-003',
  3,
  3
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_garcia' AND g.group_name='Instructors';
INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='prof_garcia' AND g.group_name='Cybersecurity Faculty';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'alex.taylor',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'alex.taylor@example.com',
  '2026-02-01 09:00:00',
  '127.0.0.1',
  'Alex',
  'Taylor',
  '2004-02-14',
  'Denver',
  'STU-2026-101',
  'SSN-STU-101',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='alex.taylor' AND g.group_name='CS101-Morning';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'brenda.wright',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'brenda.wright@example.com',
  '2026-02-01 09:05:00',
  '127.0.0.1',
  'Brenda',
  'Wright',
  '2003-08-21',
  'Atlanta',
  'STU-2026-102',
  'SSN-STU-102',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='brenda.wright' AND g.group_name='CS101-Morning';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'kevin.patel',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'kevin.patel@example.com',
  '2026-02-01 09:10:00',
  '127.0.0.1',
  'Kevin',
  'Patel',
  '2004-11-30',
  'Houston',
  'STU-2026-103',
  'SSN-STU-103',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='kevin.patel' AND g.group_name='CS101-Morning';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'maria.santos',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'maria.santos@example.com',
  '2026-02-01 09:15:00',
  '127.0.0.1',
  'Maria',
  'Santos',
  '2003-05-19',
  'San Diego',
  'STU-2026-104',
  'SSN-STU-104',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='maria.santos' AND g.group_name='CS101-Morning';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'james.wilson',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'james.wilson@example.com',
  '2026-02-01 09:20:00',
  '127.0.0.1',
  'James',
  'Wilson',
  '2004-09-08',
  'Dallas',
  'STU-2026-105',
  'SSN-STU-105',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='james.wilson' AND g.group_name='CS101-Morning';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'sophia.kim',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'sophia.kim@example.com',
  '2026-02-02 17:00:00',
  '127.0.0.1',
  'Sophia',
  'Kim',
  '2002-10-11',
  'Portland',
  'STU-2026-201',
  'SSN-STU-201',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='sophia.kim' AND g.group_name='CS101-Evening';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'daniel.novak',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'daniel.novak@example.com',
  '2026-02-02 17:05:00',
  '127.0.0.1',
  'Daniel',
  'Novak',
  '2001-04-25',
  'Phoenix',
  'STU-2026-202',
  'SSN-STU-202',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='daniel.novak' AND g.group_name='CS101-Evening';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'fatima.zahra',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'fatima.zahra@example.com',
  '2026-02-02 17:10:00',
  '127.0.0.1',
  'Fatima',
  'Zahra',
  '2003-01-30',
  'Detroit',
  'STU-2026-203',
  'SSN-STU-203',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='fatima.zahra' AND g.group_name='CS101-Evening';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'lucas.silva',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'lucas.silva@example.com',
  '2026-02-02 17:15:00',
  '127.0.0.1',
  'Lucas',
  'Silva',
  '2002-07-16',
  'Philadelphia',
  'STU-2026-204',
  'SSN-STU-204',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='lucas.silva' AND g.group_name='CS101-Evening';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'olivia.brown',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'olivia.brown@example.com',
  '2026-02-02 17:20:00',
  '127.0.0.1',
  'Olivia',
  'Brown',
  '2003-12-05',
  'Charlotte',
  'STU-2026-205',
  'SSN-STU-205',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='olivia.brown' AND g.group_name='CS101-Evening';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'marcus.vance',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'marcus.vance@example.com',
  '2026-02-05 08:30:00',
  '127.0.0.1',
  'Marcus',
  'Vance',
  '2000-06-12',
  'Minneapolis',
  'SEC-2026-301',
  'SSN-SEC-301',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='marcus.vance' AND g.group_name='CyberSec-Cohort-A';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'priya.sharma',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'priya.sharma@example.com',
  '2026-02-05 08:35:00',
  '127.0.0.1',
  'Priya',
  'Sharma',
  '2001-09-28',
  'San Jose',
  'SEC-2026-302',
  'SSN-SEC-302',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='priya.sharma' AND g.group_name='CyberSec-Cohort-A';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'elena.rostova',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'elena.rostova@example.com',
  '2026-02-05 08:40:00',
  '127.0.0.1',
  'Elena',
  'Rostova',
  '1999-03-15',
  'Orlando',
  'SEC-2026-303',
  'SSN-SEC-303',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='elena.rostova' AND g.group_name='CyberSec-Cohort-A';

INSERT INTO tce_users (
  user_name, user_password, user_email, user_regdate, user_ip,
  user_firstname, user_lastname, user_birthdate, user_birthplace,
  user_regnumber, user_ssn, user_level, user_perms
) VALUES (
  'tariq.mansoor',
  '$2y$10$N2CAKtFUa6k4vcgYy9MGPOKcXv6CEDKcOJCyco27m4.Ky2oszHN8i',
  'tariq.mansoor@example.com',
  '2026-02-05 08:45:00',
  '127.0.0.1',
  'Tariq',
  'Mansoor',
  '2000-11-20',
  'Columbus',
  'SEC-2026-304',
  'SSN-SEC-304',
  1,
  0
) ON DUPLICATE KEY UPDATE
  user_password=VALUES(user_password),
  user_email=VALUES(user_email),
  user_level=VALUES(user_level),
  user_perms=VALUES(user_perms);

INSERT IGNORE INTO tce_usrgroups (usrgrp_user_id, usrgrp_group_id)
SELECT u.user_id, g.group_id
FROM tce_users u, tce_user_groups g
WHERE u.user_name='tariq.mansoor' AND g.group_name='CyberSec-Cohort-A';

-- -----------------------------------------------------------------------------
-- 3. Modules, Subjects, Questions, and Answers
-- -----------------------------------------------------------------------------
-- Module: Computer Science & Web Engineering
INSERT INTO tce_modules (module_name, module_enabled, module_user_id)
VALUES ('Computer Science & Web Engineering', 1, 1)
ON DUPLICATE KEY UPDATE module_enabled=VALUES(module_enabled);

-- Subject: Web Protocols & Client-Server Architecture
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Web Protocols & Client-Server Architecture', 'HTTP/HTTPS protocols, RESTful API architecture, browser security, cookies, and CORS.', 1, 1
FROM tce_modules m WHERE m.module_name='Computer Science & Web Engineering' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?', 'HTTP 201 Created indicates successful request completion resulting in the creation of one or more new resources.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, '201 Created', 'Correct. 201 specifically signifies new resource creation.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, '200 OK', '200 indicates standard success, but not specifically resource creation.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, '204 No Content', '204 signifies success with no response body.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, '301 Moved Permanently', '301 is a redirection status code.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?', 'SOP prevents a script loaded from one origin from accessing document contents or DOM from another origin without authorization.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To compress HTTP payloads and optimize network latency', 'Payload compression is handled by gzip/brotli encoding, not SOP.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To enforce automatic renewal of TLS/SSL certificates', 'Certificate renewal is managed at the server/ACME level.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To synchronize JavaScript variables between client tabs', 'Tab synchronization uses BroadcastChannel or localStorage events.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To prevent scripts from one origin from reading private DOM data or responses from another origin', 'Correct. SOP is a core browser security boundary isolating web origins.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?', 'The Access-Control-Allow-Origin response header indicates whether the response can be shared with requesting code from the given origin.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Strict-Transport-Security', 'HSTS enforces HTTPS connections.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'X-Frame-Options', 'X-Frame-Options controls framing to prevent clickjacking.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Access-Control-Allow-Origin', 'Correct. This header declares permitted client origins.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Content-Security-Policy', 'CSP governs resource loading restrictions to prevent XSS.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?', 'Cookies are automatically attached to matching HTTP request headers sent to the server, while localStorage remains strictly on the client until JavaScript accesses it.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Cookies are only accessible over WebSockets, while localStorage works over HTTP', 'Cookies are native to standard HTTP requests.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client', 'Correct. Cookies are sent with HTTP headers; localStorage is never automatically transmitted.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Cookies store up to 50 MB of data, while localStorage stores only 4 KB', 'Inverse: Cookies hold ~4KB while localStorage holds ~5-10MB.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'localStorage expires as soon as the browser tab closes, while Cookies never expire', 'sessionStorage expires on tab close; localStorage persists indefinitely.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)', 'An idempotent HTTP method can be executed multiple times without changing the server outcome beyond the initial execution. GET, PUT, and DELETE are idempotent; POST is not.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'GET', 'GET is both safe and idempotent.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'PUT', 'PUT replaces state; multiple identical PUTs yield the same server state.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'DELETE', 'DELETE is idempotent; repeating deletion results in the resource being absent.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'POST', 'POST creates subordinate resources; repeating POST typically creates multiple distinct records.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP methods are specified as idempotent by the HTTP/1.1 specification (RFC 7231)? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)', 'Content-Security-Policy restricts executable script sources, Strict-Transport-Security enforces HTTPS, and X-Content-Type-Options blocks MIME sniffing.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Web Protocols & Client-Server Architecture'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Content-Security-Policy', 'CSP mitigates XSS by restricting allowed script sources.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Strict-Transport-Security', 'HSTS enforces encrypted transport and blocks SSL-stripping.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'X-Content-Type-Options', 'Blocks MIME sniffing attacks by requiring nosniff.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'User-Agent', 'User-Agent is a client request header identifying the browser software.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Web Protocols & Client-Server Architecture' AND q.question_description='Which of the following HTTP response headers provide defense-in-depth against client-side browser attacks? (Select all that apply)'
LIMIT 1;

-- Subject: Database Engineering & Relational SQL
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Database Engineering & Relational SQL', 'Relational database schema design, indexing, transactions, ACID properties, and JOIN operations.', 1, 1
FROM tce_modules m WHERE m.module_name='Computer Science & Web Engineering' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which database constraint guarantees that a column contains unique values and cannot store NULL values?', 'A PRIMARY KEY constraint uniquely identifies each record and enforces uniqueness along with an implicit NOT NULL rule.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'PRIMARY KEY', 'Correct. Enforces uniqueness and rejects NULL values.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'FOREIGN KEY', 'FOREIGN KEY enforces referential integrity to another table.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'CHECK', 'CHECK validates values against a Boolean expression.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'DEFAULT', 'DEFAULT supplies a fallback value when none is provided.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?', 'A LEFT OUTER JOIN preserves every row from the left table regardless of whether a matching record exists in the right table.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'INNER JOIN', 'INNER JOIN only returns rows where keys match in both tables.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'RIGHT JOIN (RIGHT OUTER JOIN)', 'RIGHT JOIN preserves all right table rows.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'CROSS JOIN', 'CROSS JOIN produces the Cartesian product of both tables.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'LEFT JOIN (LEFT OUTER JOIN)', 'Correct. Returns all left table rows plus matched right rows.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'In relational database transactions, what does the \"I\" in ACID stand for?', 'ACID stands for Atomicity, Consistency, Isolation, and Durability. Isolation ensures concurrent transactions do not interfere with each other.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Indexation', 'Indexing is a performance mechanism, not an ACID property.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Idempotence', 'Idempotence is an API and distributed systems concept.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Isolation', 'Correct. Isolation governs transaction concurrency and visibility levels.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Integrity', 'Integrity is a general goal, but \"I\" stands for Isolation.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which tree data structure is most commonly utilized by relational database storage engines for table indexing?', 'B-Tree and B+ Tree structures maintain sorted keys with balanced height, providing logarithmic search, range scan, and insertion performance.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Splay Tree', 'Splay trees do not guarantee balanced disk block access.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'B-Tree (and B+ Tree)', 'Correct. B-Trees minimize disk I/O and support fast equality and range lookups.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Binary Min-Heap', 'Heaps are optimized for priority queue extraction (min/max), not search.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Trie (Prefix Tree)', 'Tries are used for string autocomplete and dictionary lookups.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)', 'DDL statements define or alter the structure of database objects (CREATE, ALTER, DROP, TRUNCATE). INSERT and UPDATE are DML.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'CREATE TABLE', 'DDL command defining schema objects.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'ALTER TABLE', 'DDL command modifying table structures.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'DROP TABLE', 'DDL command removing schema objects.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'INSERT INTO', 'INSERT is a Data Manipulation Language (DML) command.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which of the following SQL statements are categorized under Data Definition Language (DDL)? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)', 'To achieve 3NF, the relation must already satisfy 2NF, and every non-prime attribute must depend directly and non-transitively on the candidate key.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Database Engineering & Relational SQL'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The table must be in Second Normal Form (2NF)', 'Normal forms are hierarchical; 3NF requires 2NF compliance.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'There must be no transitive dependencies of non-key attributes on candidate keys', 'Every non-key attribute must depend directly on the key.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Every column must contain at least three foreign keys', 'Foreign keys are not required for normalization tiers.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The table must never store numeric values', 'Normalization does not dictate data types.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Database Engineering & Relational SQL' AND q.question_description='Which requirements are necessary for a database table to satisfy Third Normal Form (3NF)? (Select all that apply)'
LIMIT 1;

-- Subject: Data Structures & Algorithmic Complexity
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Data Structures & Algorithmic Complexity', 'Asymptotic complexity (Big-O), search and sort algorithms, stacks, queues, and tree structures.', 1, 1
FROM tce_modules m WHERE m.module_name='Computer Science & Web Engineering' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the average time complexity for searching a key in a properly dimensioned Hash Map?', 'Hash maps compute bucket indices via hash functions, achieving constant O(1) time complexity on average.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(1)', 'Correct. Hash tables offer O(1) average lookup time.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(log n)', 'O(log n) is typical of balanced search trees and binary search.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(n)', 'O(n) represents linear scans and worst-case hash collisions.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(n log n)', 'O(n log n) is standard for comparison-based sorting.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?', 'A Queue enqueues elements at the back and dequeues them from the front, ensuring FIFO ordering.',
  1, 1, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Stack', 'Stacks follow Last-In, First-Out (LIFO).',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Binary Search Tree', 'BSTs order elements hierarchically by key value.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Max-Heap', 'Heaps organize elements based on priority ordering.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Queue', 'Correct. Queues adhere to First-In, First-Out.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?', 'Binary search halves the remaining candidate space in each comparison, yielding O(log n) worst-case time complexity.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(n)', 'O(n) is the complexity of linear search.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(n^2)', 'O(n^2) is characteristic of quadratic algorithms like bubble sort.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(log n)', 'Correct. Logarithmic time complexity.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'O(1)', 'O(1) is the best-case (finding the element at the midpoint immediately).',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?', 'Merge Sort achieves guaranteed O(n log n) worst-case performance by recursively dividing and merging, while preserving relative order for equal elements.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Selection Sort', 'Selection sort runs in O(n^2) time.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Merge Sort', 'Correct. Merge sort is stable and guarantees O(n log n) in all cases.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Quick Sort', 'Quick sort degrades to O(n^2) in the worst case and is unstable in standard form.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Heap Sort', 'Heap sort achieves O(n log n) but is not a stable sort.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)', 'AVL trees and Red-Black trees are self-balancing binary search trees that maintain logarithmic height through tree rotations.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'AVL Tree', 'AVL trees strictly enforce height balance differences <= 1.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Red-Black Tree', 'Red-Black trees use color rules to guarantee balanced depth.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Unbalanced Binary Search Tree', 'Standard BSTs can degenerate into linked lists with O(n) height.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Prefix Trie', 'Tries are tree structures for string retrieval, not self-balancing BSTs.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which of the following binary search tree variants automatically rebalance themselves during insertions and deletions? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)', 'Depth-First Search (detecting back-edges using recursion stack states) and Kahn\'s algorithm (topological sorting using in-degrees) can both detect cycles.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Computer Science & Web Engineering' AND s.subject_name='Data Structures & Algorithmic Complexity'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Depth-First Search (DFS) with node visitation states (White/Gray/Black)', 'A back-edge encountered during DFS indicates a directed cycle.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Kahn\'s Algorithm (Topological Sort with vertex in-degree tracking)', 'If topological sort cannot process all vertices, a cycle exists.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Dijkstra\'s Shortest Path Algorithm', 'Dijkstra computes single-source shortest paths on weighted graphs.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Huffman Encoding Tree Generation', 'Huffman coding creates prefix-free trees for lossless compression.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Data Structures & Algorithmic Complexity' AND q.question_description='Which algorithms can detect the presence of cycles in a directed graph? (Select all that apply)'
LIMIT 1;

-- Module: Cybersecurity & Network Defense
INSERT INTO tce_modules (module_name, module_enabled, module_user_id)
VALUES ('Cybersecurity & Network Defense', 1, 1)
ON DUPLICATE KEY UPDATE module_enabled=VALUES(module_enabled);

-- Subject: Network Security & Cryptographic Foundations
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Network Security & Cryptographic Foundations', 'Symmetric vs asymmetric encryption, cryptographic hashing, digital certificates, and TLS handshakes.', 1, 1
FROM tce_modules m WHERE m.module_name='Cybersecurity & Network Defense' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the essential architectural distinction between symmetric and asymmetric cryptography?', 'Symmetric encryption employs one shared secret key for encryption and decryption. Asymmetric cryptography utilizes mathematically paired public and private keys.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Symmetric uses one shared secret key; asymmetric uses a public/private key pair', 'Correct. Core definition of both cryptographic paradigms.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Symmetric encryption operates only on hardware tokens; asymmetric is software-only', 'Both paradigms can run in software or dedicated hardware.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Symmetric algorithms cannot encrypt binary data', 'Symmetric ciphers routinely encrypt arbitrary binary streams.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Asymmetric keys are always 64 bits in length', 'Asymmetric keys range from 256 bits (ECC) to 4096 bits (RSA).',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?', 'SHA-256 (part of the SHA-2 family) remains cryptographically secure against collision attacks. MD5 and SHA-1 have proven collision weaknesses.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'MD5', 'MD5 has broken collision resistance and must not be used for security.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'SHA-1', 'SHA-1 has demonstrated practical collision vulnerabilities.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'CRC32', 'CRC32 is an error-detecting code, not a cryptographic hash.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'SHA-256', 'Correct. SHA-256 offers 256-bit collision resistance.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Why is it critical to combine a cryptographic salt with user passwords before hashing?', 'Salting introduces a unique pseudorandom value per password, preventing attacks using precomputed rainbow tables and ensuring identical passwords produce distinct hashes.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To allow system administrators to decrypt cleartext passwords for recovery', 'Hashes are one-way functions; salting does not enable decryption.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To compress password lengths to fit fixed database column sizes', 'Cryptographic hashes already produce fixed-length outputs.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To defend against rainbow table lookups and ensure identical passwords produce unique hashes', 'Correct. Defeats precomputed dictionary and rainbow table lookups.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'To accelerate server password hashing computations', 'Salting does not accelerate hashing; key derivation functions are deliberately tuned to be slow.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?', 'The server presents an X.509 digital certificate digitally signed by a trusted Certificate Authority (CA) whose root certificate resides in the client trust store.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The reverse DNS PTR record of the client router', 'DNS PTR records are unauthenticated and easily spoofed.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'An X.509 digital certificate issued and signed by a trusted Certificate Authority (CA)', 'Correct. CA digital signatures validate the server identity and public key.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The client\'s local MAC address broadcasted over ARP', 'MAC addresses only exist on local physical link layers.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The HTTP session cookie set by a previous request', 'Session cookies are application-layer artifacts and do not validate TLS endpoints.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)', 'RSA, ECDSA, and Diffie-Hellman are asymmetric algorithms. AES is a symmetric block cipher.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'RSA', 'Asymmetric encryption and digital signature algorithm.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'ECDSA (Elliptic Curve Digital Signature Algorithm)', 'Asymmetric digital signature algorithm based on elliptic curves.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Diffie-Hellman Key Exchange', 'Asymmetric protocol for securely establishing shared keys.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'AES (Advanced Encryption Standard)', 'AES is a symmetric key block cipher.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)', 'bcrypt, Argon2id, and PBKDF2 are deliberately designed password hashing algorithms with configurable memory and CPU cost parameters.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Network Security & Cryptographic Foundations'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'bcrypt', 'Features an adaptive cost factor scaling iteration rounds.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Argon2id', 'Winner of the Password Hashing Competition; configurable memory and time cost.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'PBKDF2', 'NIST-approved key derivation function with configurable iteration counts.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'MD5', 'MD5 is a fast general-purpose hash function unsuitable for passwords.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Network Security & Cryptographic Foundations' AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;

-- Subject: Application Security & OWASP Top 10
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Application Security & OWASP Top 10', 'SQL injection defenses, Cross-Site Scripting (XSS), CSRF mitigation, and least privilege access controls.', 1, 1
FROM tce_modules m WHERE m.module_name='Cybersecurity & Network Defense' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the single most effective primary defense against SQL Injection vulnerabilities in application code?', 'Parameterized queries (prepared statements) ensure user input is treated strictly as data rather than executable SQL syntax.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Parameterized queries (Prepared Statements) with bound parameters', 'Correct. Pre-compiles SQL grammar and treats parameters purely as literals.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Client-side HTML input maxlength attributes', 'Client-side constraints are trivially bypassed by intercepting proxies.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Encoding database tables using Base64', 'Base64 is an encoding, not an encryption or security defense.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Replacing single quotes with double quotes via regular expressions', 'Ad-hoc regex blacklists frequently miss evasion bypasses.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?', 'Cross-Site Request Forgery (CSRF) tricks an authenticated browser into submitting unauthorized requests to a vulnerable application.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Server-Side Request Forgery (SSRF)', 'SSRF induces the backend server to make unauthorized requests.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Buffer Overflow', 'Buffer overflow is a memory safety vulnerability.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Directory Traversal', 'Directory traversal exploits dot-dot-slash paths to access files.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Cross-Site Request Forgery (CSRF)', 'Correct. CSRF exploits automatic transmission of session credentials.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?', 'Stored XSS persists malicious script into database records, which then executes in the browser of any user who views the infected page.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Hardware motherboards on client devices suffer permanent physical damage', 'XSS is a logical browser scripting vulnerability.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Database indices are automatically wiped after every query', 'Database integrity is affected by SQL injection, not XSS.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Malicious scripts execute in the context of victim user sessions, allowing cookie theft and account takeover', 'Correct. XSS executes attacker JavaScript within the victim\'s trusted browser session.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Attacking code can recompile the server-side PHP binary on disk', 'XSS executes in the client browser, not on the server operating system.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the definition of the \"Principle of Least Privilege\" in information security architecture?', 'Every subject (user, process, or system) must be granted only the minimum permissions necessary to complete authorized functions.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Requiring all servers to run on single-core CPU processors', 'Hardware specifications are unrelated to privilege management.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Granting entities only the minimum privileges essential to perform their authorized functions', 'Correct. Minimizes the potential attack surface and blast radius.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Granting full root administrator access to all employees to avoid productivity delays', 'Direct violation of security principles.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Disabling password requirements on internal local area networks', 'Weakens access controls.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)', 'Context-sensitive output encoding, robust Content Security Policies (CSP), and the HttpOnly flag on sensitive cookies protect against XSS exploitation.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Context-aware output escaping and HTML encoding before rendering data', 'Neutralizes executable characters like <, >, and quotes in user content.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Enforcing a strict Content-Security-Policy (CSP) restricting inline script execution', 'Prevents unauthorized scripts from executing even if injected.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Marking session cookies with the HttpOnly attribute', 'Blocks client-side JavaScript (document.cookie) from reading the session token.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Disabling all database foreign key constraints', 'Foreign key constraints have no bearing on XSS mitigation.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)', 'Multi-factor authentication (MFA), progressive rate limiting/delays, and screening against known breached passwords safeguard authentication endpoints.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cybersecurity & Network Defense' AND s.subject_name='Application Security & OWASP Top 10'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Multi-Factor Authentication (MFA / 2FA)', 'Requires a secondary factor beyond passwords, stopping credential stuffing.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Rate limiting and progressive login attempt throttling', 'Limits automated high-volume guess attempts per IP and account.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Screening passwords against known compromised password databases (HaveIBeenPwned)', 'Prevents users from choosing passwords already leaked in breaches.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Logging plaintext passwords into unencrypted server log files', 'Severe security vulnerability exposing credentials.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Application Security & OWASP Top 10' AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;

-- Module: Cloud Infrastructure & DevOps Practices
INSERT INTO tce_modules (module_name, module_enabled, module_user_id)
VALUES ('Cloud Infrastructure & DevOps Practices', 1, 1)
ON DUPLICATE KEY UPDATE module_enabled=VALUES(module_enabled);

-- Subject: Containerization & Docker Fundamentals
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'Containerization & Docker Fundamentals', 'Container vs VM architecture, Dockerfiles, volumes, networking, and multi-stage image builds.', 1, 1
FROM tce_modules m WHERE m.module_name='Cloud Infrastructure & DevOps Practices' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?', 'Containers share the host operating system kernel and isolate processes using cgroups and namespaces, whereas VMs run a complete guest OS on top of a hypervisor.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Containers share the host OS kernel; VMs each run a full guest operating system via a hypervisor', 'Correct. Containers are lightweight process isolations sharing the host kernel.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Containers require dedicated physical network cards for each running instance', 'Containers use virtual bridge networks created by Docker daemon.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Virtual machines can only run on Linux, while containers run on any device', 'Hypervisors run on all major server operating systems.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Containers execute exclusively in volatile RAM and cannot write to disk', 'Containers write to copy-on-write storage layers and persistent volumes.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?', 'RUN executes commands during image build time to commit new image layers. CMD defines the default command and arguments executed when a container starts.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'RUN is only executed on Linux hosts; CMD is only executed on Windows hosts', 'Both instructions are cross-platform Dockerfile standards.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'CMD commits changes to Git; RUN commits changes to Docker Hub', 'Neither instruction interacts directly with Git or Docker Hub.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'RUN deletes existing layers; CMD restores layers from cache', 'Neither instruction manages cache restoration in this manner.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'RUN executes at build time to create image layers; CMD defines default container runtime execution', 'Correct. RUN builds the image; CMD sets the container entry process.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which mechanism is recommended for persisting database data across Docker container recreation and restarts?', 'Docker Volumes and Bind Mounts store data on host filesystems independently of the container lifecycle, ensuring persistence.',
  1, 2, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Hardcoding data directly into Dockerfile ENV variables', 'Environment variables are for configuration, not persistent database storage.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Rebuilding the image on every database write operation', 'Impractical and violates immutability principles.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Docker Named Volumes or Bind Mounts', 'Correct. Volumes decouple persistent data from container lifetimes.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'The ephemeral container writable layer', 'The writable layer is destroyed when the container is removed.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the primary operational advantage of multi-stage Docker builds?', 'Multi-stage builds allow developers to use compilers, SDKs, and intermediate tools in early stages, copying only the final compiled artifacts into a lightweight, secure production image.',
  1, 3, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Converting Docker images into virtual floppy disk files', 'Unrelated legacy storage technology.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Drastically reducing final production image sizes and attack surface by leaving build tooling behind', 'Correct. Compilers and headers are omitted from the minimal runtime image.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Allowing containers to run without an underlying operating system kernel', 'Containers always rely on the host operating system kernel.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Enabling containers to bypass network port exposure rules', 'Network rules remain governed by the container runtime.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)', 'Namespaces provide isolated process, network, user, and mount views. Control Groups (cgroups) meter and enforce limits on CPU, memory, and I/O resources.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Linux Kernel Namespaces (PID, NET, MNT, IPC, UTS, USER)', 'Provides view isolation for processes, networks, and filesystems.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Linux Control Groups (cgroups)', 'Enforces CPU, memory, disk I/O, and resource consumption boundaries.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Hardware Hypervisor Type-1 firmware', 'Bare-metal hypervisors (ESXi, Xen) are used for full VMs, not containers.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Direct BIOS ROM flashing', 'BIOS flashing is motherboard firmware maintenance.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)', 'docker run creates and starts a container; docker stop halts execution gracefully; docker rm deletes stopped containers.',
  2, 1, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='Containerization & Docker Fundamentals'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'docker run', 'Creates and starts a container process.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'docker stop', 'Sends SIGTERM and gracefully halts container processes.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'docker rm', 'Removes one or more stopped containers from disk.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'docker push-kernel', 'Not a valid Docker command.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='Containerization & Docker Fundamentals' AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;

-- Subject: CI/CD Automation & Version Control (Git)
INSERT INTO tce_subjects (subject_module_id, subject_name, subject_description, subject_enabled, subject_user_id)
SELECT m.module_id, 'CI/CD Automation & Version Control (Git)', 'Git branching strategies, commit history hygiene, automated CI/CD pipelines, and semantic versioning.', 1, 1
FROM tce_modules m WHERE m.module_name='Cloud Infrastructure & DevOps Practices' LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which Git command creates a new branch and immediately switches your active working tree to it?', 'git checkout -b <name> (or the modern git switch -c <name>) creates the branch and checks it out in a single step.',
  1, 1, 1, 1
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git checkout -b <branch-name> (or git switch -c <branch-name>)', 'Correct. Combines branch creation and checkout.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git merge --create <branch-name>', 'git merge joins branches, it does not create and switch to them.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git push --new-branch <branch-name>', 'git push uploads commits to a remote repository.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git commit --branch <branch-name>', 'git commit records changes, not branch creation.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?', 'git merge ties branch histories together preserving true commit timestamps and producing a merge commit; git rebase moves the branch base, creating a linear history.',
  1, 2, 1, 2
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git merge deletes uncommitted files, while git rebase stashes them permanently', 'Neither command automatically destroys uncommitted files.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git rebase can only be used on GitHub servers, not locally', 'git rebase is a native local Git command.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git merge converts all commits into binary patches', 'Git natively stores commits as tree and commit objects.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git merge preserves exact history with a merge commit; git rebase rewrites commits linearly on the base branch', 'Correct. Merge keeps branch topology; rebase linearizes commit history.',
  1, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'What is the primary objective of Continuous Integration (CI) in software development teams?', 'CI aims to integrate developer working copies into a shared mainline several times a day, accompanied by automated building and testing to catch regressions early.',
  1, 1, 1, 3
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Replacing version control repositories with periodic email attachments', 'CI requires automated source control.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Automatically deploying untested code directly to customer servers', 'Deploying untested code violates CI/CD quality gates.',
  0, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Frequently merging code into a shared mainline with automated building and testing to surface defects early', 'Correct. Early automated defect detection is the hallmark of CI.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Eliminating the requirement for developers to write unit tests', 'CI relies heavily on developer-written unit tests to validate builds.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?', 'SemVer format is MAJOR.MINOR.PATCH. A MAJOR version bump signifies backwards-incompatible breaking API changes.',
  1, 2, 1, 4
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'BUILD metadata (e.g., 1.4.2+2026)', 'Build metadata does not denote compatibility semantics.',
  0, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'MAJOR (e.g., 1.4.2 -> 2.0.0)', 'Correct. MAJOR version changes denote incompatible public API modifications.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'MINOR (e.g., 1.4.2 -> 1.5.0)', 'MINOR denotes backwards-compatible new functionality.',
  0, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'PATCH (e.g., 1.4.2 -> 1.4.3)', 'PATCH denotes backwards-compatible bug fixes.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)', 'Automated unit/integration test suites, static analysis/linters, and security vulnerability scans are standard quality gates in CI.',
  2, 2, 1, 5
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Automated unit and integration test suites', 'Verifies functionality and guards against regression.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Static code analysis and linter checks', 'Enforces code style and spots syntax/semantic bugs.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Dependency security vulnerability scanning (SAST/SCA)', 'Identifies vulnerable third-party dependencies before merging.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'Physical hardware burn-in testing of developer laptops', 'Developer laptop burn-in is not part of software CI pipelines.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_questions (
  question_subject_id, question_description, question_explanation,
  question_type, question_difficulty, question_enabled, question_position
)
SELECT s.subject_id, 'Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)', 'git rebase, git commit --amend, and git reset --hard alter commit SHAs and history, disrupting peers if performed on shared branches.',
  2, 3, 1, 6
FROM tce_subjects s
JOIN tce_modules m ON s.subject_module_id=m.module_id
WHERE m.module_name='Cloud Infrastructure & DevOps Practices' AND s.subject_name='CI/CD Automation & Version Control (Git)'
LIMIT 1;

INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git rebase', 'Rewrites commit parentage and produces new commit SHAs.',
  1, 1, 1, 65
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git commit --amend', 'Replaces the most recent commit with a revised commit SHA.',
  1, 1, 2, 66
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git reset --hard', 'Moves HEAD and discards commits and working tree modifications.',
  1, 1, 3, 67
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;
INSERT INTO tce_answers (
  answer_question_id, answer_description, answer_explanation,
  answer_isright, answer_enabled, answer_position, answer_keyboard_key
)
SELECT q.question_id, 'git status', 'Read-only command displaying working tree status.',
  0, 1, 4, 68
FROM tce_questions q
JOIN tce_subjects s ON q.question_subject_id=s.subject_id
WHERE s.subject_name='CI/CD Automation & Version Control (Git)' AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;

-- -----------------------------------------------------------------------------
-- 4. Showcase Certification Exams
-- -----------------------------------------------------------------------------
-- Test: CS101: Web & Database Engineering Certification Exam
INSERT INTO tce_tests (
  test_name, test_description, test_begin_time, test_end_time, test_duration_time,
  test_ip_range, test_results_to_users, test_report_to_users,
  test_score_right, test_score_wrong, test_score_unanswered, test_max_score,
  test_user_id, test_score_threshold, test_random_questions_select,
  test_random_questions_order, test_random_answers_select, test_random_answers_order,
  test_comment_enabled, test_menu_enabled, test_noanswer_enabled, test_mcma_radio,
  test_repeatable, test_mcma_partial_score, test_logout_on_timeout
) VALUES (
  'CS101: Web & Database Engineering Certification Exam',
  'Comprehensive assessment covering Web Protocols, Relational Database Engineering, and Core Algorithmic Complexity. 12 questions selected across all CS subjects.',
  '2026-01-01 00:00:00', '2030-12-31 23:59:59', 45,
  '*.*.*.*', 1, 1,
  1.000, 0.000, 0.000, 12.000,
  1, 8.400, 1,
  1, 1, 1,
  1, 1, 1, 1,
  1, 1, 0
) ON DUPLICATE KEY UPDATE
  test_description=VALUES(test_description),
  test_max_score=VALUES(test_max_score),
  test_score_threshold=VALUES(test_score_threshold);

-- Link topic 'Web Protocols & Client-Server Architecture' (4 questions) to test 'CS101: Web & Database Engineering Certification Exam'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 4, 4
FROM tce_tests t WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Web Protocols & Client-Server Architecture' LIMIT 1;

-- Link topic 'Database Engineering & Relational SQL' (4 questions) to test 'CS101: Web & Database Engineering Certification Exam'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 4, 4
FROM tce_tests t WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Database Engineering & Relational SQL' LIMIT 1;

-- Link topic 'Data Structures & Algorithmic Complexity' (4 questions) to test 'CS101: Web & Database Engineering Certification Exam'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 4, 4
FROM tce_tests t WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Data Structures & Algorithmic Complexity' LIMIT 1;

INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND g.group_name='CS101-Morning';
INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND g.group_name='CS101-Evening';

-- Test: SEC201: Cybersecurity Fundamentals & Network Defense
INSERT INTO tce_tests (
  test_name, test_description, test_begin_time, test_end_time, test_duration_time,
  test_ip_range, test_results_to_users, test_report_to_users,
  test_score_right, test_score_wrong, test_score_unanswered, test_max_score,
  test_user_id, test_score_threshold, test_random_questions_select,
  test_random_questions_order, test_random_answers_select, test_random_answers_order,
  test_comment_enabled, test_menu_enabled, test_noanswer_enabled, test_mcma_radio,
  test_repeatable, test_mcma_partial_score, test_logout_on_timeout
) VALUES (
  'SEC201: Cybersecurity Fundamentals & Network Defense',
  'Security assessment covering cryptographic principles, TLS protocols, and OWASP Top 10 web application defenses. 12 questions selected across cybersecurity subjects.',
  '2026-01-01 00:00:00', '2030-12-31 23:59:59', 40,
  '*.*.*.*', 1, 1,
  1.000, 0.000, 0.000, 12.000,
  1, 9.000, 1,
  1, 1, 1,
  1, 1, 1, 1,
  1, 1, 0
) ON DUPLICATE KEY UPDATE
  test_description=VALUES(test_description),
  test_max_score=VALUES(test_max_score),
  test_score_threshold=VALUES(test_score_threshold);

-- Link topic 'Network Security & Cryptographic Foundations' (6 questions) to test 'SEC201: Cybersecurity Fundamentals & Network Defense'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 6, 4
FROM tce_tests t WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Network Security & Cryptographic Foundations' LIMIT 1;

-- Link topic 'Application Security & OWASP Top 10' (6 questions) to test 'SEC201: Cybersecurity Fundamentals & Network Defense'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 6, 4
FROM tce_tests t WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Application Security & OWASP Top 10' LIMIT 1;

INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND g.group_name='CyberSec-Cohort-A';

-- Test: OPS301: Cloud Infrastructure & DevOps Readiness
INSERT INTO tce_tests (
  test_name, test_description, test_begin_time, test_end_time, test_duration_time,
  test_ip_range, test_results_to_users, test_report_to_users,
  test_score_right, test_score_wrong, test_score_unanswered, test_max_score,
  test_user_id, test_score_threshold, test_random_questions_select,
  test_random_questions_order, test_random_answers_select, test_random_answers_order,
  test_comment_enabled, test_menu_enabled, test_noanswer_enabled, test_mcma_radio,
  test_repeatable, test_mcma_partial_score, test_logout_on_timeout
) VALUES (
  'OPS301: Cloud Infrastructure & DevOps Readiness',
  'Practical assessment on containerization principles, Docker lifecycle management, CI/CD pipelines, and Git workflows. 12 questions.',
  '2026-01-01 00:00:00', '2030-12-31 23:59:59', 30,
  '*.*.*.*', 1, 1,
  1.000, 0.000, 0.000, 12.000,
  1, 8.400, 1,
  1, 1, 1,
  1, 1, 1, 1,
  1, 1, 0
) ON DUPLICATE KEY UPDATE
  test_description=VALUES(test_description),
  test_max_score=VALUES(test_max_score),
  test_score_threshold=VALUES(test_score_threshold);

-- Link topic 'Containerization & Docker Fundamentals' (6 questions) to test 'OPS301: Cloud Infrastructure & DevOps Readiness'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 6, 4
FROM tce_tests t WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='Containerization & Docker Fundamentals' LIMIT 1;

-- Link topic 'CI/CD Automation & Version Control (Git)' (6 questions) to test 'OPS301: Cloud Infrastructure & DevOps Readiness'
INSERT INTO tce_test_subject_set (
  tsubset_test_id, tsubset_type, tsubset_difficulty, tsubset_quantity, tsubset_answers
)
SELECT t.test_id, 0, 0, 6, 4
FROM tce_tests t WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' LIMIT 1;

INSERT IGNORE INTO tce_test_subjects (subjset_tsubset_id, subjset_subject_id)
SELECT LAST_INSERT_ID(), s.subject_id
FROM tce_subjects s WHERE s.subject_name='CI/CD Automation & Version Control (Git)' LIMIT 1;

INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND g.group_name='CS101-Morning';
INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND g.group_name='CS101-Evening';
INSERT IGNORE INTO tce_testgroups (tstgrp_test_id, tstgrp_group_id)
SELECT t.test_id, g.group_id
FROM tce_tests t, tce_user_groups g
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND g.group_name='CyberSec-Cohort-A';

SET FOREIGN_KEY_CHECKS = 1;
-- =============================================================================
-- End of Showcase Seed Script
-- =============================================================================
