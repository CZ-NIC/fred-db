CREATE OR REPLACE FUNCTION drop_parts_for_month(time_begin TIMESTAMP WITHOUT TIME ZONE, service TEXT, dry_run BOOLEAN) RETURNS SETOF TEXT AS $drop_parts_for_month$
DECLARE
    alter_table TEXT;
    drop_table TEXT;
    table_name VARCHAR(60);
    base_table VARCHAR(25);
    -- order is important, `request` must be the last one
    tab_array VARCHAR[] := ARRAY['request_data','request_object_ref','request_property_value','request'];
BEGIN
    FOREACH base_table IN ARRAY tab_array
    LOOP
        table_name := quote_ident(base_table || '_' || service || '_' || partition_postfix(time_begin, -1, False));

        IF EXISTS (SELECT relname FROM pg_class WHERE relname=table_name) THEN
            alter_table := 'ALTER TABLE IF EXISTS ' || table_name || ' NO INHERIT ' || base_table;
            drop_table := 'DROP TABLE IF EXISTS ' || table_name || ' RESTRICT';
            IF NOT dry_run THEN
                EXECUTE alter_table;
                EXECUTE drop_table;
            END IF;
            RETURN NEXT alter_table;
            RETURN NEXT drop_table;
        END IF;
    END LOOP;
END;
$drop_parts_for_month$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION drop_parts(start_date TIMESTAMP WITHOUT TIME ZONE, term_date TIMESTAMP WITHOUT TIME ZONE, service TEXT, dry_run BOOLEAN) RETURNS SETOF TEXT AS $drop_parts$
DECLARE
        term_month_beg TIMESTAMP WITHOUT TIME ZONE;
        cur_month_beg  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
        cur_month_beg := date_trunc('month', start_date);
        term_month_beg := date_trunc('month', term_date);

        LOOP
            RETURN QUERY SELECT * FROM drop_parts_for_month(cur_month_beg, service, dry_run);

            EXIT WHEN cur_month_beg = term_month_beg;
            cur_month_beg := cur_month_beg + interval '1 month';
        END LOOP;
END;
$drop_parts$ LANGUAGE plpgsql;
