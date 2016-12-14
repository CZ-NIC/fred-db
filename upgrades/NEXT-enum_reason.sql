---
--- Tickets #15032 (63), #15031 (64, 65)
---
INSERT INTO enum_reason VALUES (63, 'Duplicated nameserver hostname', 'Duplicitní jméno jmenného serveru DNS');
INSERT INTO enum_reason VALUES (64, 'Administrative contact not assigned to this object', 'Administrátorský kontakt není přiřazen k tomuto objektu');
INSERT INTO enum_reason VALUES (65, 'Temporary contacts are obsolete', 'Dočasné kontakty již nejsou podporovány');
SELECT setval('enum_reason_id_seq', 65);

