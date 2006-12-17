
-- smaz tabulky
-- drop table invoice;
-- drop table invoice_prefix;

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


-- invoice  faktury (zolohove i normalni)
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
typ integer default 0, -- typ faktury 1 zalohova 2 normalni
CrDate timestamp NOT NULL DEFAULT now(),  -- datum a cas vytvoreni
prefix varchar(24) UNIQUE NOT NULL , -- cislo  faktury z invoice_prefix.prefix a counter
registarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora kteremu byla faktura vystavena
Credit numeric(10,2) NOT NULL DEFAULT 0.0, -- kredit ze ktereho se cerpa az do nuly 
Price numeric(10,2) NOT NULL DEFAULT 0.0, -- vyse faktury i s dani
numVAT integer  NOT NULL  DEFAULT 19, -- vyse dane 19%
total numeric(10,2) NOT NULL DEFAULT 0.0,  -- castka bez dane
vat numeric(10,2) NOT NULL DEFAULT 0.0  -- odvedena dan
);

-- payment int NOT NULL DEFAULT 1,  -- typ platby 1 prevodem 2 hotove 3
-- TODO
-- nutno zkopirovat vsechny udaje o adrese z tabulky registar
--        Name varchar(128),
--        Organization varchar(128),
--        Street varchar(128),
--        City varchar(128),
--        PostalCode varchar(32),
--        Country char(2) REFERENCES enum_country,
--        Telephone varchar(32),
--        Fax varchar(32),
--        Email varchar(128),
-- specificke udaje
--ICO  varchar(32),
--DIC  varchar(32)


-- tabulka pro odcerpany credit ze zalohovych faktur
CREATE TABLE invoice_credit
(
ID serial PRIMARY KEY,
InvoiceID INTEGER REFERENCES Invoice (ID),  -- normalni ucetovaci faktura
aInvoiceID INTEGER REFERENCES Invoice (ID),  -- zalohova faktura ze ktere bylo cerpano
Total numeric(10,2) NOT NULL default 0 -- kolik creditu odcerpano
);


CREATE TABLE invoice_object_registry
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
InvoiceID INTEGER REFERENCES Invoice (ID), -- id uctovaci faktury po uzavreni
CrDate timestamp NOT NULL DEFAULT now(),  -- datum a cas zuctovani
objectID integer  REFERENCES object_registry (id),
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora 
Zone INTEGER REFERENCES Zone (ID),
action INTEGER NOT NULL REFERENCES enum_action, -- typ funkce z DomainCreate ci DomainRenew
ExDate date NOT NULL , -- vysledny ExDate
price numeric(10,2) NOT NULL default 0 -- cena za operaci
);

