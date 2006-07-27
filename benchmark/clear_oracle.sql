--
-- delete tables in correct order
--

DELETE FROM domain_contact_map;
DELETE FROM nsset_contact_map;
DELETE FROM host;
DELETE FROM domain;
DELETE FROM enumval;
DELETE FROM nsset;
DELETE FROM contact;
DELETE FROM message;
DELETE FROM contact_history;
DELETE FROM nsset_contact_map_history;
DELETE FROM nsset_history;
DELETE FROM host_history;
DELETE FROM domain_contact_map_history;
DELETE FROM domain_history;
DELETE FROM enumval_history;
DELETE FROM history;
DELETE FROM action;
DELETE FROM login;
DELETE FROM registraracl;
DELETE FROM registrar;

--
-- reset all sequences to initial values
--

DROP SEQUENCE history_id_seq;
DROP SEQUENCE action_id_seq;
DROP SEQUENCE login_id_seq;
DROP SEQUENCE message_id_seq;
DROP SEQUENCE registrar_id_seq;
DROP SEQUENCE contact_id_seq;
DROP SEQUENCE host_id_seq;
DROP SEQUENCE domain_id_seq;
DROP SEQUENCE nsset_id_seq;
DROP SEQUENCE zone_id_seq;
CREATE SEQUENCE history_id_seq;
CREATE SEQUENCE action_id_seq;
CREATE SEQUENCE login_id_seq;
CREATE SEQUENCE message_id_seq;
CREATE SEQUENCE registrar_id_seq;
CREATE SEQUENCE contact_id_seq;
CREATE SEQUENCE host_id_seq;
CREATE SEQUENCE domain_id_seq;
CREATE SEQUENCE nsset_id_seq;
CREATE SEQUENCE zone_id_seq;

COMMIT;
