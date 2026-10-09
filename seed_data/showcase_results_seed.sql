-- =============================================================================
-- TCExam Simulated Exam Results & Analytics Seed Script
-- Generated: 2026-10-09 16:30:29
-- Populates tce_tests_users, tce_tests_logs, and tce_tests_logs_answers
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- Test: CS101: Web & Database Engineering Certification Exam
-- -----------------------------------------------------------------------------

-- Attempt: sophia.kim | Status: 4 | Duration: 24m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 14:00:00', 'Official certification exam completed. Grade: Honors (100.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='sophia.kim'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='sophia.kim' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:00:00', '2026-02-15 14:00:00', '2026-02-15 14:01:42',
  102000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:01:42', '2026-02-15 14:01:42', '2026-02-15 14:03:54',
  132000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:03:54', '2026-02-15 14:03:54', '2026-02-15 14:05:48',
  114000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:05:48', '2026-02-15 14:05:48', '2026-02-15 14:08:12',
  144000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:08:12', '2026-02-15 14:08:12', '2026-02-15 14:09:42',
  90000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:09:42', '2026-02-15 14:09:42', '2026-02-15 14:11:48',
  126000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:11:48', '2026-02-15 14:11:48', '2026-02-15 14:14:06',
  138000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:14:06', '2026-02-15 14:14:06', '2026-02-15 14:15:54',
  108000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='B-Tree (and B+ Tree)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:15:54', '2026-02-15 14:15:54', '2026-02-15 14:18:06',
  132000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:18:06', '2026-02-15 14:18:06', '2026-02-15 14:19:42',
  96000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:19:42', '2026-02-15 14:19:42', '2026-02-15 14:22:12',
  150000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 14:22:12', '2026-02-15 14:22:12', '2026-02-15 14:24:00',
  108000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Merge Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: alex.taylor | Status: 4 | Duration: 28m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 10:00:00', 'Official certification exam completed. Grade: Honors (91.7%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='alex.taylor'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='alex.taylor' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:00:00', '2026-02-15 10:00:00', '2026-02-15 10:01:59',
  119000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:01:59', '2026-02-15 10:01:59', '2026-02-15 10:04:33',
  154000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:04:33', '2026-02-15 10:04:33', '2026-02-15 10:06:46',
  133000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:06:46', '2026-02-15 10:06:46', '2026-02-15 10:09:34',
  168000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:09:34', '2026-02-15 10:09:34', '2026-02-15 10:11:19',
  105000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:11:19', '2026-02-15 10:11:19', '2026-02-15 10:13:46',
  147000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:13:46', '2026-02-15 10:13:46', '2026-02-15 10:16:27',
  161000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:16:27', '2026-02-15 10:16:27', '2026-02-15 10:18:33',
  126000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Splay Tree' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:18:33', '2026-02-15 10:18:33', '2026-02-15 10:21:07',
  154000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:21:07', '2026-02-15 10:21:07', '2026-02-15 10:22:59',
  112000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:22:59', '2026-02-15 10:22:59', '2026-02-15 10:25:54',
  175000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:25:54', '2026-02-15 10:25:54', '2026-02-15 10:28:00',
  126000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Merge Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: daniel.novak | Status: 4 | Duration: 35m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 18:00:00', 'Official certification exam completed. Grade: Pass (83.3%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='daniel.novak'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='daniel.novak' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:00:00', '2026-02-15 18:00:00', '2026-02-15 18:02:29',
  149000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:02:29', '2026-02-15 18:02:29', '2026-02-15 18:05:42',
  193000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:05:42', '2026-02-15 18:05:42', '2026-02-15 18:08:28',
  166000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:08:28', '2026-02-15 18:08:28', '2026-02-15 18:11:58',
  210000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are only accessible over WebSockets, while localStorage works over HTTP' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:11:58', '2026-02-15 18:11:58', '2026-02-15 18:14:09',
  131000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:14:09', '2026-02-15 18:14:09', '2026-02-15 18:17:13',
  184000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:17:13', '2026-02-15 18:17:13', '2026-02-15 18:20:34',
  201000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:20:34', '2026-02-15 18:20:34', '2026-02-15 18:23:12',
  158000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='B-Tree (and B+ Tree)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:23:12', '2026-02-15 18:23:12', '2026-02-15 18:26:25',
  193000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:26:25', '2026-02-15 18:26:25', '2026-02-15 18:28:45',
  140000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:28:45', '2026-02-15 18:28:45', '2026-02-15 18:32:24',
  219000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:32:24', '2026-02-15 18:32:24', '2026-02-15 18:35:00',
  156000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Heap Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: fatima.zahra | Status: 4 | Duration: 31m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 18:05:00', 'Official certification exam completed. Grade: Pass (83.3%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='fatima.zahra'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='fatima.zahra' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:05:00', '2026-02-15 18:05:00', '2026-02-15 18:07:12',
  132000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:07:12', '2026-02-15 18:07:12', '2026-02-15 18:10:03',
  171000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:10:03', '2026-02-15 18:10:03', '2026-02-15 18:12:30',
  147000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:12:30', '2026-02-15 18:12:30', '2026-02-15 18:15:36',
  186000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:15:36', '2026-02-15 18:15:36', '2026-02-15 18:17:32',
  116000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:17:32', '2026-02-15 18:17:32', '2026-02-15 18:20:15',
  163000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:20:15', '2026-02-15 18:20:15', '2026-02-15 18:23:13',
  178000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Integrity' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:23:13', '2026-02-15 18:23:13', '2026-02-15 18:25:33',
  140000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='B-Tree (and B+ Tree)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:25:33', '2026-02-15 18:25:33', '2026-02-15 18:28:24',
  171000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:28:24', '2026-02-15 18:28:24', '2026-02-15 18:30:28',
  124000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Stack' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:30:28', '2026-02-15 18:30:28', '2026-02-15 18:33:42',
  194000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:33:42', '2026-02-15 18:33:42', '2026-02-15 18:36:00',
  138000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Merge Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: brenda.wright | Status: 4 | Duration: 38m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 10:05:00', 'Official certification exam completed. Grade: Pass (75.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='brenda.wright'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='brenda.wright' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:05:00', '2026-02-15 10:05:00', '2026-02-15 10:07:42',
  162000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:07:42', '2026-02-15 10:07:42', '2026-02-15 10:11:11',
  209000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:11:11', '2026-02-15 10:11:11', '2026-02-15 10:14:12',
  181000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:14:12', '2026-02-15 10:14:12', '2026-02-15 10:18:00',
  228000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='localStorage expires as soon as the browser tab closes, while Cookies never expire' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:18:00', '2026-02-15 10:18:00', '2026-02-15 10:20:23',
  143000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:20:23', '2026-02-15 10:20:23', '2026-02-15 10:23:43',
  200000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:23:43', '2026-02-15 10:23:43', '2026-02-15 10:27:22',
  219000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:27:22', '2026-02-15 10:27:22', '2026-02-15 10:30:13',
  171000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Splay Tree' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:30:13', '2026-02-15 10:30:13', '2026-02-15 10:33:42',
  209000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:33:42', '2026-02-15 10:33:42', '2026-02-15 10:36:14',
  152000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:36:14', '2026-02-15 10:36:14', '2026-02-15 10:40:12',
  238000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(n^2)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:40:12', '2026-02-15 10:40:12', '2026-02-15 10:43:00',
  168000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Merge Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: maria.santos | Status: 4 | Duration: 40m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 10:10:00', 'Official certification exam completed. Grade: Pass (75.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='maria.santos'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='maria.santos' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:10:00', '2026-02-15 10:10:00', '2026-02-15 10:12:50',
  170000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:12:50', '2026-02-15 10:12:50', '2026-02-15 10:16:30',
  220000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To prevent scripts from one origin from reading private DOM data or responses from another origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:16:30', '2026-02-15 10:16:30', '2026-02-15 10:19:40',
  190000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Strict-Transport-Security' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:19:40', '2026-02-15 10:19:40', '2026-02-15 10:23:40',
  240000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:23:40', '2026-02-15 10:23:40', '2026-02-15 10:26:10',
  150000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:26:10', '2026-02-15 10:26:10', '2026-02-15 10:29:40',
  210000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:29:40', '2026-02-15 10:29:40', '2026-02-15 10:33:30',
  230000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Idempotence' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:33:30', '2026-02-15 10:33:30', '2026-02-15 10:36:30',
  180000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='B-Tree (and B+ Tree)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:36:30', '2026-02-15 10:36:30', '2026-02-15 10:40:10',
  220000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:40:10', '2026-02-15 10:40:10', '2026-02-15 10:42:50',
  160000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:42:50', '2026-02-15 10:42:50', '2026-02-15 10:47:00',
  250000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:47:00', '2026-02-15 10:47:00', '2026-02-15 10:50:00',
  180000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Heap Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: kevin.patel | Status: 4 | Duration: 42m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 10:15:00', 'Official certification exam completed. Grade: Failed (58.3%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='kevin.patel'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='kevin.patel' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:15:00', '2026-02-15 10:15:00', '2026-02-15 10:17:59',
  179000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:17:59', '2026-02-15 10:17:59', '2026-02-15 10:21:50',
  231000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To enforce automatic renewal of TLS/SSL certificates' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:21:50', '2026-02-15 10:21:50', '2026-02-15 10:25:10',
  200000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Access-Control-Allow-Origin' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:25:10', '2026-02-15 10:25:10', '2026-02-15 10:29:22',
  252000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies store up to 50 MB of data, while localStorage stores only 4 KB' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:29:22', '2026-02-15 10:29:22', '2026-02-15 10:32:00',
  158000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='PRIMARY KEY' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:32:00', '2026-02-15 10:32:00', '2026-02-15 10:35:41',
  221000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='CROSS JOIN' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:35:41', '2026-02-15 10:35:41', '2026-02-15 10:39:43',
  242000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:39:43', '2026-02-15 10:39:43', '2026-02-15 10:42:52',
  189000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Trie (Prefix Tree)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:42:52', '2026-02-15 10:42:52', '2026-02-15 10:46:43',
  231000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:46:43', '2026-02-15 10:46:43', '2026-02-15 10:49:31',
  168000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Queue' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 10:49:31', '2026-02-15 10:49:31', '2026-02-15 10:53:54',
  263000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 10:53:54', '2026-02-15 10:53:54', '2026-02-15 10:57:00',
  186000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Merge Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: lucas.silva | Status: 4 | Duration: 44m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-15 18:10:00', 'Official certification exam completed. Grade: Failed (50.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='lucas.silva'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='lucas.silva' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:10:00', '2026-02-15 18:10:00', '2026-02-15 18:13:07',
  187000, 1, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='201 Created' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP status code indicates that a request has succeeded and led to the creation of a new resource on the server?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:13:07', '2026-02-15 18:13:07', '2026-02-15 18:17:09',
  242000, 2, 4
FROM tce_questions q
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To synchronize JavaScript variables between client tabs' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary function of the Same-Origin Policy (SOP) implemented in web browsers?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:17:09', '2026-02-15 18:17:09', '2026-02-15 18:20:38',
  209000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Content-Security-Policy' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which HTTP response header is sent by servers to instruct browsers to permit cross-origin access?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:20:38', '2026-02-15 18:20:38', '2026-02-15 18:25:02',
  264000, 4, 4
FROM tce_questions q
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cookies are automatically transmitted to the server with every matching HTTP request; localStorage stays on the client' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='How do HTTP Cookies differ fundamentally from HTML5 localStorage regarding client-server communication?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:25:02', '2026-02-15 18:25:02', '2026-02-15 18:27:47',
  165000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='DEFAULT' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which database constraint guarantees that a column contains unique values and cannot store NULL values?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:27:47', '2026-02-15 18:27:47', '2026-02-15 18:31:38',
  231000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='LEFT JOIN (LEFT OUTER JOIN)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which SQL JOIN type returns all records from the left table and the matched records from the right table, filling non-matching right columns with NULL?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:31:38', '2026-02-15 18:31:38', '2026-02-15 18:35:51',
  253000, 7, 4
FROM tce_questions q
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Isolation' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In relational database transactions, what does the \"I\" in ACID stand for?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:35:51', '2026-02-15 18:35:51', '2026-02-15 18:39:09',
  198000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Splay Tree' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which tree data structure is most commonly utilized by relational database storage engines for table indexing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:39:09', '2026-02-15 18:39:09', '2026-02-15 18:43:11',
  242000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(1)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the average time complexity for searching a key in a properly dimensioned Hash Map?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:43:11', '2026-02-15 18:43:11', '2026-02-15 18:46:07',
  176000, 10, 4
FROM tce_questions q
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Binary Search Tree' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which fundamental data structure operates strictly according to the First-In, First-Out (FIFO) discipline?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-15 18:46:07', '2026-02-15 18:46:07', '2026-02-15 18:50:42',
  275000, 11, 4
FROM tce_questions q
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='O(log n)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the worst-case time complexity of the Binary Search algorithm when executed on a sorted array of size n?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-15 18:50:42', '2026-02-15 18:50:42', '2026-02-15 18:54:00',
  198000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Quick Sort' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which comparison sorting algorithm guarantees O(n log n) time complexity in the worst case while maintaining sort stability?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: james.wilson | Status: 0 | Duration: N/A
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 0, '2026-02-15 09:00:00', 'Assigned - Candidate ready to begin exam session.'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='james.wilson'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

-- Attempt: olivia.brown | Status: 0 | Duration: N/A
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 0, '2026-02-15 17:00:00', 'Assigned - Candidate ready to begin exam session.'
FROM tce_tests t, tce_users u
WHERE t.test_name='CS101: Web & Database Engineering Certification Exam' AND u.user_name='olivia.brown'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

-- -----------------------------------------------------------------------------
-- Test: SEC201: Cybersecurity Fundamentals & Network Defense
-- -----------------------------------------------------------------------------

-- Attempt: priya.sharma | Status: 4 | Duration: 22m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-18 11:00:00', 'Official certification exam completed. Grade: Honors (100.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='priya.sharma'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='priya.sharma' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:00:00', '2026-02-18 11:00:00', '2026-02-18 11:01:34',
  94000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Symmetric uses one shared secret key; asymmetric uses a public/private key pair' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:01:34', '2026-02-18 11:01:34', '2026-02-18 11:03:35',
  121000, 2, 4
FROM tce_questions q
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='SHA-256' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:03:35', '2026-02-18 11:03:35', '2026-02-18 11:05:20',
  105000, 3, 4
FROM tce_questions q
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To defend against rainbow table lookups and ensure identical passwords produce unique hashes' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:05:20', '2026-02-18 11:05:20', '2026-02-18 11:07:32',
  132000, 4, 4
FROM tce_questions q
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='An X.509 digital certificate issued and signed by a trusted Certificate Authority (CA)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:07:32', '2026-02-18 11:07:32', '2026-02-18 11:08:55',
  83000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RSA' THEN 1 WHEN a.answer_description='ECDSA (Elliptic Curve Digital Signature Algorithm)' THEN 1 WHEN a.answer_description='Diffie-Hellman Key Exchange' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:08:55', '2026-02-18 11:08:55', '2026-02-18 11:10:51',
  116000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='bcrypt' THEN 1 WHEN a.answer_description='Argon2id' THEN 1 WHEN a.answer_description='PBKDF2' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:10:51', '2026-02-18 11:10:51', '2026-02-18 11:12:58',
  127000, 7, 4
FROM tce_questions q
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Parameterized queries (Prepared Statements) with bound parameters' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:12:58', '2026-02-18 11:12:58', '2026-02-18 11:14:37',
  99000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cross-Site Request Forgery (CSRF)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:14:37', '2026-02-18 11:14:37', '2026-02-18 11:16:38',
  121000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Malicious scripts execute in the context of victim user sessions, allowing cookie theft and account takeover' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:16:38', '2026-02-18 11:16:38', '2026-02-18 11:18:06',
  88000, 10, 4
FROM tce_questions q
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Granting entities only the minimum privileges essential to perform their authorized functions' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:18:06', '2026-02-18 11:18:06', '2026-02-18 11:20:24',
  138000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Context-aware output escaping and HTML encoding before rendering data' THEN 1 WHEN a.answer_description='Enforcing a strict Content-Security-Policy (CSP) restricting inline script execution' THEN 1 WHEN a.answer_description='Marking session cookies with the HttpOnly attribute' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:20:24', '2026-02-18 11:20:24', '2026-02-18 11:22:00',
  96000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Multi-Factor Authentication (MFA / 2FA)' THEN 1 WHEN a.answer_description='Rate limiting and progressive login attempt throttling' THEN 1 WHEN a.answer_description='Screening passwords against known compromised password databases (HaveIBeenPwned)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: marcus.vance | Status: 4 | Duration: 26m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-18 11:05:00', 'Official certification exam completed. Grade: Honors (91.7%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='marcus.vance'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='marcus.vance' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:05:00', '2026-02-18 11:05:00', '2026-02-18 11:06:51',
  111000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Symmetric uses one shared secret key; asymmetric uses a public/private key pair' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:06:51', '2026-02-18 11:06:51', '2026-02-18 11:09:14',
  143000, 2, 4
FROM tce_questions q
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='SHA-256' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:09:14', '2026-02-18 11:09:14', '2026-02-18 11:11:18',
  124000, 3, 4
FROM tce_questions q
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To defend against rainbow table lookups and ensure identical passwords produce unique hashes' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:11:18', '2026-02-18 11:11:18', '2026-02-18 11:13:54',
  156000, 4, 4
FROM tce_questions q
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='An X.509 digital certificate issued and signed by a trusted Certificate Authority (CA)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:13:54', '2026-02-18 11:13:54', '2026-02-18 11:15:32',
  98000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RSA' THEN 1 WHEN a.answer_description='ECDSA (Elliptic Curve Digital Signature Algorithm)' THEN 1 WHEN a.answer_description='Diffie-Hellman Key Exchange' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-18 11:15:32', '2026-02-18 11:15:32', '2026-02-18 11:17:49',
  137000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='bcrypt' THEN 1 WHEN a.answer_description='MD5' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:17:49', '2026-02-18 11:17:49', '2026-02-18 11:20:19',
  150000, 7, 4
FROM tce_questions q
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Parameterized queries (Prepared Statements) with bound parameters' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:20:19', '2026-02-18 11:20:19', '2026-02-18 11:22:16',
  117000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cross-Site Request Forgery (CSRF)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:22:16', '2026-02-18 11:22:16', '2026-02-18 11:24:39',
  143000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Malicious scripts execute in the context of victim user sessions, allowing cookie theft and account takeover' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:24:39', '2026-02-18 11:24:39', '2026-02-18 11:26:23',
  104000, 10, 4
FROM tce_questions q
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Granting entities only the minimum privileges essential to perform their authorized functions' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:26:23', '2026-02-18 11:26:23', '2026-02-18 11:29:06',
  163000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Context-aware output escaping and HTML encoding before rendering data' THEN 1 WHEN a.answer_description='Enforcing a strict Content-Security-Policy (CSP) restricting inline script execution' THEN 1 WHEN a.answer_description='Marking session cookies with the HttpOnly attribute' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:29:06', '2026-02-18 11:29:06', '2026-02-18 11:31:00',
  114000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Multi-Factor Authentication (MFA / 2FA)' THEN 1 WHEN a.answer_description='Rate limiting and progressive login attempt throttling' THEN 1 WHEN a.answer_description='Screening passwords against known compromised password databases (HaveIBeenPwned)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: elena.rostova | Status: 4 | Duration: 37m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-18 11:10:00', 'Official certification exam completed. Grade: Failed (66.7%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='elena.rostova'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='elena.rostova' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:10:00', '2026-02-18 11:10:00', '2026-02-18 11:12:37',
  157000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Symmetric uses one shared secret key; asymmetric uses a public/private key pair' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the essential architectural distinction between symmetric and asymmetric cryptography?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:12:37', '2026-02-18 11:12:37', '2026-02-18 11:16:01',
  204000, 2, 4
FROM tce_questions q
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='SHA-256' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which cryptographic hash function is widely standardized and considered secure against collision vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:16:01', '2026-02-18 11:16:01', '2026-02-18 11:18:57',
  176000, 3, 4
FROM tce_questions q
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='To defend against rainbow table lookups and ensure identical passwords produce unique hashes' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Why is it critical to combine a cryptographic salt with user passwords before hashing?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-18 11:18:57', '2026-02-18 11:18:57', '2026-02-18 11:22:39',
  222000, 4, 4
FROM tce_questions q
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='The reverse DNS PTR record of the client router' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='During a TLS handshake, what verifies the authentic identity of the remote server to prevent Man-in-the-Middle (MitM) attacks?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:22:39', '2026-02-18 11:22:39', '2026-02-18 11:24:58',
  139000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RSA' THEN 1 WHEN a.answer_description='ECDSA (Elliptic Curve Digital Signature Algorithm)' THEN 1 WHEN a.answer_description='Diffie-Hellman Key Exchange' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which of the following algorithms are asymmetric (public-key) cryptographic algorithms? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-18 11:24:58', '2026-02-18 11:24:58', '2026-02-18 11:28:12',
  194000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='bcrypt' THEN 1 WHEN a.answer_description='MD5' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which password hashing functions feature configurable work factors (computational cost) to thwart specialized GPU/ASIC cracking? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:28:12', '2026-02-18 11:28:12', '2026-02-18 11:31:45',
  213000, 7, 4
FROM tce_questions q
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Parameterized queries (Prepared Statements) with bound parameters' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the single most effective primary defense against SQL Injection vulnerabilities in application code?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:31:45', '2026-02-18 11:31:45', '2026-02-18 11:34:32',
  167000, 8, 4
FROM tce_questions q
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Cross-Site Request Forgery (CSRF)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which attack occurs when an unauthorized action is transmitted from a user that the web application trusts, exploiting ambient credentials like cookies?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-18 11:34:32', '2026-02-18 11:34:32', '2026-02-18 11:37:56',
  204000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Hardware motherboards on client devices suffer permanent physical damage' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal danger presented by Stored Cross-Site Scripting (XSS) vulnerabilities?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:37:56', '2026-02-18 11:37:56', '2026-02-18 11:40:24',
  148000, 10, 4
FROM tce_questions q
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Granting entities only the minimum privileges essential to perform their authorized functions' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the definition of the \"Principle of Least Privilege\" in information security architecture?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-18 11:40:24', '2026-02-18 11:40:24', '2026-02-18 11:44:15',
  231000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Context-aware output escaping and HTML encoding before rendering data' THEN 1 WHEN a.answer_description='Disabling all database foreign key constraints' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which defensive techniques are effective in mitigating Cross-Site Scripting (XSS) vulnerabilities? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-18 11:44:15', '2026-02-18 11:44:15', '2026-02-18 11:47:00',
  165000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Multi-Factor Authentication (MFA / 2FA)' THEN 1 WHEN a.answer_description='Rate limiting and progressive login attempt throttling' THEN 1 WHEN a.answer_description='Screening passwords against known compromised password databases (HaveIBeenPwned)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which security practices defend authentication systems against automated credential stuffing and brute-force attacks? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: tariq.mansoor | Status: 0 | Duration: N/A
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 0, '2026-02-18 10:00:00', 'Assigned - Candidate ready to begin exam session.'
FROM tce_tests t, tce_users u
WHERE t.test_name='SEC201: Cybersecurity Fundamentals & Network Defense' AND u.user_name='tariq.mansoor'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

-- -----------------------------------------------------------------------------
-- Test: OPS301: Cloud Infrastructure & DevOps Readiness
-- -----------------------------------------------------------------------------

-- Attempt: marcus.vance | Status: 4 | Duration: 16m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-22 15:00:00', 'Official certification exam completed. Grade: Honors (100.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='marcus.vance'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='marcus.vance' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:00:00', '2026-02-22 15:00:00', '2026-02-22 15:01:08',
  68000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Containers share the host OS kernel; VMs each run a full guest operating system via a hypervisor' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:01:08', '2026-02-22 15:01:08', '2026-02-22 15:02:36',
  88000, 2, 4
FROM tce_questions q
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RUN executes at build time to create image layers; CMD defines default container runtime execution' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:02:36', '2026-02-22 15:02:36', '2026-02-22 15:03:52',
  76000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Docker Named Volumes or Bind Mounts' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:03:52', '2026-02-22 15:03:52', '2026-02-22 15:05:28',
  96000, 4, 4
FROM tce_questions q
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Drastically reducing final production image sizes and attack surface by leaving build tooling behind' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:05:28', '2026-02-22 15:05:28', '2026-02-22 15:06:28',
  60000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Linux Kernel Namespaces (PID, NET, MNT, IPC, UTS, USER)' THEN 1 WHEN a.answer_description='Linux Control Groups (cgroups)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:06:28', '2026-02-22 15:06:28', '2026-02-22 15:07:52',
  84000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='docker run' THEN 1 WHEN a.answer_description='docker stop' THEN 1 WHEN a.answer_description='docker rm' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:07:52', '2026-02-22 15:07:52', '2026-02-22 15:09:24',
  92000, 7, 4
FROM tce_questions q
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git checkout -b <branch-name> (or git switch -c <branch-name>)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:09:24', '2026-02-22 15:09:24', '2026-02-22 15:10:36',
  72000, 8, 4
FROM tce_questions q
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git merge preserves exact history with a merge commit; git rebase rewrites commits linearly on the base branch' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:10:36', '2026-02-22 15:10:36', '2026-02-22 15:12:04',
  88000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Frequently merging code into a shared mainline with automated building and testing to surface defects early' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:12:04', '2026-02-22 15:12:04', '2026-02-22 15:13:08',
  64000, 10, 4
FROM tce_questions q
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='MAJOR (e.g., 1.4.2 -> 2.0.0)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:13:08', '2026-02-22 15:13:08', '2026-02-22 15:14:48',
  100000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Automated unit and integration test suites' THEN 1 WHEN a.answer_description='Static code analysis and linter checks' THEN 1 WHEN a.answer_description='Dependency security vulnerability scanning (SAST/SCA)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:14:48', '2026-02-22 15:14:48', '2026-02-22 15:16:00',
  72000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git rebase' THEN 1 WHEN a.answer_description='git commit --amend' THEN 1 WHEN a.answer_description='git reset --hard' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: alex.taylor | Status: 4 | Duration: 19m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-22 15:05:00', 'Official certification exam completed. Grade: Pass (83.3%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='alex.taylor'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='alex.taylor' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:05:00', '2026-02-22 15:05:00', '2026-02-22 15:06:21',
  81000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Containers share the host OS kernel; VMs each run a full guest operating system via a hypervisor' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:06:21', '2026-02-22 15:06:21', '2026-02-22 15:08:06',
  105000, 2, 4
FROM tce_questions q
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RUN executes at build time to create image layers; CMD defines default container runtime execution' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:08:06', '2026-02-22 15:08:06', '2026-02-22 15:09:36',
  90000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Docker Named Volumes or Bind Mounts' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:09:36', '2026-02-22 15:09:36', '2026-02-22 15:11:30',
  114000, 4, 4
FROM tce_questions q
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Drastically reducing final production image sizes and attack surface by leaving build tooling behind' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-22 15:11:30', '2026-02-22 15:11:30', '2026-02-22 15:12:41',
  71000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Linux Kernel Namespaces (PID, NET, MNT, IPC, UTS, USER)' THEN 1 WHEN a.answer_description='Hardware Hypervisor Type-1 firmware' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:12:41', '2026-02-22 15:12:41', '2026-02-22 15:14:21',
  100000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='docker run' THEN 1 WHEN a.answer_description='docker stop' THEN 1 WHEN a.answer_description='docker rm' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:14:21', '2026-02-22 15:14:21', '2026-02-22 15:16:10',
  109000, 7, 4
FROM tce_questions q
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git checkout -b <branch-name> (or git switch -c <branch-name>)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:16:10', '2026-02-22 15:16:10', '2026-02-22 15:17:36',
  86000, 8, 4
FROM tce_questions q
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git merge preserves exact history with a merge commit; git rebase rewrites commits linearly on the base branch' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:17:36', '2026-02-22 15:17:36', '2026-02-22 15:19:21',
  105000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Frequently merging code into a shared mainline with automated building and testing to surface defects early' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:19:21', '2026-02-22 15:19:21', '2026-02-22 15:20:37',
  76000, 10, 4
FROM tce_questions q
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='MAJOR (e.g., 1.4.2 -> 2.0.0)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-22 15:20:37', '2026-02-22 15:20:37', '2026-02-22 15:22:36',
  119000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Automated unit and integration test suites' THEN 1 WHEN a.answer_description='Physical hardware burn-in testing of developer laptops' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:22:36', '2026-02-22 15:22:36', '2026-02-22 15:24:00',
  84000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git rebase' THEN 1 WHEN a.answer_description='git commit --amend' THEN 1 WHEN a.answer_description='git reset --hard' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

-- Attempt: daniel.novak | Status: 4 | Duration: 25m
INSERT INTO tce_tests_users (
  testuser_test_id, testuser_user_id, testuser_status, testuser_creation_time, testuser_comment
) SELECT t.test_id, u.user_id, 4, '2026-02-22 15:10:00', 'Official certification exam completed. Grade: Pass (75.0%).'
FROM tce_tests t, tce_users u
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='daniel.novak'
ON DUPLICATE KEY UPDATE
  testuser_status=VALUES(testuser_status),
  testuser_creation_time=VALUES(testuser_creation_time),
  testuser_comment=VALUES(testuser_comment);

SELECT tu.testuser_id INTO @curr_testuser_id
FROM tce_tests_users tu
JOIN tce_tests t ON tu.testuser_test_id=t.test_id
JOIN tce_users u ON tu.testuser_user_id=u.user_id
WHERE t.test_name='OPS301: Cloud Infrastructure & DevOps Readiness' AND u.user_name='daniel.novak' AND tu.testuser_status=4
LIMIT 1;

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:10:00', '2026-02-22 15:10:00', '2026-02-22 15:11:46',
  106000, 1, 4
FROM tce_questions q
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Containers share the host OS kernel; VMs each run a full guest operating system via a hypervisor' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the architectural distinction between a Docker container and a traditional Virtual Machine (VM)?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:11:46', '2026-02-22 15:11:46', '2026-02-22 15:14:04',
  138000, 2, 4
FROM tce_questions q
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='RUN executes at build time to create image layers; CMD defines default container runtime execution' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='In a Dockerfile, what distinguishes the RUN instruction from the CMD instruction?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:14:04', '2026-02-22 15:14:04', '2026-02-22 15:16:03',
  119000, 3, 4
FROM tce_questions q
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Docker Named Volumes or Bind Mounts' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which mechanism is recommended for persisting database data across Docker container recreation and restarts?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-22 15:16:03', '2026-02-22 15:16:03', '2026-02-22 15:18:33',
  150000, 4, 4
FROM tce_questions q
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Converting Docker images into virtual floppy disk files' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary operational advantage of multi-stage Docker builds?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:18:33', '2026-02-22 15:18:33', '2026-02-22 15:20:07',
  94000, 5, 4
FROM tce_questions q
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Linux Kernel Namespaces (PID, NET, MNT, IPC, UTS, USER)' THEN 1 WHEN a.answer_description='Linux Control Groups (cgroups)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Linux kernel mechanisms are foundational to Docker container process isolation and resource limits? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:20:07', '2026-02-22 15:20:07', '2026-02-22 15:22:18',
  131000, 6, 4
FROM tce_questions q
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='docker run' THEN 1 WHEN a.answer_description='docker stop' THEN 1 WHEN a.answer_description='docker rm' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Docker CLI commands directly manage container lifecycle states? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-22 15:22:18', '2026-02-22 15:22:18', '2026-02-22 15:24:42',
  144000, 7, 4
FROM tce_questions q
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git commit --branch <branch-name>' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git command creates a new branch and immediately switches your active working tree to it?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:24:42', '2026-02-22 15:24:42', '2026-02-22 15:26:35',
  113000, 8, 4
FROM tce_questions q
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git merge preserves exact history with a merge commit; git rebase rewrites commits linearly on the base branch' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the principal difference between `git merge` and `git rebase` when incorporating feature branch commits?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:26:35', '2026-02-22 15:26:35', '2026-02-22 15:28:53',
  138000, 9, 4
FROM tce_questions q
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Frequently merging code into a shared mainline with automated building and testing to surface defects early' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='What is the primary objective of Continuous Integration (CI) in software development teams?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  0.000, '2026-02-22 15:28:53', '2026-02-22 15:28:53', '2026-02-22 15:30:33',
  100000, 10, 4
FROM tce_questions q
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='BUILD metadata (e.g., 1.4.2+2026)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='According to Semantic Versioning (SemVer 2.0.0), which version segment MUST be incremented when introducing breaking, backwards-incompatible API changes?'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:30:33', '2026-02-22 15:30:33', '2026-02-22 15:33:09',
  156000, 11, 4
FROM tce_questions q
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='Automated unit and integration test suites' THEN 1 WHEN a.answer_description='Static code analysis and linter checks' THEN 1 WHEN a.answer_description='Dependency security vulnerability scanning (SAST/SCA)' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which automated verification steps are standard components of a continuous integration pipeline? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

INSERT INTO tce_tests_logs (
  testlog_testuser_id, testlog_user_ip, testlog_question_id, testlog_answer_text,
  testlog_score, testlog_creation_time, testlog_display_time, testlog_change_time,
  testlog_reaction_time, testlog_order, testlog_num_answers
) SELECT
  @curr_testuser_id, '127.0.0.1', q.question_id, NULL,
  1.000, '2026-02-22 15:33:09', '2026-02-22 15:33:09', '2026-02-22 15:35:00',
  111000, 12, 4
FROM tce_questions q
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1
ON DUPLICATE KEY UPDATE
  testlog_score=VALUES(testlog_score),
  testlog_display_time=VALUES(testlog_display_time),
  testlog_change_time=VALUES(testlog_change_time),
  testlog_reaction_time=VALUES(testlog_reaction_time),
  testlog_order=VALUES(testlog_order);

SELECT tl.testlog_id INTO @curr_testlog_id
FROM tce_tests_logs tl
JOIN tce_questions q ON tl.testlog_question_id=q.question_id
WHERE tl.testlog_testuser_id=@curr_testuser_id AND q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
LIMIT 1;

INSERT INTO tce_tests_logs_answers (logansw_testlog_id, logansw_answer_id, logansw_selected, logansw_order)
SELECT @curr_testlog_id, a.answer_id, CASE WHEN a.answer_description='git rebase' THEN 1 WHEN a.answer_description='git commit --amend' THEN 1 WHEN a.answer_description='git reset --hard' THEN 1 ELSE 0 END, a.answer_position
FROM tce_answers a
JOIN tce_questions q ON a.answer_question_id=q.question_id
WHERE q.question_description='Which Git commands rewrite commit history and must be exercised with extreme caution on shared public branches? (Select all that apply)'
ON DUPLICATE KEY UPDATE
  logansw_selected=VALUES(logansw_selected),
  logansw_order=VALUES(logansw_order);

SET FOREIGN_KEY_CHECKS = 1;
-- =============================================================================
-- End of Showcase Results Seed Script
-- =============================================================================
