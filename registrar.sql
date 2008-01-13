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

-- DROP TABLE RegistrarACL CASCADE;
CREATE TABLE RegistrarACL (
  ID SERIAL PRIMARY KEY,
  RegistrarID INTEGER NOT NULL REFERENCES Registrar,
  Cert varchar(1024) NOT NULL, -- certificate fingerprint
  Password varchar(64) NOT NULL
);

CREATE TABLE RegistrarInvoice (       
  ID SERIAL PRIMARY KEY,
  RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- registrar id 
  Zone integer NOT NULL REFERENCES Zone,  --  zone for which has registrar an access
  FromDate date NOT NULL , -- date when began registrar work in a zone
  LastDate date  -- date when was last created an invoice 
);

-- testing registrar
INSERT INTO Registrar (id, handle, system, organization, name, url, country) 
VALUES(1, 'REG-FRED_A', 'f', 'Testing registrar A', 'Company l.t.d.', 
       'www.nic.cz', 'CZ');

INSERT INTO Registrar (id, handle, system, organization, name, url, country) 
VALUES(2, 'REG-FRED_B', 'f', 'Testing registrar B', 'Company l.t.d.', 
       'www.nic.cz', 'CZ');

-- REG-FRED_A zone enum a .cz
INSERT INTO  RegistrarInvoice VALUES ( 1 , 1  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 2 , 1  , 3 , '2007-01-01' , NULL ); 
-- REG-FRED_B  zone enum a .cz
INSERT INTO  RegistrarInvoice VALUES ( 3 , 2  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 4 , 2  , 3 , '2007-01-01' , NULL ); 

-- for default login REG-LRR
INSERT INTO  RegistrarACL 
VALUES (1, 1, '60:7E:DF:39:62:C3:9D:3C:EB:5A:87:80:C1:73:4F:99', '123456789');
INSERT INTO  RegistrarACL 
VALUES (2, 2, '60:7E:DF:39:62:C3:9D:3C:EB:5A:87:80:C1:73:4F:99', '123456789');
INSERT INTO  RegistrarACL 
VALUES (3, 1, '39:D1:0C:CA:05:3A:CC:C0:0B:EC:6F:3F:81:0D:C7:9E', 'passwd');
INSERT INTO  RegistrarACL 
VALUES (4, 2, '39:D1:0C:CA:05:3A:CC:C0:0B:EC:6F:3F:81:0D:C7:9E', 'passwd');

