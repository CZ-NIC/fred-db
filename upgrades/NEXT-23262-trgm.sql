CREATE EXTENSION pg_trgm;-- postgresql-contrib-9.6 must be installed
CREATE EXTENSION unaccent;

CREATE OR REPLACE FUNCTION f_unaccent(TEXT) -- unaccent is STABLE not IMMUTABLE
  RETURNS text AS
  $func$
    SELECT public.unaccent('public.unaccent', $1)  -- schema-qualify function and dictionary
  $func$
LANGUAGE sql
IMMUTABLE; -- f_unaccent is IMMUTABLE unlike unaccent which is STABLE

CREATE OR REPLACE FUNCTION unaccent_streets(TEXT,TEXT,TEXT)
  RETURNS TEXT AS
  $func$
    SELECT f_unaccent(COALESCE($1,'')||COALESCE(' '||$2,'')||COALESCE(' '||$3,''))
  $func$
LANGUAGE sql
IMMUTABLE;

CREATE INDEX object_registry_name_trgm_idx ON object_registry USING GIST (name gist_trgm_ops) WHERE erdate IS NULL;

CREATE INDEX contact_name_trgm_idx ON contact USING GIST (f_unaccent(name) gist_trgm_ops);
CREATE INDEX contact_organization_trgm_idx ON contact USING GIST (f_unaccent(organization) gist_trgm_ops);
CREATE INDEX contact_streets_trgm_idx ON contact USING GIST (unaccent_streets(street1,street2,street3) gist_trgm_ops);
CREATE INDEX contact_city_trgm_idx ON contact USING GIST (f_unaccent(city) gist_trgm_ops);
CREATE INDEX contact_stateorprovince_trgm_idx ON contact USING GIST (f_unaccent(stateorprovince) gist_trgm_ops);
CREATE INDEX contact_postalcode_trgm_idx ON contact USING GIST (postalcode gist_trgm_ops);
CREATE INDEX contact_telephone_trgm_idx ON contact USING GIST (telephone gist_trgm_ops);
CREATE INDEX contact_fax_trgm_idx ON contact USING GIST (fax gist_trgm_ops);
CREATE INDEX contact_email_trgm_idx ON contact USING GIST (f_unaccent(email) gist_trgm_ops);
CREATE INDEX contact_notifyemail_trgm_idx ON contact USING GIST (f_unaccent(notifyemail) gist_trgm_ops);
CREATE INDEX contact_vat_trgm_idx ON contact USING GIST (vat gist_trgm_ops);
CREATE INDEX contact_ssn_trgm_idx ON contact USING GIST (ssn gist_trgm_ops);

CREATE INDEX contact_address_company_name_trgm_idx ON contact_address USING GIST (f_unaccent(company_name) gist_trgm_ops);
CREATE INDEX contact_address_streets_trgm_idx ON contact_address USING GIST (unaccent_streets(street1,street2,street3) gist_trgm_ops);
CREATE INDEX contact_address_city_trgm_idx ON contact_address USING GIST (f_unaccent(city) gist_trgm_ops);
CREATE INDEX contact_address_stateorprovince_trgm_idx ON contact_address USING GIST (f_unaccent(stateorprovince) gist_trgm_ops);
CREATE INDEX contact_address_postalcode_trgm_idx ON contact_address USING GIST (postalcode gist_trgm_ops);
