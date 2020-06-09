ALTER TABLE service DROP CONSTRAINT service_partition_postfix_key;
ALTER TABLE service DROP CONSTRAINT service_name_key;
ALTER TABLE result_code DROP CONSTRAINT result_code_unique_name;
ALTER TABLE request_type DROP CONSTRAINT request_type_name_service_id_key;

CREATE UNIQUE INDEX service_name_unique_idx ON service (LOWER(name));
CREATE UNIQUE INDEX service_partition_postfix_unique_idx ON service (LOWER(partition_postfix));
CREATE UNIQUE INDEX result_code_service_id_name_unique_idx ON result_code (service_id, LOWER(name));
CREATE UNIQUE INDEX request_type_service_id_name_unique_idx ON request_type (service_id, LOWER(name));
CREATE UNIQUE INDEX request_object_type_name_unique_idx ON request_object_type (LOWER(name));
