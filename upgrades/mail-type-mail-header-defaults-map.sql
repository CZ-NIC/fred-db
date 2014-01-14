CREATE TABLE mail_type_mail_header_defaults_map
(
    typeid INTEGER CONSTRAINT mail_type_mail_header_defaults_map_typeid UNIQUE NULL CONSTRAINT mail_type_id REFERENCES mail_type(id),
    defaultid INTEGER NOT NULL CONSTRAINT mail_header_defaults_id REFERENCES mail_header_defaults(id)
);

INSERT INTO mail_header_defaults (id,h_from,h_replyto,h_errorsto,h_organization,h_contentencoding,h_messageidserver)
VALUES (2,'podpora@mojeid.cz','podpora@mojeid.cz','podpora@mojeid.cz','CZ.NIC, z.s.p.o.',NULL,'nic.cz');

INSERT INTO mail_type_mail_header_defaults_map (typeid,defaultid)
SELECT id,1 FROM mail_type WHERE NOT name LIKE '%mojeid%';

INSERT INTO mail_type_mail_header_defaults_map (typeid,defaultid)
VALUES (NULL,1);

INSERT INTO mail_type_mail_header_defaults_map (typeid,defaultid)
SELECT id,2 FROM mail_type WHERE name LIKE '%mojeid%';
