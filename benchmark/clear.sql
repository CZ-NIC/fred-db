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

SELECT setval('history_id_seq', 1, FALSE);
SELECT setval('action_id_seq', 1, FALSE);
SELECT setval('login_id_seq', 1, FALSE);
SELECT setval('message_id_seq', 1, FALSE);
SELECT setval('registrar_id_seq', 1, FALSE);
SELECT setval('contact_id_seq', 1, FALSE);
SELECT setval('host_id_seq', 1, FALSE);
SELECT setval('domain_id_seq', 1, FALSE);
SELECT setval('nsset_id_seq', 1, FALSE);

