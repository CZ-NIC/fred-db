

CREATE TABLE OBJECT (
        ID SERIAL PRIMARY KEY,
        historyID integer REFERENCES history, -- odkaz na posledni zmenu v historii
        type smallint , -- typ onjektu 1 kontakt 2 nsset 3 domena
        ROID varchar(64) UNIQUE NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        CrDate timestamp NOT NULL DEFAULT now(),
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- dle Honzy v XML schematech
        );


CREATE TABLE OBJECT_history (
        historyID INTEGER PRIMARY KEY REFERENCES History, -- odkaz do historie
        ID INTEGER  NOT NULL,
        type smallint , -- typ onjektu 1 kontakt 2 nsset 3 domena         
        ROID varchar(64)  NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        CrDate timestamp NOT NULL,
        Trdate timestamp,
        UpDate timestamp,
        AuthInfoPw varchar(300)
        );

