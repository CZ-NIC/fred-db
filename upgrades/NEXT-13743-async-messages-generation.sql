-- parameter 15 can disable asynchronous generation of SMS messages. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (15, 'mojeid_async_sms_generation', 'enabled');
-- parameter 16 can disable asynchronous generation of letters. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (16, 'mojeid_async_letter_generation', 'enabled');
-- parameter 17 can disable asynchronous generation of e-mails. 
-- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
-- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (17, 'mojeid_async_email_generation', 'enabled');

-- used for mojeid asynchronous generation of messages
CREATE INDEX public_request_status_create_time_idx ON public_request(status,create_time);