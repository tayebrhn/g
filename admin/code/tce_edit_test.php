<?php
//============================================================+
// File name   : tce_edit_test.php
// Begin       : 2004-04-27
// Last Update : 2023-11-30
//
// Description : Edit Tests
//
// Author: Nicola Asuni
//
// (c) Copyright:
//               Nicola Asuni
//               Tecnick.com LTD
//               www.tecnick.com
//               info@tecnick.com
//
// License:
//    Copyright (C) 2004-2026 Nicola Asuni - Tecnick.com LTD
//    See LICENSE.TXT file for more information.
//============================================================+

/**
 * @file
 * Edit test.
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2004-04-27
 */

require_once "../config/tce_config.php";

$pageperm = K_PERM_OPERATOR;
require_once "../../shared/code/tce_authorization.php";
require_once "../../shared/config/tce_user_registration.php";

$thispage_title = $l["t_tests_editor"];
$enable_calendar = true;
require_once "tce_page_header.php";
require_once "../../shared/code/tce_functions_form.php";
require_once "../../shared/code/tce_functions_tcecode.php";
require_once "tce_functions_tcecode_editor.php";
require_once "../../shared/code/tce_functions_auth_sql.php";
require_once "tce_functions_user_select.php";
require_once "tce_functions_test_select.php";

// comma separated list of required fields
$_REQUEST["ff_required"] =
    "test_name,test_description,test_ip_range,test_duration_time,test_score_right";
$_REQUEST["ff_required_labels"] = htmlspecialchars(
    $l["w_name"] .
    "," .
    $l["w_description"] .
    "," .
    $l["w_ip_range"] .
    "," .
    $l["w_test_time"] .
    "," .
    $l["w_score_right"],
    ENT_COMPAT,
    $l["a_meta_charset"],
);

// set default values
if (
    !isset($_REQUEST["test_results_to_users"]) ||
    empty($_REQUEST["test_results_to_users"])
) {
    $test_results_to_users = false;
} else {
    $test_results_to_users = F_getBoolean($_REQUEST["test_results_to_users"]);
}

if (
    !isset($_REQUEST["test_report_to_users"]) ||
    empty($_REQUEST["test_report_to_users"])
) {
    $test_report_to_users = false;
} else {
    $test_report_to_users = F_getBoolean($_REQUEST["test_report_to_users"]);
}

$subject_id =
    !isset($_REQUEST["subject_id"]) || empty($_REQUEST["subject_id"])
    ? []
    : $_REQUEST["subject_id"];

if (!isset($_REQUEST["tsubset_type"]) || empty($_REQUEST["tsubset_type"])) {
    $tsubset_type = 0;
} else {
    $tsubset_type = (int) $_REQUEST["tsubset_type"];
}

$tsubset_difficulty = isset($_REQUEST["tsubset_difficulty"])
    ? (int) $_REQUEST["tsubset_difficulty"]
    : 1;

if (
    !isset($_REQUEST["tsubset_quantity"]) ||
    empty($_REQUEST["tsubset_quantity"])
) {
    $tsubset_quantity = 1;
} else {
    $tsubset_quantity = (int) $_REQUEST["tsubset_quantity"];
}

if (
    !isset($_REQUEST["tsubset_answers"])
) {
    $tsubset_answers = 0;
} else {
    $tsubset_answers = (int) $_REQUEST["tsubset_answers"];
}

if (isset($_REQUEST["tsubset_id"])) {
    $tsubset_id = (int) $_REQUEST["tsubset_id"];
}

if (isset($_REQUEST["test_duration_time"])) {
    $test_duration_time = (int) $_REQUEST["test_duration_time"];
}

if (isset($_REQUEST["group_id"])) {
    $group_id = (int) $_REQUEST["group_id"];
}

if (isset($_REQUEST["user_groups"])) {
    $user_groups = $_REQUEST["user_groups"];
    if (!is_array($user_groups)) {
        $user_groups = [$user_groups];
    }
} else {
    $user_groups = [];
}

if (isset($_REQUEST["sslcerts"])) {
    $sslcerts = $_REQUEST["sslcerts"];
    if (!is_array($sslcerts)) {
        $sslcerts = [$sslcerts];
    }
} else {
    $sslcerts = [];
}

if (
    !isset($_REQUEST["test_score_right"]) ||
    empty($_REQUEST["test_score_right"])
) {
    $test_score_right = 0;
} else {
    $test_score_right = (float) $_REQUEST["test_score_right"];
}

if (
    !isset($_REQUEST["test_score_wrong"]) ||
    empty($_REQUEST["test_score_wrong"])
) {
    $test_score_wrong = 0;
} else {
    $test_score_wrong = (float) $_REQUEST["test_score_wrong"];
}

if (
    !isset($_REQUEST["test_score_unanswered"]) ||
    empty($_REQUEST["test_score_unanswered"])
) {
    $test_score_unanswered = 0;
} else {
    $test_score_unanswered = (float) $_REQUEST["test_score_unanswered"];
}

if (
    !isset($_REQUEST["test_score_threshold"]) ||
    empty($_REQUEST["test_score_threshold"])
) {
    $test_score_threshold = 0;
} else {
    $test_score_threshold = (float) $_REQUEST["test_score_threshold"];
}

if (
    !isset($_REQUEST["test_random_questions_select"]) ||
    empty($_REQUEST["test_random_questions_select"])
) {
    $test_random_questions_select = false;
} else {
    $test_random_questions_select = F_getBoolean(
        $_REQUEST["test_random_questions_select"],
    );
}

if (
    !isset($_REQUEST["test_random_questions_order"]) ||
    empty($_REQUEST["test_random_questions_order"])
) {
    $test_random_questions_order = false;
} else {
    $test_random_questions_order = F_getBoolean(
        $_REQUEST["test_random_questions_order"],
    );
}

if (
    !isset($_REQUEST["test_questions_order_mode"]) ||
    empty($_REQUEST["test_questions_order_mode"])
) {
    $test_questions_order_mode = 0;
} else {
    $test_questions_order_mode = max(
        0,
        min(3, (int) $_REQUEST["test_questions_order_mode"]),
    );
}

if (
    !isset($_REQUEST["test_random_answers_select"]) ||
    empty($_REQUEST["test_random_answers_select"])
) {
    $test_random_answers_select = false;
} else {
    $test_random_answers_select = F_getBoolean(
        $_REQUEST["test_random_answers_select"],
    );
}

if (
    !isset($_REQUEST["test_random_answers_order"]) ||
    empty($_REQUEST["test_random_answers_order"])
) {
    $test_random_answers_order = false;
} else {
    $test_random_answers_order = F_getBoolean(
        $_REQUEST["test_random_answers_order"],
    );
}

if (
    !isset($_REQUEST["test_answers_order_mode"]) ||
    empty($_REQUEST["test_answers_order_mode"])
) {
    $test_answers_order_mode = 0;
} else {
    $test_answers_order_mode = max(
        0,
        min(2, (int) $_REQUEST["test_answers_order_mode"]),
    );
}

if (
    !isset($_REQUEST["test_comment_enabled"]) ||
    empty($_REQUEST["test_comment_enabled"])
) {
    $test_comment_enabled = false;
} else {
    $test_comment_enabled = F_getBoolean($_REQUEST["test_comment_enabled"]);
}

if (
    !isset($_REQUEST["test_menu_enabled"]) ||
    empty($_REQUEST["test_menu_enabled"])
) {
    $test_menu_enabled = false;
} else {
    $test_menu_enabled = F_getBoolean($_REQUEST["test_menu_enabled"]);
}

if (
    !isset($_REQUEST["test_noanswer_enabled"]) ||
    empty($_REQUEST["test_noanswer_enabled"])
) {
    $test_noanswer_enabled = false;
} else {
    $test_noanswer_enabled = F_getBoolean($_REQUEST["test_noanswer_enabled"]);
}

if (
    !isset($_REQUEST["test_mcma_radio"]) ||
    empty($_REQUEST["test_mcma_radio"])
) {
    $test_mcma_radio = false;
} else {
    $test_mcma_radio = F_getBoolean($_REQUEST["test_mcma_radio"]);
}

if (
    !isset($_REQUEST["test_repeatable"]) ||
    empty($_REQUEST["test_repeatable"])
) {
    $test_repeatable = 0;
} else {
    $test_repeatable = (int) $_REQUEST["test_repeatable"];
}

if (
    !isset($_REQUEST["test_mcma_partial_score"]) ||
    empty($_REQUEST["test_mcma_partial_score"])
) {
    $test_mcma_partial_score = false;
} else {
    $test_mcma_partial_score = F_getBoolean(
        $_REQUEST["test_mcma_partial_score"],
    );
}

if (
    !isset($_REQUEST["test_logout_on_timeout"]) ||
    empty($_REQUEST["test_logout_on_timeout"])
) {
    $test_logout_on_timeout = false;
} else {
    $test_logout_on_timeout = F_getBoolean($_REQUEST["test_logout_on_timeout"]);
}

$test_max_score = isset($_REQUEST["test_max_score"])
    ? (float) $_REQUEST["test_max_score"]
    : 0;

$test_max_score_new = 0; // test max score
$qtype = ["S", "M", "T", "O"]; // question types
$qordmode = [
    $l["w_position"],
    $l["w_alphabetic"],
    $l["w_id"],
    $l["w_type"],
    $l["w_subject"],
];
$aordmode = [$l["w_position"], $l["w_alphabetic"], $l["w_id"]];

$test_fieldset_name = "";

if (isset($_REQUEST["test_id"]) && $_REQUEST["test_id"] > 0) {
    $test_id = (int) $_REQUEST["test_id"];
    // check user's authorization
    if (
        !F_isAuthorizedUser(K_TABLE_TESTS, "test_id", $test_id, "test_user_id")
    ) {
        F_print_error("ERROR", $l["m_authorization_denied"], true);
    }
} else {
    $test_id = 0;
}

// a global viewer who does not own the test may only read it
$record_readonly =
    $test_id > 0 &&
    !F_isAuthorizedToModify(K_TABLE_TESTS, "test_id", $test_id, "test_user_id");

if ($record_readonly) {
    $menu_mode = "";
} elseif (isset($_POST["lock"])) {
    $menu_mode = "lock";
} elseif (isset($_POST["unlock"])) {
    $menu_mode = "unlock";
}

switch ($menu_mode) {
    case "lock":
        // lock test by changing end date (subtract 1000 years)
        $sql =
            "UPDATE " .
            K_TABLE_TESTS .
            ' SET
			test_end_time=' .
            F_empty_to_null(
                "" .
                ((int) substr($test_end_time, 0, 1) - 1) .
                substr($test_end_time, 1),
            ) .
            '
			WHERE test_id=' .
            $test_id .
            "";
        if (!($r = F_db_query($sql, $db))) {
            F_display_db_error(false);
        } else {
            F_print_error("MESSAGE", $l["m_updated"]);
        }

        break;

    case "unlock":
        // unlock test by restoring original end date (add 1000 years)
        $sql =
            "UPDATE " .
            K_TABLE_TESTS .
            ' SET
			test_end_time=' .
            F_empty_to_null(
                "" .
                ((int) substr($test_end_time, 0, 1) + 1) .
                substr($test_end_time, 1),
            ) .
            '
			WHERE test_id=' .
            $test_id .
            "";
        if (!($r = F_db_query($sql, $db))) {
            F_display_db_error(false);
        } else {
            F_print_error("MESSAGE", $l["m_updated"]);
        }

        break;

    case "deletesubject":
        // delete subject
        // check referential integrity (NOTE: mysql do not support "ON UPDATE" constraint)
        if (
            !F_check_unique(
                K_TABLE_TEST_USER,
                "testuser_test_id=" . $test_id . "",
            )
        ) {
            F_print_error("WARNING", $l["m_update_restrict"]);

            break;
        }

        if (isset($_POST["deletesubset_id"]) && (int) $_POST["deletesubset_id"] > 0) {
            $del_subset_id = (int) $_POST["deletesubset_id"];
            $sql =
                "DELETE FROM " .
                K_TABLE_TEST_SUBJSET .
                " WHERE tsubset_test_id=" .
                $test_id .
                " AND tsubset_id=" .
                $del_subset_id .
                "";
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            } else {
                F_print_error("MESSAGE", $l["m_deleted"]);
            }
        } else {
            // for all selected subjects
            for ($i = 0; $i < $subjcount; ++$i) {
                if (!empty($_POST["selectsubject" . $i])) {
                    $sql =
                        "DELETE FROM " .
                        K_TABLE_TEST_SUBJSET .
                        " WHERE tsubset_test_id=" .
                        $test_id .
                        " AND tsubset_id=" .
                        $_POST["selectsubject" . $i] .
                        "";
                    if (!($r = F_db_query($sql, $db))) {
                        F_display_db_error(false);
                    } else {
                        F_print_error("MESSAGE", $l["m_deleted"]);
                    }
                }
            }
        }

        break;

    case "addquestion":
        // Add question type
        // check referential integrity (NOTE: mysql do not support "ON UPDATE" constraint)
        if (
            !F_check_unique(
                K_TABLE_TEST_USER,
                "testuser_test_id=" . $test_id . "",
            )
        ) {
            F_print_error("WARNING", $l["m_update_restrict"]);
            $formstatus = false;

            break;
        }

        // prevent duplicate submission on page refresh or double click
        if (isset($_POST["subset_token"]) && !empty($_POST["subset_token"])) {
            if (isset($_SESSION["last_subset_token"]) && $_SESSION["last_subset_token"] === $_POST["subset_token"]) {
                // duplicate submission prevented
                $subject_id = [];
                $tsubset_type = 0;
                $tsubset_difficulty = 1;
                $tsubset_quantity = 1;
                $tsubset_answers = 0;
                break;
            }
            $_SESSION["last_subset_token"] = $_POST["subset_token"];
        }

        if (
            ($formstatus = F_check_form_fields()) &&
            (isset($subject_id) &&
                !empty($subject_id) &&
                isset($tsubset_quantity))
        ) {
            if ($tsubset_type == 3 || !isset($_REQUEST["tsubset_answers"]) || empty($_REQUEST["tsubset_answers"])) {
                // free-text or default: 0 alternative answers limit (display all authored answers)
                $tsubset_answers = 0;
            }

            // create a comma separated list of subjects IDs
            $subjids = "";
            foreach ($subject_id as $subid) {
                if ($subid[0] == "#") {
                    // module ID
                    $modid = (int) substr($subid, 1);
                    $sqlsm = F_select_subjects_sql(
                        "subject_module_id=" . $modid . "",
                    );
                    if ($rsm = F_db_query($sqlsm, $db)) {
                        while ($msm = F_db_fetch_array($rsm)) {
                            $subjids .= $msm["subject_id"] . ",";
                        }
                    } else {
                        F_display_db_error();
                    }
                } else {
                    $subjids .= (int) $subid . ",";
                }
            }

            $subjids = substr($subjids, 0, -1);
            $subject_id = explode(",", $subjids);
            $subjids = "(" . $subjids . ")";
            $sql_answer_position = "";
            $sql_questions_position = "";
            if (
                !$test_random_questions_order &&
                $test_questions_order_mode == 0
            ) {
                $sql_questions_position = " AND question_position>0";
            }

            if (!$test_random_answers_order && $test_answers_order_mode == 0) {
                $sql_answer_position = " AND answer_position>0";
            }

            // check here if the selected number of questions are available for the current set
            // NOTE: if the same subject is used in multiple sets this control may fail.
            $sqlq =
                "SELECT COUNT(*) AS numquestions FROM " .
                K_TABLE_QUESTIONS .
                "";
            $sqlq .=
                " WHERE question_subject_id IN " .
                $subjids .
                '
					AND question_difficulty=' .
                $tsubset_difficulty .
                '
					AND question_enabled=\'1\'';
            if ($tsubset_type > 0) {
                $sqlq .= " AND question_type=" . $tsubset_type . "";
            }

            if ($tsubset_type == 1) {
                // single question (MCSA)
                // check if the selected question has enough answers
                $sqlq .=
                    ' AND question_id IN (
							SELECT answer_question_id
							FROM ' .
                    K_TABLE_ANSWERS .
                    '
							WHERE answer_enabled=\'1\' AND answer_isright=\'1\'';
                $sqlq .= $sql_answer_position;
                $sqlq .= ' GROUP BY answer_question_id
							HAVING (COUNT(answer_id)>0))';
                $sqlq .=
                    ' AND question_id IN (
							SELECT answer_question_id
							FROM ' .
                    K_TABLE_ANSWERS .
                    '
							WHERE answer_enabled=\'1\'
							AND answer_isright=\'0\'';
                $sqlq .= $sql_answer_position;
                $sqlq .= " GROUP BY answer_question_id";
                if ($tsubset_answers > 0) {
                    $sqlq .=
                        " HAVING (COUNT(answer_id)>=" .
                        ($tsubset_answers - 1) .
                        ")";
                }

                $sqlq .= " )";
            } elseif ($tsubset_type == 2) {
                // multiple question (MCMA)
                // check if the selected question has enough answers
                $sqlq .=
                    ' AND question_id IN (
							SELECT answer_question_id
							FROM ' .
                    K_TABLE_ANSWERS .
                    '
							WHERE answer_enabled=\'1\'';
                $sqlq .= $sql_answer_position;
                $sqlq .= " GROUP BY answer_question_id";
                if ($tsubset_answers > 0) {
                    $sqlq .=
                        " HAVING (COUNT(answer_id)>=" . $tsubset_answers . ")";
                }

                $sqlq .= " )";
            } elseif ($tsubset_type == 4) {
                // ordering question
                // check if the selected question has enough answers
                $sqlq .=
                    ' AND question_id IN (
							SELECT answer_question_id
							FROM ' .
                    K_TABLE_ANSWERS .
                    '
							WHERE answer_enabled=\'1\'
							AND answer_position>0
							GROUP BY answer_question_id
							HAVING (COUNT(answer_id)>1))';
            }

            $sqlq .= $sql_questions_position;
            if (K_DATABASE_TYPE == "ORACLE") {
                $sqlq =
                    "SELECT * FROM (" .
                    $sqlq .
                    ") WHERE rownum <= " .
                    $tsubset_quantity .
                    "";
            } else {
                $sqlq .= " LIMIT " . $tsubset_quantity . "";
            }

            $numofrows = 0;
            if ($rq = F_db_query($sqlq, $db)) {
                if ($mq = F_db_fetch_array($rq)) {
                    $numofrows = $mq["numquestions"];
                }
            } else {
                F_display_db_error();
            }

            if ($numofrows < $tsubset_quantity) {
                F_print_error("WARNING", $l["m_unavailable_questions"]);
                break;
            }

            if ($subject_id !== []) {
                // insert new subject
                $sql =
                    "INSERT INTO " .
                    K_TABLE_TEST_SUBJSET .
                    ' (tsubset_test_id,
						tsubset_type,
						tsubset_difficulty,
						tsubset_quantity,
						tsubset_answers
						) VALUES (
						\'' .
                    $test_id .
                    '\',
						\'' .
                    $tsubset_type .
                    '\',
						\'' .
                    $tsubset_difficulty .
                    '\',
						\'' .
                    $tsubset_quantity .
                    '\',
						\'' .
                    $tsubset_answers .
                    '\'
						)';
                if (!($r = F_db_query($sql, $db))) {
                    F_display_db_error(false);
                } else {
                    $tsubset_id = F_db_insert_id(
                        $db,
                        K_TABLE_TEST_SUBJSET,
                        "tsubset_id",
                    );
                    // add selected subject_id
                    foreach ($subject_id as $subid) {
                        $sql =
                            "INSERT INTO " .
                            K_TABLE_SUBJECT_SET .
                            ' (
								subjset_tsubset_id,
								subjset_subject_id
								) VALUES (
								\'' .
                            $tsubset_id .
                            '\',
								\'' .
                            $subid .
                            '\'
								)';
                        if (!($r = F_db_query($sql, $db))) {
                            F_display_db_error(false);
                        }
                    }
                    F_print_error("MESSAGE", $l["m_updated"]);
                    // reset question addition fields so form inputs are cleared
                    $subject_id = [];
                    $tsubset_type = 0;
                    $tsubset_difficulty = 1;
                    $tsubset_quantity = 1;
                    $tsubset_answers = 0;
                    unset($_POST['addquestion'], $_REQUEST['addquestion']);
                    unset($_POST['subject_id'], $_REQUEST['subject_id']);
                    unset($_POST['tsubset_quantity'], $_REQUEST['tsubset_quantity']);
                    unset($_POST['tsubset_answers'], $_REQUEST['tsubset_answers']);
                    unset($_POST['tsubset_type'], $_REQUEST['tsubset_type']);
                    unset($_POST['tsubset_difficulty'], $_REQUEST['tsubset_difficulty']);
                }
            }
        }

        break;

    case "delete":
        // ask confirmation
        F_print_error("WARNING", $l["m_delete_confirm_test"]); ?>
        <div class="confirmbox">
            <form action="<?php echo $_SERVER[
                "SCRIPT_NAME"
            ]; ?>" method="post" enctype="multipart/form-data" id="form_delete">
                <div>
                    <input type="hidden" name="test_id" id="test_id" value="<?php echo $test_id; ?>" />
                    <input type="hidden" name="test_name" id="test_name" value="<?php echo $test_name; ?>" />
                    <?php
                    F_submit_button("forcedelete", $l["w_delete"], $l["h_delete"]);
                    F_submit_button("cancel", $l["w_cancel"], $l["h_cancel"]);
                    echo F_getCSRFTokenField() . K_NEWLINE;
                    ?>
                </div>
            </form>
        </div>
        <?php break;

    case "forcedelete":
        // Delete
        if ($forcedelete == $l["w_delete"]) {
            //check if delete button has been pushed (redundant check)
            // delete test
            $sql =
                "DELETE FROM " .
                K_TABLE_TESTS .
                " WHERE test_id=" .
                $test_id .
                "";
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            } else {
                $test_id = false;
                F_print_error("MESSAGE", $test_name . ": " . $l["m_deleted"]);
            }
        }

        break;

    case "update":
        // Update
        // check if the confirmation chekbox has been selected
        if (
            !isset($_REQUEST["confirmupdate"]) ||
            $_REQUEST["confirmupdate"] != 1
        ) {
            F_print_error(
                "WARNING",
                $l["m_form_missing_fields"] .
                ": " .
                $l["w_confirm"] .
                " &rarr; " .
                $l["w_update"],
            );
            $formstatus = false;

            break;
        }

        if ($formstatus = F_check_form_fields()) {
            // check referential integrity (NOTE: mysql do not support "ON UPDATE" constraint)
            if (
                !F_check_unique(
                    K_TABLE_TEST_USER,
                    "testuser_test_id=" . $test_id . "",
                )
            ) {
                F_print_error("WARNING", $l["m_update_restrict"]);
                $formstatus = false;

                break;
            }

            // check if name is unique
            if (
                !F_check_unique(
                    K_TABLE_TESTS,
                    "test_name='" . $test_name . "'",
                    "test_id",
                    $test_id,
                )
            ) {
                F_print_error("WARNING", $l["m_duplicate_name"]);
                $formstatus = false;

                break;
            }

            if (!empty($new_test_password)) {
                $test_password = getPasswordHash($new_test_password);
            }

            if ($test_score_threshold > $test_max_score) {
                $test_score_threshold = 0.6 * $test_max_score;
            }

            $sql =
                "UPDATE " .
                K_TABLE_TESTS .
                ' SET
				test_name=\'' .
                F_escape_sql($db, $test_name) .
                '\',
				test_description=\'' .
                F_escape_sql($db, $test_description) .
                '\',
				test_begin_time=' .
                F_empty_to_null($test_begin_time) .
                ',
				test_end_time=' .
                F_empty_to_null($test_end_time) .
                ',
				test_duration_time=\'' .
                $test_duration_time .
                '\',
				test_ip_range=\'' .
                F_escape_sql($db, $test_ip_range) .
                '\',
				test_results_to_users=\'' .
                (int) $test_results_to_users .
                '\',
				test_report_to_users=\'' .
                (int) $test_report_to_users .
                '\',
				test_score_right=\'' .
                $test_score_right .
                '\',
				test_score_wrong=\'' .
                $test_score_wrong .
                '\',
				test_score_unanswered=\'' .
                $test_score_unanswered .
                '\',
				test_max_score=\'' .
                $test_max_score .
                '\',
				test_score_threshold=\'' .
                $test_score_threshold .
                '\',
				test_random_questions_select=\'' .
                (int) $test_random_questions_select .
                '\',
				test_random_questions_order=\'' .
                (int) $test_random_questions_order .
                '\',
				test_questions_order_mode=\'' .
                $test_questions_order_mode .
                '\',
				test_random_answers_select=\'' .
                (int) $test_random_answers_select .
                '\',
				test_random_answers_order=\'' .
                (int) $test_random_answers_order .
                '\',
				test_answers_order_mode=\'' .
                $test_answers_order_mode .
                '\',
				test_comment_enabled=\'' .
                (int) $test_comment_enabled .
                '\',
				test_menu_enabled=\'' .
                (int) $test_menu_enabled .
                '\',
				test_noanswer_enabled=\'' .
                (int) $test_noanswer_enabled .
                '\',
				test_mcma_radio=\'' .
                (int) $test_mcma_radio .
                '\',
				test_repeatable=\'' .
                (int) $test_repeatable .
                '\',
				test_mcma_partial_score=\'' .
                (int) $test_mcma_partial_score .
                '\',
				test_logout_on_timeout=\'' .
                (int) $test_logout_on_timeout .
                '\',
				test_password=' .
                F_empty_to_null($test_password) .
                '
				WHERE test_id=' .
                $test_id .
                "";
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            } else {
                F_print_error("MESSAGE", $l["m_updated"]);
            }

            // delete previous groups
            $sql =
                "DELETE FROM " .
                K_TABLE_TEST_GROUPS .
                '
				WHERE tstgrp_test_id=' .
                $test_id .
                "";
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            }

            // update authorized groups
            if (!empty($user_groups)) {
                foreach ($user_groups as $group_id) {
                    $sql =
                        "INSERT INTO " .
                        K_TABLE_TEST_GROUPS .
                        ' (
						tstgrp_test_id,
						tstgrp_group_id
						) VALUES (
						\'' .
                        $test_id .
                        '\',
						\'' .
                        (int) $group_id .
                        '\'
						)';
                    if (!($r = F_db_query($sql, $db))) {
                        F_display_db_error(false);
                    }
                }
            }

            // delete previous SSL certificates
            $sql =
                "DELETE FROM " .
                K_TABLE_TEST_SSLCERTS .
                '
				WHERE tstssl_test_id=' .
                $test_id .
                "";
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            }

            // update authorized SSL certificates
            if (!empty($sslcerts)) {
                foreach ($sslcerts as $ssl_id) {
                    $sql =
                        "INSERT INTO " .
                        K_TABLE_TEST_SSLCERTS .
                        ' (
						tstssl_test_id,
						tstssl_ssl_id
						) VALUES (
						\'' .
                        $test_id .
                        '\',
						\'' .
                        (int) $ssl_id .
                        '\'
						)';
                    if (!($r = F_db_query($sql, $db))) {
                        F_display_db_error(false);
                    }
                }
            }
        }

        break;

    case "add":
        // Add
        if ($formstatus = F_check_form_fields()) {
            // check if name is unique
            if (
                !F_check_unique(
                    K_TABLE_TESTS,
                    "test_name='" . F_escape_sql($db, $test_name) . "'",
                )
            ) {
                F_print_error("WARNING", $l["m_duplicate_name"]);
                $formstatus = false;

                break;
            }

            if (isset($test_id) && $test_id > 0) {
                // save previous test_id.
                $old_test_id = $test_id;
            }

            if (!empty($new_test_password)) {
                $test_password = getPasswordHash($new_test_password);
            }

            $sql =
                "INSERT INTO " .
                K_TABLE_TESTS .
                ' (
			test_name,
				test_description,
				test_begin_time,
				test_end_time,
				test_duration_time,
				test_ip_range,
				test_results_to_users,
				test_report_to_users,
				test_score_right,
				test_score_wrong,
				test_score_unanswered,
				test_max_score,
				test_user_id,
				test_score_threshold,
				test_random_questions_select,
				test_random_questions_order,
				test_questions_order_mode,
				test_random_answers_select,
				test_random_answers_order,
				test_answers_order_mode,
				test_comment_enabled,
				test_menu_enabled,
				test_noanswer_enabled,
				test_mcma_radio,
				test_repeatable,
				test_mcma_partial_score,
				test_logout_on_timeout,
				test_password
				) VALUES (
				\'' .
                F_escape_sql($db, $test_name) .
                '\',
				\'' .
                F_escape_sql($db, $test_description) .
                '\',
				' .
                F_empty_to_null($test_begin_time) .
                ',
				' .
                F_empty_to_null($test_end_time) .
                ',
				\'' .
                $test_duration_time .
                '\',
				\'' .
                F_escape_sql($db, $test_ip_range) .
                '\',
				\'' .
                (int) $test_results_to_users .
                '\',
				\'' .
                (int) $test_report_to_users .
                '\',
				\'' .
                $test_score_right .
                '\',
				\'' .
                $test_score_wrong .
                '\',
				\'' .
                $test_score_unanswered .
                '\',
				\'' .
                $test_max_score .
                '\',
				\'' .
                (int) $_SESSION["session_user_id"] .
                '\',
				\'' .
                $test_score_threshold .
                '\',
				\'' .
                (int) $test_random_questions_select .
                '\',
				\'' .
                (int) $test_random_questions_order .
                '\',
				\'' .
                $test_questions_order_mode .
                '\',
				\'' .
                (int) $test_random_answers_select .
                '\',
				\'' .
                (int) $test_random_answers_order .
                '\',
				\'' .
                $test_answers_order_mode .
                '\',
				\'' .
                (int) $test_comment_enabled .
                '\',
				\'' .
                (int) $test_menu_enabled .
                '\',
				\'' .
                (int) $test_noanswer_enabled .
                '\',
				\'' .
                (int) $test_mcma_radio .
                '\',
				\'' .
                (int) $test_repeatable .
                '\',
				\'' .
                (int) $test_mcma_partial_score .
                '\',
				\'' .
                (int) $test_logout_on_timeout .
                '\',
				' .
                F_empty_to_null($test_password) .
                '
				)';
            if (!($r = F_db_query($sql, $db))) {
                F_display_db_error(false);
            } else {
                $test_id = F_db_insert_id($db, K_TABLE_TESTS, "test_id");
            }

            // add authorized user's groups
            if (!empty($user_groups)) {
                foreach ($user_groups as $group_id) {
                    $sql =
                        "INSERT INTO " .
                        K_TABLE_TEST_GROUPS .
                        ' (
						tstgrp_test_id,
						tstgrp_group_id
						) VALUES (
						\'' .
                        $test_id .
                        '\',
						\'' .
                        (int) $group_id .
                        '\'
						)';
                    if (!($r = F_db_query($sql, $db))) {
                        F_display_db_error(false);
                    }
                }
            }

            // update authorized SSL certificates
            if (!empty($sslcerts)) {
                foreach ($sslcerts as $ssl_id) {
                    $sql =
                        "INSERT INTO " .
                        K_TABLE_TEST_SSLCERTS .
                        ' (
						tstssl_test_id,
						tstssl_ssl_id
						) VALUES (
						\'' .
                        $test_id .
                        '\',
						\'' .
                        (int) $ssl_id .
                        '\'
						)';
                    if (!($r = F_db_query($sql, $db))) {
                        F_display_db_error(false);
                    }
                }
            }

            if (isset($old_test_id) && $old_test_id > 0) {
                // copy here previous selected questions to this new test
                $sql =
                    'SELECT *
					FROM ' .
                    K_TABLE_TEST_SUBJSET .
                    '
					WHERE tsubset_test_id=\'' .
                    $old_test_id .
                    "'";
                if ($r = F_db_query($sql, $db)) {
                    while ($m = F_db_fetch_array($r)) {
                        // insert new subject
                        $sqlu =
                            "INSERT INTO " .
                            K_TABLE_TEST_SUBJSET .
                            ' (
							tsubset_test_id,
							tsubset_type,
							tsubset_difficulty,
							tsubset_quantity,
							tsubset_answers
							) VALUES (
							\'' .
                            $test_id .
                            '\',
							\'' .
                            $m["tsubset_type"] .
                            '\',
							\'' .
                            $m["tsubset_difficulty"] .
                            '\',
							\'' .
                            $m["tsubset_quantity"] .
                            '\',
							\'' .
                            $m["tsubset_answers"] .
                            '\'
							)';
                        if (!($ru = F_db_query($sqlu, $db))) {
                            F_display_db_error();
                        } else {
                            $tsubset_id = F_db_insert_id(
                                $db,
                                K_TABLE_TEST_SUBJSET,
                                "tsubset_id",
                            );
                            $sqls =
                                'SELECT *
								FROM ' .
                                K_TABLE_SUBJECT_SET .
                                '
								WHERE subjset_tsubset_id=\'' .
                                $m["tsubset_id"] .
                                "'";
                            if ($rs = F_db_query($sqls, $db)) {
                                while ($ms = F_db_fetch_array($rs)) {
                                    $sqlp =
                                        "INSERT INTO " .
                                        K_TABLE_SUBJECT_SET .
                                        ' (
										subjset_tsubset_id,
										subjset_subject_id
										) VALUES (
										\'' .
                                        $tsubset_id .
                                        '\',
										\'' .
                                        $ms["subjset_subject_id"] .
                                        '\'
										)';
                                    if (!($rp = F_db_query($sqlp, $db))) {
                                        F_display_db_error();
                                    }
                                }
                            } else {
                                F_display_db_error();
                            }
                        }
                    }
                } else {
                    F_display_db_error();
                }
            }
        }

        break;

    case "clear":
        // Clear form fields
        $test_name = "";
        $test_description = "";
        $test_begin_time = date(K_TIMESTAMP_FORMAT);
        $test_end_time = date(K_TIMESTAMP_FORMAT, time() + K_SECONDS_IN_DAY);
        $test_duration_time = 60;
        $test_ip_range = "*.*.*.*";
        $test_results_to_users = false;
        $test_report_to_users = false;
        $test_score_right = 1;
        $test_score_wrong = 0;
        $test_score_unanswered = 0;
        $test_max_score = 0;
        $test_score_threshold = 0;
        $test_random_questions_select = true;
        $test_random_questions_order = true;
        $test_questions_order_mode = 0;
        $test_random_answers_select = true;
        $test_random_answers_order = true;
        $test_answers_order_mode = 0;
        $test_comment_enabled = true;
        $test_menu_enabled = true;
        $test_noanswer_enabled = false;
        $test_mcma_radio = true;
        $test_repeatable = 0;
        $test_mcma_partial_score = true;
        $test_logout_on_timeout = false;
        $test_password = "";
        break;

    default:
        break;
} //end of switch

// --- Initialize variables

if ($formstatus && $menu_mode != "clear") {
    if (!isset($test_id) || $test_id === 0) {
        $test_id = 0;
        $test_name = "";
        $test_description = "";
        $test_begin_time = date(K_TIMESTAMP_FORMAT);
        $test_end_time = date(K_TIMESTAMP_FORMAT, time() + K_SECONDS_IN_DAY);
        $test_duration_time = 60;
        $test_ip_range = "*.*.*.*";
        $test_results_to_users = false;
        $test_report_to_users = false;
        $test_score_right = 1;
        $test_score_wrong = 0;
        $test_score_unanswered = 0;
        $test_max_score = 0;
        $test_score_threshold = 0;
        $test_random_questions_select = true;
        $test_random_questions_order = true;
        $test_questions_order_mode = 0;
        $test_random_answers_select = true;
        $test_random_answers_order = true;
        $test_answers_order_mode = 0;
        $test_comment_enabled = true;
        $test_menu_enabled = true;
        $test_noanswer_enabled = false;
        $test_mcma_radio = true;
        $test_repeatable = 0;
        $test_mcma_partial_score = true;
        $test_logout_on_timeout = false;
        $test_password = "";
    } else {
        $sql =
            "SELECT * FROM " .
            K_TABLE_TESTS .
            " WHERE test_id=" .
            $test_id .
            " LIMIT 1";
        if ($r = F_db_query($sql, $db)) {
            if ($m = F_db_fetch_array($r)) {
                $test_id = $m["test_id"];
                $test_name = $m["test_name"];
                $test_description = $m["test_description"];
                $test_begin_time = $m["test_begin_time"];
                $test_end_time = $m["test_end_time"];
                $test_duration_time = $m["test_duration_time"];
                $test_ip_range = $m["test_ip_range"];
                $test_results_to_users = F_getBoolean(
                    $m["test_results_to_users"],
                );
                $test_report_to_users = F_getBoolean(
                    $m["test_report_to_users"],
                );
                $test_score_right = $m["test_score_right"];
                $test_score_wrong = $m["test_score_wrong"];
                $test_score_unanswered = $m["test_score_unanswered"];
                $test_max_score = $m["test_max_score"];
                $test_score_threshold = $m["test_score_threshold"];
                $test_random_questions_select = F_getBoolean(
                    $m["test_random_questions_select"],
                );
                $test_random_questions_order = F_getBoolean(
                    $m["test_random_questions_order"],
                );
                $test_questions_order_mode =
                    (int) $m["test_questions_order_mode"];
                $test_random_answers_select = F_getBoolean(
                    $m["test_random_answers_select"],
                );
                $test_random_answers_order = F_getBoolean(
                    $m["test_random_answers_order"],
                );
                $test_answers_order_mode = (int) $m["test_answers_order_mode"];
                $test_comment_enabled = F_getBoolean(
                    $m["test_comment_enabled"],
                );
                $test_menu_enabled = F_getBoolean($m["test_menu_enabled"]);
                $test_noanswer_enabled = F_getBoolean(
                    $m["test_noanswer_enabled"],
                );
                $test_mcma_radio = F_getBoolean($m["test_mcma_radio"]);
                $test_repeatable = $m["test_repeatable"];
                $test_mcma_partial_score = F_getBoolean(
                    $m["test_mcma_partial_score"],
                );
                $test_logout_on_timeout = F_getBoolean(
                    $m["test_logout_on_timeout"],
                );
                $test_password = $m["test_password"];
            } else {
                $test_name = "";
                $test_description = "";
                $test_begin_time = date(K_TIMESTAMP_FORMAT);
                $test_end_time = date(
                    K_TIMESTAMP_FORMAT,
                    time() + K_SECONDS_IN_DAY,
                );
                $test_duration_time = 60;
                $test_ip_range = "*.*.*.*";
                $test_results_to_users = false;
                $test_report_to_users = false;
                $test_score_right = 1;
                $test_score_wrong = 0;
                $test_score_unanswered = 0;
                $test_max_score = 0;
                $test_score_threshold = 0;
                $test_random_questions_select = true;
                $test_random_questions_order = true;
                $test_questions_order_mode = 0;
                $test_random_answers_select = true;
                $test_random_answers_order = true;
                $test_answers_order_mode = 0;
                $test_comment_enabled = true;
                $test_menu_enabled = true;
                $test_noanswer_enabled = false;
                $test_mcma_radio = true;
                $test_repeatable = 0;
                $test_mcma_partial_score = true;
                $test_logout_on_timeout = false;
                $test_password = "";
            }
        } else {
            F_display_db_error();
        }
    }
}

$millennium = substr(date("Y"), 0, 1);

echo '<div class="container">' . K_NEWLINE;

echo '<div class="tceformbox">' . K_NEWLINE;
echo '<form action="' .
    $_SERVER["SCRIPT_NAME"] .
    '" method="post" enctype="multipart/form-data" id="form_testeditor">' .
    K_NEWLINE;

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="test_id">' . $l["w_test"] . "</label>" . K_NEWLINE;
echo "</span>" . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<select name="test_id" id="test_id" size="0" onchange="document.getElementById(\'form_testeditor\').submit()" title="' .
    $l["h_test"] .
    '">' .
    K_NEWLINE;
echo '<option value="0" style="background-color:#009900;color:white;"';
if ($test_id == 0) {
    echo ' selected="selected"';
}

echo ">+</option>" . K_NEWLINE;
$sql = F_select_tests_sql();
if ($r = F_db_query($sql, $db)) {
    $countitem = 1;
    while ($m = F_db_fetch_array($r)) {
        echo '<option value="' . $m["test_id"] . '"';
        if ($m["test_id"] == $test_id) {
            echo ' selected="selected"';
            $test_fieldset_name =
                "" .
                substr($m["test_begin_time"], 0, 10) .
                " " .
                htmlspecialchars(
                    $m["test_name"],
                    ENT_NOQUOTES,
                    $l["a_meta_charset"],
                ) .
                "";
        }

        echo ">" . $countitem . ". ";
        if (substr($m["test_end_time"], 0, 1) < $millennium) {
            echo "* ";
        }

        echo substr($m["test_begin_time"], 0, 10) .
            " " .
            htmlspecialchars(
                $m["test_name"],
                ENT_NOQUOTES,
                $l["a_meta_charset"],
            ) .
            "</option>" .
            K_NEWLINE;
        ++$countitem;
    }
} else {
    echo "</select></span></div>" . K_NEWLINE;
    F_display_db_error();
}

echo "</select>" . K_NEWLINE;

// link for user selection popup
$jsaction =
    "selectWindow=window.open('tce_select_tests_popup.php?cid=test_id', 'selectWindow', 'dependent, height=600, width=800, menubar=no, resizable=yes, scrollbars=yes, status=no, toolbar=no');return false;";
echo '<a href="#" onclick="' .
    $jsaction .
    '" class="xmlbutton" title="' .
    $l["w_select"] .
    '">...</a>';

echo "</span>" . K_NEWLINE;
echo "<br /><br />" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

echo getFormNoscriptSelect("selectrecord");

echo "<fieldset>" . K_NEWLINE;
echo "<legend>" . $l["w_test"] . "</legend>" . K_NEWLINE;

echo getFormRowTextInput(
    "test_name",
    $l["w_name"],
    $l["h_test_name"],
    "",
    $test_name,
    "",
    255,
    false,
    false,
    false,
);
echo getFormRowTextBox(
    "test_description",
    $l["w_description"],
    $l["h_test_description"],
    $test_description,
    false,
);
echo getFormRowTextInput(
    "test_begin_time",
    $l["w_time_begin"],
    $l["w_time_begin"] . " " . $l["w_datetime_format"],
    "",
    $test_begin_time,
    "",
    19,
    false,
    true,
    false,
);
echo getFormRowTextInput(
    "test_end_time",
    $l["w_time_end"],
    $l["w_time_end"] . " " . $l["w_datetime_format"],
    "",
    $test_end_time,
    "",
    19,
    false,
    true,
    false,
);
echo getFormRowTextInput(
    "test_duration_time",
    $l["w_test_time"],
    $l["h_test_time"],
    "[" . $l["w_minutes"] . "]",
    $test_duration_time,
    '^([0-9]*)$',
    20,
    false,
    false,
    false,
);

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="user_groups">' . $l["w_groups"] . "</label>" . K_NEWLINE;
echo "</span>" . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<select name="user_groups[]" id="user_groups" size="5" multiple="multiple">' .
    K_NEWLINE;
//$sql = F_user_group_select_sql();
$sql = "SELECT * FROM " . K_TABLE_GROUPS . " ORDER BY group_name";
if ($r = F_db_query($sql, $db)) {
    while ($m = F_db_fetch_array($r)) {
        echo '<option value="' . $m["group_id"] . '"';
        if (
            isset($test_id) &&
            $test_id > 0 &&
            F_isTestOnGroup($test_id, $m["group_id"])
        ) {
            echo ' selected="selected"';
        }

        echo ">" .
            htmlspecialchars(
                $m["group_name"],
                ENT_NOQUOTES,
                $l["a_meta_charset"],
            ) .
            "</option>" .
            K_NEWLINE;
    }
} else {
    echo "</select></span></div>" . K_NEWLINE;
    F_display_db_error();
}

echo "</select>" . K_NEWLINE;
echo "</span>" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

echo '<div style="display:none;">';

//---IP Authorized---
echo getFormRowTextInput(
    "test_ip_range",
    $l["w_ip_range"],
    $l["h_ip_range"],
    "",
    $test_ip_range,
    '^([0-9a-fA-F,\:\.\*-]*)$',
    255,
    false,
    false,
    false,
);

//---SSL Certificate--- (Deprecated for organizational deployments)
if (defined('K_ENABLE_SSLCERTS') && K_ENABLE_SSLCERTS) {
    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . K_NEWLINE;
    echo '<label for="sslcerts">' . $l["w_sslcerts"] . "</label>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<select name="sslcerts[]" id="sslcerts" size="5" multiple="multiple">' .
        K_NEWLINE;
    $sql = "SELECT * FROM " . K_TABLE_SSLCERTS . " ORDER BY ssl_name";
    if ($r = F_db_query($sql, $db)) {
        while ($m = F_db_fetch_array($r)) {
            echo '<option value="' . $m["ssl_id"] . '"';
            if (
                isset($test_id) &&
                $test_id > 0 &&
                F_isTestOnSSLCerts($test_id, $m["ssl_id"])
            ) {
                echo ' selected="selected"';
            }

            echo ">" .
                htmlspecialchars(
                    $m["ssl_name"] . " (" . substr($m["ssl_end_date"], 0, 10) . ")",
                    ENT_NOQUOTES,
                    $l["a_meta_charset"],
                ) .
                "</option>" .
                K_NEWLINE;
        }
    } else {
        echo "</select></span></div>" . K_NEWLINE;
        F_display_db_error();
    }

    echo "</select>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;
}

echo getFormRowCheckBox(
    "test_noanswer_enabled",
    $l["w_enable_noanswer"],
    "",
    "",
    1,
    $test_noanswer_enabled,
    false,
);

echo '</div>';
//--- end of intentionaly hidden fields ---

echo getFormRowTextInput(
    "test_score_right",
    $l["w_score_right"],
    $l["h_score_right"],
    "",
    $test_score_right,
    '^([0-9\+\-]*)([\.]?)([0-9]*)$',
    20,
    false,
    false,
    false,
);
echo '<input type="hidden" name="test_score_wrong" id="test_score_wrong" value="' . htmlspecialchars((string) ($test_score_wrong ?? 0), ENT_COMPAT, $l["a_meta_charset"]) . '" />' . K_NEWLINE;
echo '<input type="hidden" name="test_score_unanswered" id="test_score_unanswered" value="' . htmlspecialchars((string) ($test_score_unanswered ?? 0), ENT_COMPAT, $l["a_meta_charset"]) . '" />' . K_NEWLINE;
echo getFormRowTextInput(
    "test_score_threshold",
    $l["w_test_score_threshold"],
    $l["h_test_score_threshold"],
    "",
    $test_score_threshold,
    '^([0-9\+\-]*)([\.]?)([0-9]*)$',
    20,
    false,
    false,
    false,
);

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="test_random_questions_select">' .
    $l["w_random_questions"] .
    ":</label>" .
    K_NEWLINE;
echo "</span>" . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<input type="checkbox" name="test_random_questions_select" id="test_random_questions_select" value="1"';
if ($test_random_questions_select) {
    echo ' checked="checked"';
}

echo ' onclick="JF_check_random_boxes()"';
echo ' title="' . $l["h_random_questions"] . '" />';
echo ' <label for="test_random_questions_select">' .
    $l["w_select"] .
    "</label>" .
    K_NEWLINE;

echo ' <input type="checkbox" name="test_random_questions_order" id="test_random_questions_order" value="1"';
if ($test_random_questions_order) {
    echo ' checked="checked"';
}

echo ' onclick="JF_check_random_boxes()"';
echo ' title="' . $l["w_order"] . '" />';
echo ' <label for="test_random_questions_order">' .
    $l["w_order"] .
    "</label>" .
    K_NEWLINE;

echo '<span id="select_questions_order_mode" style="visibility:visible;">' .
    K_NEWLINE;
echo ' | <label for="test_questions_order_mode">' .
    $l["w_order_by"] .
    "</label>" .
    K_NEWLINE;
echo ' <select name="test_questions_order_mode" id="test_questions_order_mode" size="1" title="' .
    $l["h_questions_order_mode"] .
    '">' .
    K_NEWLINE;
foreach ($qordmode as $ok => $ov) {
    echo '<option value="' . $ok . '"';
    if ($test_questions_order_mode == $ok) {
        echo ' selected="selected"';
    }

    echo ">" .
        htmlspecialchars($ov, ENT_NOQUOTES, $l["a_meta_charset"]) .
        "</option>" .
        K_NEWLINE;
}

echo "</select>" . K_NEWLINE;
echo "</span>" . K_NEWLINE;

echo "</span>" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="test_random_answers_select">' .
    $l["w_random_answers"] .
    ":</label>" .
    K_NEWLINE;
echo "</span>" . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<input type="checkbox" name="test_random_answers_select" id="test_random_answers_select" value="1"';
if ($test_random_answers_select) {
    echo ' checked="checked"';
}

echo ' onclick="JF_check_random_boxes()"';
echo ' title="' . $l["h_random_answers"] . '" />';
echo ' <label for="test_random_answers_select">' .
    $l["w_select"] .
    "</label>" .
    K_NEWLINE;

echo ' <input type="checkbox" name="test_random_answers_order" id="test_random_answers_order" value="1"';
if ($test_random_answers_order) {
    echo ' checked="checked"';
}

echo ' onclick="JF_check_random_boxes()"';
echo ' title="' . $l["w_order"] . '" />';
echo ' <label for="test_random_answers_order">' .
    $l["w_order"] .
    "</label>" .
    K_NEWLINE;

echo '<span id="select_answers_order_mode" style="visibility:visible;">' .
    K_NEWLINE;
echo ' | <label for="test_answers_order_mode">' .
    $l["w_order_by"] .
    "</label>" .
    K_NEWLINE;
echo ' <select name="test_answers_order_mode" id="test_answers_order_mode" size="1" title="' .
    $l["h_answers_order_mode"] .
    '">' .
    K_NEWLINE;
foreach ($aordmode as $ok => $ov) {
    echo '<option value="' . $ok . '"';
    if ($test_answers_order_mode == $ok) {
        echo ' selected="selected"';
    }

    echo ">" .
        htmlspecialchars($ov, ENT_NOQUOTES, $l["a_meta_charset"]) .
        "</option>" .
        K_NEWLINE;
}

echo "</select>" . K_NEWLINE;
echo "</span>" . K_NEWLINE;

echo "</span>" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

echo getFormRowCheckBox(
    "test_mcma_radio",
    $l["w_mcma_radio"],
    "",
    "",
    1,
    $test_mcma_radio,
    false,
);
echo getFormRowCheckBox(
    "test_mcma_partial_score",
    $l["w_mcma_partial_score"],
    "",
    "",
    1,
    $test_mcma_partial_score,
    false,
);
echo getFormRowCheckBox(
    "test_menu_enabled",
    $l["w_enable_menu"],
    "",
    "",
    1,
    $test_menu_enabled,
    false,
);
echo getFormRowCheckBox(
    "test_comment_enabled",
    $l["w_enable_comment"],
    "",
    "",
    1,
    $test_comment_enabled,
    false,
);
echo getFormRowCheckBox(
    "test_results_to_users",
    $l["w_results_to_users"],
    "",
    "",
    1,
    $test_results_to_users,
    false,
);
echo getFormRowCheckBox(
    "test_report_to_users",
    $l["w_report_to_users"],
    "",
    "",
    1,
    $test_report_to_users,
    false,
);

$repeat_options = [
    0 => $l["w_no"],
    1 => $l["w_repeatable"],
];
for ($i = 2; $i <= 127; ++$i) {
    $repeat_options[$i] = $i;
}

echo getFormRowSelectBox(
    "test_repeatable",
    $l["w_repeatable"],
    "",
    "",
    $test_repeatable,
    $repeat_options,
    "",
);

echo getFormRowCheckBox(
    "test_logout_on_timeout",
    $l["w_logout_on_timeout"],
    "",
    "",
    1,
    $test_logout_on_timeout,
    false,
);

echo getFormRowTextInput(
    "new_test_password",
    $l["w_password"],
    $l["h_test_password"],
    " (" . $l["d_password_length"] . ")",
    "",
    K_USRREG_PASSWORD_RE,
    255,
    false,
    false,
    true,
);

echo '<div class="row">' . K_NEWLINE;
echo "<br />" . K_NEWLINE;
echo '<input type="hidden" name="test_password" id="test_password" value="' .
    $test_password .
    '" />' .
    K_NEWLINE;

// show buttons by case

if (!$record_readonly) {
    if (isset($test_id) && $test_id > 0) {
        echo '<span style="background-color:#999999;">';
        echo '<input type="checkbox" name="confirmupdate" id="confirmupdate" value="1" title="confirm &rarr; update" />';
        F_submit_button("update", $l["w_update"], $l["h_update"]);
        echo "</span>";
    }

    F_submit_button("add", $l["w_add"], $l["h_add"]);
    if (isset($test_id) && $test_id > 0) {
        F_submit_button("delete", $l["w_delete"], $l["h_delete"]);
        if (substr($test_end_time, 0, 1) < $millennium) {
            F_submit_button("unlock", $l["w_unlock"], $l["w_unlock"]);
        } else {
            F_submit_button("lock", $l["w_lock"], $l["w_lock"]);
        }
    }

    F_submit_button("clear", $l["w_clear"], $l["h_clear"]);
}

echo "<br /><br />" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

echo "</fieldset>" . K_NEWLINE;

// display a list of selected subject_id (topics)
if (isset($test_id) && $test_id > 0) {
    echo '<div class="row"><br /></div>' . K_NEWLINE;

    echo "<fieldset>" . K_NEWLINE;
    echo "<legend>" . $l["w_questions"] . "</legend>" . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">&nbsp;</span>' . K_NEWLINE;
    echo '<span class="formw">' . $test_fieldset_name . "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    // Fetch modules and subjects data
    $sql_mods = F_select_module_subjects_sql("module_enabled='1' AND subject_enabled='1'");
    $modules_list = [];
    $module_subjects = [];
    $subjects_data = [];
    if ($r_mods = F_db_query($sql_mods, $db)) {
        while ($m_row = F_db_fetch_array($r_mods)) {
            $m_id = (int) $m_row['module_id'];
            $s_id = (int) $m_row['subject_id'];
            $modules_list[$m_id] = $m_row['module_name'];
            if (!isset($module_subjects[$m_id])) {
                $module_subjects[$m_id] = [];
            }
            $module_subjects[$m_id][] = $s_id;
            $subjects_data[$s_id] = [
                'module_id' => $m_id,
                'module_name' => $m_row['module_name'],
                'subject_id' => $s_id,
                'subject_name' => $m_row['subject_name'],
            ];
        }
    }

    // Pre-aggregate question counts in a single efficient query
    $topic_questions_stat = [];
    $sql_counts = 'SELECT question_subject_id, question_type, question_difficulty, COUNT(*) as numquestions
        FROM ' . K_TABLE_QUESTIONS . '
        WHERE question_enabled=\'1\'
        GROUP BY question_subject_id, question_type, question_difficulty';
    if ($rc = F_db_query($sql_counts, $db)) {
        while ($mc = F_db_fetch_array($rc)) {
            $sid = (int) $mc['question_subject_id'];
            $qt = (int) $mc['question_type'];
            $qd = (int) $mc['question_difficulty'];
            $cnt = (int) $mc['numquestions'];
            if (!isset($topic_questions_stat[$sid])) {
                $topic_questions_stat[$sid] = [
                    'total' => 0,
                    'by_type' => [],
                    'by_diff' => [],
                    'matrix' => [],
                ];
            }
            $topic_questions_stat[$sid]['total'] += $cnt;
            if (!isset($topic_questions_stat[$sid]['by_type'][$qt])) {
                $topic_questions_stat[$sid]['by_type'][$qt] = 0;
            }
            $topic_questions_stat[$sid]['by_type'][$qt] += $cnt;

            if (!isset($topic_questions_stat[$sid]['by_diff'][$qd])) {
                $topic_questions_stat[$sid]['by_diff'][$qd] = 0;
            }
            $topic_questions_stat[$sid]['by_diff'][$qd] += $cnt;

            $topic_questions_stat[$sid]['matrix'][$qt . '_' . $qd] = $cnt;
        }
    }

    // Module filter dropdown and topic search
    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label"><label for="filter_module_id">' . $l['w_module'] . '</label></span>' . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<select name="filter_module_id" id="filter_module_id" onchange="FJ_filter_topics_by_module(this.value);" title="' . $l['h_module_name'] . '" style="min-width:180px;">' . K_NEWLINE;
    echo '<option value="0">*** ' . $l['w_all'] . ' ***</option>' . K_NEWLINE;
    foreach ($modules_list as $m_id => $m_name) {
        echo '<option value="' . $m_id . '">' . htmlspecialchars($m_name, ENT_NOQUOTES, $l['a_meta_charset']) . '</option>' . K_NEWLINE;
    }
    echo '</select>' . K_NEWLINE;
    echo '<span style="margin-left:12px;">' . K_NEWLINE;
    echo '<input type="text" id="filter_topic_search" placeholder="' . htmlspecialchars($l['w_search'] ?? 'Search topics...', ENT_COMPAT, $l['a_meta_charset']) . '" oninput="FJ_filter_topics_search(this.value);" style="width:180px; padding:3px 6px; font-size:90%;" />' . K_NEWLINE;
    echo '</span>' . K_NEWLINE;
    echo '</span>' . K_NEWLINE;
    echo '</div>' . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . K_NEWLINE;
    echo '<label for="subject_id">' . $l["w_subjects"] . "</label>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<select name="subject_id[]" id="subject_id" size="8" multiple="multiple" onchange="FJ_update_availability();" title="' .
        $l["h_subjects"] .
        '">' .
        K_NEWLINE;
    foreach ($module_subjects as $m_id => $s_ids) {
        $m_name = $modules_list[$m_id] ?? ('Module ' . $m_id);
        $m_selected = in_array('#' . $m_id, $subject_id) ? ' selected="selected"' : '';
        echo '<option value="#' . $m_id . '" data-module-id="' . $m_id . '" class="opt_module_header" style="background-color:#DDEEFF;font-weight:bold;"' . $m_selected . '>* [All topics in: ' . htmlspecialchars($m_name, ENT_NOQUOTES, $l['a_meta_charset']) . ']</option>' . K_NEWLINE;
        foreach ($s_ids as $s_id) {
            $s_row = $subjects_data[$s_id];
            $s_name = $s_row['subject_name'];
            $q_count = $topic_questions_stat[$s_id]['total'] ?? 0;
            $s_selected = in_array((string)$s_id, $subject_id) ? ' selected="selected"' : '';
            echo '<option value="' . $s_id . '" data-module-id="' . $m_id . '" class="opt_topic_item"' . $s_selected . '>&nbsp;&nbsp;&nbsp;' .
                htmlspecialchars($s_name, ENT_NOQUOTES, $l['a_meta_charset']) .
                ' (' . $q_count . ' ' . $l['w_questions'] . ')</option>' . K_NEWLINE;
        }
    }
    echo "</select>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . K_NEWLINE;
    echo '<label for="tsubset_quantity">' . $l["w_num_questions"] . "</label>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<input type="text" name="tsubset_quantity" id="tsubset_quantity" value="' . $tsubset_quantity . '" size="5" maxlength="20" class="numeric" />' . K_NEWLINE;
    echo '<span id="tsubset_availability_badge" class="labeldesc" style="display:inline-block; margin-left:10px; font-weight:bold; color:#1c4626; background:#eff7f1; padding:3px 8px; border-radius:4px; border:1px solid #c9e2cd;">';
    echo 'Available: <strong id="tsubset_avail_count">0</strong> matching questions';
    echo '</span>' . K_NEWLINE;
    echo '<a href="#" id="btn_use_all_available" onclick="FJ_use_all_available(); return false;" style="margin-left:8px; font-size:85%; text-decoration:underline;">[use all available]</a>' . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . K_NEWLINE;
    echo '<label for="tsubset_type">' . $l["w_type"] . "</label>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<select name="tsubset_type" id="tsubset_type" size="0" onchange="FJ_update_availability();" title="' .
        $l["h_question_type"] .
        '">' .
        K_NEWLINE;
    echo '<option value="0"';
    if ($tsubset_type == 0) {
        echo ' selected="selected"';
    }

    echo ">*** " . $l["w_all"] . " ***</option>" . K_NEWLINE;
    echo '<option value="1"';
    if ($tsubset_type == 1) {
        echo ' selected="selected"';
    }

    echo ">" . $l["w_single_answer"] . "</option>" . K_NEWLINE;
    echo '<option value="2"';
    if ($tsubset_type == 2) {
        echo ' selected="selected"';
    }

    echo ">" . $l["w_multiple_answers"] . "</option>" . K_NEWLINE;
    echo '<option value="3"';
    if ($tsubset_type == 3) {
        echo ' selected="selected"';
    }

    echo ">" . $l["w_free_answer"] . "</option>" . K_NEWLINE;
    echo '<option value="4"';
    if ($tsubset_type == 4) {
        echo ' selected="selected"';
    }

    echo ">" . $l["w_ordering_answer"] . "</option>" . K_NEWLINE;
    echo "</select>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . K_NEWLINE;
    echo '<label for="tsubset_difficulty">' .
        $l["w_question_difficulty"] .
        "</label>" .
        K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<select name="tsubset_difficulty" id="tsubset_difficulty" size="0" onchange="FJ_update_availability();" title="' .
        $l["h_question_difficulty"] .
        '">' .
        K_NEWLINE;
    for ($i = 0; $i <= K_QUESTION_DIFFICULTY_LEVELS; ++$i) {
        echo '<option value="' . $i . '"';
        if ($i == $tsubset_difficulty) {
            echo ' selected="selected"';
        }

        echo ">" . $i . "</option>" . K_NEWLINE;
    }

    echo "</select>" . K_NEWLINE;
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo '<input type="hidden" name="tsubset_answers" id="tsubset_answers" value="' . (int) ($tsubset_answers ?? 0) . '" />' . K_NEWLINE;

    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">&nbsp;</span>' . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<input type="hidden" name="subset_token" id="subset_token" value="' . md5(uniqid((string) mt_rand(), true)) . '" />' . K_NEWLINE;
    F_submit_button(
        "addquestion",
        $l["w_add_questions"],
        $l["h_add_questions"],
    );
    echo "</span>" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo '<div class="rowl" title="' . $l["h_subjects"] . '">' . K_NEWLINE;
    echo "<br />" . K_NEWLINE;
    echo '<div class="preview">' . K_NEWLINE;
    $sql = "SELECT * FROM " . K_TABLE_TEST_SUBJSET . ' WHERE tsubset_test_id=\'' . $test_id . '\' ORDER BY tsubset_id';
    if ($r = F_db_query($sql, $db)) {
        $subjcount = 0;
        $total_subset_questions = 0;
        $test_max_score_new = 0;
        $rows_html = '';
        while ($m = F_db_fetch_array($r)) {
            $subjects_list = '';
            $sqls = 'SELECT subject_id, subject_name FROM ' . K_TABLE_SUBJECTS . ', ' . K_TABLE_SUBJECT_SET . ' WHERE subject_id=subjset_subject_id AND subjset_tsubset_id=\'' . $m['tsubset_id'] . '\' ORDER BY subject_name';
            if ($rs = F_db_query($sqls, $db)) {
                while ($ms = F_db_fetch_array($rs)) {
                    $subjects_list .= '<a href="tce_edit_subject.php?subject_id=' . $ms['subject_id'] . '" title="' . $l['t_subjects_editor'] . '">' . htmlspecialchars($ms['subject_name'], ENT_NOQUOTES, $l['a_meta_charset']) . '</a>, ';
                }
            } else {
                F_display_db_error();
            }
            $subjects_list = rtrim($subjects_list, ', ');

            $type_label = $l['w_all'];
            if ($m['tsubset_type'] == 1) {
                $type_label = $l['w_single_answer'];
            } elseif ($m['tsubset_type'] == 2) {
                $type_label = $l['w_multiple_answers'];
            } elseif ($m['tsubset_type'] == 3) {
                $type_label = $l['w_free_answer'];
            } elseif ($m['tsubset_type'] == 4) {
                $type_label = $l['w_ordering_answer'];
            }

            $subset_score = $test_score_right * $m['tsubset_difficulty'] * $m['tsubset_quantity'];
            $test_max_score_new += $subset_score;
            $total_subset_questions += (int) $m['tsubset_quantity'];

            $rows_html .= '<tr>' . K_NEWLINE;
            $rows_html .= '<td style="text-align:center;"><input type="checkbox" name="selectsubject' . $subjcount . '" id="selectsubject' . $subjcount . '" value="' . $m['tsubset_id'] . '" class="subset_checkbox" title="' . $l['w_select'] . '" /></td>' . K_NEWLINE;
            $rows_html .= '<td>' . $subjects_list . '</td>' . K_NEWLINE;
            $rows_html .= '<td>' . htmlspecialchars($type_label, ENT_NOQUOTES, $l['a_meta_charset']) . '</td>' . K_NEWLINE;
            $rows_html .= '<td style="text-align:center;">' . $m['tsubset_difficulty'] . '</td>' . K_NEWLINE;
            $rows_html .= '<td style="text-align:center;"><strong>' . $m['tsubset_quantity'] . '</strong></td>' . K_NEWLINE;
            $rows_html .= '<td style="text-align:right;">' . sprintf('%.2f', $subset_score) . '</td>' . K_NEWLINE;
            $rows_html .= '<td style="text-align:center;"><button type="button" class="btn_delete_subset" onclick="FJ_delete_single_subset(' . $m['tsubset_id'] . ');" style="background:#dc3545; color:#fff; border:none; border-radius:3px; padding:2px 8px; cursor:pointer; font-size:85%;" title="' . $l['w_delete'] . '">[x] ' . $l['w_delete'] . '</button></td>' . K_NEWLINE;
            $rows_html .= '</tr>' . K_NEWLINE;

            ++$subjcount;
        }

        // update test_max_score if changed
        if (isset($test_max_score) && $test_max_score_new !== $test_max_score) {
            $test_max_score = $test_max_score_new;
            $sqlup = 'UPDATE ' . K_TABLE_TESTS . ' SET test_max_score=' . $test_max_score . ' WHERE test_id=' . $test_id;
            if (!($rup = F_db_query($sqlup, $db))) {
                F_display_db_error(false);
            }
        }

        if ($subjcount > 0) {
            echo '<table class="userselect subsets_table" style="margin-top:10px; width:100%; border-collapse:collapse;">' . K_NEWLINE;
            echo '<thead>' . K_NEWLINE;
            echo '<tr>' . K_NEWLINE;
            echo '<th style="width:30px; text-align:center;"><input type="checkbox" id="select_all_subsets" onclick="FJ_toggle_all_subsets(this);" title="' . $l['w_select'] . '" /></th>' . K_NEWLINE;
            echo '<th>' . $l['w_subjects'] . '</th>' . K_NEWLINE;
            echo '<th>' . $l['w_type'] . '</th>' . K_NEWLINE;
            echo '<th style="text-align:center;">' . $l['w_question_difficulty'] . '</th>' . K_NEWLINE;
            echo '<th style="text-align:center;">' . $l['w_questions'] . '</th>' . K_NEWLINE;
            echo '<th style="text-align:right;">' . $l['w_score'] . '</th>' . K_NEWLINE;
            echo '<th style="text-align:center; width:90px;">' . $l['w_action'] . '</th>' . K_NEWLINE;
            echo '</tr>' . K_NEWLINE;
            echo '</thead>' . K_NEWLINE;
            echo '<tbody>' . K_NEWLINE . $rows_html . '</tbody>' . K_NEWLINE;
            echo '<tfoot>' . K_NEWLINE;
            echo '<tr style="font-weight:bold; background:#eff7f1;">' . K_NEWLINE;
            echo '<td colspan="4" style="text-align:right;">Total:</td>' . K_NEWLINE;
            echo '<td style="text-align:center;">' . $total_subset_questions . '</td>' . K_NEWLINE;
            echo '<td style="text-align:right;">' . sprintf('%.2f', $test_max_score_new) . '</td>' . K_NEWLINE;
            echo '<td>&nbsp;</td>' . K_NEWLINE;
            echo '</tr>' . K_NEWLINE;
            echo '</tfoot>' . K_NEWLINE;
            echo '</table>' . K_NEWLINE;

            echo '<input type="hidden" name="subjcount" id="subjcount" value="' . $subjcount . '" />' . K_NEWLINE;
            echo '<input type="hidden" name="deletesubset_id" id="deletesubset_id" value="0" />' . K_NEWLINE;
            echo '<div style="margin-top:8px;">' . K_NEWLINE;
            F_submit_button('deletesubject', $l['w_delete'], $l['h_delete']);
            echo '</div>' . K_NEWLINE;
        } else {
            echo '<p style="color:#666; font-style:italic;">No question subsets have been added to this exam yet.</p>' . K_NEWLINE;
            echo '<input type="hidden" name="subjcount" id="subjcount" value="0" />' . K_NEWLINE;
            echo '<input type="hidden" name="deletesubset_id" id="deletesubset_id" value="0" />' . K_NEWLINE;
        }
    } else {
        F_display_db_error();
    }

    echo '&nbsp;' . K_NEWLINE;
    echo $l['w_max_score'] . ': ' . $test_max_score_new;
    echo '<input type="hidden" name="test_max_score" id="test_max_score" value="' . $test_max_score_new . '" />';

    echo "</div>" . K_NEWLINE;
    echo "<br /><br />" . K_NEWLINE;
    echo "</div>" . K_NEWLINE;

    echo "</fieldset>" . K_NEWLINE;

    echo '<div class="row"><br /></div>' . K_NEWLINE;

}

echo F_getCSRFTokenField() . K_NEWLINE;
echo "</form>" . K_NEWLINE;

echo "</div>" . K_NEWLINE;

echo '<div class="pagehelp">' . $l["hp_edit_test"] . "</div>" . K_NEWLINE;
echo "</div>" . K_NEWLINE;

// javascript controls
echo '<script type="text/javascript">' . K_NEWLINE;
echo "//<![CDATA[" . K_NEWLINE;
echo "function JF_check_random_boxes() {" . K_NEWLINE;
echo " if (document.getElementById('test_random_questions_select').checked==true){document.getElementById('test_random_questions_order').checked=true;}" .
    K_NEWLINE;
echo " if ((document.getElementById('test_random_questions_order').checked==false)&&(document.getElementById('test_random_questions_select').checked==true)){document.getElementById('test_random_questions_order').checked=true;}" .
    K_NEWLINE;
echo ' if (document.getElementById(\'test_random_questions_order\').checked==false){document.getElementById(\'select_questions_order_mode\').style.visibility="visible";}else{document.getElementById(\'select_questions_order_mode\').style.visibility="hidden";}' .
    K_NEWLINE;
echo " if (document.getElementById('test_random_answers_select').checked==true){document.getElementById('test_random_answers_order').checked=true;}" .
    K_NEWLINE;
echo " if ((document.getElementById('test_random_answers_order').checked==false)&&(document.getElementById('test_random_answers_select').checked==true)){document.getElementById('test_random_answers_order').checked=true;}" .
    K_NEWLINE;
echo ' if (document.getElementById(\'test_random_answers_order\').checked==false){document.getElementById(\'select_answers_order_mode\').style.visibility="visible";}else{document.getElementById(\'select_answers_order_mode\').style.visibility="hidden";}' .
    K_NEWLINE;
echo "}" . K_NEWLINE;
echo "JF_check_random_boxes();" . K_NEWLINE;
echo "//]]>" . K_NEWLINE;
echo "</script>" . K_NEWLINE;

// initialize SlimSelect and question availability controls
$json_topic_questions = isset($topic_questions_stat) ? json_encode($topic_questions_stat) : '{}';
$json_module_subjects = isset($module_subjects) ? json_encode($module_subjects) : '{}';

echo '<script type="text/javascript">' . K_NEWLINE;
echo "//<![CDATA[" . K_NEWLINE;
echo 'var topicQuestionMap = ' . $json_topic_questions . ';' . K_NEWLINE;
echo 'var moduleSubjectsMap = ' . $json_module_subjects . ';' . K_NEWLINE;
echo 'window.slimSelectSubject = null;' . K_NEWLINE;

echo 'function FJ_filter_topics_by_module(moduleId) {' . K_NEWLINE;
echo ' moduleId = parseInt(moduleId);' . K_NEWLINE;
echo ' var sel = document.getElementById("subject_id");' . K_NEWLINE;
echo ' if (!sel) return;' . K_NEWLINE;
echo ' var allOptions = sel.querySelectorAll("option");' . K_NEWLINE;
echo ' for (var i = 0; i < allOptions.length; i++) {' . K_NEWLINE;
echo '  var opt = allOptions[i];' . K_NEWLINE;
echo '  var optModId = parseInt(opt.getAttribute("data-module-id") || 0);' . K_NEWLINE;
echo '  if (moduleId === 0 || optModId === moduleId) {' . K_NEWLINE;
echo '   opt.style.display = "";' . K_NEWLINE;
echo '   opt.disabled = false;' . K_NEWLINE;
echo '  } else {' . K_NEWLINE;
echo '   opt.style.display = "none";' . K_NEWLINE;
echo '   opt.disabled = true;' . K_NEWLINE;
echo '   opt.selected = false;' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' if (window.slimSelectSubject && typeof window.slimSelectSubject.setData === "function") {' . K_NEWLINE;
echo '  var data = [];' . K_NEWLINE;
echo '  for (var i = 0; i < allOptions.length; i++) {' . K_NEWLINE;
echo '   var opt = allOptions[i];' . K_NEWLINE;
echo '   var optModId = parseInt(opt.getAttribute("data-module-id") || 0);' . K_NEWLINE;
echo '   if (moduleId === 0 || optModId === moduleId) {' . K_NEWLINE;
echo '    data.push({ text: opt.text, value: opt.value, selected: opt.selected, disabled: false });' . K_NEWLINE;
echo '   }' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo '  window.slimSelectSubject.setData(data);' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' FJ_update_availability();' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_filter_topics_search(term) {' . K_NEWLINE;
echo ' term = (term || "").toLowerCase().trim();' . K_NEWLINE;
echo ' var sel = document.getElementById("subject_id");' . K_NEWLINE;
echo ' if (!sel) return;' . K_NEWLINE;
echo ' var modId = parseInt((document.getElementById("filter_module_id") || {}).value || 0);' . K_NEWLINE;
echo ' var allOptions = sel.querySelectorAll("option");' . K_NEWLINE;
echo ' for (var i = 0; i < allOptions.length; i++) {' . K_NEWLINE;
echo '  var opt = allOptions[i];' . K_NEWLINE;
echo '  var optModId = parseInt(opt.getAttribute("data-module-id") || 0);' . K_NEWLINE;
echo '  var matchMod = (modId === 0 || optModId === modId);' . K_NEWLINE;
echo '  var matchText = (term === "" || opt.text.toLowerCase().indexOf(term) !== -1);' . K_NEWLINE;
echo '  if (matchMod && matchText) {' . K_NEWLINE;
echo '   opt.style.display = "";' . K_NEWLINE;
echo '   opt.disabled = false;' . K_NEWLINE;
echo '  } else {' . K_NEWLINE;
echo '   opt.style.display = "none";' . K_NEWLINE;
echo '   opt.disabled = true;' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' if (window.slimSelectSubject && typeof window.slimSelectSubject.setData === "function") {' . K_NEWLINE;
echo '  var data = [];' . K_NEWLINE;
echo '  for (var i = 0; i < allOptions.length; i++) {' . K_NEWLINE;
echo '   var opt = allOptions[i];' . K_NEWLINE;
echo '   var optModId = parseInt(opt.getAttribute("data-module-id") || 0);' . K_NEWLINE;
echo '   var matchMod = (modId === 0 || optModId === modId);' . K_NEWLINE;
echo '   var matchText = (term === "" || opt.text.toLowerCase().indexOf(term) !== -1);' . K_NEWLINE;
echo '   if (matchMod && matchText) {' . K_NEWLINE;
echo '    data.push({ text: opt.text, value: opt.value, selected: opt.selected, disabled: false });' . K_NEWLINE;
echo '   }' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo '  window.slimSelectSubject.setData(data);' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' FJ_update_availability();' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_count_subject_matches(sid, qType, qDiff) {' . K_NEWLINE;
echo ' if (!window.topicQuestionMap || !window.topicQuestionMap[sid]) return 0;' . K_NEWLINE;
echo ' var matrix = window.topicQuestionMap[sid].matrix || {};' . K_NEWLINE;
echo ' if (qType === 0) {' . K_NEWLINE;
echo '  var sum = 0;' . K_NEWLINE;
echo '  for (var t = 1; t <= 4; t++) {' . K_NEWLINE;
echo '   var k = t + "_" + qDiff;' . K_NEWLINE;
echo '   if (matrix[k]) sum += parseInt(matrix[k]);' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo '  return sum;' . K_NEWLINE;
echo ' } else {' . K_NEWLINE;
echo '  var k = qType + "_" + qDiff;' . K_NEWLINE;
echo '  return parseInt(matrix[k] || 0);' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_update_availability() {' . K_NEWLINE;
echo ' var sel = document.getElementById("subject_id");' . K_NEWLINE;
echo ' var badge = document.getElementById("tsubset_avail_count");' . K_NEWLINE;
echo ' var badgeBox = document.getElementById("tsubset_availability_badge");' . K_NEWLINE;
echo ' if (!sel || !badge) return;' . K_NEWLINE;
echo ' var selectedVals = [];' . K_NEWLINE;
echo ' for (var i = 0; i < sel.options.length; i++) {' . K_NEWLINE;
echo '  if (sel.options[i].selected) selectedVals.push(sel.options[i].value);' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' var qType = parseInt((document.getElementById("tsubset_type") || {}).value || 0);' . K_NEWLINE;
echo ' var qDiff = parseInt((document.getElementById("tsubset_difficulty") || {}).value || 0);' . K_NEWLINE;
echo ' var totalAvail = 0;' . K_NEWLINE;
echo ' var processedSubjects = {};' . K_NEWLINE;
echo ' for (var i = 0; i < selectedVals.length; i++) {' . K_NEWLINE;
echo '  var val = selectedVals[i];' . K_NEWLINE;
echo '  if (typeof val === "string" && val.charAt(0) === "#") {' . K_NEWLINE;
echo '   var modId = parseInt(val.substring(1));' . K_NEWLINE;
echo '   if (window.moduleSubjectsMap && window.moduleSubjectsMap[modId]) {' . K_NEWLINE;
echo '    var sList = window.moduleSubjectsMap[modId];' . K_NEWLINE;
echo '    for (var j = 0; j < sList.length; j++) {' . K_NEWLINE;
echo '     var sid = sList[j];' . K_NEWLINE;
echo '     if (!processedSubjects[sid]) {' . K_NEWLINE;
echo '      processedSubjects[sid] = true;' . K_NEWLINE;
echo '      totalAvail += FJ_count_subject_matches(sid, qType, qDiff);' . K_NEWLINE;
echo '     }' . K_NEWLINE;
echo '    }' . K_NEWLINE;
echo '   }' . K_NEWLINE;
echo '  } else {' . K_NEWLINE;
echo '   var sid = parseInt(val);' . K_NEWLINE;
echo '   if (sid > 0 && !processedSubjects[sid]) {' . K_NEWLINE;
echo '    processedSubjects[sid] = true;' . K_NEWLINE;
echo '    totalAvail += FJ_count_subject_matches(sid, qType, qDiff);' . K_NEWLINE;
echo '   }' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' badge.innerText = totalAvail;' . K_NEWLINE;
echo ' if (badgeBox) {' . K_NEWLINE;
echo '  if (totalAvail > 0) {' . K_NEWLINE;
echo '   badgeBox.style.color = "#1c4626";' . K_NEWLINE;
echo '   badgeBox.style.background = "#eff7f1";' . K_NEWLINE;
echo '   badgeBox.style.borderColor = "#c9e2cd";' . K_NEWLINE;
echo '  } else {' . K_NEWLINE;
echo '   badgeBox.style.color = "#721c24";' . K_NEWLINE;
echo '   badgeBox.style.background = "#f8d7da";' . K_NEWLINE;
echo '   badgeBox.style.borderColor = "#f5c6cb";' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_use_all_available() {' . K_NEWLINE;
echo ' var badge = document.getElementById("tsubset_avail_count");' . K_NEWLINE;
echo ' var qtyInput = document.getElementById("tsubset_quantity");' . K_NEWLINE;
echo ' if (badge && qtyInput) {' . K_NEWLINE;
echo '  var count = parseInt(badge.innerText || 0);' . K_NEWLINE;
echo '  if (count > 0) qtyInput.value = count;' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_delete_single_subset(id) {' . K_NEWLINE;
echo ' if (confirm("Are you sure you want to delete this question subset?")) {' . K_NEWLINE;
echo '  var form = document.getElementById("form_testeditor");' . K_NEWLINE;
echo '  var delInput = document.getElementById("deletesubset_id");' . K_NEWLINE;
echo '  if (form && delInput) {' . K_NEWLINE;
echo '   delInput.value = id;' . K_NEWLINE;
echo '   var hiddenAction = document.createElement("input");' . K_NEWLINE;
echo '   hiddenAction.type = "hidden";' . K_NEWLINE;
echo '   hiddenAction.name = "deletesubject";' . K_NEWLINE;
echo '   hiddenAction.value = "1";' . K_NEWLINE;
echo '   form.appendChild(hiddenAction);' . K_NEWLINE;
echo '   form.submit();' . K_NEWLINE;
echo '  }' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'function FJ_toggle_all_subsets(master) {' . K_NEWLINE;
echo ' var cbs = document.querySelectorAll(".subset_checkbox");' . K_NEWLINE;
echo ' for (var i = 0; i < cbs.length; i++) {' . K_NEWLINE;
echo '  cbs[i].checked = master.checked;' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '}' . K_NEWLINE;

echo 'document.addEventListener("DOMContentLoaded", function() {' . K_NEWLINE;
echo ' if (document.getElementById("user_groups")) { new SlimSelect({ select: "#user_groups", placeholder: "' . $l["w_groups"] . '", search: true, selectAllText: "Select All", deselectLabel: "Deselect" }); }' . K_NEWLINE;
echo ' if (document.getElementById("sslcerts")) { new SlimSelect({ select: "#sslcerts", placeholder: "' . $l["w_sslcerts"] . '", search: true, selectAllText: "Select All", deselectLabel: "Deselect" }); }' . K_NEWLINE;
echo ' if (document.getElementById("subject_id")) {' . K_NEWLINE;
echo '  window.slimSelectSubject = new SlimSelect({ select: "#subject_id", placeholder: "' . $l["w_subjects"] . '", search: true, selectAllText: "Select All", deselectLabel: "Deselect", onChange: function() { FJ_update_availability(); } });' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo ' FJ_update_availability();' . K_NEWLINE;
echo ' if (window.history && window.history.replaceState) {' . K_NEWLINE;
echo '  var cleanTestId = parseInt((document.getElementById("test_id") || {}).value || 0);' . K_NEWLINE;
echo '  var cleanUrl = window.location.pathname + (cleanTestId > 0 ? "?test_id=" + cleanTestId : "");' . K_NEWLINE;
echo '  window.history.replaceState(null, "", cleanUrl);' . K_NEWLINE;
echo ' }' . K_NEWLINE;
echo '});' . K_NEWLINE;
echo "//]]>" . K_NEWLINE;
echo "</script>" . K_NEWLINE;
require_once "../code/tce_page_footer.php";

//============================================================+
// END OF FILE
//============================================================+
