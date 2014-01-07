---
--- #8703 rename constraints changed from postgres v8.3.9 to postgres v9.1.9
---
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

