-- login table for clients login
-- DROP TABLE Login CASCADE;
CREATE TABLE Login (
        ID SERIAL PRIMARY KEY, -- return as clientID from CORBA Login function
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- registrar id 
        LoginDate timestamp NOT NULL DEFAULT now(), -- login date and time into system
        loginTRID varchar(128) NOT NULL, -- login transaction number
	LogoutDate timestamp, -- logout date and time
        logoutTRID varchar(128), -- logout transaction number 
        lang  varchar(2) NOT NULL DEFAULT 'en' -- language, in which return error messages
        );

CREATE INDEX login_registrarid_idx ON login (registrarid);

