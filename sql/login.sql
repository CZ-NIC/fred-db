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

comment on table Login is
'records of all epp session

creating - when processing login epp message
updating - when processing logout epp message';
comment on column Login.ID is 'return as cliendID from CORBA Login FUNCTION';
comment on column Login.RegistrarID is 'registrar id';
comment on column Login.LoginDate is 'login date and time into system';
comment on column Login.loginTRID is 'login transaction number';
comment on column Login.LogoutDate is 'logout date and time';
comment on column Login.logoutTRID is 'logout transaction number';
comment on column Login.lang is 'language, in which return error messages';
