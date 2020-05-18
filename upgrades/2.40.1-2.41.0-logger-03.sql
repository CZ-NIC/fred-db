CREATE INDEX CONCURRENTLY request_object_ref_object_ident_idx ON request_object_ref(object_ident);

CREATE OR REPLACE FUNCTION add_index_to_request_object_ref_partitions_tmp() RETURNS VOID AS $$
DECLARE
    table_name RECORD;
BEGIN
  FOR table_name IN
    SELECT tablename
      FROM pg_tables
     WHERE tablename LIKE 'request_object_ref_%'
  LOOP
    RAISE NOTICE 'Creating index on table %...', table_name;
    PERFORM 'CREATE INDEX CONCURRENTLY ' || table_name || '_object_ident_idx '
                'ON ' || table_name || '(object_ident);';
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT add_index_to_request_object_ref_partitions_tmp();
DROP FUNCTION add_index_to_request_object_ref_partitions_tmp();
