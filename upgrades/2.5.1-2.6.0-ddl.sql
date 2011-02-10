---
--- Tickets #4750
---
ALTER TABLE public_request ALTER COLUMN status SET DEFAULT 1;


---
--- Ticket #4953
---
ALTER TABLE history ALTER COLUMN request_id TYPE bigint;


---
--- Ticket #4511 - message status into one table
---
ALTER TABLE enum_send_status ADD COLUMN status_name VARCHAR(64) UNIQUE;
ALTER TABLE message_archive DROP CONSTRAINT message_archive_status_id_fkey;
ALTER TABLE message_archive ADD CONSTRAINT message_archive_status_id_fkey FOREIGN KEY (status_id) REFERENCES enum_send_status(id);
DROP TABLE message_status;


---
--- Ticket #4574
---
CREATE TABLE notify_request
(
    request_id BIGINT NOT NULL,
    message_id INTEGER REFERENCES mail_archive(id)
);


---
--- Ticket #4574
---
ALTER TABLE public_request RENAME COLUMN logd_request_id TO create_request_id;
ALTER TABLE public_request ALTER COLUMN create_request_id TYPE bigint;
ALTER TABLE public_request ADD COLUMN resolve_request_id bigint;

