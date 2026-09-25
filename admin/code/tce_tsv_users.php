<?php

//============================================================+
// File name   : tce_tsv_users.php
// Begin       : 2006-03-30
// Last Update : 2023-11-30
//
// Description : Functions to export users using TSV format.
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
 * Display all users in TSV format.
 * (Tab Delimited Text File)
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2006-03-30
 */



// check user's authorization
require_once('../config/tce_config.php');
$pageperm = K_PERM_MANAGE_IDENTITY;
require_once('../../shared/code/tce_authorization.php');

// check if CSV format is requested
$csv_mode = K_ENABLE_CSV_CONVERSION && isset($_REQUEST['format']) && $_REQUEST['format'] === 'csv';
$ext = $csv_mode ? 'csv' : 'tsv';

// send headers
header('Content-Description: TXT File Transfer');
header('Cache-Control: public, must-revalidate, max-age=0'); // HTTP/1.1
header('Pragma: public');
header('Expires: Sat, 26 Jul 1997 05:00:00 GMT'); // Date in the past
header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT');
// force download dialog
header('Content-Type: application/force-download');
header('Content-Type: application/octet-stream', false);
header('Content-Type: application/download', false);
if ($csv_mode) {
    header('Content-Type: text/csv', false);
} else {
    header('Content-Type: text/tab-separated-values', false);
}
// use the Content-Disposition header to supply a recommended filename
header('Content-Disposition: attachment; filename=tcexam_users_' . date('YmdHis') . '.' . $ext . ';');
header('Content-Transfer-Encoding: binary');

$data = F_tsv_export_users();
if ($csv_mode) {
    $data = F_tsv_to_csv($data);
}
echo $data;

/**
 * Export all users to TSV grouped by users' groups.
 * @author Nicola Asuni
 * @since 2006-03-30
 * @return TSV data
 */
function F_tsv_export_users()
{
    global $l, $db;
    require_once('../config/tce_config.php');

    $tsv = ''; // TSV data to be returned

    // print column names
    $tsv .= 'user_id';
    $tsv .= K_TAB . 'user_name';
    $tsv .= K_TAB . 'user_password';
    $tsv .= K_TAB . 'user_email';
    $tsv .= K_TAB . 'user_regdate';
    $tsv .= K_TAB . 'user_ip';
    $tsv .= K_TAB . 'user_firstname';
    $tsv .= K_TAB . 'user_lastname';
    $tsv .= K_TAB . 'user_birthdate';
    $tsv .= K_TAB . 'user_birthplace';
    $tsv .= K_TAB . 'user_regnumber';
    $tsv .= K_TAB . 'user_ssn';
    $tsv .= K_TAB . 'user_level';
    $tsv .= K_TAB . 'user_verifycode';
    $tsv .= K_TAB . 'user_otpkey';
    $tsv .= K_TAB . 'user_groups';

    $sql = 'SELECT * FROM ' . K_TABLE_USERS . ' WHERE (user_id>1)';
    if (! F_has_global_view()) {
        // filter for level
        $sql .= ' AND ((user_level<' . $_SESSION['session_user_level'] . ') OR (user_id=' . $_SESSION['session_user_id'] . '))';
        // filter for groups
        $sql .= ' AND user_id IN (SELECT tb.usrgrp_user_id
			FROM ' . K_TABLE_USERGROUP . ' AS ta, ' . K_TABLE_USERGROUP . ' AS tb
			WHERE ta.usrgrp_group_id=tb.usrgrp_group_id
				AND ta.usrgrp_user_id=' . (int) $_SESSION['session_user_id'] . '
				AND tb.usrgrp_user_id=user_id)';
    }

    $sql .= ' ORDER BY user_lastname,user_firstname,user_name';
    if ($r = F_db_query($sql, $db)) {
        while ($m = F_db_fetch_array($r)) {
            $tsv .= K_NEWLINE . $m['user_id'];
            $tsv .= K_TAB . $m['user_name'];
            $tsv .= K_TAB; // password cannot be exported because is encrypted
            $tsv .= K_TAB . $m['user_email'];
            $tsv .= K_TAB . $m['user_regdate'];
            $tsv .= K_TAB . $m['user_ip'];
            $tsv .= K_TAB . $m['user_firstname'];
            $tsv .= K_TAB . $m['user_lastname'];
            $tsv .= K_TAB . substr($m['user_birthdate'] ?? '', 0, 10);
            $tsv .= K_TAB . $m['user_birthplace'];
            $tsv .= K_TAB . $m['user_regnumber'];
            $tsv .= K_TAB . $m['user_ssn'];
            $tsv .= K_TAB . $m['user_level'];
            $tsv .= K_TAB . $m['user_verifycode'];
            $tsv .= K_TAB . $m['user_otpkey'];
            $tsv .= K_TAB;
            $grp = '';
            // comma separated list of user's groups
            $sqlg = 'SELECT *
				FROM ' . K_TABLE_GROUPS . ', ' . K_TABLE_USERGROUP . '
				WHERE usrgrp_group_id=group_id
					AND usrgrp_user_id=' . $m['user_id'] . '
				ORDER BY group_name';
            if ($rg = F_db_query($sqlg, $db)) {
                while ($mg = F_db_fetch_array($rg)) {
                    $grp .= $mg['group_name'] . ',';
                }
            } else {
                F_display_db_error();
            }

            if ($grp !== '') {
                // add user's groups removing last comma
                $tsv .= substr($grp, 0, -1);
            }
        }
    } else {
        F_display_db_error();
    }

    return $tsv;
}

//============================================================+
// END OF FILE
//============================================================+
