---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.37.2' WHERE id = 1;

---
--- new type for mojeid password reset SMS
---
INSERT INTO message_type (id, type) VALUES (12, 'mojeid_sms_password_reset');
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'mojeid_sms_password_reset'::text;
