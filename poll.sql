CREATE TABLE MessageType (
        ID INTEGER PRIMARY KEY,
	name VARCHAR(30) NOT NULL
);
-- do not change the number codes - current code depends on it!
INSERT INTO MessageType VALUES (01, 'credit');
INSERT INTO MessageType VALUES (02, 'techcheck');
INSERT INTO MessageType VALUES (03, 'transfer_contact');
INSERT INTO MessageType VALUES (04, 'transfer_nsset');
INSERT INTO MessageType VALUES (05, 'transfer_domain');
INSERT INTO MessageType VALUES (06, 'delete_contact');
INSERT INTO MessageType VALUES (07, 'delete_nsset');
INSERT INTO MessageType VALUES (08, 'delete_domain');
INSERT INTO MessageType VALUES (09, 'imp_expiration');
INSERT INTO MessageType VALUES (10, 'expiration');
INSERT INTO MessageType VALUES (11, 'imp_validation');
INSERT INTO MessageType VALUES (12, 'validation');
INSERT INTO MessageType VALUES (13, 'outzone');

CREATE TABLE Message (
        ID SERIAL PRIMARY KEY,
        ClID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE,
        CrDate timestamp NOT NULL DEFAULT now(),
        ExDate TIMESTAMP,
        Seen BOOLEAN NOT NULL DEFAULT false,
	MsgType INTEGER REFERENCES messagetype (id)
);
CREATE INDEX message_clid_idx ON message (clid);
CREATE INDEX message_seen_idx ON message (clid,seen,crdate,exdate);

CREATE TABLE poll_credit (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  zone INTEGER REFERENCES zone (id),
  credlimit INTEGER NOT NULL,
  credit INTEGER NOT NULL
);

CREATE TABLE poll_eppaction (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  objid INTEGER REFERENCES object_history (historyid)
);

CREATE TABLE poll_techcheck (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  cnid INTEGER REFERENCES check_nsset (id)
);

CREATE TABLE poll_stateChange (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  stateid INTEGER REFERENCES object_state (id)
);

