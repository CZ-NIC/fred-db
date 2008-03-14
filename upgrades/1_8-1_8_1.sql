UPDATE enum_parameters SET val='1.8.1' WHERE id=1;

DROP INDEX action_elements_elementid_idx;
CREATE INDEX action_elements_actionid_idx ON action_elements (actionid);

CREATE INDEX domain_exdate_idx ON domain (exdate);
CREATE INDEX action_clienttrid_idx ON action (clienttrid);
CREATE INDEX object_state_object_id_all_idx ON object_state (object_id);

comment on table enum_country is 'list of country codes and names';
comment on column enum_country.id is 'country code (e.g. CZ for Czech republic)';
comment on column enum_country.country is 'english country name';
comment on column enum_country.country_cs is 'optional country name in native language';


comment on column domain_blacklist.regexp is 'regular expression which is blocked';
comment on column domain_blacklist.valid_from is 'from when is block valid';
comment on column domain_blacklist.valid_to is 'till when is block valid, if it is NULL, it is not restricted';
comment on column domain_blacklist.reason is 'reason why is domain blocked';
comment on column domain_blacklist.creator is 'who created this record. If it is NULL, it is system record created as a part of system configuration';

comment on table enum_bank_code is 'list of bank codes';
comment on column enum_bank_code.code is 'bank code';
comment on column enum_bank_code.name_short is 'bank name abbrevation';
comment on column enum_bank_code.name_full is 'full bank name';


comment on table enum_ssntype is
'Table of identification number types

types:
id - type   - description
 1 - RC     - born number
 2 - OP     - identity card number
 3 - PASS   - passport number
 4 - ICO    - organization identification number
 5 - MPSV   - social system identification
 6 - BIRTHDAY - day of birth';
comment on column enum_ssntype.type is 'type abbrevation';
comment on column enum_ssntype.description is 'type description';

comment on table enum_tlds is 'list of available tlds for checking of dns host tld';
-- CREATE LANGUAGE 'plpgsql';
comment on column invoice_prefix.Zone is 'reference to zone';
comment on column invoice_prefix.typ is 'invoice type (0-advanced, 1-normal)';
comment on column invoice_prefix.year is 'for which year';
comment on column invoice_prefix.prefix is 'counter with prefix of number of invoice';

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

comment on column invoice_generation.id is 'unique automatically generated identifier';
comment on column invoice_generation.InvoiceID is 'id of normal invoice';

comment on column invoice_credit_payment_map.invoiceID is 'id of normal invoice';
comment on column invoice_credit_payment_map.ainvoiceID is 'id of advance invoice';
comment on column invoice_credit_payment_map.credit is 'seized credit';
comment on column invoice_credit_payment_map.balance is 'actual tax balance advance invoice';

comment on column invoice_object_registry.id is 'unique automatically generated identifier';
comment on column invoice_object_registry.invoiceID is 'id of invoice for which is item counted';
comment on column invoice_object_registry.CrDate is 'billing date and time';
comment on column invoice_object_registry.zone is 'link to zone';
comment on column invoice_object_registry.registrarID is 'link to registrar';
comment on column invoice_object_registry.operation is 'operation type of registration or renew';
comment on column invoice_object_registry.ExDate is 'final ExDate only for RENEW';
comment on column invoice_object_registry.period is 'number of unit for renew in months';

comment on column invoice_object_registry_price_map.InvoiceID is 'id of advanced invoice';
comment on column invoice_object_registry_price_map.price is 'operation cost';

comment on column invoice_mails.invoiceid is 'link to invoices';
comment on column invoice_mails.mailid is 'e-mail which contains this invoice';
comment on table Contact_History is
'Historic data from contact table.
creation - actual data will be copied here from original table in case of any change in contact table';

comment on table Domain_History is
'Historic data from domain table

creation - in case of any change in domain table, including changes in bindings to other tables';

comment on table domain_contact_map_history is
'Historic data from domain_contact_map table

creation - all contacts links which are linked to changed domain are copied here';

comment on table NSSet_History is
'Historic data from domain nsset

creation - in case of any change in nsset table, including changes in bindings to other tables';

comment on table nsset_contact_map_history is
'Historic data from nsset_contact_map table

creation - all contact links which are linked to changed nsset are copied here';

comment on table Host_history is
'historic data from host table

creation - all entries from host table which exist for given nsset are copied here when nsset is altering';

comment on table Registrar is 'Evidence of registrars, who can create or change administered object via register';
comment on column Registrar.ID is 'unique automatically generated identifier';
comment on column Registrar.ICO is 'organization identification number';
comment on column Registrar.DIC is 'tax identification number';
comment on column Registrar.varsymb is 'coupling variable symbol (ico)';
comment on column Registrar.VAT is 'whether VAT should be count in invoicing';
comment on column Registrar.Handle is 'unique text string identifying registrar, it is generated by system admin when new registrar is created';
comment on column Registrar.Name is 'registrats name';
comment on column Registrar.Organization is 'Official company name';
comment on column Registrar.Street1 is 'part of address';
comment on column Registrar.Street2 is 'part of address';
comment on column Registrar.Street3 is 'part of address';
comment on column Registrar.City is 'part of address - city';
comment on column Registrar.StateOrProvince is 'part of address - region';
comment on column Registrar.PostalCode is 'part of address - postal code';
comment on column Registrar.Country is 'code for country from enum_country table';
comment on column Registrar.Telephone is 'phone number';
comment on column Registrar.Fax is 'fax number';
comment on column Registrar.Email is 'e-mail address';
comment on column Registrar.Url is 'registrars web address';

comment on table RegistrarACL is 'Registrars login information';
comment on column RegistrarACL.Cert is 'certificate fingerprint';
comment on column RegistrarACL.Password is 'login password';

comment on column RegistrarInvoice.Zone is 'zone for which has registrar an access';
comment on column RegistrarInvoice.FromDate is 'date when began registrar work in a zone';
comment on column RegistrarInvoice.LastDate is 'date when was last created an invoice';

comment on table MessageType is
'table with message number codes and its names

id - name
01 - credit
02 - techcheck
03 - transfer_contact
04 - transfer_nsset
05 - transfer_domain
06 - delete_contact
07 - delete_nsset
08 - delete_domain
09 - imp_expiration
10 - expiration
11 - imp_validation
12 - validation
13 - outzone';

comment on table Message is 'Evidence of messages for registrars, which can be picked up by epp poll funcion';

                       
comment on table enum_status is
'id - status
1   - ok
2   - inactive
101 - clientDeleteProhibited
201 - serverDeleteProhibited
102 - clientHold
202 - serverHold
103 - clientRenewProhibited
203 - serverRenewProhibited
104 - clientTransferProhibited
204 - serverTransferProhibited
105 - clientUpdateProhibited
205 - serverUpdateProhibited
301 - pendingCreate
302 - pendingDelete
303 - pendingRenew
304 - pendingTransfer
305 - pendingUpdate';
comment on column enum_status.id is 'status id';
comment on column enum_status.status is 'status message';
comment on table mail_defaults is 
'Defaults used in templates which change rarely.
Default names must be prefixed with ''defaults'' namespace when used in template';
comment on column mail_defaults.name is 'key of default';
comment on column mail_defaults.value is 'value of default';

comment on table mail_footer is 'Mail footer is defided in this table and not in templates in order to reduce templates size';

comment on table mail_vcard is 'vcard is attached to every email message';

comment on table mail_header_defaults is
'Some header defaults which are likely not a subject to change are specified in database and used in absence';
comment on column mail_header_defaults.h_from is '''From:'' header';
comment on column mail_header_defaults.h_replyto is '''Reply-to:'' header';
comment on column mail_header_defaults.h_errorsto is '''Errors-to:'' header';
comment on column mail_header_defaults.h_organization is '''Organization:'' header';
comment on column mail_header_defaults.h_contentencoding is '''Content-encoding:'' header';
comment on column mail_header_defaults.h_messageidserver is 'Message id cannot be overriden by client, in db is stored only part after ''@'' character';

comment on table mail_templates is 'Here are stored email templates which represent one text attachment of email message';
comment on column mail_templates.contenttype is 'subtype of content type text';
comment on column mail_templates.template is 'clearsilver template';
comment on column mail_templates.footer is 'should footer be concatenated with template?';

comment on table mail_type is 'Type of email gathers templates from which email is composed';
comment on column mail_type.name is 'name of type';
comment on column mail_type.subject is 'template of email subject';

comment on table mail_archive is
'Here are stored emails which are going to be sent and email which have
already been sent (they differ in status value).';
comment on column mail_archive.mailtype is 'email type';
comment on column mail_archive.crdate is 'date and time of insertion in table';
comment on column mail_archive.moddate is 'date and time of sending (event unsuccesfull)';
comment on column mail_archive.status is 
'status value has following meanings:
 0 - the email was successfully sent
 1 - the email is ready to be sent
 x - the email wait for manual confirmation which should change status value to 0
     when the email is desired to be sent. x represent any value different from
     0 and 1 (convention is number 2)';
comment on column mail_archive.message is 'text of email which is asssumed to be notificaion about undelivered';
comment on column mail_archive.attempt is 
'failed attempt to send email message to be sent including headers
(except date and msgid header), without non-templated attachments';

comment on table mail_attachments is 'list of attachment ids bound to email in mail_archive';
comment on column mail_attachments.mailid is 'id of email in archive';
comment on column mail_attachments.attachid is 'attachment id';

comment on table mail_handles is 'handles associated with email in mail_archive';
comment on column mail_handles.mailid is 'id of email in archive';
comment on column mail_handles.associd is 'handle of associated object';

comment on table enum_reason is 'Table of error messages reason';
comment on column enum_reason.reason is 'reason in english language';
comment on column enum_reason.reason_cs is 'reason in native language';
COMMENT ON TABLE enum_action IS 
'List of action which can be done using epp communication over central registry

id  - status
100 - ClientLogin
101 - ClientLogin
120 - PollAcknowledgement
121 - PollResponse
200 - ContactCheck
201 - ContactInfo
202 - ContactDelete
203 - ContactUpdate
204 - ContactCreate
205 - ContactTransfer
400 - NSsetCheck
401 - NSsetInfo
402 - NSsetDelete
403 - NSsetUpdate
404 - NSsetCreate
405 - NSsetTransfer
500 - DomainCheck
501 - DomainInfo
502 - DomainDelete
503 - DomainUpdate
504 - DomainCreate
505 - DomainTransfer
506 - DomainRenew
507 - DomainTrade
1000 - UnknowAction
1002 - ListContact
1004 - ListNSset
1005 - ListDomain
1010 - ClientCredit
1012 - nssetTest
1101 - ContactSendAuthInfo
1102 - NSSetSendAuthInfo
1103 - DomainSendAuthInfo
1104 - Info
1105 - GetInfoResults';

COMMENT on table action is 
'Table for transactions record. In this table is logged every operation done over central register

creation - at the beginning of processing any epp message
update - at the end of processing any epp message';
COMMENT on COLUMN action.id is 'unique automatically generated identifier';
comment on column action.clientid is 'id of client from table Login, it is possible have null value here';
comment on column action.action is 'type of function(action) from classifier';
comment on column action.response is 'return code of function';
comment on column action.StartDate is 'date and time when function starts';
comment on column action.EndDate is 'date and time when function ends';
comment on column action.clientTRID is 'client transaction identifier, client must care about its unique, server copy it to response';
comment on column action.serverTRID is 'server transaction identifier';

comment on table history is
'Main evidence table with modified data, it join historic tables modified during same operation
create - in case of any change';
comment on column history.id is 'unique automatically generated identifier';
comment on column history.action is 'link to action which cause modification';

comment on table notify_statechange_map is
'Notification processing rules - direct notifier what mails need to be send
and whom upon object state change';

comment on table notify_statechange is 'store information about successfull notification';
comment on column notify_statechange.state_id is 'which statechnage triggered notification';
comment on column notify_statechange.type is 'what notification was done';
comment on column notify_statechange.mail_id is 'email with result of notification (null if contact have no email)';


comment on table notify_letters is 'notification about deleteWarning state by PDF letter, multiple states is stored in one PDF document';
comment on column notify_letters.state_id is 'which statechange triggered notification';
comment on column notify_letters.file_id is 'file with pdf about notification (null for old)';
comment on column OBJECT_registry.ID is 'unique automatically generated identifier';
comment on column OBJECT_registry.ROID is 'unique roid';
comment on column OBJECT_registry.type is 'object type (1-contact, 2-nsset, 3-domain)';
comment on column OBJECT_registry.name is 'handle of fqdn';
comment on column OBJECT_registry.CrID is 'link to registrar';
comment on column OBJECT_registry.CrDate is 'object creation date and time';
comment on column OBJECT_registry.ErDate is 'object erase date';
comment on column OBJECT_registry.CrhistoryID is 'link into create history';
comment on column OBJECT_registry.historyID is 'link to last change in history';
comment on table Contact is 'List of contacts which act in register as domain owners and administrative contacts for nameservers group';
comment on column Contact.ID is 'references into object table';
comment on column Contact.Name is 'name of contact person';
comment on column Contact.Organization is 'full trade name of organization';
comment on column Contact.Street1 is 'part of address';
comment on column Contact.Street2 is 'part of address';
comment on column Contact.Street3 is 'part of address';
comment on column Contact.City is 'part of address - city';
comment on column Contact.StateOrProvince is 'part of address - region';
comment on column Contact.PostalCode is 'part of address - postal code';
comment on column Contact.Country is 'two character country code (e.g. cz) from enum_country table';
comment on column Contact.Telephone is 'telephone number';
comment on column Contact.Fax is 'fax number';
comment on column Contact.Email is 'email address';
comment on column Contact.DiscloseName is 'whether reveal contact name';
comment on column contact.DiscloseOrganization is 'whether reveal organization';
comment on column Contact.DiscloseAddress is 'whether reveal address';
comment on column Contact.DiscloseTelephone is 'whether reveal phone number';
comment on column Contact.DiscloseFax is 'whether reveal fax number';
comment on column Contact.DiscloseEmail is 'whether reveal email address';
comment on column Contact.NotifyEmail is 'to this email address will be send message in case of any change in domain or nsset affecting contact';
comment on column Contact.VAT is 'tax number';
comment on column Contact.SSN is 'unambiguous identification number (e.g. Social Security number, identity card number, date of birth)';
comment on column Contact.SSNtype is 'type of identification number from enum_ssntype table';
comment on column Contact.DiscloseVAT is 'whether reveal VAT number';
comment on column Contact.DiscloseIdent is 'whether reveal SSN number';
comment on column Contact.DiscloseNotifyEmail is 'whether reveal notify email';



comment on table Host is 'Records of relationship between nameserver and ip address';
comment on column Host.id is 'unique automatically generatet identifier';
comment on column Host.NSSetID is 'in which nameserver group belong this record';
comment on column Host.FQDN is 'fully qualified domain name that is in zone file as NS';

comment on table Domain is 'Evidence of domains';
comment on column Domain.ID is 'point to object table';
comment on column Domain.Zone is 'zone in which domain belong';
comment on column Domain.Registrant is 'domain owner';
comment on column Domain.NSSet is 'link to nameserver set, can be NULL (when is domain registered withou nsset)';
comment on column Domain.Exdate is 'domain expiry date';

comment on table enum_error is
'Table of error messages
id   - message
1000 - command completed successfully
1001 - command completed successfully, action pending
1300 - command completed successfully, no messages
1301 - command completed successfully, act to dequeue
1500 - command completed successfully, ending session
2000 - unknown command
2001 - command syntax error
2002 - command use error
2003 - required parameter missing
2004 - parameter value range error
2005 - parameter value systax error
2100 - unimplemented protocol version
2101 - unimplemented command
2102 - unimplemented option
2103 - unimplemented extension
2104 - billing failure
2105 - object is not eligible for renewal
2106 - object is not eligible for transfer
2200 - authentication error
2201 - authorization error
2202 - invalid authorization information
2300 - object pending transfer
2301 - object not pending transfer
2302 - object exists
2303 - object does not exists
2304 - object status prohibits operation
2305 - object association prohibits operation
2306 - parameter value policy error
2307 - unimplemented object service
2308 - data management policy violation
2400 - command failed
2500 - command failed, server closing connection
2501 - authentication error, server closing connection
2502 - session limit exceeded, server closing connection';
comment on column enum_error.id is 'id of error';
comment on column enum_error.status is 'error message in english language';
comment on column enum_error.status_cs is 'error message in native language';
comment on table genzone_domain_status is
'List of status for domain zone generator classification

id - name
 1 - domain is in zone
 2 - domain is deleted
 3 - domain is without nsset
 4 - domain is expired
 5 - domain is not validated';


comment on table enum_parameters is
'Table of system operational parameters.
Meanings of parameters:

1 - model version - for checking data model version and for applying upgrade scripts
2 - tld list version - for updating table enum_tlds by data from url
3 - expiration notify period - used to change state of domain to unguarded and remove domain from DNS,
    value is number of days relative to date domain.exdate
4 - expiration dns protection period - same as parameter 3
5 - expiration letter warning period - used to change state of domain to deleteWarning and generate letter
    witch warning
6 - expiration registration protection period - used to change state of domain to deleteCandidate and
    unregister domain from system
7 - validation notify 1 period - used to change state of domain to validationWarning1 and send poll
    message to registrar
8 - validation notify 2 period - used to change state of domain to validationWarning2 and send
    email to registrant
9 - regular day procedure period - used to identify hout when objects are deleted and domains
    are moving outzone
10 - regular day procedure zone - used to identify time zone in which parameter 9 is specified';
comment on column enum_parameters.id is 'primary identification';
comment on column enum_parameters.name is 'descriptive name of parameter - for information uses only';
comment on column enum_parameters.val is 'value of parameter';
comment on table enum_notify is
'list of notify operations

id - notify - explenation
 1 - domain exDate after - domain is after date of expiration
 2 - domain DNS after - domain is excluded from a zone
 3 - domain DEL - domain is definitively deleted
 4 - domain valexDate before - domain is closely before expiration of validation date
 5 - domain valexDate after - domain is after expiration of validation date
 6 - domain exDate before - domain is closely before expiration of expiration';

comment on column object_status_notifications.notify is 'notification type';
comment on column object_status_notifications.historyid is 'recording of status, in which some object is';
comment on column object_status_notifications.messageid is 'if it is also epp message distributed';

comment on column object_status_notifications_mail_map.mail_type is 'type of email notification';
comment on column object_status_notifications_mail_map.mailid is 'id of sended e-mail';
comment on table Login is
'records of all epp session

creating - when processing login epp message
updating - when processing logout epp message';
comment on column Login.ID is 'return as cliendID from CORBA Login FUNCTION';
comment on column Login.RegistrarID is 'registrar id';
comment on column Login.LoginDate is 'login date and time into system';
comment on column Login.loginTRID is 'login transaction number';
comment on column Login.LogoutDate is 'logout date and time';
comment on column Login.logoutTRID is 'logout transaction number';
comment on column Login.lang is 'language, in which return error messages';
comment on table enum_filetype is 'list of file types

id - name
 1 - invoice pdf
 2 - invoice xml
 3 - accounting xml
 4 - banking statement
 5 - expiration warning letter';

comment on table files is
'table of files';
comment on column files.id is 'unique automatically generated identifier';
comment on column files.name is 'file name';
comment on column files.path is 'path to file';
comment on column files.mimetype is 'file mimetype';
comment on column files.crdate is 'file creation timestamp';
comment on column files.filesize is 'file size';
comment on column files.filetype is 'file type from table enum_filetype';
comment on table enum_operation is 'list of priced operation';
comment on column enum_operation.id is 'unique automatically generated identifier';
comment on column enum_operation.operation is 'operation';

comment on table price_vat is 'Table of VAT validity (in case that VAT is changing in the future. Stores coefficient for VAT recount)';
comment on column price_vat.id is 'unique automatically generated identifier';
comment on column price_vat.valid_to is 'date of VAT change realization';
comment on column price_vat.koef is 'coefficient high for VAT recount';
comment on column price_vat.VAT is 'VAT high';
comment on table price_list is 'list of operation prices';
comment on column price_list.id is 'unique automatically generated identifier';
comment on column price_list.zone is 'link to zone, for which is price list valid if it is domain (if it is not domain then it is NULL)';
comment on column price_list.operation is 'for which action is price connected';
comment on column price_list.valid_from is 'from when is record valid';
comment on column price_list.valid_to is 'till when is record valid, if it is NULL then valid is unlimited';
comment on column price_list.price is 'cost of operation (for one year-12 months)';
comment on column price_list.period is 'period (in months) of payment, null if it is not periodic';
comment on table bank_account is
'This table contains information about register administrator bank account';
comment on column bank_account.id is 'unique automatically generated identifier';
comment on column bank_account.zone is 'for which zone should be account executed';
comment on column bank_account.balance is 'actual balance';
comment on column bank_account.last_date is 'date of last statement';
comment on column bank_account.last_num is 'number of last statement';
comment on column BANK_STATEMENT_HEAD.id is 'unique automatically generated identifier';
comment on column BANK_STATEMENT_HEAD.account_id is 'link to used bank account';
comment on column BANK_STATEMENT_HEAD.num is 'statements number';
comment on column BANK_STATEMENT_HEAD.create_date is 'statement creation date';
comment on column BANK_STATEMENT_HEAD.balance_old is 'old balance state';
comment on column BANK_STATEMENT_HEAD.balance_credit is 'income during statement';
comment on column BANK_STATEMENT_HEAD.balance_debet is 'expenses during statement';
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
comment on table enum_object_states is 'list of all supported status types';
comment on column enum_object_states.name is 'code name for status';
comment on column enum_object_states.types is 'what types of objects can have this status (object_registry.type list)';
comment on column enum_object_states.manual is 'if this status is set manualy';
comment on column enum_object_states.external is 'if this status is exported to public';

comment on table enum_object_states_desc is 'description for states in different languages';
comment on column enum_object_states_desc.lang is 'code of language';
comment on column enum_object_states_desc.description is 'descriptive text';

comment on table object_state is 'main table of object states and their changes';
comment on column object_state.object_id is 'id of object that has this new status';
comment on column object_state.state_id is 'id of status';
comment on column object_state.valid_from is 'date and time when object entered state';
comment on column object_state.valid_to is 'date and time when object leaved state or null if still has this status';
comment on column object_state.ohid_from is 'history id of object in the moment of entering state (may be null)';
comment on column object_state.ohid_to is 'history id of object in the moment of leaving state or null';

comment on table object_state_request is 'request for setting manual state';
comment on column object_state_request.object_id is 'id of object gaining request state';
comment on column object_state_request.state_id is 'id of requested state';
comment on column object_state_request.valid_from is 'when object should enter requested state';
comment on column object_state_request.valid_to is 'when object should leave requested state';
comment on column object_state_request.crdate is 'could be pointed to some list of administation action';
comment on column object_state_request.canceled is 'could be pointed to some list of administation action';
