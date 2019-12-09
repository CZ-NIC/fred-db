CREATE OR REPLACE FUNCTION f_unaccent(TEXT)  -- unaccent is STABLE not IMMUTABLE
    RETURNS text AS
    $func$
        SELECT public.unaccent('public.unaccent', $1)  -- schema-qualify function and dictionary
    $func$
LANGUAGE sql
IMMUTABLE;  -- f_unaccent is IMMUTABLE unlike unaccent which is STABLE

CREATE OR REPLACE FUNCTION unaccent_streets(TEXT, TEXT, TEXT)
    RETURNS TEXT AS
    $func$
        SELECT f_unaccent(COALESCE($1, '') || COALESCE(' ' || $2, '') || COALESCE(' ' || $3, ''))
    $func$
LANGUAGE sql
IMMUTABLE
SET search_path = 'public';


CREATE INDEX CONCURRENTLY object_registry_contact_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('contact'::TEXT);

CREATE INDEX CONCURRENTLY object_registry_domain_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('domain'::TEXT);

CREATE INDEX CONCURRENTLY object_registry_keyset_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('keyset'::TEXT);

CREATE INDEX CONCURRENTLY object_registry_nsset_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type = get_object_type_id('nsset'::TEXT);


CREATE INDEX CONCURRENTLY contact_history_name_trgm_idx ON contact_history
       USING GIN (f_unaccent(name) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_organization_trgm_idx ON contact_history
       USING GIN (f_unaccent(organization) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_streets_trgm_idx ON contact_history
       USING GIN (unaccent_streets(street1, street2, street3) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_city_trgm_idx ON contact_history
       USING GIN (f_unaccent(city) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_stateorprovince_trgm_idx ON contact_history
       USING GIN (f_unaccent(stateorprovince) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_postalcode_trgm_idx ON contact_history
       USING GIN (postalcode gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_telephone_trgm_idx ON contact_history
       USING GIN (telephone gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_fax_trgm_idx ON contact_history
       USING GIN (fax gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_email_trgm_idx ON contact_history
       USING GIN (f_unaccent(email) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_notifyemail_trgm_idx ON contact_history
       USING GIN (f_unaccent(notifyemail) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_vat_trgm_idx ON contact_history
       USING GIN (vat gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_history_ssn_trgm_idx ON contact_history
       USING GIN (ssn gin_trgm_ops);


CREATE INDEX CONCURRENTLY contact_address_history_company_name_trgm_idx ON contact_address_history
       USING GIN (f_unaccent(company_name) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_address_history_streets_trgm_idx ON contact_address_history
       USING GIN (unaccent_streets(street1, street2, street3) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_address_history_city_trgm_idx ON contact_address_history
       USING GIN (f_unaccent(city) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_address_history_stateorprovince_trgm_idx ON contact_address_history
       USING GIN (f_unaccent(stateorprovince) gin_trgm_ops);

CREATE INDEX CONCURRENTLY contact_address_history_postalcode_trgm_idx ON contact_address_history
       USING GIN (postalcode gin_trgm_ops);


CREATE INDEX CONCURRENTLY dnskey_history_key_idx ON dnskey_history(key);

CREATE INDEX CONCURRENTLY host_history_fqdn_trgm_idx ON host_history
       USING GIN (fqdn gin_trgm_ops);

CREATE INDEX CONCURRENTLY host_ipaddr_map_history_key_idx ON host_ipaddr_map_history(ipaddr);
