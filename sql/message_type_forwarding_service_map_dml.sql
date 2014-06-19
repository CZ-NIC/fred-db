
-- #11241

INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'domain_expiration'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'MOBILEM'::message_forwarding_service FROM message_type WHERE type = 'mojeid_pin2'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'OPTYS'::message_forwarding_service FROM message_type WHERE type = 'mojeid_pin3'::text;
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
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'contact_check_notice'::text;
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
  SELECT id, 'POSTSERVIS'::message_forwarding_service FROM message_type WHERE type = 'contact_check_thank_you'::text;
