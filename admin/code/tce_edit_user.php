<?php
//============================================================+
// File name   : tce_edit_user.php
// Begin       : 2002-02-08
// Last Update : 2023-11-30
//
// Description : Edit user data.
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
 * Display form to edit users.
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2002-02-08
 */



require_once('../config/tce_config.php');

$pageperm = K_PERM_MANAGE_IDENTITY;
require_once('../../shared/code/tce_authorization.php');
require_once('../../shared/config/tce_user_registration.php');

$thispage_title = $l['t_user_editor'];
$enable_calendar = true;
require_once('../code/tce_page_header.php');

require_once('../../shared/code/tce_functions_form.php');
require_once('../../shared/code/tce_functions_otp.php');
require_once('tce_functions_user_select.php');

$user_id = isset($_REQUEST['user_id']) ? (int) $_REQUEST['user_id'] : 0;
if ($user_id > 0 && ! F_isAuthorizedEditorForUser($user_id)) {
    F_print_error('ERROR', $l['m_authorization_denied'], true);
}

$group_id = isset($_REQUEST['group_id']) ? (int) $_REQUEST['group_id'] : 0;
if ($group_id > 0 && ! F_isAuthorizedEditorForGroup($group_id)) {
    F_print_error('ERROR', $l['m_authorization_denied'], true);
}

// a global viewer who does not administer the account or the group may only read it
$record_readonly = ($user_id > 0 && ! F_isAuthorizedToModifyUser($user_id))
    || ($group_id > 0 && ! F_isAuthorizedToModifyGroup($group_id));
if ($record_readonly) {
    $menu_mode = '';
}

if (isset($_REQUEST['user_groups'])) {
    $user_groups = $_REQUEST['user_groups'];
    if (! is_array($user_groups)) {
        $user_groups = [$user_groups];
    }
} else {
    $user_groups = [];
}

$user_name = isset($_REQUEST['user_name']) ? utrim($_REQUEST['user_name']) : '';
$user_email = isset($_REQUEST['user_email']) ? utrim($_REQUEST['user_email']) : '';
$user_password = isset($_REQUEST['user_password']) ? $_REQUEST['user_password'] : '';
$newpassword = isset($_REQUEST['newpassword']) ? $_REQUEST['newpassword'] : '';
$newpassword_repeat = isset($_REQUEST['newpassword_repeat']) ? $_REQUEST['newpassword_repeat'] : '';
$user_regnumber = isset($_REQUEST['user_regnumber']) ? utrim($_REQUEST['user_regnumber']) : '';
$user_firstname = isset($_REQUEST['user_firstname']) ? utrim($_REQUEST['user_firstname']) : '';
$user_lastname = isset($_REQUEST['user_lastname']) ? utrim($_REQUEST['user_lastname']) : '';
$user_birthdate = isset($_REQUEST['user_birthdate']) ? utrim($_REQUEST['user_birthdate']) : '';
$user_birthplace = isset($_REQUEST['user_birthplace']) ? utrim($_REQUEST['user_birthplace']) : '';
$user_ssn = isset($_REQUEST['user_ssn']) ? utrim($_REQUEST['user_ssn']) : '';
$user_otpkey = isset($_REQUEST['user_otpkey']) ? utrim($_REQUEST['user_otpkey']) : '';
$forcedelete = isset($_REQUEST['forcedelete']) ? $_REQUEST['forcedelete'] : '';
$user_ip = isset($_REQUEST['user_ip']) ? $_REQUEST['user_ip'] : getNormalizedIP($_SERVER['REMOTE_ADDR']);
$user_regdate = isset($_REQUEST['user_regdate']) ? $_REQUEST['user_regdate'] : date(K_TIMESTAMP_FORMAT);

if (isset($_REQUEST['user_level'])) {
    $user_level = (int) $_REQUEST['user_level'];
    if (! F_user_can(K_PERM_ADMIN)) {
        if ($user_id == $_SESSION['session_user_id']) {
            // you cannot change your own level
            $user_level = (int) $_SESSION['session_user_level'];
        } else {
            // you cannot create a user with a level equal or higher than yours
            $user_level = min(max(0, ((int) $_SESSION['session_user_level'] - 1)), $user_level);
        }
    }
} else {
    $user_level = 1;
}

// capability mask (tce_users.user_perms)
$user_perms_submitted = isset($_REQUEST['user_perms']);
$user_perms = 0;
if ($user_perms_submitted) {
    if (is_array($_REQUEST['user_perms'])) {
        foreach ($_REQUEST['user_perms'] as $perm_item) {
            $user_perms |= (int) $perm_item;
        }
    } else {
        $user_perms = (int) $_REQUEST['user_perms'];
    }

    $user_perms &= K_PERM_ALL;
    if (! F_user_can(K_PERM_ADMIN)) {
        if (isset($user_id) && $user_id == $_SESSION['session_user_id']) {
            // you cannot change your own capabilities
            $user_perms = F_user_perms();
        } else {
            // you may only grant the capabilities you hold yourself;
            // the capabilities you cannot grant stay as they are
            $current_perms = 0;
            if (! empty($user_id) && $user_id > 0) {
                $sqlp = 'SELECT user_perms FROM ' . K_TABLE_USERS . ' WHERE user_id=' . (int) $user_id . ' LIMIT 1';
                if ($rp = F_db_query($sqlp, $db)) {
                    if ($mp = F_db_fetch_array($rp)) {
                        $current_perms = (int) $mp['user_perms'];
                    }
                } else {
                    F_display_db_error();
                }
            }

            $user_perms = ($user_perms & F_user_perms()) | ($current_perms & ~ F_user_perms());
        }
    }
}

// comma separated list of required fields
$_REQUEST['ff_required'] = 'user_name';
$_REQUEST['ff_required_labels'] = htmlspecialchars($l['w_name'], ENT_COMPAT, $l['a_meta_charset']);

switch ($menu_mode) { // process submitted data
    case 'delete':{
         // ask confirmation
        if (! F_user_can(K_PERM_MANAGE_IDENTITY) || $user_id == $_SESSION['session_user_id'] || $user_id == 1) {
            F_print_error('ERROR', $l['m_authorization_denied']);
            break;
        }

        if (empty($user_name) && $user_id > 0) {
            $sql_u = 'SELECT user_name FROM ' . K_TABLE_USERS . ' WHERE user_id=' . $user_id . ' LIMIT 1';
            if ($r_u = F_db_query($sql_u, $db)) {
                if ($m_u = F_db_fetch_array($r_u)) {
                    $user_name = $m_u['user_name'];
                }
            }
        }

        F_print_error('WARNING', $l['m_delete_confirm']);
        ?>
        <div class="confirmbox">
        <form action="<?php echo $_SERVER['SCRIPT_NAME']; ?>" method="post" enctype="multipart/form-data" id="form_delete">
        <div>
        <input type="hidden" name="user_id" id="user_id" value="<?php echo $user_id; ?>" />
        <input type="hidden" name="user_name" id="user_name" value="<?php echo stripslashes($user_name); ?>" />
        <?php
        F_submit_button('forcedelete', $l['w_delete'], $l['h_delete']);
        F_submit_button('cancel', $l['w_cancel'], $l['h_cancel']);
        echo F_getCSRFTokenField() . K_NEWLINE;
        ?>
        </div>
        </form>
        </div>
        <?php
        break;
    }

    case 'forcedelete':{
         // Delete specified user
        if (! F_user_can(K_PERM_MANAGE_IDENTITY) || $user_id == $_SESSION['session_user_id'] || $user_id == 1) {
            F_print_error('ERROR', $l['m_authorization_denied']);
            break;
        }

        if ($forcedelete == $l['w_delete'] || isset($_POST['forcedelete'])) { //check if delete button has been pushed
            if ($user_id == 1) { //can't delete anonymous user
                F_print_error('WARNING', $l['m_delete_anonymous']);
            } else {
                $sql = 'DELETE FROM ' . K_TABLE_USERS . ' WHERE user_id=' . $user_id . '';
                if (! $r = F_db_query($sql, $db)) {
                    F_display_db_error(false);
                } else {
                    $user_id = false;
                    F_print_error('MESSAGE', '[' . stripslashes($user_name) . '] ' . $l['m_user_deleted']);
                }
            }
        }

        break;
    }

    case 'update':{ // Update user
        // check if the confirmation chekbox has been selected
        if (! isset($_REQUEST['confirmupdate']) || $_REQUEST['confirmupdate'] != 1) {
            F_print_error('WARNING', $l['m_form_missing_fields'] . ': ' . $l['w_confirm'] . ' &rarr; ' . $l['w_update']);
            
            break;
        }

        if ($formstatus = F_check_form_fields()) {
            // check if name is unique
            if (! F_check_unique(K_TABLE_USERS, "user_name='" . F_escape_sql($db, $user_name) . "'", 'user_id', $user_id)) {
                F_print_error('WARNING', $l['m_duplicate_name']);
                $formstatus = false;
                
                break;
            }

            // check if registration number is unique
            if (isset($user_regnumber) && strlen($user_regnumber) > 0 && ! F_check_unique(K_TABLE_USERS, "user_regnumber='" . F_escape_sql($db, $user_regnumber) . "'", 'user_id', $user_id)) {
                F_print_error('WARNING', $l['m_duplicate_regnumber']);
                $formstatus = false;
                
                break;
            }

            // check if ssn is unique
            if (isset($user_ssn) && strlen($user_ssn) > 0 && ! F_check_unique(K_TABLE_USERS, "user_ssn='" . F_escape_sql($db, $user_ssn) . "'", 'user_id', $user_id)) {
                F_print_error('WARNING', $l['m_duplicate_ssn']);
                $formstatus = false;
                
                break;
            }

            // check password
            if (! empty($newpassword) || ! empty($newpassword_repeat)) {
                if ($newpassword == $newpassword_repeat) {
                    $user_password = getPasswordHash($newpassword);
                    // update OTP key
                    $user_otpkey = F_getRandomOTPkey();
                } else { //print message and exit
                    F_print_error('WARNING', $l['m_different_passwords']);
                    $formstatus = false;
                    
                    break;
                }
            }

            if (! $user_perms_submitted && $user_id > 0) {
                // the submitted form did not carry the capability checkboxes: keep the current mask
                $sqlp = 'SELECT user_perms FROM ' . K_TABLE_USERS . ' WHERE user_id=' . (int) $user_id . ' LIMIT 1';
                if ($rp = F_db_query($sqlp, $db)) {
                    if ($mp = F_db_fetch_array($rp)) {
                        $user_perms = (int) $mp['user_perms'];
                    }
                } else {
                    F_display_db_error();
                }
            }

            $sql = 'UPDATE ' . K_TABLE_USERS . ' SET
				user_regdate=\'' . F_escape_sql($db, $user_regdate) . '\',
				user_ip=\'' . F_escape_sql($db, $user_ip) . '\',
				user_name=\'' . F_escape_sql($db, $user_name) . '\',
				user_email=' . F_empty_to_null($user_email) . ',
				user_password=\'' . F_escape_sql($db, $user_password) . '\',
				user_regnumber=' . F_empty_to_null($user_regnumber) . ',
				user_firstname=' . F_empty_to_null($user_firstname) . ',
				user_lastname=' . F_empty_to_null($user_lastname) . ',
				user_birthdate=' . F_empty_to_null($user_birthdate) . ',
				user_birthplace=' . F_empty_to_null($user_birthplace) . ',
				user_ssn=' . F_empty_to_null($user_ssn) . ',
				user_level=\'' . $user_level . '\',
				user_perms=\'' . (int) $user_perms . '\',
				user_otpkey=' . F_empty_to_null($user_otpkey) . '
				WHERE user_id=' . $user_id . '';
            if (! $r = F_db_query($sql, $db)) {
                F_display_db_error(false);
            } else {
                F_print_error('MESSAGE', stripslashes($user_name) . ': ' . $l['m_user_updated']);
            }

            // remove old groups
            $old_user_groups = F_get_user_groups($user_id);
            foreach ($old_user_groups as $group_id) {
                if (F_isAuthorizedToModifyGroup($group_id)) {
                    // delete previous groups
                    $sql = 'DELETE FROM ' . K_TABLE_USERGROUP . '
						WHERE usrgrp_user_id=' . $user_id . ' AND usrgrp_group_id=' . $group_id . '';
                    if (! $r = F_db_query($sql, $db)) {
                        F_display_db_error(false);
                    }
                }
            }

            // update user's groups
            if (! empty($user_groups)) {
                foreach ($user_groups as $group_id) {
                    if (F_isAuthorizedToModifyGroup($group_id)) {
                        $sql = 'INSERT INTO ' . K_TABLE_USERGROUP . ' (
							usrgrp_user_id,
							usrgrp_group_id
							) VALUES (
							\'' . $user_id . '\',
							\'' . $group_id . '\'
							)';
                        if (! $r = F_db_query($sql, $db)) {
                            F_display_db_error(false);
                        }
                    }
                }
            }
        }

        break;
    }

    case 'add':{ // Add user
        if (! $user_perms_submitted) {
            $user_perms = F_cumulative_perms_for_level($user_level);
            if (! F_user_can(K_PERM_ADMIN)) {
                $user_perms &= F_user_perms();
            }
        }
        if ($formstatus = F_check_form_fields()) { // check submittef form fields
            // check if name is unique
            if (! F_check_unique(K_TABLE_USERS, "user_name='" . F_escape_sql($db, $user_name) . "'")) {
                F_print_error('WARNING', $l['m_duplicate_name']);
                $formstatus = false;
                
                break;
            }

            // check if registration number is unique
            if (isset($user_regnumber) && strlen($user_regnumber) > 0 && ! F_check_unique(K_TABLE_USERS, "user_regnumber='" . F_escape_sql($db, $user_regnumber) . "'")) {
                F_print_error('WARNING', $l['m_duplicate_regnumber']);
                $formstatus = false;
                
                break;
            }

            // check if ssn is unique
            if (isset($user_ssn) && strlen($user_ssn) > 0 && ! F_check_unique(K_TABLE_USERS, "user_ssn='" . F_escape_sql($db, $user_ssn) . "'")) {
                F_print_error('WARNING', $l['m_duplicate_ssn']);
                $formstatus = false;
                
                break;
            }

            // check password
            if (! empty($newpassword) || ! empty($newpassword_repeat)) { // update password
                if ($newpassword == $newpassword_repeat) {
                    $user_password = getPasswordHash($newpassword);
                    // update OTP key
                    $user_otpkey = F_getRandomOTPkey();
                } else { //print message and exit
                    F_print_error('WARNING', $l['m_different_passwords']);
                    $formstatus = false;
                    
                    break;
                }
            } else { //print message and exit
                F_print_error('WARNING', $l['m_empty_password']);
                $formstatus = false;
                
                break;
            }

            $user_ip = getNormalizedIP($_SERVER['REMOTE_ADDR']); // get the user's IP number
            $user_regdate = date(K_TIMESTAMP_FORMAT); // get the registration date and time

            $sql = 'INSERT INTO ' . K_TABLE_USERS . ' (
				user_regdate,
				user_ip,
				user_name,
				user_email,
				user_password,
				user_regnumber,
				user_firstname,
				user_lastname,
				user_birthdate,
				user_birthplace,
				user_ssn,
				user_level,
				user_perms,
				user_otpkey
				) VALUES (
				\'' . F_escape_sql($db, $user_regdate) . '\',
				\'' . F_escape_sql($db, $user_ip) . '\',
				\'' . F_escape_sql($db, $user_name) . '\',
				' . F_empty_to_null($user_email) . ',
				\'' . F_escape_sql($db, $user_password) . '\',
				' . F_empty_to_null($user_regnumber) . ',
				' . F_empty_to_null($user_firstname) . ',
				' . F_empty_to_null($user_lastname) . ',
				' . F_empty_to_null($user_birthdate) . ',
				' . F_empty_to_null($user_birthplace) . ',
				' . F_empty_to_null($user_ssn) . ',
				\'' . $user_level . '\',
				\'' . (int) $user_perms . '\',
				' . F_empty_to_null($user_otpkey) . '
				)';
            if (! $r = F_db_query($sql, $db)) {
                F_display_db_error(false);
            } else {
                $user_id = F_db_insert_id($db, K_TABLE_USERS, 'user_id');
            }

            // add user's groups
            if (! empty($user_groups)) {
                foreach ($user_groups as $group_id) {
                    if (F_isAuthorizedToModifyGroup($group_id)) {
                        $sql = 'INSERT INTO ' . K_TABLE_USERGROUP . ' (
							usrgrp_user_id,
							usrgrp_group_id
							) VALUES (
							\'' . $user_id . '\',
							\'' . $group_id . '\'
							)';
                        if (! $r = F_db_query($sql, $db)) {
                            F_display_db_error(false);
                        }
                    }
                }
            }
        }

        break;
    }

    case 'clear':{ // Clear form fields
        $user_regdate = '';
        $user_ip = '';
        $user_name = '';
        $user_email = '';
        $user_password = '';
        $user_regnumber = '';
        $user_firstname = '';
        $user_lastname = '';
        $user_birthdate = '';
        $user_birthplace = '';
        $user_ssn = '';
        $user_level = '';
        $user_perms = 0;
        $user_otpkey = '';
        break;
    }

    default:{
        break;
    }
} //end of switch

// --- Initialize variables
if ($formstatus && $menu_mode != 'clear') {
    if (! isset($user_id) || empty($user_id)) {
        $user_id = 0;
        $user_regdate = '';
        $user_ip = '';
        $user_name = '';
        $user_email = '';
        $user_password = '';
        $user_regnumber = '';
        $user_firstname = '';
        $user_lastname = '';
        $user_birthdate = '';
        $user_birthplace = '';
        $user_ssn = '';
        $user_level = '';
        $user_perms = 0;
        $user_otpkey = '';
    } else {
        $sql = 'SELECT * FROM ' . K_TABLE_USERS . ' WHERE user_id=' . $user_id . ' LIMIT 1';
        if ($r = F_db_query($sql, $db)) {
            if ($m = F_db_fetch_array($r)) {
                $user_id = $m['user_id'] ?? '';
                $user_regdate = $m['user_regdate'] ?? '';
                $user_ip = $m['user_ip'] ?? '';
                $user_name = $m['user_name'] ?? '';
                $user_email = $m['user_email'] ?? '';
                $user_password = $m['user_password'] ?? '';
                $user_regnumber = $m['user_regnumber'] ?? '';
                $user_firstname = $m['user_firstname'] ?? '';
                $user_lastname = $m['user_lastname'] ?? '';
                $user_birthdate = substr($m['user_birthdate'] ?? '', 0, 10);
                $user_birthplace = $m['user_birthplace'] ?? '';
                $user_ssn = $m['user_ssn'] ?? '';
                $user_level = $m['user_level'] ?? '';
                $user_perms = (int) ($m['user_perms'] ?? 0);
                $user_otpkey = $m['user_otpkey'] ?? '';
            } else {
                $user_regdate = '';
                $user_ip = '';
                $user_name = '';
                $user_email = '';
                $user_password = '';
                $user_regnumber = '';
                $user_firstname = '';
                $user_lastname = '';
                $user_birthdate = '';
                $user_birthplace = '';
                $user_ssn = '';
                $user_level = '';
                $user_perms = 0;
                $user_otpkey = '';
            }
        } else {
            F_display_db_error();
        }
    }
}

echo '<div class="container">' . K_NEWLINE;

echo '<div class="tceformbox">' . K_NEWLINE;
echo '<form action="' . $_SERVER['SCRIPT_NAME'] . '" method="post" enctype="multipart/form-data" id="form_usereditor">' . K_NEWLINE;

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="user_id">' . $l['w_user'] . '</label>' . K_NEWLINE;
echo '</span>' . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<select name="user_id" id="user_id" size="0" onchange="document.getElementById(\'form_usereditor\').submit()">' . K_NEWLINE;
echo '<option value="0" style="background-color:#009900;color:white;"';
if ($user_id == 0) {
    echo ' selected="selected"';
}

echo '>+</option>' . K_NEWLINE;
$sql = 'SELECT user_id, user_lastname, user_firstname, user_name FROM ' . K_TABLE_USERS . ' WHERE (user_id>1)';
if (! F_has_global_view() && ! F_user_can(K_PERM_MANAGE_IDENTITY)) {
    // filter for level
    $sql .= ' AND ((user_level<' . $_SESSION['session_user_level'] . ') OR (user_id=' . $_SESSION['session_user_id'] . '))';
    // filter for groups
    $sql .= ' AND user_id IN (SELECT tb.usrgrp_user_id
		FROM ' . K_TABLE_USERGROUP . ' AS ta, ' . K_TABLE_USERGROUP . ' AS tb
		WHERE ta.usrgrp_group_id=tb.usrgrp_group_id
			AND ta.usrgrp_user_id=' . (int) $_SESSION['session_user_id'] . '
			AND tb.usrgrp_user_id=user_id)';
} elseif (! F_user_can(K_PERM_ADMIN)) {
    $sql .= ' AND ((user_level<' . $_SESSION['session_user_level'] . ') OR (user_id=' . $_SESSION['session_user_id'] . '))';
}

$sql .= ' ORDER BY user_lastname, user_firstname, user_name';
if ($r = F_db_query($sql, $db)) {
    $countitem = 1;
    while ($m = F_db_fetch_array($r)) {
        echo '<option value="' . $m['user_id'] . '"';
        if ($m['user_id'] == $user_id) {
            echo ' selected="selected"';
        }

        echo '>' . $countitem . '. ' . htmlspecialchars($m['user_lastname'] . ' ' . $m['user_firstname'] . ' - ' . $m['user_name'] . '', ENT_NOQUOTES, $l['a_meta_charset']) . '</option>' . K_NEWLINE;
        ++$countitem;
    }
} else {
    echo '</select></span></div>' . K_NEWLINE;
    F_display_db_error();
}

echo '</select>' . K_NEWLINE;

// link for user selection popup
$jsaction = "selectWindow=window.open('tce_select_users_popup.php?cid=user_id', 'selectWindow', 'dependent, height=600, width=800, menubar=no, resizable=yes, scrollbars=yes, status=no, toolbar=no');return false;";
echo '<a href="#" onclick="' . $jsaction . '" class="xmlbutton" title="' . $l['w_select'] . '">...</a>';

echo '</span>' . K_NEWLINE;
echo '</div>' . K_NEWLINE;

echo getFormNoscriptSelect('selectrecord');

echo '<div class="row"><hr /></div>' . K_NEWLINE;

echo getFormRowTextInput('user_name', $l['w_username'], $l['h_login_name'], '', $user_name, '', 255, false, false, false);
echo getFormRowTextInput('user_email', $l['w_email'], $l['h_usered_email'], '', $user_email, K_EMAIL_RE_PATTERN, 255, false, false, false);
echo getFormRowTextInput('newpassword', $l['w_password'], $l['h_password'], ' (' . $l['d_password_length'] . ')', '', K_USRREG_PASSWORD_RE, 255, false, false, true);
echo getFormRowTextInput('newpassword_repeat', $l['w_password'], $l['h_password_repeat'], ' (' . $l['w_repeat'] . ')', '', '', 255, false, false, true);
echo getFormRowFixedValue('user_regdate', $l['w_regdate'], $l['h_regdate'], '', $user_regdate);
// map each grantable level to a "number - role name" label
$grantable_levels = range(0, K_AUTH_ADMINISTRATOR);
if (! F_user_can(K_PERM_ADMIN)) {
    // a non-administrator cannot grant a level equal to or higher than its own
    $grantable_levels = range(0, max(0, (int) $_SESSION['session_user_level'] - 1));
    if (isset($user_id) && $user_id == $_SESSION['session_user_id']) {
        // keep the user's own level selectable when editing the own account
        $grantable_levels[] = (int) $_SESSION['session_user_level'];
        sort($grantable_levels);
    }
}

$user_level_items = [];
foreach ($grantable_levels as $level_item) {
    $user_level_items[$level_item] = htmlspecialchars(F_getUserLevelLabel($level_item, true), ENT_NOQUOTES, $l['a_meta_charset']);
}

echo getFormRowSelectBox('user_level', $l['w_level'], $l['h_level'], '', $user_level, $user_level_items);

// capability checkboxes: a full administrator may grant every capability,
// while any other editor may only grant the capabilities it holds itself
$cap_title = (isset($l['w_capabilities']) && $l['w_capabilities'] !== '') ? $l['w_capabilities'] : 'capabilities';
$cap_header = htmlspecialchars($cap_title, ENT_NOQUOTES, $l['a_meta_charset']);
$cap_header .= ' <span style="font-size:80%;font-weight:normal;">(<a href="#" id="btn_apply_level_preset" title="' . htmlspecialchars($l['h_level'] ?? 'Apply standard preset for this level', ENT_COMPAT, $l['a_meta_charset']) . '" style="text-decoration:underline;">apply level preset</a>)</span>';
echo getFormRowVertDiv($cap_header);
foreach (F_getCapabilityNames() as $cap_mask => [$cap_key, $cap_label]) {
    $cap_name = (isset($l[$cap_key]) && $l[$cap_key] !== '') ? $l[$cap_key] : $cap_label;
    $cap_desc = F_getCapabilityDescription($cap_mask);
    $cap_checked = (($user_perms & $cap_mask) !== 0);
    $cap_disabled = (! F_user_can(K_PERM_ADMIN) && ! F_user_can_any($cap_mask));
    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label"><label for="user_perms_' . $cap_mask . '" title="' . htmlspecialchars($cap_desc, ENT_COMPAT, $l['a_meta_charset']) . '">' . htmlspecialchars($cap_name, ENT_COMPAT, $l['a_meta_charset']) . '</label></span>' . K_NEWLINE;
    echo '<span class="formw">' . K_NEWLINE;
    echo '<input type="checkbox" name="user_perms[]" id="user_perms_' . $cap_mask . '" value="' . $cap_mask . '" title="' . htmlspecialchars($cap_desc, ENT_COMPAT, $l['a_meta_charset']) . '"';
    if ($cap_checked) {
        echo ' checked="checked"';
    }

    if ($cap_disabled) {
        // the server preserves the capabilities this editor cannot grant,
        // and "disabled" makes the lock visible and real in the browser
        echo ' disabled="disabled" class="disabled"';
    }

    echo ' />';
    if (! empty($cap_desc)) {
        echo ' <span class="labeldesc">' . htmlspecialchars($cap_desc, ENT_NOQUOTES, $l['a_meta_charset']) . '</span>';
    }
    echo K_NEWLINE;
    echo '</span>' . K_NEWLINE;
    echo '</div>' . K_NEWLINE;
}

echo getFormRowTextInput('user_firstname', $l['w_firstname'], $l['h_firstname'], '', $user_firstname, '', 255, false, false, false);
echo getFormRowTextInput('user_lastname', $l['w_lastname'], $l['h_lastname'], '', $user_lastname, '', 255, false, false, false);
echo '<div style="display:none;">';
echo getFormRowFixedValue('user_ip', $l['w_ip'], $l['h_ip'], '', $user_ip);
echo getFormRowTextInput('user_regnumber', $l['w_regcode'], $l['h_regcode'], '', $user_regnumber, '', 255, false, false, false);
echo getFormRowTextInput('user_birthdate', $l['w_birth_date'], $l['h_birth_date'] . ' ' . $l['w_date_format'], '', $user_birthdate, '', 10, true, false, false);
echo getFormRowTextInput('user_birthplace', $l['w_birth_place'], $l['h_birth_place'], '', $user_birthplace, '', 255, false, false, false);
echo getFormRowTextInput('user_ssn', $l['w_fiscal_code'], $l['h_fiscal_code'], '', $user_ssn, '', 255, false, false, false);
echo '</div>';

echo '<div class="row">' . K_NEWLINE;
echo '<span class="label">' . K_NEWLINE;
echo '<label for="user_groups">' . $l['w_groups'] . '</label>' . K_NEWLINE;
echo '</span>' . K_NEWLINE;
echo '<span class="formw">' . K_NEWLINE;
echo '<select name="user_groups[]" id="user_groups" size="5" multiple="multiple">' . K_NEWLINE;
$sql = 'SELECT * FROM ' . K_TABLE_GROUPS . ' ORDER BY group_name';
if ($r = F_db_query($sql, $db)) {
    while ($m = F_db_fetch_array($r)) {
        echo '<option value="' . $m['group_id'] . '"';
        if (! F_isAuthorizedEditorForGroup($m['group_id'])) {
            echo ' style="text-decoration:line-through;"';
        }

        if (F_isUserOnGroup($user_id, $m['group_id'])) {
            echo ' selected="selected"';
            $m['group_name'] = '* ' . $m['group_name'];
        }

        echo '>' . htmlspecialchars($m['group_name'], ENT_NOQUOTES, $l['a_meta_charset']) . '</option>' . K_NEWLINE;
    }
} else {
    echo '</select></span></div>' . K_NEWLINE;
    F_display_db_error();
}

echo '</select>' . K_NEWLINE;
echo '</span>' . K_NEWLINE;
echo '</div>' . K_NEWLINE;

echo '<div style="display:none;">';

echo getFormRowTextInput('user_otpkey', $l['w_otpkey'], $l['h_otpkey'], '', $user_otpkey, '', 255, false, false, false);

// display QR-Code for Google authenticator
if (! empty($user_otpkey)) {
    require_once('../../shared/tcpdf/tcpdf_barcodes_2d.php');
    $host = preg_replace('/[h][t][t][p][s]?[:][\/][\/]/', '', K_PATH_HOST);
    $qrcode = new TCPDF2DBarcode('otpauth://totp/' . $user_name . '@' . $host . '?secret=' . $user_otpkey, 'QRCODE,H');
    echo '<div class="row">' . K_NEWLINE;
    echo '<span class="label">' . $l['w_otp_qrcode'] . '</span>' . K_NEWLINE;
    echo '<span class="formw" style="margin:30px 0px 30px 0px;">' . K_NEWLINE;
    echo $qrcode->getBarcodeHTML(6, 6, 'black');
    echo '</span>' . K_NEWLINE;
    echo '</div>' . K_NEWLINE;
} 
echo '</div>';

echo '<div class="row">' . K_NEWLINE;
// show buttons by case
if ($record_readonly) {
    // read-only access: no modification buttons
} elseif (isset($user_id) && $user_id > 0) {
    if ($user_level < $_SESSION['session_user_level'] || $user_id == $_SESSION['session_user_id'] || F_user_can(K_PERM_ADMIN)) {
        echo '<span style="background-color:#999999;">';
        echo '<input type="checkbox" name="confirmupdate" id="confirmupdate" value="1" title="confirm &rarr; update" />';
        F_submit_button('update', $l['w_update'], $l['h_update']);
        echo '</span>';
    }

    if ($user_id > 1 && F_user_can(K_PERM_MANAGE_IDENTITY) && $user_id != $_SESSION['session_user_id']) {
        // your account and anonymous user can't be deleted
        F_submit_button('delete', $l['w_delete'], $l['h_delete']);
    }
} else {
    F_submit_button('add', $l['w_add'], $l['h_add']);
}

if (!$record_readonly) {
    F_submit_button('clear', $l['w_clear'], $l['h_clear']);
}

echo '<input type="hidden" name="user_password" id="user_password" value="' . $user_password . '" />' . K_NEWLINE;
echo '</div>' . K_NEWLINE;
echo F_getCSRFTokenField() . K_NEWLINE;
echo '</form>' . K_NEWLINE;
echo '</div>' . K_NEWLINE;

echo '<div class="pagehelp">' . $l['hp_edit_user'] . '</div>' . K_NEWLINE;
echo '</div>' . K_NEWLINE;

$level_perms_map = [];
for ($lvl = 0; $lvl <= 10; ++$lvl) {
    $level_perms_map[$lvl] = F_cumulative_perms_for_level($lvl);
}

echo '<script type="text/javascript">' . K_NEWLINE;
echo '//<![CDATA[' . K_NEWLINE;
echo 'var levelPermsMap = ' . json_encode($level_perms_map) . ';' . K_NEWLINE;
echo 'function FJ_sync_level_capabilities() {' . K_NEWLINE;
echo '    var lvlSelect = document.getElementById("user_level");' . K_NEWLINE;
echo '    if (!lvlSelect) { return; }' . K_NEWLINE;
echo '    var selectedLevel = parseInt(lvlSelect.value, 10);' . K_NEWLINE;
echo '    var targetMask = (levelPermsMap[selectedLevel] !== undefined) ? levelPermsMap[selectedLevel] : 0;' . K_NEWLINE;
echo '    var capCheckboxes = document.querySelectorAll("input[name=\'user_perms[]\']");' . K_NEWLINE;
echo '    for (var i = 0; i < capCheckboxes.length; i++) {' . K_NEWLINE;
echo '        var cb = capCheckboxes[i];' . K_NEWLINE;
echo '        if (!cb.disabled) {' . K_NEWLINE;
echo '            var mask = parseInt(cb.value, 10);' . K_NEWLINE;
echo '            cb.checked = ((targetMask & mask) !== 0);' . K_NEWLINE;
echo '        }' . K_NEWLINE;
echo '    }' . K_NEWLINE;
echo '}' . K_NEWLINE;
echo 'document.addEventListener("DOMContentLoaded", function() {' . K_NEWLINE;
echo '    if (document.getElementById("user_groups")) { new SlimSelect({ select: "#user_groups", placeholder: "' . $l["w_groups"] . '", search: true, selectAllText: "Select All", deselectLabel: "Deselect" }); }' . K_NEWLINE;
echo '    var lvlSelect = document.getElementById("user_level");' . K_NEWLINE;
echo '    if (lvlSelect) {' . K_NEWLINE;
echo '        lvlSelect.addEventListener("change", FJ_sync_level_capabilities);' . K_NEWLINE;
echo '    }' . K_NEWLINE;
echo '    var btnPreset = document.getElementById("btn_apply_level_preset");' . K_NEWLINE;
echo '    if (btnPreset) {' . K_NEWLINE;
echo '        btnPreset.addEventListener("click", function(e) {' . K_NEWLINE;
echo '            e.preventDefault();' . K_NEWLINE;
echo '            FJ_sync_level_capabilities();' . K_NEWLINE;
echo '        });' . K_NEWLINE;
echo '    }' . K_NEWLINE;
echo '});' . K_NEWLINE;
echo '//]]>' . K_NEWLINE;
echo '</script>' . K_NEWLINE;

require_once('../code/tce_page_footer.php');

//============================================================+
// END OF FILE
//============================================================+
