CREATE OR REPLACE FUNCTION drop_parts_for_month(time_begin TIMESTAMP WITHOUT TIME ZONE, service VARCHAR(15), dry_run BOOLEAN) RETURNS TEXT AS $drop_parts_for_month$
DECLARE
    alter_table TEXT;
    drop_table TEXT;
    table_name VARCHAR(60);
    tab VARCHAR(25);
    -- order is important, `request` must be the last one
    tab_array VARCHAR[] := ARRAY['request_data','request_object_ref','request_property_value','request'];
    cmds TEXT := '';
BEGIN
    FOREACH tab IN ARRAY tab_array
    LOOP
        table_name := quote_ident(tab || '_' || service || '_' || partition_postfix(time_begin, -1, False));

        IF EXISTS (SELECT relname FROM pg_class WHERE relname=table_name) THEN
            alter_table := 'ALTER TABLE IF EXISTS ' || table_name || ' NO INHERIT ' || tab;
            drop_table := 'DROP TABLE IF EXISTS ' || table_name || ' RESTRICT';
            IF NOT dry_run THEN
                EXECUTE alter_table;
                EXECUTE drop_table;
            END IF;
            cmds := cmds || alter_table || E'\n' || drop_table || E'\n';
        END IF;
    END LOOP;
    RETURN cmds;
END;
$drop_parts_for_month$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION drop_parts(start_date TIMESTAMP WITHOUT TIME ZONE, term_date TIMESTAMP WITHOUT TIME ZONE, service VARCHAR(15), dry_run BOOLEAN) RETURNS TEXT AS $drop_parts$
DECLARE
        term_month_beg TIMESTAMP WITHOUT TIME ZONE;
        cur_month_beg  TIMESTAMP WITHOUT TIME ZONE;
        logs TEXT;
        cmds TEXT := '';
BEGIN
        cur_month_beg := date_trunc('month', start_date);
        term_month_beg := date_trunc('month', term_date);

        LOOP
            SELECT * INTO logs FROM drop_parts_for_month(cur_month_beg, service, dry_run);
            cmds := cmds || logs;

            EXIT WHEN cur_month_beg = term_month_beg;
            cur_month_beg := cur_month_beg + interval '1 month';
        END LOOP;
        RETURN cmds;
END;
$drop_parts$ LANGUAGE plpgsql;
