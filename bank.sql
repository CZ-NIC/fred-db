
-- zrus tabulky
-- drop table banking_invoice_varsym_map;
-- drop table BANK_STATEMENT_ITEM;
-- drop table BANK_STATEMENT_HEAD;
-- drop table bank_account;

-- ciselnik bank
-- CREATE TABLE enum_bank_code (
-- code char(4) PRIMARY KEY,
-- name_short varchar(4) UNIQUE NOT NULL , -- zkratka
-- name_full varchar(64) UNIQUE  NOT NULL -- uplny nazev
-- );

                                   
-- ACCOUNT -- tabulka nasich uctu
CREATE TABLE bank_account 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
Zone INTEGER REFERENCES Zone (ID), -- pro jakou zony  se ma ucet zpracovavat
account_number char(16) UNIQUE NOT NULL , -- cislo uctu
account_name  char(20) , -- nazev uctu
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
balance  numeric(10,2), -- aktualni zustatek 
last_date date, -- datum posledniho vypisu 
last_num int  -- cislo posledniho vypisu
);

-- parovaci variabilni symbol registratora je v tabulce registrar ( je to jeho ICO pro CZ ) a plati pro vsechny zony

-- testovaci zaznam pro nacteni vypisu
insert into  bank_account values ( 2 , 3 , '188208275' , 'CZNIC ucet CSOB' , '0300' , '130000' , '2006-11-10' , 161  );
insert into bank_account (  id , Zone , account_number , account_name , bank_code )  values ( 1 , 1 , '756' , 'ENUM ucet ebanka' , '2400'   );



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
balance_debet numeric(10,2) NOT NULL -- vydaje behem vypisu  ( debetni obrat )
);


-- polozky vypisu
CREATE TABLE BANK_STATEMENT_ITEM
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
statement_id int  REFERENCES BANK_STATEMENT_HEAD, -- odkaz do tabulky hlavicek vypisu
account_number char(16)  NOT NULL , -- cislo protiuctu ze ktereho prisla nebo kam byla odeslana platba
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
code int, -- kod uctovani 1 polozka debet 2 polozka credit 4 storno debet 5 storno kredit 
KonstSym char(10), -- konstantni symbol (obsahuje i kod banky )
VarSymb char(10), -- konstantni symbol
SpecSymb char(10), -- konstantni symbol
price numeric(10,2) NOT NULL,  -- zuctovana castka  pokud je debet zaporna castka
account_evid varchar(20), --cislo dokladu
account_date date NOT NULL, --  datum zuctovani pripsani na ucet ci odeslani
account_memo  varchar(64), -- poznamka
invoice_ID INTEGER REFERENCES Invoice default NULL -- nula pokud neni prichozi platba zpracovani jinak odkaz na zalohovou fakturu
);




-- polozky ON-LINE vypisu E-BANKA
CREATE TABLE BANK_EBANKA_LIST
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
account_id int  REFERENCES bank_account, -- zpracovany ucet
price numeric(10,2) NOT NULL,  -- prevedena  castka
CrDate  timestamp NOT NULL DEFAULT now(),  -- datum a cas prevodu prevedeneho uz do UTC
account_number char(16)  NOT NULL , -- cislo protiuctu ze ktereho prisla nebo kam byla odeslana platba
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky platce
status int, -- status  0 Nezrealizováno , Zrealizováno , Ukonèeno
KonstSym char(10), -- konstantni symbol platby
VarSymb char(10), -- variabilni symbol platby
memo  varchar(64), -- poznamka
Ident char(10) UNIQUE, -- jednoznacny identifikator platby
invoice_ID INTEGER REFERENCES Invoice default NULL -- nula pokud neni prichozi platba zpracovani jinak odkaz na zalohovou faktu$
);


