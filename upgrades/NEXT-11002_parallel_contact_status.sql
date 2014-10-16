CREATE INDEX object_state_valid_to_idx ON object_state (valid_to);
DROP INDEX object_state_object_id_idx;-- uses object_state_now_idx instead