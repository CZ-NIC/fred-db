INSERT INTO message_type  (id,type) VALUES (11,'mojeid_card');
INSERT INTO enum_filetype (id,name) VALUES (10,'mojeid card');
INSERT INTO message_type_forwarding_service_map (message_type_id,service_handle)
    SELECT id,'OPTYS'::message_forwarding_service
    FROM message_type
    WHERE type='mojeid_card';
