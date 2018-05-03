CREATE TABLE MessageType (
        ID INTEGER CONSTRAINT messagetype_pkey PRIMARY KEY,
	name VARCHAR(30) NOT NULL
);
-- do not change the number codes - current code depends on it!
INSERT INTO MessageType VALUES (01, 'credit');
INSERT INTO MessageType VALUES (02, 'techcheck');
INSERT INTO MessageType VALUES (03, 'transfer_contact');
INSERT INTO MessageType VALUES (04, 'transfer_nsset');
INSERT INTO MessageType VALUES (05, 'transfer_domain');
INSERT INTO MessageType VALUES (06, 'idle_delete_contact');
INSERT INTO MessageType VALUES (07, 'idle_delete_nsset');
INSERT INTO MessageType VALUES (08, 'idle_delete_domain');
INSERT INTO MessageType VALUES (09, 'imp_expiration');
INSERT INTO MessageType VALUES (10, 'expiration');
INSERT INTO MessageType VALUES (11, 'imp_validation');
INSERT INTO MessageType VALUES (12, 'validation');
INSERT INTO MessageType VALUES (13, 'outzone');
INSERT INTO MessageType VALUES (14, 'transfer_keyset');
INSERT INTO MessageType VALUES (15, 'idle_delete_keyset');
INSERT INTO MessageType VALUES (17, 'update_domain');
INSERT INTO MessageType VALUES (18, 'update_nsset');
INSERT INTO MessageType VALUES (19, 'update_keyset');
INSERT INTO MessageType VALUES (20, 'delete_contact');
INSERT INTO MessageType VALUES (21, 'delete_domain');
INSERT INTO MessageType VALUES (22, 'update_contact');

COMMENT ON TABLE MessageType IS
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
13 - outzone
14 - transfer_keyset
15 - idle_delete_keyset
17 - update_domain
18 - update_nsset
19 - update_keyset
20 - delete_contact
21 - delete_domain
22 - update_contact';

CREATE TABLE Message (
        ID SERIAL CONSTRAINT message_pkey PRIMARY KEY,
        ClID INTEGER NOT NULL CONSTRAINT message_clid_fkey REFERENCES Registrar ON UPDATE CASCADE,
        CrDate timestamp NOT NULL DEFAULT now(),
        ExDate TIMESTAMP,
        Seen BOOLEAN NOT NULL DEFAULT false,
	MsgType INTEGER CONSTRAINT message_msgtype_fkey REFERENCES messagetype (id)
);
CREATE INDEX message_clid_id_unseen_idx ON message (clid,id) WHERE NOT seen;

comment on table Message is 'Message queue for registrars which can be fetched from by epp poll functions';

CREATE TABLE poll_credit (
  msgid INTEGER CONSTRAINT poll_credit_pkey PRIMARY KEY
  CONSTRAINT poll_credit_msgid_fkey REFERENCES message (id),
  zone INTEGER CONSTRAINT poll_credit_zone_fkey REFERENCES zone (id),
  credlimit numeric(10,2) NOT NULL,
  credit numeric(10,2) NOT NULL
);

CREATE TABLE poll_credit_zone_limit (
  zone INTEGER CONSTRAINT poll_credit_zone_limit_pkey PRIMARY KEY
  CONSTRAINT poll_credit_zone_limit_zone_fkey REFERENCES zone(id),
  credlimit numeric(10,2) NOT NULL
);

CREATE TABLE poll_eppaction (
  msgid INTEGER CONSTRAINT poll_eppaction_pkey PRIMARY KEY
  CONSTRAINT poll_eppaction_msgid_fkey REFERENCES message (id),
  objid INTEGER CONSTRAINT poll_eppaction_objid_fkey REFERENCES object_history (historyid)
);

CREATE TABLE poll_techcheck (
  msgid INTEGER CONSTRAINT poll_techcheck_pkey PRIMARY KEY
  CONSTRAINT poll_techcheck_msgid_fkey REFERENCES message (id),
  cnid INTEGER CONSTRAINT poll_techcheck_cnid_fkey REFERENCES check_nsset (id)
);

CREATE TABLE poll_stateChange (
  msgid INTEGER CONSTRAINT poll_statechange_pkey PRIMARY KEY
  CONSTRAINT poll_statechange_msgid_fkey REFERENCES message (id),
  stateid INTEGER CONSTRAINT poll_statechange_stateid_fkey REFERENCES object_state (id)
);

CREATE INDEX poll_statechange_stateid_idx ON poll_statechange (stateid);
