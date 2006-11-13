
-- ciselnik bank
CREATE TABLE enum_bank_code (
code char(4) PRIMARY KEY,
name_short varchar(4) UNIQUE NOT NULL , -- zkratka
name_full varchar(64) UNIQUE  NOT NULL -- uplny nazev
);

CREATE TABLE enum_bank_type (
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
inout boolean, -- prijem true vydej false
name varchar(32) -- nazev operace
);

INSERT INTO enum_bank_type VALUES ( 100 , 'f' , 'bankovni poplatky' );
INSERT INTO enum_bank_type VALUES ( 20 , 't' , 'prevod na ucet' );
INSERT INTO enum_bank_type VALUES ( 21 , 't' , 'trvaly prevod na ucet' );
INSERT INTO enum_bank_type VALUES ( 30 ,  'f' , 'odchozi platba' ); 
  
                                 
-- ACCOUNT -- tabulka nasich uctu
CREATE TABLE account 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_number char(16) UNIQUE NOT NULL , -- cislo uctu
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
balance  numeric(10,2), -- aktualni zustatek 
last_statement date -- do jakeho data byl nacten vypis z banky
);

-- bankovni vypisy 
CREATE TABLE BANK_STATEMENT_HEAD 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_id int  REFERENCES account, -- zpracovani pro dany ucet odkaz to tabulky account
statement_from date NOT NULL, -- vypis za obdobi OD - DO
statement_to date NOT NULL , -- do
balance_in numeric(10,2) NOT NULL, -- pocatecni zustatek
balance_out numeric(10,2) NOT NULL ,  -- konecny zustatek
receipts   numeric(10,2) NOT NULL, -- prijmy za behem vypisu
expenditures numeric(10,2) NOT NULL -- vydaje behem vypisu
);


-- polozky vypisu
CREATE TABLE BANK_STATEMENT_ITEM
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
statement_id int  REFERENCES BANK_STATEMENT_HEAD, -- odkaz do tabulky hlavicek vypisu
account_number char(16) UNIQUE NOT NULL , -- cislo uctu ze ktereho prisla nebo kam byla odeslana platba
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
typ int  REFERENCES  enum_bank_type, -- typ operace prevod na ucet bankovni poplatek urok atd.
KS char(10), -- konstantni symbol
VS char(10), -- konstantni symbol
SS char(10), -- konstantni symbol
price numeric(10,2) NOT NULL,  -- zuctovana castka  pokud je debet zaporna castka
mem  varchar(64) -- poznamka
);




