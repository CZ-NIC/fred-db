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
VALUES (1, 'model_version', '1.8');
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