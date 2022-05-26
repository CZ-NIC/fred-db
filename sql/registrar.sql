-- DROP TABLE Registrar CASCADE;
CREATE TABLE Registrar (
  ID SERIAL CONSTRAINT registrar_pkey PRIMARY KEY,
  ICO  varchar(50), -- ICO of registrar
  DIC  varchar(50), -- DIC of registrar
  varsymb  char(10) CONSTRAINT registrar_varsymb_key UNIQUE, -- coupling variable symbol ( ico )
  VAT boolean NOT NULL DEFAULT True,
  Handle varchar(255) CONSTRAINT registrar_handle_key UNIQUE NOT NULL,
  Name varchar(1024),
  Organization varchar(1024),
  Street1 varchar(1024),
  Street2 varchar(1024),
  Street3 varchar(1024),
  City varchar(1024),
  StateOrProvince varchar(1024),
  PostalCode varchar(32),
  Country char(2) CONSTRAINT registrar_country_fkey REFERENCES enum_country,
  Telephone varchar(32),
  Fax varchar(32),
  Email varchar(1024),
  Url varchar(1024),
  System bool default false,
  Regex varchar(30) default NULL,
  is_internal bool NOT NULL default false,
  uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid()
);

comment on table Registrar is 'Evidence of registrars, who can create or change administered object via register';
comment on column Registrar.ID is 'unique automatically generated identifier';
comment on column Registrar.ICO is 'organization identification number';
comment on column Registrar.DIC is 'tax identification number';
comment on column Registrar.varsymb is 'coupling variable symbol (ico)';
comment on column Registrar.VAT is 'whether VAT should be counted in invoicing';
comment on column Registrar.Handle is 'unique text string identifying registrar, it is generated by system admin when new registrar is created';
comment on column Registrar.Name is 'registrats name';
comment on column Registrar.Organization is 'Official company name';
comment on column Registrar.Street1 is 'part of address';
comment on column Registrar.Street2 is 'part of address';
comment on column Registrar.Street3 is 'part of address';
comment on column Registrar.City is 'part of address - city';
comment on column Registrar.StateOrProvince is 'part of address - region';
comment on column Registrar.PostalCode is 'part of address - postal code';
comment on column Registrar.Country is 'code for country from enum_country table';
comment on column Registrar.Telephone is 'phone number';
comment on column Registrar.Fax is 'fax number';
comment on column Registrar.Email is 'e-mail address';
comment on column Registrar.Url is 'registrars web address';
comment on column Registrar.Uuid is 'uuid for external reference';

-- DROP TABLE registraracl CASCADE;
CREATE TABLE registraracl (
  id SERIAL CONSTRAINT registraracl_pkey PRIMARY KEY,
  registrarid INTEGER NOT NULL CONSTRAINT registraracl_registrarid_fkey REFERENCES registrar,
  cert VARCHAR(1024) NOT NULL, -- certificate fingerprint
  password VARCHAR(1024) NOT NULL, -- password data
  CONSTRAINT registraracl_registrarid_cert_fkey UNIQUE (registrarid,cert)
);

COMMENT ON TABLE registraracl IS 'Registrars login information';
COMMENT ON COLUMN registraracl.cert IS 'fingerprint of registrar''s certificate';
COMMENT ON COLUMN registraracl.password IS 'data generated by password hashing function';

CREATE TABLE RegistrarInvoice (
  ID SERIAL CONSTRAINT registrarinvoice_pkey PRIMARY KEY,
  RegistrarID INTEGER NOT NULL CONSTRAINT registrarinvoice_registrarid_fkey REFERENCES Registrar, -- registrar id
  Zone integer NOT NULL CONSTRAINT registrarinvoice_zone_fkey REFERENCES Zone,  --  zone for which has registrar an access
  FromDate date NOT NULL , -- date when began registrar work in a zone
  toDate date -- after this date registrar is not allowed to register
);

comment on column RegistrarInvoice.Zone is 'zone for which has registrar an access';
comment on column RegistrarInvoice.FromDate is 'date when began registrar work in a zone';
comment on column RegistrarInvoice.toDate is 'after this date, registrar is not allowed to register';
