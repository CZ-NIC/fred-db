---
--- #8703 rename constraints referenced by server
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
    
    DROP FUNCTION rename_constraints_ticket_8703();
  END;
$$ LANGUAGE plpgsql;

SELECT  rename_constraints_ticket_8703();
