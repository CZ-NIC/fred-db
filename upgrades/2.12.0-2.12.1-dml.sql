---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.12.1' WHERE id = 1;

---
--- update of identifikaction email according to #7687
---
UPDATE mail_type SET subject='[mojeID] Založení účtu - PIN1 pro aktivaci mojeID' WHERE id=21;
UPDATE mail_templates SET template =
'
Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontatních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít Váš účet mojeID používat.
Zároveň Vám pošleme poštou dopis s kódem PIN3, po jehož zadání bude Váš
účet plně aktivní.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Váš tým <?cs var:defaults.company ?>
'
WHERE id = 21;
