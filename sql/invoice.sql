
CREATE TABLE invoice_type 
(
typ serial
, description text
);

INSERT INTO invoice_type (typ , description) VALUES (0,'advance');
INSERT INTO invoice_type (typ , description) VALUES (1,'account');

-- TODO make prefix classifier for every year so that pass between years is available

CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
zone_id INTEGER REFERENCES zone (id),
typ integer default 0 REFERENCES invoice_type (typ),  -- invoice type 0 advanced 1 normal
year numeric NOT NULL, --for which year  
prefix bigint -- counter with prefix of number line invoice 
, CONSTRAINT invoice_prefix_zone_key UNIQUE (zone_id, typ, year)
);

comment on column invoice_prefix.zone_id is 'reference to zone';
comment on column invoice_prefix.typ is 'invoice type (0-advanced, 1-normal)';
comment on column invoice_prefix.year is 'for which year';
comment on column invoice_prefix.prefix is 'counter with prefix of number of invoice';

-- advance invoices 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
zone_id INTEGER REFERENCES zone (id),
CrDate timestamp NOT NULL DEFAULT now(),  -- date and time of invoice creation 
TaxDate date NOT NULL, -- date of taxable fulfilment ( when payment cames by advance FA)
prefix bigint UNIQUE NOT NULL , -- 9 placed number of invoice from invoice_prefix.prefix counted via TaxDate 
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar
-- TODO registrarhistoryID for links to right ICO and DIC addresses
balance numeric(10,2) DEFAULT 0.0, -- credit from which is taken till zero if it is NULL it is normal invoice 
operations_price numeric(10,2) DEFAULT 0.0, -- account invoice sum price of operations  
VAT numeric NOT NULL, -- VAT percent used for this invoice)
total numeric(10,2) NOT NULL  DEFAULT 0.0 ,  -- amount without tax ( for accounting is same as price = total amount without tax);
totalVAT numeric(10,2)  NOT NULL DEFAULT 0.0 , -- tax paid (0 for accounted tax it is paid at advance invoice)
invoice_prefix_id INTEGER NOT NULL REFERENCES invoice_prefix(ID), --  invoice type  from which year is anf which type is according to prefix 
file INTEGER REFERENCES files ,-- link to generated PDF (it can be null till is generated)
fileXML INTEGER REFERENCES files -- link to generated XML (it can be null till is generated) 
);

comment on table invoice is
'table of invoices';
comment on column invoice.id is 'unique automatically generated identifier';
comment on column invoice.zone_id is 'reference to zone';
comment on column invoice.CrDate is 'date and time of invoice creation';
comment on column invoice.TaxDate is 'date of taxable fulfilment (when payment cames by advance FA)';
comment on column invoice.prefix is '9 placed number of invoice from invoice_prefix.prefix counted via TaxDate';
comment on column invoice.registrar_id is 'link to registrar';
comment on column invoice.balance is '*advance invoice: balance from which operations are charged *account invoice: amount to be paid (0 in case there is no debt)';
comment on column invoice.operations_price is 'sum of operations without tax';
comment on column invoice.VAT is 'VAT hight from account';
comment on column invoice.total is 'amount without tax';
comment on column invoice.totalVAT is 'tax paid';
comment on column invoice.invoice_prefix_id is 'invoice type - which year and type (accounting/advance) ';
comment on column invoice.file is 'link to generated PDF file, it can be NULL till file is generated';
comment on column invoice.fileXML is 'link to generated XML file, it can be NULL till file is generated';

-- invoices generation
CREATE TABLE invoice_generation
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
FromDate date NOT  NULL , -- local date account period from is taken 00:00:00 
ToDate date NOT NULL  , -- 23:59:59 is taken into date
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar
zone_id INTEGER REFERENCES Zone (id),
invoice_id INTEGER REFERENCES invoice (id) -- id of normal invoice
);

comment on column invoice_generation.id is 'unique automatically generated identifier';
comment on column invoice_generation.invoice_id is 'id of normal invoice';

--  account tabel of advance invoices
CREATE TABLE invoice_credit_payment_map
(
ac_invoice_id INTEGER REFERENCES invoice (id) , -- id of normal invoice
ad_invoice_id INTEGER REFERENCES invoice (id) , -- id of advance invoice
credit numeric(10,2)  NOT NULL DEFAULT 0.0, -- seized credit
balance numeric(10,2)  NOT NULL DEFAULT 0.0, -- actual tax balance advance invoice 
PRIMARY KEY (ac_invoice_id, ad_invoice_id)
);

comment on column invoice_credit_payment_map.ac_invoice_id is 'id of normal invoice';
comment on column invoice_credit_payment_map.ad_invoice_id is 'id of advance invoice';
comment on column invoice_credit_payment_map.credit is 'seized credit';
comment on column invoice_credit_payment_map.balance is 'actual tax balance advance invoice';

CREATE INDEX invoice_credit_payment_map_ac_invoice_id_idx
       ON invoice_credit_payment_map (ac_invoice_id);
CREATE INDEX invoice_credit_payment_map_ad_invoice_id_idx
       ON invoice_credit_payment_map (ad_invoice_id);

-- TODO into normal invoices make account period from when till when.

-- when is billing realized, they are substracted from advanced invoice 
-- it can occur that one object is billing twice every from different advance invoice
CREATE TABLE invoice_operation
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
ac_invoice_id INTEGER REFERENCES invoice (id) , -- id of invoice for which is item counted 
CrDate timestamp NOT NULL DEFAULT now(),  -- billing date and time 
object_id integer  REFERENCES object_registry (id),
zone_id INTEGER REFERENCES zone (id),
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar 
operation_id INTEGER NOT NULL REFERENCES enum_operation, -- operation type of registration or renew
date_from date,
date_to date default NULL,  -- final ExDate only for RENEW 
quantity integer default 0, -- number of unit for renew in months
registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

comment on column invoice_operation.id is 'unique automatically generated identifier';
comment on column invoice_operation.ac_invoice_id is 'id of invoice for which is item counted';
comment on column invoice_operation.CrDate is 'billing date and time';
comment on column invoice_operation.zone_id is 'link to zone';
comment on column invoice_operation.registrar_id is 'link to registrar';
comment on column invoice_operation.operation_id is 'operation type of registration or renew';
comment on column invoice_operation.date_to is 'expiration date only for RENEW';
comment on column invoice_operation.quantity is 'number of operations or number of months for renew';

CREATE INDEX invoice_operation_object_id_idx
       ON invoice_operation (object_id);

CREATE TABLE invoice_operation_charge_map
(
invoice_operation_id INTEGER REFERENCES invoice_operation(ID),
invoice_id INTEGER REFERENCES invoice (id), -- id of advanced invoice
price numeric(10,2) NOT NULL default 0 , -- cost for operation
PRIMARY KEY ( invoice_operation_id ,  invoice_id ) -- unique key
);

comment on column invoice_operation_charge_map.invoice_id is 'id of advanced invoice';
comment on column invoice_operation_charge_map.price is 'operation cost';

CREATE INDEX invoice_operation_charge_map_invoice_id_idx
       ON invoice_operation_charge_map (invoice_id);

CREATE TABLE invoice_mails
(
id SERIAL NOT NULL PRIMARY KEY, -- unique primary key
invoiceid INTEGER REFERENCES invoice, -- link to invoices
genid INTEGER REFERENCES invoice_generation, -- link to invoices
mailid INTEGER NOT NULL REFERENCES mail_archive -- e-mail which contains this invoice 
);

comment on column invoice_mails.invoiceid is 'link to invoices';
comment on column invoice_mails.mailid is 'e-mail which contains this invoice';

CREATE TABLE invoice_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , invoice_id bigint NOT NULL REFERENCES invoice(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

COMMENT ON TABLE invoice_registrar_credit_transaction_map
	IS 'positive credit item from payment assigned to deposit or account invoice';




