-- Zasilani zprav o zmene stavu objektu

CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- jednoznacny primarni klic
CrDate  timestamp NOT NULL DEFAULT now(),  
type  integer  , -- typ  (expiration 1 , validation 2 , vyrazeni ze zony 3 )
objectID integer  REFERENCES object_registry (id), -- id objektu
historyid integer  REFERENCES  history(id) ,  --  zaznamenani stavu v jakem nejaky objekt je
mailid integer references mail_archive(id), -- id odeslaneho mailu
messageid integer  REFERENCES  message(id)  -- zaslana EPP zprava 
);
