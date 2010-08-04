---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4313
--- 
---

CREATE TABLE result_code (
    id SERIAL PRIMARY KEY,
    service_id INTEGER REFERENCES service(id),
    result_code INTEGER NOT NULL,
    name VARCHAR(64) NOT NULL    
);

ALTER TABLE result_code ADD CONSTRAINT result_code_unique  UNIQUE (service_id, result_code );
ALTER TABLE result_code ADD CONSTRAINT result_code_unique  UNIQUE (service_id, name );

COMMENT ON TABLE result_code IS 'all possible operation result codes';
COMMENT ON COLUMN result_code.id IS 'result_code id';
COMMENT ON COLUMN result_code.service_id IS 'reference to service table. This is needed to distinguish entries with identical result_code values';
COMMENT ON COLUMN result_code.result_code IS 'result code as returned by the specific service, it''s only unique within the service';
COMMENT ON COLUMN result_code.name IS 'short name for error (abbreviation) written in camelcase';


ALTER TABLE request ADD COLUMN result_code_id INTEGER;
ALTER TABLE request ADD FOREIGN KEY (result_code_id) REFERENCES result_code(id); 

COMMENT ON COLUMN request.result_code_id IS 'result code as returned by the specific service, it''s only unique within the service';

-- for CloseRequest result_code_id updates, exception commented out until request.result_code_id optional
CREATE OR REPLACE FUNCTION get_result_code_id( integer, integer) 
RETURNS integer AS $$
DECLARE
    result_code_id INTEGER;
BEGIN

    SELECT id FROM result_code INTO result_code_id
        WHERE service_id=$1 and result_code=$2 ; 

    IF result_code_id is null THEN
--      RAISE EXCEPTION 'result_code_id is null';
    END IF;
    RETURN result_code_id;
END;
$$ LANGUAGE plpgsql;
