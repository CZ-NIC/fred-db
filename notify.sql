-- Zasilani zprav o zmene stavu objektu


-- ciselnik notify operaci
-- DROP TABLE enum_notify CASCADE;
CREATE TABLE enum_notify  (
        id SERIAL PRIMARY KEY,
        notify varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_notify   VALUES( 1 , 'domain exDate after'); -- domena je po datumu Expirace
INSERT INTO enum_notify   VALUES( 2 , 'domain DNS after'); -- domena je vyrazena ze zony
INSERT INTO enum_notify   VALUES( 3 , 'domain DEL' ); -- domena je definitivne smazana 
INSERT INTO enum_notify   VALUES( 4 , 'domain valexDate before' ); -- domena je tesne pres uplynutim datumu validace
INSERT INTO enum_notify   VALUES( 5 , 'domain valexDate  after'); -- domena  je po uplynuti datumu validace
INSERT INTO enum_notify   VALUES( 6 , 'domain exDate before'); -- domena je tesne pred uplynutim expirace

CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
notify INTEGER REFERENCES enum_notify(id), -- typ notifikace 
CrDate  timestamp NOT NULL DEFAULT now(),  
objectID integer  REFERENCES object_registry (id), -- id objektu
historyid integer  REFERENCES  history(id) ,  --  zaznamenani stavu v jakem nejaky objekt je
messageid integer  REFERENCES  message(id)  -- pokud je take rozeslana EPP zprava 
);

-- vazebni tabulka rozslanych e-mailu
CREATE TABLE  object_status_notifications_mail_map
(
id INTEGER REFERENCES object_status_notifications(id) , -- odkaz do tabulky
mail_type  integer   REFERENCES  mail_type(id)  , -- typ  email notifikace 
mailid integer references mail_archive(id) -- id odeslaneho mailu
);
