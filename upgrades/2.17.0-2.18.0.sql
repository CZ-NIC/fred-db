---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.18.0' WHERE id = 1;


---
--- #11241 - message forwarding service configuration
---
CREATE TYPE message_forwarding_service AS ENUM ('MOBILEM', 'POSTSERVIS', 'OPTYS', 'MANUAL');

CREATE TABLE message_type_forwarding_service_map
(
  message_type_id BIGINT NOT NULL
    CONSTRAINT message_type_forwarding_service_map_message_type_id_fkey REFERENCES message_type(id),
    CONSTRAINT message_type_forwarding_service_map_message_type_id_unique UNIQUE (message_type_id),
  service_handle message_forwarding_service NOT NULL
);


INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'domain_expiration'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'mojeid_pin2'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'mojeid_pin3'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'mojeid_sms_change'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'monitoring'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'contact_verification_pin2'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'contact_verification_pin3'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'mojeid_pin3_reminder'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MANUAL'::message_forwarding_service FROM message_type WHERE type = 'contact_check_notice'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MANUAL'::message_forwarding_service FROM message_type WHERE type = 'contact_check_thank_you'::text;

ALTER TABLE message_archive ADD COLUMN service_handle message_forwarding_service;

UPDATE message_archive AS ma SET service_handle = mtfsm.service_handle
    FROM message_type_forwarding_service_map mtfsm
    WHERE mtfsm.message_type_id = ma.message_type_id;

UPDATE message_archive AS ma SET service_handle = 'MANUAL'::message_forwarding_service
    WHERE ma.message_type_id = (SELECT id FROM message_type WHERE type = 'mojeid_pin2'::text)
        AND comm_type_id = (SELECT id FROM comm_type WHERE type = 'registered_letter'::text);

ALTER TABLE message_archive ALTER COLUMN service_handle SET NOT NULL;

---
--- #9375 - drop table with state request associated with given request
---
DROP TABLE public_request_state_request_map;


---
--- #11106 - merge contact fn index
---
CREATE INDEX contact_name_coalesce_trim_idx ON contact (trim(both ' ' from COALESCE(name,'')));

