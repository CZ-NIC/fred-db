
CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
Zone INTEGER REFERENCES Zone (ID),
typ integer default 0,  -- typ faktury 1 zalohova 0 normalni
pref varchar(16),  -- prefix
num int,  -- pocet null rad
counter int-- citac
);

-- 4 rady faktur ( 2) zalohove pro CZ a ENUM
insert into invoice_prefix values ( 1 , 3 ,  1 , 'Z2006-CZ-'  ,  6  , 1 );
insert into invoice_prefix values ( 2 , 1  , 1 , 'Z2006-ENUM-'  ,  6  ,  1);
-- dve rady normalni
insert into invoice_prefix values ( 3 , 3 ,  0  , 'F2006-CZ-' , 6 , 1 );
insert into invoice_prefix values ( 4 , 1 ,  0  , 'F2006-ENUM-' , 6  , 1 );


-- invoice  Zalohove faktury 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
Zone INTEGER REFERENCES Zone (ID),
CrDate timestamp NOT NULL DEFAULT now(),  -- datum a cas vytvoreni
-- ZdDate date NOT NULL, -- datum zdanitelneho plneni 
FromDate timestamp default NULL , -- datum zuctovaciho odobi od-do
ToDate timestamp default NULL , -- do datumu
payment integer default 1, -- typ platby 1 ( bankovnim prevodem )
prefix varchar(24) UNIQUE NOT NULL , -- cislo  faktury z invoice_prefix.prefix a counter
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora
-- TODO registrarhistoryID pro odkazy na spravne adresy ICO a DIC
Credit numeric(10,2) NOT NULL DEFAULT 0.0, -- kredit ze ktereho se cerpa az do nuly 
Price numeric(10,2) NOT NULL DEFAULT 0.0, -- vyse faktury i s dani
VAT integer  NOT NULL  DEFAULT 19, -- vyse dane 19%
total numeric(10,2) NOT NULL DEFAULT 0.0,  -- castka bez dane
totalVAT numeric(10,2) NOT NULL DEFAULT 0.0  -- odvedena dan
);



-- TODO do normalnich uctovacich faktur udelat zucotvaci obdobi od kdy do kdy.

-- pri uctovani se odecitaji ze zalohovych faktur 
-- muze se vyskytnout ze jeden objekt je zuctovan dvakrat pokazde z jinne zalohove faktury
CREATE TABLE invoice_object_registry
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
invoiceID INTEGER REFERENCES Invoice (ID) , -- id ostre faktury na ktere je polozka vedena
CrDate timestamp NOT NULL DEFAULT now(),  -- datum a cas zuctovani
objectID integer  REFERENCES object_registry (id),
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora 
operation INTEGER NOT NULL REFERENCES enum_operation, -- typ operace registrace ci prodlouzeni
ExDate date NOT NULL  -- vysledny ExDate
);


CREATE TABLE invoice_object_registry_price_map
(
id INTEGER REFERENCES invoice_object_registry(ID),
InvoiceID INTEGER REFERENCES Invoice (ID), -- id zalohove faktury
price numeric(10,2) NOT NULL default 0 , -- cena za operaci
PRIMARY KEY (id ,  InvoiceID  ) -- unikatni klic
);

