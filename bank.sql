
-- drop tables
-- drop table banking_invoice_varsym_map;
-- drop table BANK_STATEMENT_ITEM;
-- drop table BANK_STATEMENT_HEAD;
-- drop table bank_account;

-- bank classifier 
-- CREATE TABLE enum_bank_code (
-- code char(4) PRIMARY KEY,
-- name_short varchar(4) UNIQUE NOT NULL , -- shortcut
-- name_full varchar(64) UNIQUE  NOT NULL -- full name
-- );

                                   
-- ACCOUNT -- table of our accounts
CREATE TABLE bank_account 
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
Zone INTEGER REFERENCES Zone (ID), -- for which zone should be account executed
account_number char(16) UNIQUE NOT NULL , -- account number
account_name  char(20) , -- account name
bank_code char(4)  REFERENCES enum_bank_code,   -- bank code
balance  numeric(10,2), -- actual balance 
last_date date, -- date of last statement 
last_num int  -- number of last statement
);

-- coupling variable symbol of registrar is in a table registrar ( it is his ICO for CZ ) a it is valid for all zones

-- testing record for loading statement
insert into  bank_account values ( 2 , 3 , '188208275' , 'CZNIC ucet CSOB' , '0300' , '130000' , '2006-11-10' , 161  );
insert into bank_account (  id , Zone , account_number , account_name , bank_code )  values ( 1 , 1 , '756' , 'ENUM ucet ebanka' , '2400'   );



-- bank statements 
CREATE TABLE BANK_STATEMENT_HEAD 
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
account_id int  REFERENCES bank_account, -- processing for given account link to account tabel
num int, -- serial number statement
create_date date NOT NULL, --  create date of a statement
balance_old_date date NOT NULL , -- date of a last balance
balance_old numeric(10,2) NOT NULL, -- old balance
balance_new numeric(10,2) NOT NULL,  -- new balance
balance_credit  numeric(10,2) NOT NULL, -- income during statement ( credit balance )
balance_debet numeric(10,2) NOT NULL -- expenses during statement ( debet balance )
);


-- statements item
CREATE TABLE BANK_STATEMENT_ITEM
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
statement_id int  REFERENCES BANK_STATEMENT_HEAD, -- link into table heads of bank statements
account_number char(16)  NOT NULL , -- contra-account number from which came or was sent a payment
bank_code char(4)  REFERENCES enum_bank_code,   -- bank code
code int, -- account code 1 debet item 2 credit item 4  cancel debet 5 cancel credit 
KonstSym char(10), -- constant symbol ( it contains bank code too )
VarSymb char(10), -- variable symbol
SpecSymb char(10), -- constant symbol
price numeric(10,2) NOT NULL,  -- applied amount if a debet is negative amount 
account_evid varchar(20), -- account evidence 
account_date date NOT NULL, --  accounting date of credit or sending / datum zuctovani pripsani na ucet ci odeslani (czech comment)
account_memo  varchar(64), -- note
invoice_ID INTEGER REFERENCES Invoice default NULL -- null if it isn't income payment otherwise link to invoice / nula pokud neni prichozi platba zpracovani jinak odkaz na zalohovou fakturu (czech comment)
);




-- items of ON-LINE E-Banka statement
CREATE TABLE BANK_EBANKA_LIST
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
account_id int  REFERENCES bank_account, -- current account
price numeric(10,2) NOT NULL,  -- transfer amount
CrDate  timestamp NOT NULL DEFAULT now(),  -- date and time of transfer transfered into UTC / datum a cas prevodu prevedeneho uz do UTC
account_number char(16)  NOT NULL , -- countra-account number from which came or was sent a payment 
bank_code char(4)  REFERENCES enum_bank_code,   -- bank code of payer
KonstSym char(10), -- constant symbol of payment 
VarSymb char(10), -- variable symbol of payment
memo  varchar(64), -- note
name varchar(64), -- account name from which came a payment 
Ident char(10) UNIQUE, -- unique identifier of payment
invoice_ID INTEGER REFERENCES Invoice default NULL -- null if it isn't income payment otherwise link to advanced invoice / nula pokud neni prichozi platba zpracovani jinak odkaz na zalohovou faktu$
);


