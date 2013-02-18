---
--- Ticket #7652
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


---
--- unnest function for postgres <= 8.3
---
CREATE OR REPLACE FUNCTION unnest(anyarray)
  RETURNS SETOF anyelement AS
$BODY$
SELECT $1[i] FROM
    generate_series(array_lower($1, 1),
                    array_upper($1, 1)) i;
$BODY$
LANGUAGE 'sql' IMMUTABLE;

