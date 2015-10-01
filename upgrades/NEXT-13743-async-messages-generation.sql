-- parameter 15 can disable asynchronous generation of SMS messages. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (15, 'async_sms_generation', 'enabled');
-- parameter 16 can disable asynchronous generation of letters. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (16, 'async_letter_generation', 'enabled');
-- parameter 17 can disable asynchronous generation of e-mails. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (17, 'async_email_generation', 'enabled');
