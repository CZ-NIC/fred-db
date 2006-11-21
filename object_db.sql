

CREATE TABLE OBJECT (
        ID SERIAL PRIMARY KEY,
        type smallint , -- typ onjektu 1 kontakt 2 nsset 3 domena
        NAME varchar(255) UNIQUE NOT NULL , -- handle ci FQDN
        ROID varchar(64) UNIQUE NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        CrDate timestamp NOT NULL DEFAULT now(),
        Exdate timestamp DEFAULT NULL ,
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- dle Honzy v XML schematech
        );

