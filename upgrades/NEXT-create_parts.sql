---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


--- no ticket assigned 

-- CREATE partitions for a specific month
CREATE OR REPLACE FUNCTION create_parts_for_month(part_time TIMESTAMP WITHOUT TIME ZONE) RETURNS VOID AS 
$create_parts_for_month$ DECLARE
        serv INTEGER;
        cur REFCURSOR;
BEGIN

        -- a chance for minor optimization: create_tbl_* needs partitions_postfix 
        --- which can be selected from table service. 
        OPEN cur FOR SELECT id FROM service;
        LOOP
            FETCH cur INTO serv;
            EXIT WHEN NOT FOUND;

            PERFORM create_tbl_request(part_time, serv, false);
            PERFORM create_tbl_request_data(part_time, serv, false);
            PERFORM create_tbl_request_property_value(part_time, serv, false);
            PERFORM create_tbl_request_object_ref(part_time, serv, false);
            
        END LOOP;

        close cur;

        -- monitoring (service type doesn't matter here - specifying 1)
        PERFORM create_tbl_request(part_time, 1, true);
        PERFORM create_tbl_request_data(part_time, 1, true);
        PERFORM create_tbl_request_property_value(part_time, 1, true);
        PERFORM create_tbl_request_object_ref(part_time, 1, true);

        -- now service type -1 for session tables
        PERFORM create_tbl_session(part_time);
            
END;
$create_parts_for_month$ LANGUAGE plpgsql;


