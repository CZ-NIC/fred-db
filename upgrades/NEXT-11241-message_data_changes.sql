----
---- #11241
----

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

UPDATE message_type_forwarding_service_map SET service_handle = 'OPTYS'::message_forwarding_service
    WHERE message_type_id = (SELECT id FROM message_type WHERE type = 'mojeid_pin3'::text);


