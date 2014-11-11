--send mojeid_pin3 letters via OPTYS
--Ticket #11241 comment:24
--Ticket #11668 comment:31

UPDATE message_type_forwarding_service_map SET service_handle = 'OPTYS'::message_forwarding_service
    WHERE message_type_id = (SELECT id FROM message_type WHERE type = 'mojeid_pin3'::text);
