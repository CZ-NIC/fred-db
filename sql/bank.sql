
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
account_number char(16) NOT NULL , -- account number
account_name  char(20) , -- account name
bank_code char(4)  REFERENCES enum_bank_code,   -- bank code
balance  numeric(10,2) default 0.0, -- actual balance 
last_date date, -- date of last statement 
last_num int  -- number of last statement
);

-- coupling variable symbol of registrar is in a table registrar ( it is his ICO for CZ ) a it is valid for all zones

comment on table bank_account is
'This table contains information about register administrator bank account';
comment on column bank_account.id is 'unique automatically generated identifier';
comment on column bank_account.zone is 'for which zone should be account executed';
comment on column bank_account.balance is 'actual balance';
comment on column bank_account.last_date is 'date of last statement';
comment on column bank_account.last_num is 'number of last statement';

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

comment on column BANK_STATEMENT_HEAD.id is 'unique automatically generated identifier';
comment on column BANK_STATEMENT_HEAD.account_id is 'link to used bank account';
comment on column BANK_STATEMENT_HEAD.num is 'statements number';
comment on column BANK_STATEMENT_HEAD.create_date is 'statement creation date';
comment on column BANK_STATEMENT_HEAD.balance_old is 'old balance state';
comment on column BANK_STATEMENT_HEAD.balance_credit is 'income during statement';
comment on column BANK_STATEMENT_HEAD.balance_debet is 'expenses during statement';

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
account_date date NOT NULL, --  accounting date of credit or sending 
account_memo  varchar(64), -- note
invoice_ID INTEGER REFERENCES Invoice default NULL -- null if it isn't income payment of process otherwise link to advance invoice
);

comment on column BANK_STATEMENT_ITEM.id is 'unique automatically generated identifier';
comment on column BANK_STATEMENT_ITEM.statement_id is 'link to statement head';
comment on column BANK_STATEMENT_ITEM.account_number is 'contra-account number from which came or was sent a payment';
comment on column BANK_STATEMENT_ITEM.bank_code is 'contra-account bank code';
comment on column BANK_STATEMENT_ITEM.code is 'operation code (1-debet item, 2-credit item, 4-cancel debet, 5-cancel credit)';
comment on column BANK_STATEMENT_ITEM.KonstSym is 'constant symbol (contains bank code too)';
comment on column BANK_STATEMENT_ITEM.VarSymb is 'variable symbol';
comment on column BANK_STATEMENT_ITEM.SpecSymb is 'spec symbol';
comment on column BANK_STATEMENT_ITEM.price is 'applied positive(credit) or negative(debet) amount';
comment on column BANK_STATEMENT_ITEM.account_evid is 'account evidence';
comment on column BANK_STATEMENT_ITEM.account_date is 'accounting date';
comment on column BANK_STATEMENT_ITEM.account_memo is 'note';
comment on column BANK_STATEMENT_ITEM.invoice_ID is 'null if it is not income payment of process otherwise link to proper invoice';


-- items of ON-LINE E-Banka statement
CREATE TABLE BANK_EBANKA_LIST
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
account_id int  REFERENCES bank_account, -- current account
price numeric(10,2) NOT NULL,  -- transfer amount
CrDate  timestamp NOT NULL DEFAULT now(),  -- date and time of transfer transfered into UTC 
account_number char(16)  NOT NULL , -- countra-account number from which came or was sent a payment 
bank_code char(4)  REFERENCES enum_bank_code,   -- bank code of payer
KonstSym char(10), -- constant symbol of payment 
VarSymb char(10), -- variable symbol of payment
memo  varchar(64), -- note
name varchar(64), -- account name from which came a payment 
Ident char(10) UNIQUE, -- unique identifier of payment
invoice_ID INTEGER REFERENCES Invoice default NULL -- null if it isn't income payment process otherwise link to advanced invoice 
);

comment on table BANK_EBANKA_LIST is 'items of online e-banka statement';
comment on column BANK_EBANKA_LIST.id is 'unique automatically generated identificator';
comment on column BANK_EBANKA_LIST.account_id is 'link to current account';
comment on column BANK_EBANKA_LIST.price is 'transfer amount';
comment on column BANK_EBANKA_LIST.CrDate is 'date and time of transfer in UTC';
comment on column BANK_EBANKA_LIST.account_number is 'contra-account number';
comment on column BANK_EBANKA_LIST.bank_code is 'bank code';
comment on column BANK_EBANKA_LIST.KonstSym is 'constant symbol of payment';
comment on column BANK_EBANKA_LIST.VarSymb is 'variable symbol of payment';
comment on column BANK_EBANKA_LIST.memo is 'note';
comment on column BANK_EBANKA_LIST.name is 'account name from which came a payment';
comment on column BANK_EBANKA_LIST.Ident is 'unique identifier of payment';
comment on column BANK_EBANKA_LIST.invoice_ID is 'null if it is not income payement process otherwise link to proper invoice';

