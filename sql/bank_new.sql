CREATE TABLE BANK_HEAD 
(
    id serial NOT NULL PRIMARY KEY, -- unique primary key
    account_id int  REFERENCES bank_account, -- processing for given account link to account tabel
    num int, -- serial number statement
    create_date date , --  create date of a statement
    balance_old_date date , -- date of a last balance
    balance_old numeric(10,2) , -- old balance
    balance_new numeric(10,2) ,  -- new balance
    balance_credit  numeric(10,2) , -- income during statement ( credit balance )
    balance_debet numeric(10,2), -- expenses during statement ( debet balance )
    file_id INTEGER REFERENCES Files default NULL
);

comment on column BANK_HEAD.id is 'unique automatically generated identifier';
comment on column BANK_HEAD.account_id is 'link to used bank account';
comment on column BANK_HEAD.num is 'statements number';
comment on column BANK_HEAD.create_date is 'statement creation date';
comment on column BANK_HEAD.balance_old is 'old balance state';
comment on column BANK_HEAD.balance_credit is 'income during statement';
comment on column BANK_HEAD.balance_debet is 'expenses during statement';
comment on column BANK_HEAD.file_id is 'xml file identifier number';

-- statements item
CREATE TABLE BANK_ITEM
(
    id serial NOT NULL PRIMARY KEY, -- unique primary key
    statement_id int  REFERENCES BANK_HEAD default null, -- link into table heads of bank statements
    account_id int  REFERENCES bank_account default null, -- link into table of accounts
    account_number varchar(17)  NOT NULL , -- contra-account number from which came or was sent a payment
    bank_code varchar(4) NOT NULL,   -- bank code
    code int, -- account code 1 debet item 2 credit item 4  cancel debet 5 cancel credit 
    type int, -- transfer type
    status int, -- payment status
    KonstSym varchar(10), -- constant symbol ( it contains bank code too )
    VarSymb varchar(10), -- variable symbol
    SpecSymb varchar(10), -- constant symbol
    price numeric(10,2) NOT NULL,  -- applied amount if a debet is negative amount 
    account_evid varchar(20), -- account evidence 
    account_date date NOT NULL, --  accounting date of credit or sending 
    account_memo  varchar(64), -- note
    invoice_ID INTEGER REFERENCES Invoice default NULL, -- null if it isn't income payment of process otherwise link to advance invoice
    account_name  varchar(64), -- account name
    crtime timestamp NOT NULL default now(),
    UNIQUE(account_id, account_evid)
);

comment on column BANK_ITEM.id is 'unique automatically generated identifier';
comment on column BANK_ITEM.statement_id is 'link to statement head';
comment on column BANK_ITEM.account_id is 'link to account table';
comment on column BANK_ITEM.account_number is 'contra-account number from which came or was sent a payment';
comment on column BANK_ITEM.bank_code is 'contra-account bank code';
comment on column BANK_ITEM.code is 'operation code (1-debet item, 2-credit item, 4-cancel debet, 5-cancel credit)';
comment on column BANK_ITEM.type is 'transfer type (1-from/to registrar, 2-from/to bank, 3-between our own accounts, 4-related to academia, 5-other transfers';
comment on column BANK_ITEM.status is 'payment status (1-Realized (only this should be further processed), 2-Partially realized, 3-Not realized, 4-Suspended, 5-Ended, 6-Waiting for clearing )';
comment on column BANK_ITEM.KonstSym is 'constant symbol (contains bank code too)';
comment on column BANK_ITEM.VarSymb is 'variable symbol';
comment on column BANK_ITEM.SpecSymb is 'spec symbol';
comment on column BANK_ITEM.price is 'applied positive(credit) or negative(debet) amount';
comment on column BANK_ITEM.account_evid is 'account evidence';
comment on column BANK_ITEM.account_date is 'accounting date';
comment on column BANK_ITEM.account_memo is 'note';
comment on column BANK_ITEM.invoice_ID is 'null if it is not income payment of process otherwise link to proper invoice';
comment on column BANK_ITEM.account_name is 'account name';
comment on column BANK_ITEM.crtime is 'create timestamp';

