<?php

//============================================================+
// File name   : tce_show_online_users.php
// Begin       : 2001-10-18
// Last Update : 2023-11-30
//
// Description : Display online user's data.
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
 * Display online user's data.
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2001-10-18
 */



require_once('../config/tce_config.php');

$pageperm = K_PERM_OPERATOR;
require_once('../../shared/code/tce_authorization.php');

$thispage_title = $l['t_online_users'];

require_once('../code/tce_page_header.php');
require_once('tce_functions_users_online.php');

// set default values
$order_field = isset($_REQUEST['order_field']) ? $_REQUEST['order_field'] : 'cpsession_expiry';
$orderdir = isset($_REQUEST['orderdir']) ? (int) $_REQUEST['orderdir'] : 0;
$firstrow = isset($_REQUEST['firstrow']) ? (int) $_REQUEST['firstrow'] : 0;
$rowsperpage = isset($_REQUEST['rowsperpage']) ? (int) $_REQUEST['rowsperpage'] : K_MAX_ROWS_PER_PAGE;

F_show_online_users('', $order_field, $orderdir, $firstrow, $rowsperpage);

require_once('../code/tce_page_footer.php');

//============================================================+
// END OF FILE
//============================================================+
