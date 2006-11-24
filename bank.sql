
-- zrus tabulky
drop table banking_invoice_varsym_map;
drop table BANK_STATEMENT_ITEM;
drop table BANK_STATEMENT_HEAD;
drop table bank_account;

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
account_name  char(20) , -- nazev uctu
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
balance  numeric(10,2), -- aktualni zustatek 
last_date date, -- datum posledniho vypisu 
last_num int  -- cislo posledniho vypisu
);

-- testovaci zaznam pro nacteni vypisu
insert into  bank_account values ( 1 , '188208275' , 'CZNIC ucet CSOB' , '0300' , '130000' , '2006-11-10' , 161  );


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


-- parovani bankovnich vypisu
CREATE TABLE banking_invoice_varsym_map
(
Zone INTEGER REFERENCES Zone (ID), -- pro jakou zony  se ma zpracovavat
account_number char(16)  NOT NULL , -- cislo uctu ze ktereho by mela platba prijit
bank_code char(4)  REFERENCES enum_bank_code,   -- kod banky
varsymb  char(10) UNIQUE NOT NULL , -- parovaci variabilni symbol
registarID INTEGER NOT NULL REFERENCES Registrar -- registrator
);



-- var symbl a cislo uctu platby na CZ domenu od Zoner
insert into banking_invoice_varsym_map values ( 3 , '182658400' , '0300' , '0026058774' , 140 );
-- od web4u
insert into banking_invoice_varsym_map values ( 3 , '105159835' , '0300' , '0049437381'  , 800 );



