-- ciselnik funkci
DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

-- prihlasovaci funkce
INSERT INTO enum_action (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO enum_action (id , status) VALUES(101 , 'ClientLogout');
-- funkce pro praci s kontakty
INSERT INTO enum_action (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO enum_action (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO enum_action (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO enum_action (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO enum_action (id , status) VALUES(204 , 'ContactCreate');
INSERT INTO enum_action (id , status) VALUES(205 , 'ContactTransfer');
-- funkce pro hosty
INSERT INTO enum_action (id , status) VALUES(300 , 'HostCheck');
INSERT INTO enum_action (id , status) VALUES(301 , 'HostInfo');
INSERT INTO enum_action (id , status) VALUES(302 , 'HostDelete');
INSERT INTO enum_action (id , status) VALUES(303 , 'HostUpdate');
INSERT INTO enum_action (id , status) VALUES(304 , 'HostCreate');
-- funkce pro domeny
INSERT INTO enum_action (id , status) VALUES(400 , 'DomainCheck');
INSERT INTO enum_action (id , status) VALUES(401 , 'DomainInfo');
INSERT INTO enum_action (id , status) VALUES(402 , 'DomainDelete');
INSERT INTO enum_action (id , status) VALUES(403 , 'DomainUpdate');
INSERT INTO enum_action (id , status) VALUES(404 , 'DomainCreate');
INSERT INTO enum_action (id , status) VALUES(405 , 'DomainTransfer');

--  tabulka pro zapis transakci
DROP TABLE Action CASCADE;
CREATE TABLE Action (
        ID SERIAL PRIMARY KEY, -- id zaznamu
	clientID INTEGER NOT NULL REFERENCES Login, -- id clienta z tabulky Login
	action INTEGER NOT NULL REFERENCES enum_action, -- typ funkce z enum cisleniku
        response  INTEGER  REFERENCES enum_error, -- navratovt kod funkce 
        StartDate timestamp NOT NULL DEFAULT now(), -- datum a cas prihlaseni do systemu
        clientTRID varchar(128) NOT NULL, -- cislo prihlasovaci transakce
	EndDate timestamp, -- datum a cas uknceni funkce
        serverTRID varchar(128) UNIQUE   -- cislo transakce ze servru 
        );

