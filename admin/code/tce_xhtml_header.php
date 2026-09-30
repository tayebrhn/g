<?php

//============================================================+
// File name   : tce_xhtml_header.php
// Begin       : 2004-04-24
// Last Update : 2023-11-30
//
// Description : print default XHTML page header
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
 * output default XHTML header (doctype + head)
 * @package com.tecnick.tcexam.admin
 * @author Nicola Asuni
 * @since 2004-04-24
 * int $pagelevel page access level (0-10), default 0
 * string $thispage_title page title, default K_TCEXAM_TITLE
 * string $thispage_description page description, default K_TCEXAM_DESCRIPTION
 * string $thispage_author page author, default K_TCEXAM_AUTHOR
 * string $thispage_reply page reply to, default K_TCEXAM_REPLY_TO
 * string $thispage_keywords page keywords, default K_TCEXAM_KEYWORDS
 * string $thispage_icon page icon, default K_TCEXAM_ICON
 * string $thispage_style page CSS file name, default K_TCEXAM_STYLE
 */



//if necessary load default values
if (! isset($pagelevel) || empty($pagelevel)) {
    $pagelevel = 0;
}

if (! isset($thispage_title) || empty($thispage_title)) {
    $thispage_title = K_TCEXAM_TITLE;
}

if (! isset($thispage_description) || empty($thispage_description)) {
    $thispage_description = K_TCEXAM_DESCRIPTION;
}

if (! isset($thispage_author) || empty($thispage_author)) {
    $thispage_author = K_TCEXAM_AUTHOR;
}

if (! isset($thispage_reply) || empty($thispage_reply)) {
    $thispage_reply = K_TCEXAM_REPLY_TO;
}

if (! isset($thispage_keywords) || empty($thispage_keywords)) {
    $thispage_keywords = K_TCEXAM_KEYWORDS;
}

if (! isset($thispage_icon) || empty($thispage_icon)) {
    $thispage_icon = K_TCEXAM_ICON;
}

if (! isset($thispage_style) || empty($thispage_style)) {
    $thispage_style = strcasecmp($l['a_meta_dir'], 'rtl') == 0 ? K_TCEXAM_STYLE_RTL : K_TCEXAM_STYLE;
}

echo '<?xml version="1.0" encoding="' . $l['a_meta_charset'] . '" ' . '?' . '>' . K_NEWLINE;
echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' . K_NEWLINE;
echo '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="' . $l['a_meta_language'] . '" lang="' . $l['a_meta_language'] . '" dir="' . $l['a_meta_dir'] . '">' . K_NEWLINE;

echo '<head>' . K_NEWLINE;
echo '<title>' . htmlspecialchars($thispage_title, ENT_NOQUOTES, $l['a_meta_charset']) . '</title>' . K_NEWLINE;
echo '<meta name="viewport" content="width=device-width, initial-scale=1">' . K_NEWLINE;
echo '<meta http-equiv="Content-Type" content="text/html; charset=' . $l['a_meta_charset'] . '" />' . K_NEWLINE;
echo '<meta name="language" content="' . $l['a_meta_language'] . '" />' . K_NEWLINE;
// the trailing base64 value is the encoded copyright marker (K_KEY_SECURITY),
// not a secret: it pairs with the integrity marker in the page footer
echo '<meta name="description" content="' . htmlspecialchars($thispage_description, ENT_COMPAT, $l['a_meta_charset']) . ' [' . base64_decode(K_KEY_SECURITY) . ']" />' . K_NEWLINE;
echo '<meta name="author" content="' . htmlspecialchars($thispage_author, ENT_COMPAT, $l['a_meta_charset']) . '" />' . K_NEWLINE;
echo '<meta name="reply-to" content="' . htmlspecialchars($thispage_reply, ENT_COMPAT, $l['a_meta_charset']) . '" />' . K_NEWLINE;
echo '<meta name="keywords" content="' . htmlspecialchars($thispage_keywords, ENT_COMPAT, $l['a_meta_charset']) . '" />' . K_NEWLINE;
// The theme entry may chain its stylesheet layers through @import statements.
// The browser can only discover the imported files after downloading the
// entry itself, so the last layer (which holds the theme colors) arrives on
// a second round trip and the header flashes white meanwhile. Link the
// imported files directly, in the same order and each with its own
// cache-buster, so every stylesheet is discovered in the page head and
// fetched in parallel.
$thispage_style_file = __DIR__ . '/../styles/' . basename($thispage_style);
$style_links = [];
$entry_css = is_file($thispage_style_file) ? @file_get_contents($thispage_style_file) : false;
if ($entry_css !== false && preg_match_all('/@import\s+(?:url\(\s*)?[\'"]([^\'")]+)[\'"]/', $entry_css, $entry_imports)) {
    foreach ($entry_imports[1] as $entry_import) {
        // drop any query string (replaced by a fresh mtime cache-buster)
        $entry_import = preg_replace('/[?#].*$/', '', $entry_import);
        $entry_import_file = __DIR__ . '/../styles/' . $entry_import;
        if ($entry_import === '' || ! is_file($entry_import_file)) {
            // broken reference: fall back to linking the entry itself
            $style_links = [];
            break;
        }

        $style_links[] = '../styles/' . $entry_import . '?v=' . filemtime($entry_import_file);
    }
}

if ($style_links === []) {
    // a single-file theme, or an unreadable entry: link the entry directly
    $style_links[] = $thispage_style . (is_file($thispage_style_file) ? '?v=' . filemtime($thispage_style_file) : '');
}

foreach ($style_links as $style_link) {
    echo '<link rel="stylesheet" href="' . $style_link . '" type="text/css" />' . K_NEWLINE;
}
echo '<link rel="shortcut icon" href="' . $thispage_icon . '" />' . K_NEWLINE;
echo '<link rel="stylesheet" href="' . K_PATH_SHARED_JSCRIPTS . 'slimselect/slimselect.min.css" type="text/css" />' . K_NEWLINE;
// calendar
if (isset($enable_calendar) && $enable_calendar) {
    echo '<link rel="stylesheet" href="' . K_PATH_SHARED_JSCRIPTS . 'flatpickr/flatpickr.min.css" type="text/css" />' . K_NEWLINE;
    echo '<script type="text/javascript" src="' . K_PATH_SHARED_JSCRIPTS . 'flatpickr/flatpickr.min.js"></script>' . K_NEWLINE;
    // TCExam language codes that differ from the flatpickr locale file names
    $flatpickr_locales = ['jp' => 'ja', 'CN' => 'zh', 'br' => 'pt', 'el' => 'gr'];
    $l10n = $l['a_meta_language'];
    if (isset($flatpickr_locales[$l10n])) {
        $l10n = $flatpickr_locales[$l10n];
    }

    if ($l10n != 'en' && F_file_exists(K_PATH_SHARED_JSCRIPTS . 'flatpickr/l10n/' . $l10n . '.js')) {
        echo '<script type="text/javascript" src="' . K_PATH_SHARED_JSCRIPTS . 'flatpickr/l10n/' . $l10n . '.js"></script>' . K_NEWLINE;
        echo '<script type="text/javascript">if (typeof flatpickr != "undefined" && typeof flatpickr.l10ns != "undefined" && flatpickr.l10ns["' . $l10n . '"]) { flatpickr.localize(flatpickr.l10ns["' . $l10n . '"]); }</script>' . K_NEWLINE;
    }
}

echo '<script type="text/javascript" src="' . K_PATH_SHARED_JSCRIPTS . 'slimselect/slimselect.min.js"></script>' . K_NEWLINE;
// integrity marker (paired with the base64 copyright marker in the
// description meta and the footer comment) - intentionally not removed
echo '<!-- Exam19730104 -->' . K_NEWLINE;
echo '</head>' . K_NEWLINE;

echo '<body>' . K_NEWLINE;

global $login_error;
if (isset($login_error) && $login_error) {
    F_print_error('WARNING', $l['m_login_wrong']);
}

//============================================================+
// END OF FILE
//============================================================+
