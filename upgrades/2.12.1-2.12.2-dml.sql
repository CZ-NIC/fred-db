---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.12.2' WHERE id = 1;

---
--- new type for sending PIN3 reminder letter
---
INSERT INTO message_type (id, type) VALUES (8, 'mojeid_pin3_reminder');
