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


CREATE INDEX object_registry_name_trgm_idx ON object_registry
       USING GIST (name gist_trgm_ops) WHERE erdate IS NULL;


CREATE INDEX contact_name_trgm_idx ON contact
       USING GIST (f_unaccent(name) gist_trgm_ops);

CREATE INDEX contact_organization_trgm_idx ON contact
       USING GIST (f_unaccent(organization) gist_trgm_ops);

CREATE INDEX contact_streets_trgm_idx ON contact
       USING GIST (unaccent_streets(street1, street2, street3) gist_trgm_ops);

CREATE INDEX contact_city_trgm_idx ON contact
       USING GIST (f_unaccent(city) gist_trgm_ops);

CREATE INDEX contact_stateorprovince_trgm_idx ON contact
       USING GIST (f_unaccent(stateorprovince) gist_trgm_ops);

CREATE INDEX contact_postalcode_trgm_idx ON contact
       USING GIST (postalcode gist_trgm_ops);

CREATE INDEX contact_telephone_trgm_idx ON contact
       USING GIST (telephone gist_trgm_ops);

CREATE INDEX contact_fax_trgm_idx ON contact
       USING GIST (fax gist_trgm_ops);

CREATE INDEX contact_email_trgm_idx ON contact
       USING GIST (f_unaccent(email) gist_trgm_ops);

CREATE INDEX contact_notifyemail_trgm_idx ON contact
       USING GIST (f_unaccent(notifyemail) gist_trgm_ops);

CREATE INDEX contact_vat_trgm_idx ON contact
       USING GIST (vat gist_trgm_ops);

CREATE INDEX contact_ssn_trgm_idx ON contact
       USING GIST (ssn gist_trgm_ops);


CREATE INDEX contact_address_company_name_trgm_idx ON contact_address
       USING GIST (f_unaccent(company_name) gist_trgm_ops);

CREATE INDEX contact_address_streets_trgm_idx ON contact_address
       USING GIST (unaccent_streets(street1, street2, street3) gist_trgm_ops);

CREATE INDEX contact_address_city_trgm_idx ON contact_address
       USING GIST (f_unaccent(city) gist_trgm_ops);

CREATE INDEX contact_address_stateorprovince_trgm_idx ON contact_address
       USING GIST (f_unaccent(stateorprovince) gist_trgm_ops);

CREATE INDEX contact_address_postalcode_trgm_idx ON contact_address
       USING GIST (postalcode gist_trgm_ops);


CREATE INDEX CONCURRENTLY object_registry_contact_name_trgm_idx ON object_registry
       USING GIN (name gin_trgm_ops) WHERE type=get_object_type_id('contact'::TEXT);


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
