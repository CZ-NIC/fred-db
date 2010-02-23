
-- create partitions for a specific month
create or replace function create_parts_for_month(part_time timestamp without time zone) returns void as 
$create_parts_for_month$ declare
        serv integer;
        cur CURSOR is select id, partition_postfix from service;
begin

        open cur;
        loop
            fetch cur into serv;
            exit when not found;

            perform create_tbl_request(part_time, serv, false);
            perform create_tbl_request_data(part_time, serv, false);
            perform create_tbl_request_property_value(part_time, serv, false);
            
        end loop;

        close cur;

        -- monitoring (service type doesn't matter)
        perform create_tbl_request(part_time, 1, true);
        perform create_tbl_request_data(part_time, 1, true);
        perform create_tbl_request_property_value(part_time, 1, true);

        -- now service type -1 for session tables
        perform create_tbl_session(part_time);
            
end;
$create_parts_for_month$ language plpgsql;


create or replace function create_parts(term_date timestamp without time zone) returns void as $create_parts$
declare
        term_month timestamp without time zone;
        cur_month  timestamp without time zone;

begin
        cur_month := date_trunc('month', now());

        term_month := date_trunc('month', term_date);

        loop 
            perform create_parts_for_month(cur_month);

            exit when cur_month = term_month;
            cur_month := cur_month + interval '1 month';
        end loop;

end;
$create_parts$ language plpgsql;
                
