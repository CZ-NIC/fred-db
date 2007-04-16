-- DROP TABLE Registrar CASCADE;
CREATE TABLE Registrar (
  ID SERIAL PRIMARY KEY,
  ICO  char(10), -- ICO registratora 
  DIC  char(15), -- DIC registratora
  varsymb  char(10)  , -- parovaci variabilni symbol (ico )
  VAT boolean DEFAULT True, --jestli se ma zapocitavat DPH pri fakturaci
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
  RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registratora
  Zone integer REFERENCES Zone,  --  zona pro kterou ma registratrio pristup
  FromDate date DEFAULT NULL , -- datum kdy zacal registrator pracovat v dane zone
  LastDate date DEFAULT NULL  -- datum kdy byla naposledy vyvorena faktura
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

-- pro defualt prihlaseni REG-LRR
INSERT INTO  RegistrarACL 
VALUES (1, 1, 'AE:B3:5F:FA:38:80:DB:37:53:6A:3E:D4:55:E2:91:97', '123456789');
INSERT INTO  RegistrarACL 
VALUES (2, 2, 'AE:B3:5F:FA:38:80:DB:37:53:6A:3E:D4:55:E2:91:97', '123456789');

