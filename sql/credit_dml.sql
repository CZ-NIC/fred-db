

-- init credit for all registrars and zones to 0
INSERT INTO registrar_credit SELECT nextval('registrar_credit_id_seq'), 0,r.id,  z.id FROM registrar r, zone z;
