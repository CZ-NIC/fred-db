-- Sending messages about a change of object status


-- classifier of notify operation
-- DROP TABLE enum_notify CASCADE;
CREATE TABLE enum_notify  (
        id INTEGER PRIMARY KEY,
        notify varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_notify   VALUES( 1 , 'domain exDate after'); -- domain is after date of expiration
INSERT INTO enum_notify   VALUES( 2 , 'domain DNS after'); -- domain is excluded from a zone
INSERT INTO enum_notify   VALUES( 3 , 'domain DEL' ); -- domain is definitively deleted  
INSERT INTO enum_notify   VALUES( 4 , 'domain valexDate before' ); -- domain is closely before expiration of validation date
INSERT INTO enum_notify   VALUES( 5 , 'domain valexDate  after'); -- domain is after expiration of validation date 
INSERT INTO enum_notify   VALUES( 6 , 'domain exDate before'); -- domain is closely before expiration of expiration

CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
notify INTEGER REFERENCES enum_notify(id), -- notification type 
CrDate  timestamp NOT NULL DEFAULT now(),  
objectID integer  REFERENCES object_registry (id), -- object id
historyid integer  REFERENCES  history(id) ,  --  recording of status, in which some object is 
messageid integer  REFERENCES  message(id)  -- if it is also EPP message distributed  
);

-- vazebni tabulka rozslanych e-mailu
CREATE TABLE  object_status_notifications_mail_map
(
id INTEGER REFERENCES object_status_notifications(id) , -- link to table
mail_type  integer   REFERENCES  mail_type(id)  , -- typ  email notifikace 
mailid integer references mail_archive(id), -- id odeslaneho mailu
PRIMARY KEY(id,mail_type,mailid)
);

