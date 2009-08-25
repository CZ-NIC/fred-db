---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '2.1.6' WHERE id = 1;


---
--- Ticket #1873 - remove public_request - action table relationship
---

ALTER TABLE public_request ADD COLUMN registrar_id INTEGER;
ALTER TABLE public_request ADD FOREIGN KEY (registrar_id) REFERENCES registrar(id);

--- fill in values for current data (TEST THIS)
BEGIN;
LOCK TABLE public_request IN ACCESS EXCLUSIVE MODE;

UPDATE 
    public_request pr 
SET 
    registrar_id = (SELECT 
                        l.registrarid 
                    FROM 
                        action a 
                        JOIN login l ON (a.clientid = l.id) 
                    WHERE 
                        a.id = pr.epp_action_id);

END;

