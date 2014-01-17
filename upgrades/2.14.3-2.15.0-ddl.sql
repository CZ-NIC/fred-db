---
--- administrative domain blocking/unblocking
---
CREATE TABLE object_state_request_reason
(
    object_state_request_id INTEGER NOT NULL REFERENCES object_state_request (id),
    -- state created
    reason_creation VARCHAR(300) NULL DEFAULT NULL,
    -- state canceled
    reason_cancellation VARCHAR(300) NULL DEFAULT NULL,
    PRIMARY KEY (object_state_request_id)
);


---
--- #9085 domain name validation configuration by zone
---
CREATE TABLE enum_domain_name_validation_checker (
        id SERIAL CONSTRAINT enum_domain_name_validation_checker_pkey PRIMARY KEY,
        name TEXT CONSTRAINT enum_domain_name_validation_checker_name_key UNIQUE NOT NULL,
        description TEXT NOT NULL
        );

COMMENT ON TABLE enum_domain_name_validation_checker IS
'This table contains names of domain name checkers used in server DomainNameValidator';
COMMENT ON COLUMN enum_domain_name_validation_checker.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN enum_domain_name_validation_checker.name IS 'name of the checker';
COMMENT ON COLUMN enum_domain_name_validation_checker.description IS 'description of the checker';

CREATE TABLE zone_domain_name_validation_checker_map (
  id BIGSERIAL CONSTRAINT zone_domain_name_validation_checker_map_pkey PRIMARY KEY,
  checker_id INTEGER NOT NULL CONSTRAINT zone_domain_name_validation_checker_map_checker_id_fkey
    REFERENCES enum_domain_name_validation_checker (id),
  zone_id INTEGER NOT NULL CONSTRAINT zone_domain_name_validation_checker_map_zone_id_fkey
    REFERENCES zone (id),
  CONSTRAINT zone_domain_name_validation_checker_map_key UNIQUE (checker_id, zone_id)
);

COMMENT ON TABLE zone_domain_name_validation_checker_map IS
'This table domain name checkers applied to domain names by zone';
COMMENT ON COLUMN zone_domain_name_validation_checker_map.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN zone_domain_name_validation_checker_map.checker_id IS 'checker';
COMMENT ON COLUMN zone_domain_name_validation_checker_map.zone_id IS 'zone';


---
--- #8703 rename constraints changed from postgres v8.3.9 to postgres v9.1.9
---

CREATE OR REPLACE FUNCTION rename_constraints_ticket_8703()
  RETURNS void AS $$
  DECLARE
  BEGIN

    PERFORM * FROM pg_constraint WHERE conname = 'host_nssetid_key';
    IF FOUND THEN
        ALTER TABLE host DROP CONSTRAINT host_nssetid_key;
    END IF;
    PERFORM * FROM pg_constraint WHERE conname = 'host_nssetid_fqdn_key';
    IF NOT FOUND THEN
        ALTER TABLE host ADD CONSTRAINT host_nssetid_fqdn_key UNIQUE (nssetid, fqdn);
    END IF;

    PERFORM * FROM pg_constraint WHERE conname = 'bank_payment_account_id_key';
    IF FOUND THEN
        ALTER TABLE bank_payment DROP CONSTRAINT bank_payment_account_id_key;
    END IF;
    PERFORM * FROM pg_constraint WHERE conname = 'bank_payment_account_id_account_evid_key';
    IF NOT FOUND THEN
        ALTER TABLE bank_payment ADD CONSTRAINT bank_payment_account_id_account_evid_key UNIQUE (account_id, account_evid);
    END IF;

    PERFORM * FROM pg_constraint WHERE conname = 'public_request_messages_map_public_request_id_key';
    IF FOUND THEN
        ALTER TABLE public_request_messages_map DROP CONSTRAINT public_request_messages_map_public_request_id_key;
    END IF;
    PERFORM * FROM pg_constraint WHERE conname = 'public_request_messages_map_public_request_id_message_archi_key';
    IF NOT FOUND THEN
        ALTER TABLE public_request_messages_map ADD CONSTRAINT public_request_messages_map_public_request_id_message_archi_key UNIQUE (public_request_id, message_archive_id);
    END IF;

    PERFORM * FROM pg_constraint WHERE conname = 'public_request_messages_map_public_request_id_key1';
    IF FOUND THEN
        ALTER TABLE public_request_messages_map DROP CONSTRAINT public_request_messages_map_public_request_id_key1;
    END IF;
    PERFORM * FROM pg_constraint WHERE conname = 'public_request_messages_map_public_request_id_mail_archive__key';
    IF NOT FOUND THEN
        ALTER TABLE public_request_messages_map ADD CONSTRAINT public_request_messages_map_public_request_id_mail_archive__key UNIQUE (public_request_id , mail_archive_id);
    END IF;

    DROP FUNCTION rename_constraints_ticket_8703();
  END;
$$ LANGUAGE plpgsql;

SELECT rename_constraints_ticket_8703();


---
---  #8703 remove obsoleted functions
---
DROP FUNCTION raise_exception_ifnull(anyelement, text);
DROP FUNCTION ex_data(text);

