

-- TODO make prefix classifier for every year so that pass between years is available 
CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
Zone INTEGER REFERENCES Zone (ID),
typ integer default 0,  -- invoice type 0 advanced 1 normal
year numeric NOT NULL, --for which year  
prefix bigint -- counter with prefix of number line invoice 
);

comment on column invoice_prefix.Zone is 'reference to zone';
comment on column invoice_prefix.typ is 'invoice type (0-advanced, 1-normal)';
comment on column invoice_prefix.year is 'for which year';
comment on column invoice_prefix.prefix is 'counter with prefix of number of invoice';

-- advance invoices 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
Zone INTEGER REFERENCES Zone (ID),
CrDate timestamp NOT NULL DEFAULT now(),  -- date and time of invoice creation 
TaxDate date NOT NULL, -- date of taxable fulfilment ( when payment cames by advance FA)
prefix bigint UNIQUE NOT NULL , -- 9 placed number of invoice from invoice_prefix.prefix counted via TaxDate 
registrarID INTEGER NOT NULL REFERENCES Registrar, -- link to registrar
-- TODO registrarhistoryID for links to right ICO and DIC addresses
Credit numeric(10,2) DEFAULT 0.0, -- credit from which is taken till zero if it is NULL it is normal invoice 
Price numeric(10,2) NOT NULL DEFAULT 0.0, -- invoice high also with tax 
VAT integer NOT NULL  DEFAULT 19, -- VAT high 19% (0) for account
total numeric(10,2) NOT NULL  DEFAULT 0.0 ,  -- amount without tax ( for accounting is same as price = total amount without tax);
totalVAT numeric(10,2)  NOT NULL DEFAULT 0.0 , -- tax paid (0 for accounted tax it is paid at advance invoice)
prefix_type INTEGER NOT NULL REFERENCES invoice_prefix(ID), --  invoice type  from which year is anf which type is according to prefix 
file INTEGER REFERENCES files ,-- link to generated PDF (it can be null till is generated)
fileXML INTEGER REFERENCES files -- link to generated XML (it can be null till is generated) 
);

comment on table invoice is
'table of invoices';
comment on column invoice.id is 'unique automatically generated identifier';
comment on column invoice.Zone is 'reference to zone';
comment on column invoice.CrDate is 'date and time of invoice creation';
comment on column invoice.TaxDate is 'date of taxable fulfilment (when payment cames by advance FA)';
comment on column invoice.prefix is '9 placed number of invoice from invoice_prefix.prefix counted via TaxDate';
comment on column invoice.registrarID is 'link to registrar';
comment on column invoice.Credit is 'credit from which is taken till zero, if it is NULL it is normal invoice';
comment on column invoice.Price is 'invoice high with tax';
comment on column invoice.VAT is 'VAT hight from account';
comment on column invoice.total is 'amount without tax';
comment on column invoice.totalVAT is 'tax paid';
comment on column invoice.prefix_type is 'invoice type (from which year is and which type is according to prefix)';
comment on column invoice.file is 'link to generated PDF file, it can be NULL till file is generated';
comment on column invoice.fileXML is 'link to generated XML file, it can be NULL till file is generated';

-- invoices generation
CREATE TABLE invoice_generation
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
FromDate date NOT  NULL , -- local date account period from is taken 00:00:00 
ToDate date NOT NULL  , -- 23:59:59 is taken into date
registrarID INTEGER NOT NULL REFERENCES Registrar, -- link to registrar
Zone INTEGER REFERENCES Zone (ID),
InvoiceID INTEGER REFERENCES Invoice (ID) -- id of normal invoice
);

comment on column invoice_generation.id is 'unique automatically generated identifier';
comment on column invoice_generation.InvoiceID is 'id of normal invoice';

--  account tabel of advance invoices
CREATE TABLE invoice_credit_payment_map
(
invoiceID INTEGER REFERENCES Invoice (ID) , -- id of normal invoice
ainvoiceID INTEGER REFERENCES Invoice (ID) , -- id of advance invoice
credit numeric(10,2)  NOT NULL DEFAULT 0.0, -- seized credit
balance numeric(10,2)  NOT NULL DEFAULT 0.0, -- actual tax balance advance invoice 
PRIMARY KEY (invoiceID, ainvoiceID)
);

comment on column invoice_credit_payment_map.invoiceID is 'id of normal invoice';
comment on column invoice_credit_payment_map.ainvoiceID is 'id of advance invoice';
comment on column invoice_credit_payment_map.credit is 'seized credit';
comment on column invoice_credit_payment_map.balance is 'actual tax balance advance invoice';

CREATE INDEX invoice_credit_payment_map_invoiceid_idx
       ON invoice_credit_payment_map (invoiceid);
CREATE INDEX invoice_credit_payment_map_ainvoiceid_idx
       ON invoice_credit_payment_map (ainvoiceid);

-- TODO into normal invoices make account period from when till when.

-- when is billing realized, they are substracted from advanced invoice 
-- it can occur that one object is billing twice every from different advance invoice
CREATE TABLE invoice_object_registry
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
invoiceID INTEGER REFERENCES Invoice (ID) , -- id of invoice for which is item counted 
CrDate timestamp NOT NULL DEFAULT now(),  -- billing date and time 
objectID integer  REFERENCES object_registry (id),
zone INTEGER REFERENCES Zone (ID),
registrarID INTEGER NOT NULL REFERENCES Registrar, -- link to registrar 
operation INTEGER NOT NULL REFERENCES enum_operation, -- operation type of registration or renew
ExDate date default NULL,  -- final ExDate only for RENEW 
period integer default 0 -- number of unit for renew in months
);

comment on column invoice_object_registry.id is 'unique automatically generated identifier';
comment on column invoice_object_registry.invoiceID is 'id of invoice for which is item counted';
comment on column invoice_object_registry.CrDate is 'billing date and time';
comment on column invoice_object_registry.zone is 'link to zone';
comment on column invoice_object_registry.registrarID is 'link to registrar';
comment on column invoice_object_registry.operation is 'operation type of registration or renew';
comment on column invoice_object_registry.ExDate is 'final ExDate only for RENEW';
comment on column invoice_object_registry.period is 'number of unit for renew in months';

CREATE INDEX invoice_object_registry_objectid_idx
       ON invoice_object_registry (objectid);

CREATE TABLE invoice_object_registry_price_map
(
id INTEGER REFERENCES invoice_object_registry(ID),
InvoiceID INTEGER REFERENCES Invoice (ID), -- id of advanced invoice
price numeric(10,2) NOT NULL default 0 , -- cost for operation
PRIMARY KEY (id ,  InvoiceID  ) -- unique key
);

comment on column invoice_object_registry_price_map.InvoiceID is 'id of advanced invoice';
comment on column invoice_object_registry_price_map.price is 'operation cost';

CREATE INDEX invoice_object_registry_price_map_invoiceid_idx
       ON invoice_object_registry_price_map (invoiceid);

CREATE TABLE invoice_mails
(
id SERIAL NOT NULL PRIMARY KEY, -- unique primary key
invoiceid INTEGER REFERENCES invoice, -- link to invoices
genid INTEGER REFERENCES invoice_generation, -- link to invoices
mailid INTEGER NOT NULL REFERENCES mail_archive -- e-mail which contains this invoice 
);

comment on column invoice_mails.invoiceid is 'link to invoices';
comment on column invoice_mails.mailid is 'e-mail which contains this invoice';
