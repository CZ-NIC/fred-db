-- DROP TABLE Registrar CASCADE;
CREATE TABLE Registrar (
  ID SERIAL PRIMARY KEY,
  ICO  char(10), -- ICO of registrar
  DIC  char(15), -- DIC of registrar
  varsymb  char(10)  , -- coupling variable symbol ( ico )
  VAT boolean DEFAULT True, -- whether VAT should be count by invoicing 
  Handle varchar(255) UNIQUE NOT NULL,
  Name varchar(1024),
  Organization varchar(1024),
  Street1 varchar(1024),
  Street2 varchar(1024),
  Street3 varchar(1024),
  City varchar(1024),
  StateOrProvince varchar(1024),
  PostalCode varchar(32),
  Country char(2) REFERENCES enum_country,
  Telephone varchar(32),
  Fax varchar(32),
  Email varchar(1024),
  Url varchar(1024),
  System bool default false
);

comment on table Registrar is 'Evidence of registrars, who can create or change administered object via register';
comment on column Registrar.ID is 'unique automatically generated identifier';
comment on column Registrar.ICO is 'organization identification number';
comment on column Registrar.DIC is 'tax identification number';
comment on column Registrar.varsymb is 'coupling variable symbol (ico)';
comment on column Registrar.VAT is 'whether VAT should be count in invoicing';
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

-- DROP TABLE RegistrarACL CASCADE;
CREATE TABLE RegistrarACL (
  ID SERIAL PRIMARY KEY,
  RegistrarID INTEGER NOT NULL REFERENCES Registrar,
  Cert varchar(1024) NOT NULL, -- certificate fingerprint
  Password varchar(64) NOT NULL
);

comment on table RegistrarACL is 'Registrars login information';
comment on column RegistrarACL.Cert is 'certificate fingerprint';
comment on column RegistrarACL.Password is 'login password';

CREATE TABLE RegistrarInvoice (       
  ID SERIAL PRIMARY KEY,
  RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- registrar id 
  Zone integer NOT NULL REFERENCES Zone,  --  zone for which has registrar an access
  FromDate date NOT NULL , -- date when began registrar work in a zone
  LastDate date  -- date when was last created an invoice 
);

comment on column RegistrarInvoice.Zone is 'zone for which has registrar an access';
comment on column RegistrarInvoice.FromDate is 'date when began registrar work in a zone';
comment on column RegistrarInvoice.LastDate is 'date when was last created an invoice';

