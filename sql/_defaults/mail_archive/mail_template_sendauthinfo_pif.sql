INSERT INTO mail_template VALUES
(1, 1, 'Zaslání autorizační informace / Sending authorization information',
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře
na našich stránkách dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

Heslo je: <?cs var:authinfo ?>

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Based on your request submitted via the web form on our pages on
<?cs var:reqdate ?>, which was assigned
the identification number <?cs var:reqid ?>, we are sending you the requested
password belonging to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>keyset identified with<?cs /if ?> <?cs var:handle ?>.

The password is: <?cs var:authinfo ?>

If you did not submit the aforementioned request, please notify us of
this fact at the address <?cs var:defaults.emailsupport ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
