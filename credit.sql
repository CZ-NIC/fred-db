-- tabulka pro pricitani creditu za operace DomainCreate a DomainReNew
DROP TABLE Credit CASCADE;
CREATE TABLE Credit (
        ID SERIAL PRIMARY KEY, -- vraci se jako clientID z CORBA funkce Login
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registratora
	ObjectID  INTEGER NOT NULL , -- id objektu domain nsset contact
        Date timestamp NOT NULL DEFAULT now(), -- datum a cas pricteni creditu
        OperationID INTEGER NOT NULL REFERENCES enum_action , -- typ akce 
        period INTEGER   -- perioda prodlozeni platnosti domeny v mesicich
        );


