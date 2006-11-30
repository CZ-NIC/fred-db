

CREATE TABLE OBJECT (
        ID SERIAL PRIMARY KEY,
        historyid integer REFERENCES history, -- odkaz na posledni zmenu v historii
        type smallint , -- typ onjektu 1 kontakt 2 nsset 3 domena
        NAME varchar(255) UNIQUE NOT NULL , -- handle ci FQDN
        ROID varchar(64) UNIQUE NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        CrDate timestamp NOT NULL DEFAULT now(),
--      Exdate timestamp DEFAULT NULL , specificky pro jen pro domenu DROP
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- dle Honzy v XML schematech
        );

