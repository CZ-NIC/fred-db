-- tabulka pro pricitani creditu za operace DomainCreate a DomainReNew
DROP TABLE Credit CASCADE;
CREATE TABLE Credit (
        ID SERIAL PRIMARY KEY, -- vraci se jako clientID z CORBA funkce Login
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registratora
	DomainID  INTEGER NOT NULL , -- REFERENCES odkaz do Domain
        -- tabulky nebo do domain_history pokud je domena vymazana	          
        Date timestamp NOT NULL DEFAULT now(), -- datum a cas pricteni creditu
        DomainCreate boolean  DEFAULT true , -- true pokud je opera 
        period INTEGER   -- perioda prodlozeni platnosti domeny v mesicich
        );


