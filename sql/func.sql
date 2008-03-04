-- must be superuser
-- CREATE LANGUAGE 'plpgsql';

-- 
--  create temporary table and if temporary table already
--  exists truncate it for immediate usage
--
CREATE OR REPLACE FUNCTION create_tmp_table(tname VARCHAR) 
RETURNS VOID AS $$
BEGIN
 EXECUTE 'CREATE TEMPORARY TABLE ' || tname || ' (id INTEGER PRIMARY KEY)';
 EXCEPTION
 WHEN DUPLICATE_TABLE THEN EXECUTE 'TRUNCATE TABLE ' || tname;
END;
$$ LANGUAGE plpgsql;

CREATE UNIQUE INDEX object_registry_name_type_uniq 
ON object_registry (name,type) WHERE erdate IS NULL;
--
-- create object and return it's id. duplicate is not raised as exception
-- but return 0 as id instead. it expect unique index on table
-- object_registry. cannot check enum subdomains!!!
--
CREATE OR REPLACE FUNCTION create_object(
 crregid INTEGER, 
 oname VARCHAR, 
 otype INTEGER
) 
RETURNS INTEGER AS $$
DECLARE iid INTEGER;
BEGIN
 iid := NEXTVAL('object_registry_id_seq');
 INSERT INTO object_registry (id,roid,name,type,crid) 
 VALUES (
  iid,
  (ARRAY['C','N','D'])[otype] || LPAD(iid,10,'0') || '-CZ' ,
  CASE
   WHEN otype=1 THEN UPPER(oname)
   WHEN otype=2 THEN UPPER(oname)
   WHEN otype=3 THEN LOWER(oname)
  END,
  otype,
  crregid
 );
 RETURN iid;
 EXCEPTION
 WHEN UNIQUE_VIOLATION THEN RETURN 0;
END;
$$ LANGUAGE plpgsql;
