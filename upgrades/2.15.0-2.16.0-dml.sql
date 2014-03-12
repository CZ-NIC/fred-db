---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.16.0' WHERE id = 1;



---
--- #Ticket #10252
---
INSERT INTO mail_header_defaults (id, h_from, h_replyto, h_errorsto, h_organization, h_contentencoding, h_messageidserver)
    VALUES (2, 'podpora@mojeid.cz', 'podpora@mojeid.cz', 'podpora@mojeid.cz', 'CZ.NIC, z.s.p.o.', NULL, 'nic.cz');

INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id)
    SELECT id, 1 FROM mail_type WHERE NOT name LIKE '%mojeid%';

INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id)
    VALUES (NULL, 1);

INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id)
    SELECT id, 2 FROM mail_type WHERE name LIKE '%mojeid%';
