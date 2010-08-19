--- THIS SCRIPT could be MERGED with that to ticket #4327

--- don't forget to update database schema version
---
---

-- UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


--
-- #4374
--

ALTER TABLE session RENAME COLUMN name TO user_name;

ALTER TABLE session ADD COLUMN user_id INTEGER;

-- drop rule which executes the trigger
DROP RULE session_insert_function ON session;
ALTER TABLE session DROP COLUMN lang;

CREATE OR REPLACE FUNCTION tr_session(id INTEGER, user_name VARCHAR(255), user_id INTEGER, login_date timestamp, logout_date timestamp) RETURNS VOID AS $tr_session$
DECLARE 
        table_name VARCHAR(50);
        stmt  TEXT;
BEGIN
        table_name := quote_ident('session_' || partition_postfix(login_date, -1, false));
        stmt := 'INSERT INTO ' || table_name || ' (id, user_name, user_id, login_date, logout_date) VALUES (' 
                || COALESCE(id::TEXT, 'NULL')           || ', ' 
                || COALESCE(quote_literal(user_name), 'NULL')                 || ', '
                || COALESCE(user_id::TEXT, 'NULL')                       || ', '
                || COALESCE(quote_literal(login_date), 'NULL')           || ', '
                || COALESCE(quote_literal(logout_date), 'NULL')          

                || ')';

        -- raise notice 'session Generated insert: %', stmt;
        EXECUTE stmt;

EXCEPTION
        WHEN undefined_table THEN
        BEGIN
                PERFORM create_tbl_session(login_date);
        
                EXECUTE stmt;
        END;
END;
$tr_session$ LANGUAGE plpgsql;


/** parameter table_name must already be processed by quote_ident
*/
CREATE OR REPLACE FUNCTION create_indexes_session(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_session$
DECLARE 
        create_indexes TEXT;
BEGIN
        create_indexes = 'CREATE INDEX ' || table_name || '_name_idx ON ' || table_name || '(user_name); CREATE INDEX ' || table_name || '_user_id_idx ON ' || table_name || '(user_id); CREATE INDEX ' || table_name || '_login_date_idx ON ' || table_name || '(login_date);'; 
        EXECUTE create_indexes;

END;
$create_indexes_session$ LANGUAGE plpgsql;


CREATE OR REPLACE RULE session_insert_function AS ON INSERT TO session
DO INSTEAD SELECT tr_session ( NEW.id, NEW.user_name, NEW.user_id, NEW.login_date, NEW.logout_date); 

