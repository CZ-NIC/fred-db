

-- TODO dodelat cislenik prefixu pro kazdy rok aby se zvladnul prechod mezi roky
CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
Zone INTEGER REFERENCES Zone (ID),
typ integer default 0,  -- typ faktury 0 zalohova 1 normalni
year numeric NOT NULL, --pro jaky rok  
prefix integer -- citac s prefixem ciselne rady fakrru 
);

-- zona enum
-- zalohove
insert into invoice_prefix values ( 1 , 1 ,  0 , 2007 , 110700001 );
-- vyuctovaci 
insert into invoice_prefix values ( 2 , 1 ,  1 , 2007 , 120700001 );
-- zona CZ
-- zalohove
insert into invoice_prefix values ( 3 , 3 ,  0 , 2007 , 130700001 );
-- vyuctovaci
insert into invoice_prefix values ( 4 , 3 ,  1 , 2007 , 140700001 );
 
 


-- taulka fakturaci ucetnich faltur od do a id faktury pokud je NULL neni vyuctovaci faktura vystavena



-- invoice  Zalohove faktury 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
Zone INTEGER REFERENCES Zone (ID),
CrDate timestamp NOT NULL DEFAULT now(),  -- datum a cas vytvoreni faktury
TaxDate date  , -- datum zdanitelneho plneni ( kdy prisla platba u zalohove FA)
prefix_type INTEGER REFERENCES invoice_prefix(ID), --  typ faktury z jakeho je roku a jakeho je typu dle prefixu
prefix integer UNIQUE default NULL , -- deviti mistne  cislo faktury z invoice_prefix.prefix pocitano dle TaxDate
                                     -- pokud je NULL je to vypis vyuctovani za sluzby  vyuctovaci faktura se neuvadi je to typ 2 
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora
-- TODO registrarhistoryID pro odkazy na spravne adresy ICO a DIC
Credit numeric(10,2)  DEFAULT 0.0, -- kredit ze ktereho se cerpa az do nuly pokud NULL je to vyctovaci faktura
Price numeric(10,2) NOT NULL DEFAULT 0.0, -- vyse faktury i s dani
VAT integer NOT NULL  DEFAULT 19, -- vyse dane 19% (0) pro vyctovaci
total numeric(10,2) NOT NULL  DEFAULT 0.0 ,  -- castka bez dane ( pro vyctvovaci stejny jako price=total castka bez dane);
totalVAT numeric(10,2)  NOT NULL DEFAULT 0.0  -- odvedena dan ( 0 pro vyctovaci dan je odvedena na zalohovych FA )
);

-- generovani faktur
CREATE TABLE invoice_generation
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
FromDate timestamp NOT  NULL , -- datum zuctovaciho odobi od-do
ToDate timestamp NOT NULL DEFAULT now() , -- do datumu
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora
Zone INTEGER REFERENCES Zone (ID),
InvoiceID INTEGER REFERENCES Invoice (ID) -- id vyuctovaci faktury
);

--  tabulka vyuctovani zalohovych Faktur
CREATE TABLE invoice_credit_payment_map
(
invoiceID INTEGER REFERENCES Invoice (ID) , -- id vyuctovaci faktury
ainvoiceID INTEGER REFERENCES Invoice (ID) , -- id zalohove faktury
credit numeric(10,2)  NOT NULL DEFAULT 0.0, -- strzeny  kredit
balance numeric(10,2)  NOT NULL DEFAULT 0.0, -- aktualni zustatek dane zalohova FAKTURY
PRIMARY KEY (invoiceID, ainvoiceID)
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
zone INTEGER REFERENCES Zone (ID),
registrarID INTEGER NOT NULL REFERENCES Registrar, -- odkaz na registratora 
operation INTEGER NOT NULL REFERENCES enum_operation, -- typ operace registrace ci prodlouzeni
period integer default 0, -- pocet jednotek na prodlouzeni ve mesicich
ExDate date default NULL  -- vysledny ExDate pouze pro RENEW
);


CREATE TABLE invoice_object_registry_price_map
(
id INTEGER REFERENCES invoice_object_registry(ID),
InvoiceID INTEGER REFERENCES Invoice (ID), -- id zalohove faktury
price numeric(10,2) NOT NULL default 0 , -- cena za operaci
price_balance numeric(10,2) NOT NULL default 0 , -- aktualni  zustatek creditu na dane zalohove FA
PRIMARY KEY (id ,  InvoiceID  ) -- unikatni klic
);

