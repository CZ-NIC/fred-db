INSERT INTO mail_template VALUES
(26, 1,
'Identifikace kontaktu / Contact identification',
'Vážený uživateli,

úspěšně jste dokončil(a) první část ověření svého kontaktu
v Centrálním registru s následujícími údaji.

identifikátor: <?cs var:handle ?>
jméno:         <?cs var:firstname ?>
příjmení:      <?cs var:lastname ?>
e-mail:        <?cs var:email ?>

Zároveň Vám byl vygenerován a odeslán poštou kód PIN3, který obdržíte
v nejbližších dnech. Ověření kontaktu dokončíte zadáním kódu PIN3 na stránce
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Rádi bychom Vám také připomněli, že až do okamžiku zadání kódu PIN3
nelze v kontaktu měnit jméno, organizaci, e-mail, telefon ani adresu.
Případná editace těchto údajů v této fázi ověřovacího procesu by měla
za následek jeho přerušení.

Děkujeme za pochopení.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

You have successfully completed the first step of verification
of your contact in the Central registry using the following data.

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

We have also sent you a letter containing your PIN3 and you will receive it
in a few days. To complete your contact verification, submit your PIN3 on the page
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Please, be aware that you should not change contact name, organization, email,
phone or address of the contact before you submit the PIN3. Any modification
of these entries would interrupt the verification process.

Thank you for your understanding.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
