-- DROP TABLE enum_status CASCADE;
CREATE TABLE enum_status (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
       );
                                               
INSERT INTO enum_status (id , status) VALUES( 1   , 'ok' );
INSERT INTO enum_status (id , status) VALUES( 2   , 'inactive' );
INSERT INTO enum_status (id , status) VALUES( 101 , 'clientDeleteProhibited');
INSERT INTO enum_status (id , status) VALUES( 201 , 'serverDeleteProhibited');
INSERT INTO enum_status (id , status) VALUES( 102 , 'clientHold');
INSERT INTO enum_status (id , status) VALUES( 202 , 'serverHold');
INSERT INTO enum_status (id , status) VALUES( 103 , 'clientRenewProhibited');
INSERT INTO enum_status (id , status) VALUES( 203 , 'serverRenewProhibited');
INSERT INTO enum_status (id , status) VALUES( 104 , 'clientTransferProhibited');
INSERT INTO enum_status (id , status) VALUES( 204 , 'serverTransferProhibited');
INSERT INTO enum_status (id , status) VALUES( 105 , 'clientUpdateProhibited');
INSERT INTO enum_status (id , status) VALUES( 205 , 'serverUpdateProhibited');
INSERT INTO enum_status (id , status) VALUES( 301 , 'pendingCreate');
INSERT INTO enum_status (id , status) VALUES( 302 , 'pendingDelete');
INSERT INTO enum_status (id , status) VALUES( 303 , 'pendingRenew');
INSERT INTO enum_status (id , status) VALUES( 304 , 'pendingTransfer');
INSERT INTO enum_status (id , status) VALUES( 305 , 'pendingUpdate');

select setval('enum_status_id_seq', 305);
                       
comment on table enum_status is
'id - status
1   - ok
2   - inactive
101 - clientDeleteProhibited
201 - serverDeleteProhibited
102 - clientHold
202 - serverHold
103 - clientRenewProhibited
203 - serverRenewProhibited
104 - clientTransferProhibited
204 - serverTransferProhibited
105 - clientUpdateProhibited
205 - serverUpdateProhibited
301 - pendingCreate
302 - pendingDelete
303 - pendingRenew
304 - pendingTransfer
305 - pendingUpdate';
comment on column enum_status.id is 'status id';
comment on column enum_status.status is 'status message';
