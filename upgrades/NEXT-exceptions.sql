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

SELECT  rename_constraints_ticket_8703();

CREATE OR REPLACE FUNCTION rename_logger_constraints_ticket_8703()
  RETURNS void AS $$
  DECLARE
  BEGIN
  
    PERFORM * FROM pg_constraint WHERE conname = 'request_type_name_key';
    IF FOUND THEN
        ALTER TABLE request_type DROP CONSTRAINT request_type_name_key;
    END IF;
    PERFORM * FROM pg_constraint WHERE conname = 'request_type_name_service_id_key';
    IF NOT FOUND THEN
        ALTER TABLE request_type ADD CONSTRAINT request_type_name_service_id_key UNIQUE (name, service_id);
    END IF;
    
    DROP FUNCTION rename_logger_constraints_ticket_8703();
  END;
$$ LANGUAGE plpgsql;

SELECT rename_logger_constraints_ticket_8703();

---
---  #8703 removal of git rebase -obsoleted exception functions
---
DROP FUNCTION raise_exception_ifnull(anyelement, text);
DROP FUNCTION ex_data(text);


