

-- TODO make prefix classifier for every year so that pass between years is available 
CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
Zone INTEGER REFERENCES Zone (ID),
typ integer default 0,  -- invoice type 0 advanced 1 normal
year numeric NOT NULL, --for which year  
prefix bigint -- counter with prefix of number line invoice 
);

-- zona enum
-- advance
insert into invoice_prefix values ( 1 , 1 ,  0 , 2007 , 110700001 );
-- normal 
insert into invoice_prefix values ( 2 , 1 ,  1 , 2007 , 120700001 );
-- CZ zone
-- advance
insert into invoice_prefix values ( 3 , 3 ,  0 , 2007 , 130700001 );
-- normal
insert into invoice_prefix values ( 4 , 3 ,  1 , 2007 , 140700001 );
 
 


-- tabel of invoices billing from when till when and id of invoice if it is NULL it isn't normal invoice drawn



-- advance invoices 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
Zone INTEGER NOT NULL REFERENCES Zone (ID),
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

--  account tabel of advance invoices
CREATE TABLE invoice_credit_payment_map
(
invoiceID INTEGER REFERENCES Invoice (ID) , -- id of normal invoice
ainvoiceID INTEGER REFERENCES Invoice (ID) , -- id of advance invoice
credit numeric(10,2)  NOT NULL DEFAULT 0.0, -- seized credit
balance numeric(10,2)  NOT NULL DEFAULT 0.0, -- actual tax balance advance invoice 
PRIMARY KEY (invoiceID, ainvoiceID)
);







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


CREATE TABLE invoice_object_registry_price_map
(
id INTEGER REFERENCES invoice_object_registry(ID),
InvoiceID INTEGER REFERENCES Invoice (ID), -- id of advanced invoice
price numeric(10,2) NOT NULL default 0 , -- cost for operation
PRIMARY KEY (id ,  InvoiceID  ) -- unique key
);

CREATE TABLE invoice_mails
(
id SERIAL NOT NULL PRIMARY KEY, -- unique primary key
invoiceid INTEGER REFERENCES invoice, -- link to invoices
genid INTEGER REFERENCES invoice_generation, -- link to invoices
mailid INTEGER NOT NULL REFERENCES mail_archive -- e-mail which contains this invoice 
);