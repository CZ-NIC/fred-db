
-- ciselnik bank
CREATE TABLE enum_bank_code (
code char(4) PRIMARY KEY,
name_short varchar(4) UNIQUE NOT NULL , -- zkratka
name_full varchar(64) UNIQUE  NOT NULL -- uplny nazev
);

                                   
-- ACCOUNT -- tabulka nasich uctu
CREATE TABLE bank_account 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_number char(16) UNIQUE NOT NULL , -- cislo uctu
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
balance  numeric(10,2), -- aktualni zustatek 
last_date date, -- datum posledniho vypisu 
last_num int  -- cislo posledniho vypisu
);

-- bankovni vypisy 
CREATE TABLE BANK_STATEMENT_HEAD 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_id int  REFERENCES bank_account, -- zpracovani pro dany ucet odkaz to tabulky account
num int, -- poradove cislo vypisu
create_date date NOT NULL, --  datum vytvoreni vypisu
balance_old_date date NOT NULL , -- datum starehi zustatku
balance_old numeric(10,2) NOT NULL, -- stary zustatek
balance_new numeric(10,2) NOT NULL,  -- novy zustatek
balance_credit  numeric(10,2) NOT NULL, -- prijmy za behem vypisu (creditni obrat )
balence_debet numeric(10,2) NOT NULL -- vydaje behem vypisu  ( debetni obrat )
);


-- polozky vypisu
CREATE TABLE BANK_STATEMENT_ITEM
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
statement_id int  REFERENCES BANK_STATEMENT_HEAD, -- odkaz do tabulky hlavicek vypisu
account_number char(16) UNIQUE NOT NULL , -- cislo protiuctu ze ktereho prisla nebo kam byla odeslana platba
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
code int, -- kod uctovani 1 polozka debet 2 polozka credit 4 storno debet 5 storno kredit 
KS char(10), -- konstantni symbol (obsahuje i kod banky )
VS char(10), -- konstantni symbol
SS char(10), -- konstantni symbol
price numeric(10,2) NOT NULL,  -- zuctovana castka  pokud je debet zaporna castka
evid varchar(20), --cislo dokladu
mem  varchar(64) -- poznamka
);




