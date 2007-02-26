-- Zasilani zprav o zmene stavu objektu


CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
CrDate  timestamp NOT NULL DEFAULT now(),  
mail_type  integer   REFERENCES  mail_type(id)  , -- typ  notifikace dle rozesilaneho template e-mailu
objectID integer  REFERENCES object_registry (id), -- id objektu
historyid integer  REFERENCES  history(id) ,  --  zaznamenani stavu v jakem nejaky objekt je
mailid integer references mail_archive(id), -- id odeslaneho mailu
messageid integer  REFERENCES  message(id)  -- pokud je take rozeslana EPP zprava 
);
