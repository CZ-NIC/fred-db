---
--- contact states
---
INSERT INTO enum_object_states (id, name, types, manual, external, importance)
VALUES (29, 'serverContactNameChangeProhibited', '{1}', 't', 't', NULL),
       (30, 'serverContactOrganizationChangeProhibited', '{1}', 't', 't', NULL),
       (31, 'serverContactIdentChangeProhibited', '{1}', 't', 't', NULL),
       (32, 'serverContactPermanentAddressChangeProhibited', '{1}', 't', 't', NULL);

INSERT INTO enum_object_states_desc (state_id, lang, description)
VALUES (29, 'CS', 'Není povolena změna jména'),
       (29, 'EN', 'Name update forbidden'),
       (30, 'CS', 'Není povolena změna organizace'),
       (30, 'EN', 'Organization update forbidden'),
       (31, 'CS', 'Není povolena změna dodatečného identifikátoru'),
       (31, 'EN', 'Ident update forbidden'),
       (32, 'CS', 'Není povolena změna adresy trvalého bydliště'),
       (32, 'EN', 'Permanent address update forbidden');
