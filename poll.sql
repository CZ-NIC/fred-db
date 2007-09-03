CREATE TABLE MessageType (
        ID INTEGER PRIMARY KEY,
	name VARCHAR(30) NOT NULL
);
INSERT INTO MessageType VALUES (1, 'credit');
INSERT INTO MessageType VALUES (2, 'techcheck');
INSERT INTO MessageType VALUES (3, 'eppaction');
INSERT INTO MessageType VALUES (4, 'statechange');

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
  objid INTEGER REFERENCES object_history (id)
);

CREATE TABLE poll_techcheck (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  cnid INTEGER REFERENCES check_nsset (id)
);

CREATE TABLE poll_stateChange (
  msgid INTEGER PRIMARY KEY REFERENCES message (id),
  stateid INTEGER REFERENCES object_state (id)
);

