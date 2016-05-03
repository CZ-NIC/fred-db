---
--- Ticket #14153 - pin1 email fix
---
UPDATE mail_templates SET template =
'Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontaktních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít svůj účet mojeID používat.
Zároveň Vám pošleme poštou dopis s kódem PIN3, po jehož zadání bude Váš
účet plně aktivní.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

S pozdravem
tým mojeID

Pokud jste o aktivaci tohoto účtu mojeID nežádali, prosíme, tento e-mail ignorujte.
' WHERE id = 21;
