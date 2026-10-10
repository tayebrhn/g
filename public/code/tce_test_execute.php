<?php
//============================================================+
// File name   : tce_test_execute.php
// Begin       : 2004-05-29
// Last Update : 2023-11-30
//
// Description : execute a specific test
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
 * Execute a specific test.
 * @package com.tecnick.tcexam.public
 * @author Nicola Asuni
 * @since 2004-05-29
 */



require_once('../config/tce_config.php');

$pagelevel = K_AUTH_PUBLIC_TEST_EXECUTE;
$thispage_title = $l['t_test_execute'];
$thispage_description = $l['hp_test_execute'];
require_once('../../shared/code/tce_authorization.php');
require_once('../../shared/code/tce_functions_form.php');
require_once('../../shared/code/tce_functions_test.php');

$formname = 'testform';

$test_id = 0;
$testlog_id = 0;
$answpos = [];
$answer_text = '';
$test_comment = '';
$reaction_time = 0;

if (isset($_REQUEST['testid']) && $_REQUEST['testid'] > 0) {
    $test_id = (int) $_REQUEST['testid'];
    // check for test password
    $tph = F_getTestPassword($test_id);
    if (! empty($tph) && ! checkPassword($tph . $test_id . $_SESSION['session_user_id'] . $_SESSION['session_user_ip'], $_SESSION['session_test_login'])) {
        // display login page
        require_once('../code/tce_page_header.php');
        echo F_testLoginForm($_SERVER['SCRIPT_NAME'], 'form_test_login', 'post', 'multipart/form-data', $test_id);
        require_once('../code/tce_page_footer.php');
        exit(); //break page here
    }

    if (isset($_REQUEST['repeat']) && $_REQUEST['repeat'] == 1) {
        // mark previous test attempts as repeated
        F_repeatTest($test_id);
    }

    if (F_executeTest($test_id)) {
        if (! empty($_REQUEST['testlogid'])) {
            $testlog_id = (int) $_REQUEST['testlogid'];
        }

        if (! empty($_REQUEST['answpos'])) {
            $answpos = is_numeric($_REQUEST['answpos']) ? [
                $_REQUEST['answpos'] => 1,
            ] : (array) $_REQUEST['answpos'];
        }

        if (! empty($_REQUEST['answertext'])) {
            $answer_text = $_REQUEST['answertext'];
        }

        if (! empty($_REQUEST['reaction_time'])) {
            $reaction_time = (int) $_REQUEST['reaction_time'];
        }

        $is_timeout_finish = (isset($_REQUEST['finish']) && $_REQUEST['finish'] > 0);
        $is_force_terminate = ! empty($_REQUEST['forceterminate']);

        if ($is_force_terminate || $is_timeout_finish) {
            if ($testlog_id > 0 && F_isRightTestlogUser($test_id, $testlog_id)) {
                // update current question answers before locking
                F_updateQuestionLog($test_id, $testlog_id, $answpos, $answer_text, $reaction_time);
            }

            // terminate the test (lock the test to status=4)
            F_terminateUserTest($test_id);
            $testdata = F_getTestData($test_id);
            $target_url = F_getBoolean($testdata['test_results_to_users']) ? ('tce_test_results.php?testid=' . $test_id) : ('tce_test_finished.php?testid=' . $test_id);
            // redirect the user
            header('Location: ' . $target_url);
            echo '<?xml version="1.0" encoding="' . $l['a_meta_charset'] . '"?' . '>' . K_NEWLINE;
            echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' . K_NEWLINE;
            echo '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="' . $l['a_meta_language'] . '" lang="' . $l['a_meta_language'] . '" dir="' . $l['a_meta_dir'] . '">' . K_NEWLINE;
            echo '<head>' . K_NEWLINE;
            echo '<title>REDIRECT</title>' . K_NEWLINE;
            echo '<meta http-equiv="refresh" content="0;url=' . htmlspecialchars($target_url, ENT_QUOTES, $l['a_meta_charset']) . '" />' . K_NEWLINE; //reload page
            echo '</head>' . K_NEWLINE;
            echo '<body>' . K_NEWLINE;
            echo '<a href="' . htmlspecialchars($target_url, ENT_QUOTES, $l['a_meta_charset']) . '">CONTINUE...</a>' . K_NEWLINE;
            echo '</body>' . K_NEWLINE;
            echo '</html>' . K_NEWLINE;
            exit;
        }

        // the user is authorized to execute the selected test
        $thispage_title .= ': ' . F_getTestName($test_id);

        require_once('../code/tce_page_header.php');
        echo '<div class="container">' . K_NEWLINE;

        echo '<span class="infolink">' . F_testInfoLink($test_id, $l['w_info']) . '<br /><br /></span>' . K_NEWLINE;

        // Synchronize flagged questions
        if (! isset($_SESSION['test_flags_' . $test_id]) || ! is_array($_SESSION['test_flags_' . $test_id])) {
            $_SESSION['test_flags_' . $test_id] = [];
        }
        if (isset($_REQUEST['flagged_log_ids'])) {
            $raw_flags = trim((string) $_REQUEST['flagged_log_ids']);
            if ($raw_flags === '') {
                $_SESSION['test_flags_' . $test_id] = [];
            } else {
                $parsed_flags = array_map('intval', explode(',', $raw_flags));
                $_SESSION['test_flags_' . $test_id] = array_values(array_unique(array_filter($parsed_flags, function ($id) {
                    return $id > 0;
                })));
            }
        }
        $flagged_ids = $_SESSION['test_flags_' . $test_id];
        $flagged_log_ids_str = implode(',', $flagged_ids);

        if (! isset($_REQUEST['terminationform']) && F_isRightTestlogUser($test_id, $testlog_id)) {
            // the form has been submitted, update testlogid data
            F_updateQuestionLog($test_id, $testlog_id, $answpos, $answer_text, $reaction_time);
            // update user's test comment
            if (isset($_REQUEST['testcomment']) && ! empty($_REQUEST['testcomment'])) {
                $test_comment = $_REQUEST['testcomment'];
                F_updateTestComment($test_id, $test_comment);
            }

            if ((isset($_REQUEST['nextquestion']) || isset($_REQUEST['autonext']) && $_REQUEST['autonext'] == 1) && $_REQUEST['nextquestionid'] > 0) {
                // go to next question
                $testlog_id = 0 + (int) $_REQUEST['nextquestionid'];
            } elseif (isset($_REQUEST['prevquestion']) && $_REQUEST['prevquestionid'] > 0) {
                // go to previous question
                $testlog_id = (int) $_REQUEST['prevquestionid'];
            } else {
                // go to selected question
                foreach (array_keys($_POST) as $key) {
                    if (preg_match('/jumpquestion_(\d+)/', $key, $matches) > 0) {
                        $testlog_id = (int) $matches[1];
                        break;
                    }
                }
            }
        }

        // Test statistics for sticky header and review summary
        $user_stats = F_getTestUserStats($test_id, (int) $_SESSION['session_user_id']);
        $total_questions = $user_stats['total'];
        $answered_questions = $user_stats['answered'];
        $unanswered_questions = $user_stats['unanswered'];
        $progress_percentage = $user_stats['progress_pct'];
        $flagged_count = count($flagged_ids);

        $curr_q_index = 1;
        if ($testlog_id > 0 && isset($user_stats['questions'][$testlog_id])) {
            $curr_q_index = $user_stats['questions'][$testlog_id]['index'];
        } elseif (! empty($user_stats['questions'])) {
            $first_q = reset($user_stats['questions']);
            $curr_q_index = $first_q['index'];
        }

        // Determine test end time for interactive timer (both normal questions and review confirmation)
        $test_data = F_getTestData($test_id);
        if (! isset($examtime) && isset($test_data['test_duration_time']) && $test_data['test_duration_time'] > 0) {
            $tu_sql = 'SELECT testuser_id, testuser_creation_time FROM ' . K_TABLE_TEST_USER . ' WHERE testuser_test_id=' . (int) $test_id . ' AND testuser_user_id=' . (int) $_SESSION['session_user_id'] . ' AND testuser_status<5 ORDER BY testuser_id DESC LIMIT 1';
            if ($tu_res = F_db_query($tu_sql, $db)) {
                if ($tu_row = F_db_fetch_array($tu_res)) {
                    $examtime = strtotime($tu_row['testuser_creation_time']) + ($test_data['test_duration_time'] * K_SECONDS_IN_MINUTE);
                    $timeout_logout = F_getBoolean($test_data['test_logout_on_timeout']) ? 'true' : 'false';
                }
            }
        }

        // Render Sticky Exam Status Header
        echo '<div class="exam_sticky_bar" id="exam_sticky_bar">' . K_NEWLINE;
        echo '<div class="sticky_left">' . K_NEWLINE;
        echo '<span class="sticky_test_name" title="' . htmlspecialchars(F_getTestName($test_id), ENT_QUOTES, $l['a_meta_charset']) . '">' . htmlspecialchars(F_getTestName($test_id), ENT_QUOTES, $l['a_meta_charset']) . '</span>' . K_NEWLINE;
        echo '<span class="sticky_qnum">Question <strong id="sticky_curr_num">' . $curr_q_index . '</strong> of <strong>' . $total_questions . '</strong></span>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;

        echo '<div class="sticky_center">' . K_NEWLINE;
        echo '<div class="sticky_progress_wrap">' . K_NEWLINE;
        echo '<div class="sticky_progress_info">' . K_NEWLINE;
        echo '<span id="sticky_progress_text">' . $answered_questions . ' / ' . $total_questions . ' Answered (' . $progress_percentage . '%)</span>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;
        echo '<div class="sticky_progress_bar">' . K_NEWLINE;
        echo '<div class="sticky_progress_fill" id="sticky_progress_fill" style="width:' . $progress_percentage . '%;"></div>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;

        echo '<div class="sticky_right">' . K_NEWLINE;
        echo '<div class="sticky_timer_box" id="sticky_timer_box" title="' . $l['w_clock_timer'] . '">' . K_NEWLINE;
        echo '<span class="sticky_timer_icon">&#9200;</span> ' . K_NEWLINE;
        echo '<span class="sticky_timer_display" id="sticky_timer_display">--:--:--</span>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;
        echo '<button type="button" class="btn_end_exam" id="btn_open_review" onclick="FJ_open_review_modal();" title="' . $l['w_terminate_exam'] . '">' . $l['w_terminate'] . ' &raquo;</button>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;
        echo '</div>' . K_NEWLINE;

        // confirmation form to terminate the test
        if (isset($_REQUEST['terminatetest']) && ! empty($_REQUEST['terminatetest'])) {
            // check if some questions were omitted (undisplayed or unanswered).
            $num_omitted_questions = F_getNumOmittedQuestions($test_id);
            $omitted_msg = '';
            if ($num_omitted_questions > 0) {
                $omitted_msg = '<br /><span style="color:#990000;font-size:120%;">[ ' . $l['h_questions_unanswered'] . ': ' . $num_omitted_questions . ' ]</span><br />';
            }

            F_print_error('WARNING', $omitted_msg . '' . $l['m_confirm_test_termination']);
            ?>
            <div class="confirmbox review_confirm_wrapper">
                <div class="review_summary_card">
                    <h3 class="review_summary_heading">Exam Pre-Submission Review</h3>
                    <div class="review_stats_grid">
                        <div class="review_stat_card card_answered">
                            <span class="stat_value"><?php echo $answered_questions; ?></span>
                            <span class="stat_label">Answered</span>
                        </div>
                        <div class="review_stat_card card_unanswered">
                            <span class="stat_value"><?php echo $unanswered_questions; ?></span>
                            <span class="stat_label">Unanswered</span>
                        </div>
                        <div class="review_stat_card card_flagged">
                            <span class="stat_value"><?php echo $flagged_count; ?></span>
                            <span class="stat_label">Flagged</span>
                        </div>
                    </div>

                    <?php if ($unanswered_questions > 0): ?>
                    <div class="review_jump_section">
                        <h4>Unanswered Questions (Click to Answer):</h4>
                        <form action="<?php echo $_SERVER['SCRIPT_NAME']; ?>" method="post" enctype="multipart/form-data" class="review_jump_form">
                        <input type="hidden" name="testid" value="<?php echo $test_id; ?>" />
                        <input type="hidden" name="flagged_log_ids" value="<?php echo htmlspecialchars($flagged_log_ids_str); ?>" />
                        <?php echo F_getCSRFTokenField() . K_NEWLINE; ?>
                        <div class="review_chips_grid">
                        <?php foreach ($user_stats['questions'] as $qlog_id => $qitem): ?>
                            <?php if (! $qitem['answered']): ?>
                            <button type="submit" name="jumpquestion_<?php echo $qlog_id; ?>" class="review_jump_chip chip_unanswered" title="Jump to question <?php echo $qitem['index']; ?>">Question <?php echo $qitem['index']; ?></button>
                            <?php endif; ?>
                        <?php endforeach; ?>
                        </div>
                        </form>
                    </div>
                    <?php endif; ?>

                    <?php if ($flagged_count > 0): ?>
                    <div class="review_jump_section">
                        <h4>Flagged for Review (Click to Inspect):</h4>
                        <form action="<?php echo $_SERVER['SCRIPT_NAME']; ?>" method="post" enctype="multipart/form-data" class="review_jump_form">
                        <input type="hidden" name="testid" value="<?php echo $test_id; ?>" />
                        <input type="hidden" name="flagged_log_ids" value="<?php echo htmlspecialchars($flagged_log_ids_str); ?>" />
                        <?php echo F_getCSRFTokenField() . K_NEWLINE; ?>
                        <div class="review_chips_grid">
                        <?php foreach ($user_stats['questions'] as $qlog_id => $qitem): ?>
                            <?php if (in_array($qlog_id, $flagged_ids)): ?>
                            <button type="submit" name="jumpquestion_<?php echo $qlog_id; ?>" class="review_jump_chip chip_flagged" title="Jump to flagged question <?php echo $qitem['index']; ?>">&#9873; Question <?php echo $qitem['index']; ?></button>
                            <?php endif; ?>
                        <?php endforeach; ?>
                        </div>
                        </form>
                    </div>
                    <?php endif; ?>
                </div>

                <form action="<?php echo $_SERVER['SCRIPT_NAME']; ?>" method="post" enctype="multipart/form-data" id="form_test_terminate">
                <div>
                <input type="hidden" name="testid" id="testid" value="<?php echo $test_id; ?>" />
                <input type="hidden" name="testlogid" id="testlogid" value="<?php echo $testlog_id; ?>" />
                <input type="hidden" name="terminationform" id="terminationform" value="1" />
                <input type="hidden" name="display_time" id="display_time" value="" />
                <input type="hidden" name="reaction_time" id="reaction_time" value="" />
                <input type="hidden" name="flagged_log_ids" value="<?php echo htmlspecialchars($flagged_log_ids_str); ?>" />
                <?php
                F_submit_button('forceterminate', $l['w_terminate'], $l['w_terminate_exam']);
                F_submit_button('cancel', $l['w_cancel'], $l['h_cancel']);
                echo F_getCSRFTokenField() . K_NEWLINE;
                ?>
                </div>
                </form>
            </div>
<?php
        } else {
            echo '<form action="' . $_SERVER['SCRIPT_NAME'] . '" method="post" enctype="multipart/form-data" id="' . $formname . '"';
            echo ' onsubmit="var submittime=new Date();document.getElementById(\'reaction_time\').value=submittime.getTime()-document.getElementById(\'display_time\').value;"';
            echo '>' . K_NEWLINE;
            echo '<div>' . K_NEWLINE;

            // display questions + navigation menu
            echo F_questionForm($test_id, $testlog_id, $formname);
            // the $finish variable is used to check if the form has been automatically submitted
            // at the end of the time.
            $finish = isset($_REQUEST['finish']) && $_REQUEST['finish'] > 0 ? 1 : 0;

            echo '<input type="hidden" name="finish" id="finish" value="' . $finish . '" />' . K_NEWLINE;
            echo '<input type="hidden" name="display_time" id="display_time" value="" />' . K_NEWLINE;
            echo '<input type="hidden" name="reaction_time" id="reaction_time" value="" />' . K_NEWLINE;
            echo '<input type="hidden" name="flagged_log_ids" id="flagged_log_ids" value="' . htmlspecialchars($flagged_log_ids_str) . '" />' . K_NEWLINE;

            // textarea field for user's comment
            echo '<span class="testcomment">' . F_testComment($test_id) . '</span>' . K_NEWLINE;

            // test termination button
            F_submit_button('terminatetest', $l['w_terminate_exam'], $l['w_terminate_exam']);

            echo K_NEWLINE;
            echo '</div>' . K_NEWLINE;
            echo F_getCSRFTokenField() . K_NEWLINE;
            echo '</form>' . K_NEWLINE;

            // Pre-Submission Review Modal
            ?>
            <div id="review_modal_backdrop" class="review_modal_backdrop" style="display:none;">
                <div class="review_modal_dialog">
                    <div class="review_modal_header">
                        <h3 class="modal_title">Review Your Exam</h3>
                        <button type="button" class="btn_close_modal" onclick="FJ_close_review_modal();" title="Close review">&times;</button>
                    </div>
                    <div class="review_modal_body">
                        <p class="review_modal_intro">Review your answered questions, missed questions, and bookmarks before final submission.</p>
                        <div class="review_stats_grid">
                            <div class="review_stat_card card_answered">
                                <span class="stat_value" id="modal_stat_answered"><?php echo $answered_questions; ?></span>
                                <span class="stat_label">Answered</span>
                            </div>
                            <div class="review_stat_card card_unanswered">
                                <span class="stat_value" id="modal_stat_unanswered"><?php echo $unanswered_questions; ?></span>
                                <span class="stat_label">Unanswered</span>
                            </div>
                            <div class="review_stat_card card_flagged">
                                <span class="stat_value" id="modal_stat_flagged"><?php echo $flagged_count; ?></span>
                                <span class="stat_label">Flagged</span>
                            </div>
                        </div>

                        <?php if ($unanswered_questions > 0): ?>
                        <div class="review_jump_section">
                            <h4>Unanswered Questions (Click to Answer):</h4>
                            <div class="review_chips_grid">
                            <?php foreach ($user_stats['questions'] as $qlog_id => $qitem): ?>
                                <?php if (! $qitem['answered']): ?>
                                <button type="button" class="review_jump_chip chip_unanswered" onclick="FJ_modal_jump(<?php echo $qlog_id; ?>);">Question <?php echo $qitem['index']; ?></button>
                                <?php endif; ?>
                            <?php endforeach; ?>
                            </div>
                        </div>
                        <?php endif; ?>

                        <?php if ($flagged_count > 0): ?>
                        <div class="review_jump_section">
                            <h4>Flagged for Review (Click to Inspect):</h4>
                            <div class="review_chips_grid">
                            <?php foreach ($user_stats['questions'] as $qlog_id => $qitem): ?>
                                <?php if (in_array($qlog_id, $flagged_ids)): ?>
                                <button type="button" class="review_jump_chip chip_flagged" onclick="FJ_modal_jump(<?php echo $qlog_id; ?>);">&#9873; Question <?php echo $qitem['index']; ?></button>
                                <?php endif; ?>
                            <?php endforeach; ?>
                            </div>
                        </div>
                        <?php endif; ?>

                        <div class="review_modal_alert">
                            Are you ready to submit your exam? Once submitted, you cannot change your answers.
                        </div>
                    </div>
                    <div class="review_modal_footer">
                        <button type="button" class="btn_modal_cancel" onclick="FJ_close_review_modal();">&larr; Return to Exam</button>
                        <button type="button" class="btn_modal_submit" onclick="FJ_modal_confirm_submit();">Proceed to Submit &raquo;</button>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
            //<![CDATA[
            function FJ_toggle_flag(testId, testlogId) {
                testlogId = parseInt(testlogId, 10);
                var hiddenInput = document.getElementById('flagged_log_ids');
                var currentFlags = [];
                if (hiddenInput && hiddenInput.value) {
                    currentFlags = hiddenInput.value.split(',').map(function(id) { return parseInt(id, 10); }).filter(function(id) { return !isNaN(id) && id > 0; });
                }
                var idx = currentFlags.indexOf(testlogId);
                var isFlagged = false;
                if (idx >= 0) {
                    currentFlags.splice(idx, 1);
                    isFlagged = false;
                } else {
                    currentFlags.push(testlogId);
                    isFlagged = true;
                }
                var flagStr = currentFlags.join(',');
                if (hiddenInput) {
                    hiddenInput.value = flagStr;
                }
                try {
                    localStorage.setItem('tce_flags_' + testId, flagStr);
                } catch(e) {}

                var btn = document.getElementById('btn_toggle_flag');
                if (btn) {
                    if (isFlagged) {
                        btn.className = 'btn_flag is_flagged';
                        btn.innerHTML = '&#9873; <span id="flag_btn_text">Flagged</span>';
                    } else {
                        btn.className = 'btn_flag';
                        btn.innerHTML = '&#9872; <span id="flag_btn_text">Mark for Review</span>';
                    }
                }

                var chip = document.getElementById('jumpquestion_' + testlogId);
                if (chip) {
                    if (isFlagged) {
                        if (chip.className.indexOf('chip_flagged') === -1) {
                            chip.className += ' chip_flagged';
                        }
                        if (!chip.querySelector('.chip_flag_icon')) {
                            var flagSpan = document.createElement('span');
                            flagSpan.className = 'chip_flag_icon';
                            flagSpan.innerHTML = '&#9873;';
                            chip.appendChild(flagSpan);
                        }
                    } else {
                        chip.className = chip.className.replace(/\bchip_flagged\b/g, '').trim();
                        var flagSpan = chip.querySelector('.chip_flag_icon');
                        if (flagSpan) {
                            chip.removeChild(flagSpan);
                        }
                    }
                }

                var palFlagged = document.getElementById('pal_stat_flagged');
                if (palFlagged) {
                    palFlagged.textContent = currentFlags.length;
                }
                var modalFlagged = document.getElementById('modal_stat_flagged');
                if (modalFlagged) {
                    modalFlagged.textContent = currentFlags.length;
                }
            }

            function FJ_open_review_modal() {
                var modal = document.getElementById('review_modal_backdrop');
                if (modal) {
                    modal.style.display = 'flex';
                }
            }

            function FJ_close_review_modal() {
                var modal = document.getElementById('review_modal_backdrop');
                if (modal) {
                    modal.style.display = 'none';
                }
            }

            function FJ_modal_jump(testlogId) {
                var tf = document.getElementById('testform');
                if (!tf) return;
                var inp = document.createElement('input');
                inp.type = 'hidden';
                inp.name = 'jumpquestion_' + testlogId;
                inp.value = '1';
                tf.appendChild(inp);
                tf.submit();
            }

            function FJ_modal_confirm_submit() {
                var tf = document.getElementById('testform');
                if (!tf) return;
                var inp = document.createElement('input');
                inp.type = 'hidden';
                inp.name = 'forceterminate';
                inp.value = '1';
                tf.appendChild(inp);
                tf.submit();
            }

            (function(){
                var testId = <?php echo (int) $test_id; ?>;
                var inp = document.getElementById('flagged_log_ids');
                if (inp) {
                    try {
                        var local = localStorage.getItem('tce_flags_' + testId);
                        if (local !== null && (!inp.value || inp.value.trim() === '')) {
                            inp.value = local;
                        } else if (inp.value) {
                            localStorage.setItem('tce_flags_' + testId, inp.value);
                        }
                    } catch(e) {}
                }
                window.addEventListener('keydown', function(e) {
                    if (e.key === 'Escape' || e.keyCode === 27) {
                        FJ_close_review_modal();
                    }
                });
                window.addEventListener('click', function(e) {
                    var modal = document.getElementById('review_modal_backdrop');
                    if (e.target === modal) {
                        FJ_close_review_modal();
                    }
                });
            })();
            //]]>
            </script>
            <?php
        }

        // start the countdown or clock if disabled
        if (isset($examtime) && $examtime > 0) {
            $timeout_logout = isset($timeout_logout) && $timeout_logout ? 'true' : 'false';

            echo '<script type="text/javascript">' . K_NEWLINE;
            echo '//<![CDATA[' . K_NEWLINE;
            echo 'if(typeof enable_countdown === "undefined" || !enable_countdown) {' . K_NEWLINE;
            echo '	FJ_start_timer(true, ' . (time() - $examtime) . ", '" . addslashes($l['m_exam_end_time']) . "', " . $timeout_logout . ', ' . (round(microtime(true) * 1000)) . ');' . K_NEWLINE;
            echo '}' . K_NEWLINE;
            echo 'var loadtime=new Date();' . K_NEWLINE;
            echo "document.getElementById('display_time').value=loadtime.getTime();" . K_NEWLINE;
            echo '//]]>' . K_NEWLINE;
            echo '</script>' . K_NEWLINE;
        } elseif (isset($test_data) && $test_data['test_duration_time'] == 0) {
            echo '<script type="text/javascript">' . K_NEWLINE;
            echo '//<![CDATA[' . K_NEWLINE;
            echo 'if(typeof enable_countdown === "undefined" || !enable_countdown) {' . K_NEWLINE;
            echo '	FJ_start_timer(false, 0, "", false, ' . (round(microtime(true) * 1000)) . ');' . K_NEWLINE;
            echo '}' . K_NEWLINE;
            echo 'var loadtime=new Date();' . K_NEWLINE;
            echo "document.getElementById('display_time').value=loadtime.getTime();" . K_NEWLINE;
            echo '//]]>' . K_NEWLINE;
            echo '</script>' . K_NEWLINE;
        }
    } else {
        // check if user has already completed this test
        $user_id = (int) $_SESSION['session_user_id'];
        $sqltu = 'SELECT testuser_id, testuser_status FROM ' . K_TABLE_TEST_USER . '
            WHERE testuser_test_id=' . (int) $test_id . ' AND testuser_user_id=' . $user_id . '
            ORDER BY testuser_id DESC LIMIT 1';
        $redirect_target = 'index.php';
        if ($rtu = F_db_query($sqltu, $db)) {
            if ($mtu = F_db_fetch_array($rtu)) {
                if ((int) $mtu['testuser_status'] >= 4) {
                    $testdata = F_getTestData($test_id);
                    $redirect_target = F_getBoolean($testdata['test_results_to_users'])
                        ? ('tce_test_results.php?testid=' . (int) $test_id)
                        : ('tce_test_finished.php?testid=' . (int) $test_id);
                }
            }
        }
        header('Location: ' . $redirect_target);
        echo '<?xml version="1.0" encoding="' . $l['a_meta_charset'] . '"?' . '>' . K_NEWLINE;
        echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' . K_NEWLINE;
        echo '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="' . $l['a_meta_language'] . '" lang="' . $l['a_meta_language'] . '" dir="' . $l['a_meta_dir'] . '">' . K_NEWLINE;
        echo '<head>' . K_NEWLINE;
        echo '<title>REDIRECT</title>' . K_NEWLINE;
        echo '<meta http-equiv="refresh" content="0;url=' . htmlspecialchars($redirect_target, ENT_QUOTES, $l['a_meta_charset']) . '" />' . K_NEWLINE;
        echo '</head>' . K_NEWLINE;
        echo '<body>' . K_NEWLINE;
        echo '<a href="' . htmlspecialchars($redirect_target, ENT_QUOTES, $l['a_meta_charset']) . '">CONTINUE...</a>' . K_NEWLINE;
        echo '</body>' . K_NEWLINE;
        echo '</html>' . K_NEWLINE;
        exit;
    }
} else {
    require_once('../code/tce_page_header.php');
    echo '<div class="container">' . K_NEWLINE;
}

echo '<div class="pagehelp">' . $l['hp_test_execute'] . '</div>' . K_NEWLINE;

echo '</div>' . K_NEWLINE; // container

require_once('../code/tce_page_footer.php');

//============================================================+
// END OF FILE
//============================================================+
