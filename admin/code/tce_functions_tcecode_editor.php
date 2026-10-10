<?php

//============================================================+
// File name   : tce_functions_tcecode_editor.php
// Begin       : 2002-02-20
// Last Update : 2023-11-30
//
// Description : TCExam Code Editor (editor for special mark-up
//               code used to add some text formatting)
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
 * Functions for custom mark-up language editor.
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2002-02-20
 */

/**
 * Display TCExam Code EDITOR Tag Buttons
 * Note: Rich text editor toolbar has been removed across the project.
 * Returns an empty string for backward compatibility.
 * @param $callingform (string) name of calling xhtml form
 * @param $callingfield (string) name of calling form field
 * @return string
 */
function tcecodeEditorTagButtons($callingform, $callingfield)
{
    return '';
}

/**
 * Display one tag button
 * Note: Rich text editor toolbar has been removed across the project.
 * Returns an empty string for backward compatibility.
 * @param $name (string) name of the button
 * @param $tag (string) tag value
 * @param $image (string) image file of button
 * @param $onclick (string) default onclick action
 * @param $accesskey (string) accesskey
 * @return string
 */
function getImageButton($name, $tag, $image, $onclick = '', $accesskey = '')
{
    return '';
}

//============================================================+
// END OF FILE
//============================================================+
