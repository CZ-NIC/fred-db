--Helps to write query using conditional index like type=1
CREATE FUNCTION get_object_type_id(TEXT)
RETURNS integer AS
'SELECT id FROM enum_object_type WHERE name=$1'
LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT;
