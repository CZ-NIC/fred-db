---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.38.0' WHERE id = 1;


INSERT INTO enum_operation (id, operation) VALUES (6, 'MonthlyFee'); -- registry contractual fee per month

---
--- new type for mojeid two factor reset SMS
---
INSERT INTO message_type (id, type) VALUES (13, 'mojeid_sms_two_factor_reset');
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'mojeid_sms_two_factor_reset'::text;
