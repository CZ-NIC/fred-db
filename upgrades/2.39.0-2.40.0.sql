---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.40.0' WHERE id = 1;


CREATE INDEX CONCURRENTLY object_registry_domain_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('domain'::TEXT);

CREATE INDEX CONCURRENTLY object_registry_keyset_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('keyset'::TEXT);

CREATE INDEX CONCURRENTLY object_registry_nsset_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('nsset'::TEXT);


CREATE INDEX CONCURRENTLY dnskey_history_key_idx ON dnskey_history(key);

CREATE INDEX CONCURRENTLY host_history_fqdn_trgm_idx ON host_history
       USING GIN (fqdn gin_trgm_ops);

CREATE INDEX CONCURRENTLY host_ipaddr_map_history_key_idx ON host_ipaddr_map_history(ipaddr);
