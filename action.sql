-- ciselnik funkci
-- DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

-- prihlasovaci funkce
INSERT INTO enum_action (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO enum_action (id , status) VALUES(101 , 'ClientLogout');
-- poll funkce
INSERT INTO enum_action (id , status) VALUES(  120 , 'PollAcknowledgement' );
INSERT INTO enum_action (id , status) VALUES(  121 ,  'PollResponse' );

 
-- funkce pro praci s kontakty
INSERT INTO enum_action (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO enum_action (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO enum_action (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO enum_action (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO enum_action (id , status) VALUES(204 , 'ContactCreate');

-- funkce pro hosty
INSERT INTO enum_action (id , status) VALUES(300 , 'HostCheck');
INSERT INTO enum_action (id , status) VALUES(301 , 'HostInfo');
INSERT INTO enum_action (id , status) VALUES(302 , 'HostDelete');
INSERT INTO enum_action (id , status) VALUES(303 , 'HostUpdate');
INSERT INTO enum_action (id , status) VALUES(304 , 'HostCreate');

-- funkce pro NSSET
INSERT INTO enum_action (id , status) VALUES(400 , 'NSsetCheck');
INSERT INTO enum_action (id , status) VALUES(401 , 'NSsetInfo');
INSERT INTO enum_action (id , status) VALUES(402 , 'NSsetDelete');
INSERT INTO enum_action (id , status) VALUES(403 , 'NSsetUpdate');
INSERT INTO enum_action (id , status) VALUES(404 , 'NSsetCreate');
INSERT INTO enum_action (id , status) VALUES(405 , 'NSsetTransfer');

-- funkce pro domeny
INSERT INTO enum_action (id , status) VALUES(500 , 'DomainCheck');
INSERT INTO enum_action (id , status) VALUES(501 , 'DomainInfo');
INSERT INTO enum_action (id , status) VALUES(502 , 'DomainDelete');
INSERT INTO enum_action (id , status) VALUES(503 , 'DomainUpdate');
INSERT INTO enum_action (id , status) VALUES(504 , 'DomainCreate');
INSERT INTO enum_action (id , status) VALUES(505 , 'DomainTransfer');
INSERT INTO enum_action (id , status) VALUES(506 , 'DomainRenew');
INSERT INTO enum_action (id , status) VALUES(507 , 'DomainTrade');

-- funkce nezadana
INSERT INTO enum_action (id , status) VALUES( 1000 , 'UnknowAction');

--  tabulka pro zapis transakci
-- DROP TABLE Action CASCADE;
CREATE TABLE Action (
        ID SERIAL PRIMARY KEY, -- id zaznamu
	clientID INTEGER REFERENCES Login, -- id clienta z tabulky Login moznost i nula
	action INTEGER NOT NULL REFERENCES enum_action, -- typ funkce z enum cisleniku
        response  INTEGER  REFERENCES enum_error, -- navratovt kod funkce 
        StartDate timestamp NOT NULL DEFAULT now(), -- datum a cas prihlaseni do systemu
        clientTRID varchar(128) NOT NULL, -- cislo prihlasovaci transakce
	EndDate timestamp, -- datum a cas uknceni funkce
        serverTRID varchar(128) UNIQUE   -- cislo transakce ze servru 
        );

-- DROP TABLE  action_xml CASCADE;
CREATE TABLE action_xml( actionID INTEGER NOT NULL REFERENCES action, xml text not NULL );

