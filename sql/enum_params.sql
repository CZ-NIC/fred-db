-- system operational parametr
-- parameters are accessed through their id not name, so proper
-- numbering is essential

CREATE TABLE enum_parameters (
  id INTEGER PRIMARY KEY, -- primary identification 
  name VARCHAR(100) NOT NULL UNIQUE, -- descriptive name (informational)
  val VARCHAR(100) NOT NULL -- value of parameter
);

-- parametr 1 is for checking data model version and for applying upgrade
-- scripts
INSERT INTO enum_parameters (id, name, val) 
VALUES (1, 'model_version', '1.9.0');
-- parametr 2 is for updating table enum_tlds by data from url
-- http://data.iana.org/TLD/tlds-alpha-by-domain.txt
INSERT INTO enum_parameters (id, name, val) 
VALUES (2, 'tld_list_version', '2008013001');
-- parametr 3 is used to change state of domain to unguarded and remove
-- this domain from DNS. value is number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (3, 'expiration_notify_period', '-30');
-- parametr 4 is used to change state of domain to unguarded and remove
-- this domain from DNS. value is number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (4, 'expiration_dns_protection_period', '30');
-- parametr 5 is used to change state of domain to deleteWarning and 
-- generate letter with warning. value number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (5, 'expiration_letter_warning_period', '34');
-- parametr 6 is used to change state of domain to deleteCandidate and 
-- unregister domain from system. value is number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (6, 'expiration_registration_protection_period', '45');
-- parametr 7 is used to change state of domain to validationWarning1 and 
-- send poll message to registrar. value is number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (7, 'validation_notify1_period', '-30');
-- parametr 8 is used to change state of domain to validationWarning2 and 
-- send email to registrant. value is number of dates relative to date 
-- domain.exdate 
INSERT INTO enum_parameters (id, name, val) 
VALUES (8, 'validation_notify2_period', '-15');
-- parametr 9 is used to identify hour when objects are deleted 
-- and domains are moving outzone. value is number of hours relative to date 
-- of operation
INSERT INTO enum_parameters (id, name, val) 
VALUES (9, 'regular_day_procedure_period', '14');
-- parametr 10 is used to identify time zone in which parameter 9 is specified  
INSERT INTO enum_parameters (id, name, val) 
VALUES (10, 'regular_day_procedure_zone', 'CET');
-- parametr 11 is used to change state of objects other than domain to
-- deleteCandidate. It is specified in granularity of months and means, period
-- during which object wasn't linked to other object and wasn't updated 
INSERT INTO enum_parameters (id, name, val) 
VALUES (11, 'object_registration_protection_period', '6');

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
