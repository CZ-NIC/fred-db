UPDATE mail_type SET subject = 'MojeID - změna e-mailu' WHERE id = 24;

UPDATE mail_templates SET template =
'Vážený uživateli,

k dokončení procedury změny e-mailu zadejte prosím kód PIN1: <?cs var:pin ?>

Váš tým CZ.NIC'
WHERE id = 24;
