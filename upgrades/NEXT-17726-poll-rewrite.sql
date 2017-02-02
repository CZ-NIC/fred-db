DROP INDEX message_clid_idx;
DROP INDEX message_seen_idx;
CREATE INDEX message_clid_id_unseen_idx ON message (clid,id) WHERE NOT seen;

comment on table Message is 'Message queue for registrars which can be fetched from by epp poll functions';
