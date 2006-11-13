
-- ciselnik bank
CREATE TABLE enum_bank_code (
code char(4) PRIMARY KEY,
name_short varchar(4) UNIQUE NOT NULL , -- zkratka
name_full varchar(64) UNIQUE  NOT NULL -- uplny nazev
);
                                 
-- ACCOUNT -- tabulka nasich uctu
CREATE TABLE account 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_number char(16) UNIQUE NOT NULL , -- cislo uctu
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
balance  money -- aktualni zustatek 
);

-- bankovni vypisy 
CREATE TABLE BANK_STATEMENT_HEAD 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_id int  REFERENCES account, -- zpracovani pro dany ucet odkaz to tabulky account
statement_from date, -- vypis za obdobi OD - DO
statement_to date, -- do
balance_in money, -- pocatecni zustatek
balance_out money,  -- konecny zustatek
receipts   money, -- prijmy za behem vypisu
expenditures money -- vydaje behem vypisu
);


-- polozky vypisu
CREATE TABLE BANK_STATEMENT_ITEM
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
statement_id int  REFERENCES BANK_STATEMENT_HEAD, -- odkaz do tabulky hlavicek vypisu
account_number char(16) UNIQUE NOT NULL , -- cislo uctu ze ktereho prisla nebo kam byla odeslana platba
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
KS char(10), -- konstantni symbol
VS char(10), -- konstantni symbol
SS char(10), -- konstantni symbol
price money,  -- zuctovana castka  pokud je debet zaporna castka
mem  varchar(64) -- poznamka
);




