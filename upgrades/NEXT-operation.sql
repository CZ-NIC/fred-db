---
--- #7652
---


-- if value is null then raise exception with errmsg, else return value
-- for compatibility with OperationException process variable data in errmsg by ex_data function
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

-- preprocess data for raise_exception_ifnull  errmsg for compatibility with OperationException
-- if value is null then replace with '[null]' and replace '|' by '[pipe]'
CREATE OR REPLACE FUNCTION ex_data(value text)
RETURNS text AS
$BODY$
DECLARE
    return_value TEXT;
BEGIN
    return_value := COALESCE(REPLACE(value, '|', '[pipe]'),'[null]');
    RETURN return_value;
END;
$BODY$
LANGUAGE 'plpgsql';


CREATE TABLE enum_object_type
(
  id integer NOT NULL,
  name TEXT NOT NULL,
  CONSTRAINT enum_object_type_pkey PRIMARY KEY (id),
  CONSTRAINT enum_object_type_name_key UNIQUE (name)
);

INSERT INTO enum_object_type (id,name) VALUES ( 1 , 'contact' );
INSERT INTO enum_object_type (id,name) VALUES ( 2 , 'nsset' );
INSERT INTO enum_object_type (id,name) VALUES ( 3 , 'domain' );
INSERT INTO enum_object_type (id,name) VALUES ( 4 , 'keyset' );

ALTER TABLE object_registry ADD CONSTRAINT object_registry_type_fkey FOREIGN KEY (type)
      REFERENCES enum_object_type (id);

