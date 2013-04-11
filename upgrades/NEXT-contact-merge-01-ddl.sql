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
--- create unnest array function if missing
---
CREATE OR REPLACE FUNCTION create_unnest_if_missing()
  RETURNS void AS $$
  DECLARE
  BEGIN
    PERFORM * FROM pg_proc WHERE proname = 'unnest';
    IF NOT FOUND THEN
        CREATE OR REPLACE FUNCTION unnest(anyarray)
          RETURNS SETOF anyelement AS
        $BODY$
        SELECT $1[i] FROM
            generate_series(array_lower($1, 1),
                            array_upper($1, 1)) i;
        $BODY$
        LANGUAGE 'sql' IMMUTABLE;
    END IF;
    DROP FUNCTION create_unnest_if_missing();
  END;
$$ LANGUAGE plpgsql;

SELECT  create_unnest_if_missing();


---
--- Ticket #7873 - enumval domainid unique constraint
---
ALTER TABLE enumval ADD CONSTRAINT enumval_domainid_key UNIQUE (domainid);


---
--- Ticket #7875
---
CREATE INDEX dnskey_keysetid_idx ON dnskey (keysetid);

ALTER TABLE dnskey ADD CONSTRAINT dnskey_unique_key UNIQUE (keysetid, flags, protocol, alg, key);

