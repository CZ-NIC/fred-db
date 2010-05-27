---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

CREATE TABLE enum_send_status (
    id INTEGER PRIMARY KEY,
    description TEXT
);

comment on table enum_send_status is 'list of statuses when sending a general message to a contact';

INSERT INTO enum_send_status (id, description) VALUES (1, 'Ready for processing/sending');
INSERT INTO enum_send_status (id, description) VALUES (2, 'Waiting for manual confirmation of sending');
INSERT INTO enum_send_status (id, description) VALUES (3, 'No automatic processing');
INSERT INTO enum_send_status (id, description) VALUES (4, 'Delivery failed');
INSERT INTO enum_send_status (id, description) VALUES (5, 'Successfully sent');
INSERT INTO enum_send_status (id, description) VALUES (6, 'In processing, don''t touch');

ALTER TABLE notify_letters ADD FOREIGN KEY (status) REFERENCES enum_send_status(id);

