INSERT INTO mail_template VALUES
(2, 1, 'Zaslání autorizační informace / Sending authorization information',
'Vážený zákazníku,

na základě Vaší žádosti, podané prostřednictvím registrátora
<?cs var:registrar ?>, Vám zasíláme požadované heslo
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

Heslo je: <?cs var:authinfo ?>

Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Based on your request submitted via the registrar <?cs var:registrar ?>,
we are sending you the requested password belonging to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>keyset identified with<?cs /if ?> <?cs var:handle ?>.

The password is: <?cs var:authinfo ?>

This message is being sent only to the e-mail address of the relevant person that we have on file in the Central Registry of Domain Names.

If you did not submit the aforementioned request, please notify us of this fact at the address <?cs var:defaults.emailsupport ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
