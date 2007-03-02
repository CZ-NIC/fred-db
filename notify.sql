-- Zasilani zprav o zmene stavu objektu


CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
CrDate  timestamp NOT NULL DEFAULT now(),  
objectID integer  REFERENCES object_registry (id), -- id objektu
historyid integer  REFERENCES  history(id) ,  --  zaznamenani stavu v jakem nejaky objekt je
messageid integer  REFERENCES  message(id)  -- pokud je take rozeslana EPP zprava 
);

CREATE TABLE  object_status_notifications_mail_map
(
id INTEGER REFERENCES object_status_notifications(id) , -- odkaz do tabulky
mail_type  integer   REFERENCES  mail_type(id)  , -- typ  email notifikace 
mailid integer references mail_archive(id) -- id odeslaneho mailu
);
