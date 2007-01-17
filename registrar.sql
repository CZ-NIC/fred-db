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
        FromDate timestamp DEFAULT NULL , -- datum kdy zacal registrator pracovat v dane zone
        LastDate timestamp DEFAULT NULL  -- datum kdy byla naposledy vyvorena faktura
        );


-- sytemovy registrator
INSERT INTO Registrar ( id, handle , System , organization , name , url , Country ) 
  VALUES( 1,   'REG-LRR',   't' , 'CZ.NIC, z.s.p.o.'  , 'LRR' ,  'www.nic.cz' , 'CZ' );

-- nutny  pro unit testy REG-LRR2
-- INSERT INTO Registrar ( id, handle , name , System ) VALUES( 200,   'REG-LRR2',    'LRR2'  , 't'  );


INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  ( 2 , 'REG-KRAXNET' , 'KRAXNET, s.r.o.', 'KRAXNET, s.r.o.',  'www.registr-cisel.cz' ,
           'Kamenická 599/26' ,  '170 00' , 'Praha 7' ,  '26460335' , '26460335' , 'CZ26460335', 'CZ' );

INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  (  3  , 'REG-IGNUM' , 'IGNUM, s.r.o.' , 'IGNUM, s.r.o.' , 'www.domena.cz' , 
               'Thámova 18' ,  '186 00' ,  'Praha 8' , '26159708' ,  '26159708' , 'CZ26159708', 'CZ' );

INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  ( 4 , 'REG-IPEX'  ,  'IPEX, a.s.' , 'IPEX, a.s.' , 'www.ipex.cz' , 
         'Široká 37' , '370 01' ,  'České Budějovice' , '45021295' , '45021295' , 'CZ45021295' , 'CZ');
            

INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  (  5 , 'REG-GENREG'  , 'GENERAL REGISTRY, s.r.o.' , 'GENERAL REGISTRY, s.r.o.' ,   'www.domainmaster.cz' , 
         'Novohradská 745/21' , '371 07' , 'České Budějovice' , '26027267' , '26027267' , 'CZ26027267', 'CZ' );


INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  (  6 , 'REG-MATTES' , 'MATTES AD, s.r.o.' , 'MATTES AD, s.r.o.' ,  '802.cz' , 
          'Masarykova 1117'  , '738 01' ,  'Frýdek - Místek' , '42868602' , '42868602' , 'CZ42868602' , 'CZ' );


INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  ( 7  , 'REG-FORPSI' ,  'P.E.S. consulting, s.r.o.'  ,  'P.E.S. consulting, s.r.o.' , 'www.forpsi.com' , 
           'Václavské náměstí 17' , '110 00' , 'Praha 1' , '25124005' , '25124005' , 'CZ25124005' , 'CZ' );
           
INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City, DIC , Country )
VALUES  (   8 , 'REG-EURODNS'  , 'EuroDNS S.A.' , 'EuroDNS S.A.' ,  'www.eurodns.com' , 
            '2, rue Léon Laval' , 'L-3372' ,  'Leudelange' , 'LU19406747' , 'LU' );
            
            
INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  ( 9  , 'REG-ACTIVE'  , 'ACTIVE 24, s.r.o.' , 'ACTIVE 24, s.r.o.' , 'www.active24.cz' , 
           'Pláničkova 1' ,  '162 00' ,  'Praha 6' , '25115804' , '25115804' , 'CZ25115804' , 'CZ' );
 
INSERT INTO Registrar ( id, handle, name,organization , url , Street1 , PostalCode , City,ICO,varsymb, DIC , Country )
VALUES  (  10 ,  'REG-SWS'     ,  'SW Systems s.r.o.' ,  'SW Systems s.r.o.' , 'www.swsystems.cz' , 
           'Bernolákova 1190/4' ,  '142 00' ,  'Praha 4' , '27218791' , '27218791' , 'CZ27218791' , 'CZ' );
 



-- prace s danou zonou
-- REG-LRR zone enum a .cz
--INSERT INTO  RegistrarInvoice VALUES ( 1 , 1  , 1 , '2007-01-01' , NULL );
--INSERT INTO  RegistrarInvoice VALUES ( 2 , 1  , 3 , '2007-01-01' , NULL ); 
--  REG-LRR2  zone enum a .cz
--INSERT INTO  RegistrarInvoice VALUES ( 3 , 2  , 1 , '2007-01-01' , NULL );
--INSERT INTO  RegistrarInvoice VALUES ( 4 , 2  , 3 , '2007-01-01' , NULL ); 

-- registratori 23 .1 predelat na 22.1 2007 od kdy se zacne fakturovat
INSERT INTO  RegistrarInvoice VALUES ( 1 , 1  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 2 , 2  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 3 , 3  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 4 , 4  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 5 , 5  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 6 , 6  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 8 , 7  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 9 , 8  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 10 , 10  , 1 , '2007-01-01' , NULL );



-- pro defualt prihlaseni REG-LRR
INSERT INTO  RegistrarACL values ( 1 , 1 , 'AE:B3:5F:FA:38:80:DB:37:53:6A:3E:D4:55:E2:91:97' , '123456789' );

