<?php

//============================================================+
// File name   : tce_page_header.php
// Begin       : 2001-09-18
// Last Update : 2023-11-30
//
// Description : Outputs default XHTML page header.
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
 * Outputs default XHTML page header.
 * @package com.tecnick.tcexam.public
 * @author Nicola Asuni
 * @since 2001-09-18
 */



require_once('tce_xhtml_header.php');

// display header (brand title + timer)
echo '<div class="header">' . K_NEWLINE;
echo '<div class="left"></div>' . K_NEWLINE;
echo '<div class="headertitle">' . htmlspecialchars(K_SITE_TITLE, ENT_NOQUOTES, $l['a_meta_charset']) . '</div>' . K_NEWLINE;
echo '<div class="right">' . K_NEWLINE;
echo '<a id="timersection"></a>' . K_NEWLINE;
include('../../shared/code/tce_page_timer.php');
echo '</div>' . K_NEWLINE;
echo '</div>' . K_NEWLINE;

// display menu
echo '<div id="scrollayer" class="scrollmenu">' . K_NEWLINE;
require_once(__DIR__ . '/tce_page_menu.php');
echo '</div>' . K_NEWLINE;

echo '<div class="body">' . K_NEWLINE;

// anchor for the menu "skip navigation" link
echo '<a id="topofdoc"></a>' . K_NEWLINE;

//============================================================+
// END OF FILE
//============================================================+
