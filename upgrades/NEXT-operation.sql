---
--- #7652
---

-- if value is null then raise exception, else return value
CREATE OR REPLACE FUNCTION raise_exception_ifnull(value anyelement,errmsg text) 
RETURNS anyelement AS 
$BODY$  
DECLARE
BEGIN
    IF value IS NULL THEN
        RAISE EXCEPTION '%', errmsg;
    END IF;
    RETURN value;
END;  
$BODY$
LANGUAGE 'plpgsql';

