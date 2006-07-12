-- login tabulka pro pihlasovani clientu
-- DROP TABLE Login CASCADE;
CREATE TABLE Login (
        ID SERIAL PRIMARY KEY, -- vraci se jako clientID z CORBA funkce Login
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registratora
        LoginDate timestamp NOT NULL DEFAULT now(), -- datum a cas prihlaseni do systemu
        loginTRID varchar(128) NOT NULL, -- cislo prihlasovaci transakce
	LogoutDate timestamp, -- datum a cas odhlaseni
        logoutTRID varchar(128), -- cislo odhlasovaci transakce
        lang  varchar(2) NOT NULL DEFAULT 'en' -- jazyk ve kterem se vraceji chybove zpravy
        );


