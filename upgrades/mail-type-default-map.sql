CREATE TABLE mail_type_default_map
(
    typeid INTEGER UNIQUE NULL REFERENCES mail_type(id),
    defaultid INTEGER NOT NULL REFERENCES mail_header_defaults(id)
);

INSERT INTO mail_type_default_map (typeid,defaultid) SELECT id,1 FROM mail_type;
INSERT INTO mail_type_default_map (typeid,defaultid) VALUES(NULL,1);
