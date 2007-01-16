
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


-- DELETE FROM Registrar;
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES( 100,    'REG-GENERAL-REGISTRY' ,  'GENERAL REGISTRY, s.r.o.' ,     'DomainMaster',   'www.domainmaster.cz');
INSERT INTO Registrar ( id,  handle ,organization , name , url ) VALUES( 300 ,   'REG-ACTIVE24'  ,'ACTIVE 24, s. r. o.' ,    'DOMENY.CZ' , 'www.domeny.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES( 400 ,  'REG-HAVEL'  ,'ha-vel internet s.r.o.' ,       'ha-vel' , 'domeny.ha-vel.cz');
INSERT INTO Registrar ( id,   handle ,organization , name , url ) VALUES( 500,  'REG-IGNUM'   , 'IGNUM, s.r.o.' ,                 'DOMENA.CZ' ,   ' www.domena.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES( 600 ,   'REG-INTERNET-CZ',  'INTERNET CZ, a.s.' ,       'Velkoobchod domen' ,  'domeny.velkoobchod.cz');
INSERT INTO Registrar ( id, handle ,organization , name , url ) VALUES( 700,    'REG-MIRAMO' , 'MIRAMO spol. s r.o.' ,          '9net.cz' ,  'www.9net.cz');
INSERT INTO Registrar ( id,  handle ,organization , name , url ) VALUES( 800,   'REG-ZONER' , 'ZONER software, s.r.o.' ,       'RegZone!' ,  'www.regZone.cz');
INSERT INTO Registrar ( id, handle ,organization , name , url ) VALUES( 200,  'REG-CT'   , 'CESKY TELECOM, a.s.' ,          'Internet OnLine' , 'domeny.iol.cz');
INSERT INTO Registrar ( id,  handle ,organization , name , url ) VALUES( 110,  'REG-KRAXNET'  ,   'KRAXNET s.r.o.' ,               'XNET'   ,   'www.xnet.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES(120,    'REG-MEDIA4WEB',    'Media4web s.r.o.' ,          'Media4web'   , 'www.media4web.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES(130,  'REG-ONE'   ,   'ONE.CZ s.r.o.' ,                 'REGISTRATOR.CZ'  , 'www.registrator.cz');
INSERT INTO Registrar ( id, handle ,organization , name , url ) VALUES( 140,  'REG-WEB4U'  ,'Web4U s.r.o.' ,                  'Sprava domen',  'www.spravadomen.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES( 150 , 'REG-NEXTRA' ,  'NEXTRA Czech Republic s.r.o.' ,  'NEXTRA'   ,   'domeny.nextra.cz');
INSERT INTO Registrar ( id, handle , organization , name , url ) VALUES( 160 , 'REG-IPEX'  , 'IPEX a.s.'              ,       'IPEX'        ,    'www.ipex.cz');
INSERT INTO Registrar ( id, handle ,organization , name , url ) VALUES( 170 ,  'REG-SKYNET',   'SkyNet, a.s.'            ,      'SkyNet'    ,        'www.skynet.cz');
INSERT INTO Registrar ( id, handle ,organization , name , url ) VALUES( 1,   'REG-LRR',    'CZ.NIC, z.s.p.o.'          ,    'LRR'         ,      'www.lrr.cz');

INSERT INTO Registrar ( id, handle , name  ) VALUES( 2,  '{1 , 2 , 3 }' , 'REG-LRR2',    'LRR2'   );

-- prace s danou zonou
-- REG-LRR zone enum a .cz
INSERT INTO  RegistrarInvoice VALUES ( 1 , 1  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 2 , 1  , 3 , '2007-01-01' , NULL ); 
-- REG-LRR2  zone enum a .cz
INSERT INTO  RegistrarInvoice VALUES ( 3 , 2  , 1 , '2007-01-01' , NULL );
INSERT INTO  RegistrarInvoice VALUES ( 4 , 2  , 3 , '2007-01-01' , NULL ); 


-- pro defualt prihlaseni
INSERT INTO  RegistrarACL values ( 1 , 1 , 'AE:B3:5F:FA:38:80:DB:37:53:6A:3E:D4:55:E2:91:97' , '123456789' );
INSERT INTO  RegistrarACL values ( 2 , 2 , 'AE:B3:5F:FA:38:80:DB:37:53:6A:3E:D4:55:E2:91:97' , '123456789' );

