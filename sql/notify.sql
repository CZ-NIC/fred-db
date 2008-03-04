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

comment on table enum_notify is
'list of notify operations

id - notify - explenation
 1 - domain exDate after - domain is after date of expiration
 2 - domain DNS after - domain is excluded from a zone
 3 - domain DEL - domain is definitively deleted
 4 - domain valexDate before - domain is closely before expiration of validation date
 5 - domain valexDate after - domain is after expiration of validation date
 6 - domain exDate before - domain is closely before expiration of expiration';

CREATE TABLE  object_status_notifications 
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
notify INTEGER REFERENCES enum_notify(id), -- notification type 
CrDate  timestamp NOT NULL DEFAULT now(),  
objectID integer  REFERENCES object_registry (id), -- object id
historyid integer  REFERENCES  history(id) ,  --  recording of status, in which some object is 
messageid integer  REFERENCES  message(id)  -- if it is also EPP message distributed  
);

comment on column object_status_notifications.notify is 'notification type';
comment on column object_status_notifications.historyid is 'recording of status, in which some object is';
comment on column object_status_notifications.messageid is 'if it is also epp message distributed';

-- coupling tabel of sended e-mails
CREATE TABLE  object_status_notifications_mail_map
(
id INTEGER REFERENCES object_status_notifications(id) , -- link to table
mail_type  integer   REFERENCES  mail_type(id)  , -- type of email notification  
mailid integer references mail_archive(id), -- id of sended e-mail
PRIMARY KEY(id,mail_type,mailid)
);

comment on column object_status_notifications_mail_map.mail_type is 'type of email notification';
comment on column object_status_notifications_mail_map.mailid is 'id of sended e-mail';
