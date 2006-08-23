-- tabulka pro pricitani creditu za operace DomainCreate a DomainReNew
-- DROP TABLE Credit CASCADE;


CREATE TABLE Credit (
 id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
 registrar integer NOT NULL REFERENCES Registrar, -- id registratora
 action integer REFERENCES  Action, -- pri jake akci -> action.id (NULL=prijata platba)
 amount numeric(10,2) NOT NULL, -- o jakou castku se ucet pohnul
 credit numeric(10,2) NOT NULL -- celkova castka na kreditu
 );
     
     
