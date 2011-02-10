---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.6.0' WHERE id = 1;


---
--- Ticket #4511 - message status into one table
---
UPDATE enum_send_status SET status_name='ready' WHERE id = 1;
UPDATE enum_send_status SET status_name='waiting_confirmation' WHERE id = 2;
UPDATE enum_send_status SET status_name='no_processing' WHERE id = 3;
UPDATE enum_send_status SET status_name='send_failed' WHERE id = 4;
UPDATE enum_send_status SET status_name='sent' WHERE id = 5;
UPDATE enum_send_status SET status_name='being_sent' WHERE id = 6;


