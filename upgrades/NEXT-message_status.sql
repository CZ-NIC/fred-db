---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4511
--- message status into one table
---

--ddl
ALTER TABLE enum_send_status ADD COLUMN status_name VARCHAR(64) UNIQUE;
ALTER TABLE message_archive DROP CONSTRAINT message_archive_status_id_fkey;
ALTER TABLE message_archive ADD CONSTRAINT message_archive_status_id_fkey FOREIGN KEY (status_id) REFERENCES enum_send_status(id);
DROP TABLE message_status;

--dml
UPDATE enum_send_status SET status_name='ready' WHERE id = 1;
UPDATE enum_send_status SET status_name='waiting_confirmation' WHERE id = 2;
UPDATE enum_send_status SET status_name='no_processing' WHERE id = 3;
UPDATE enum_send_status SET status_name='send_failed' WHERE id = 4;
UPDATE enum_send_status SET status_name='sent' WHERE id = 5;
UPDATE enum_send_status SET status_name='being_sent' WHERE id = 6;




