/*
============================================================
File name   : mysql_db_upgrade_16to17.sql
Begin       : 2026-09-24
Last Update : 2026-09-24

Description : TCExam database structure upgrade commands
              (from version 16 to 17).
Database    : MySQL 4.1+

Adds the tce_users.user_perms capability bitmask and seeds it
from the legacy cumulative user levels, so the upgrade does not
change anyone's rights (see PERMISSIONS.md).

Author: Nicola Asuni

(c) Copyright:
              Nicola Asuni
              Tecnick.com LTD
              www.tecnick.com

License:
Copyright (C) 2004-2026 Nicola Asuni - Tecnick.com LTD
   See LICENSE.TXT file for more information.
============================================================+
*/

ALTER TABLE tce_users ADD COLUMN user_perms Int NOT NULL DEFAULT 0;

UPDATE tce_users SET user_perms = CASE
	WHEN user_level >= 10 THEN 127
	WHEN user_level = 9 THEN 63
	WHEN user_level >= 6 THEN 15
	WHEN user_level >= 5 THEN 7
	WHEN user_level >= 3 THEN 3
	WHEN user_level = 2 THEN 1
	ELSE 0
END;
