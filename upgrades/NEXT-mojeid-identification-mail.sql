INSERT INTO mail_template (
    mail_type_id,
    version,
    subject,
    body_template,
    body_template_content_type,
    mail_template_footer_id,
    mail_template_default_id,
    mail_header_default_id
)
SELECT
    -- Keep most of the columns intact.
    mt.mail_type_id,
    mt.version + 1,  -- increase version
    mt.subject,
'Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontaktních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít svůj účet mojeID používat.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

S pozdravem
tým mojeID

Pokud jste o aktivaci tohoto účtu mojeID nežádali, prosíme, tento e-mail ignorujte.
',
    mt.body_template_content_type,
    mt.mail_template_footer_id,
    mt.mail_template_default_id,
    mt.mail_header_default_id
FROM
    mail_template mt
    JOIN mail_type mtype ON (mt.mail_type_id = mtype.id)
WHERE
    mtype.name = 'mojeid_identification'
ORDER BY version DESC
LIMIT 1;
