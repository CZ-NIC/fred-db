INSERT INTO service (id, partition_postfix, name) VALUES
(10, 'ferda_', 'Ferda');

SELECT SETVAL('service_id_seq'::REGCLASS, (SELECT MAX(id) FROM service));

INSERT INTO request_type (service_id, id, name) VALUES
(10, 10000, 'ContactAuthInfo'),
(10, 10001, 'ContactDetail'),
(10, 10002, 'ContactHistory'),
(10, 10003, 'ContactSearch'),
(10, 10004, 'ContactSearchHistory'),
(10, 10005, 'ContactState'),
(10, 10006, 'DomainAuthInfo'),
(10, 10007, 'DomainDetail'),
(10, 10008, 'DomainHistory'),
(10, 10009, 'DomainSearch'),
(10, 10010, 'DomainSearchHistory'),
(10, 10011, 'DomainState'),
(10, 10012, 'KeysetAuthInfo'),
(10, 10013, 'KeysetDetail'),
(10, 10014, 'KeysetHistory'),
(10, 10015, 'KeysetSearch'),
(10, 10016, 'KeysetSearchHistory'),
(10, 10017, 'KeysetState'),
(10, 10018, 'NssetAuthInfo'),
(10, 10019, 'NssetDetail'),
(10, 10020, 'NssetHistory'),
(10, 10021, 'NssetSearch'),
(10, 10022, 'NssetSearchHistory'),
(10, 10023, 'NssetState'),
(10, 10024, 'RegistrarCreditList'),
(10, 10025, 'RegistrarDetail'),
(10, 10026, 'RegistrarList'),
(10, 10027, 'ContactRepresentativeChange'),
(10, 10028, 'ContactRepresentativeDelete');

SELECT SETVAL('request_type_id_seq'::REGCLASS, (SELECT MAX(id) FROM request_type));

INSERT INTO result_code (service_id, result_code, name) VALUES
(10, 0 , 'Success'),
(10, 1 , 'Fail'),
(10, 2 , 'Error');

SELECT SETVAL('result_code_id_seq'::REGCLASS, (SELECT MAX(id) FROM result_code));
