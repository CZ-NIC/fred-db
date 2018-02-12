INSERT INTO mail_template VALUES
(35, 1,
'Výpis z registru / Registry record statement',
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>, Vám v příloze zasíláme požadovaný výpis z registru doménových jmen.

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto skutečnost na adresu podpora@nic.cz.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

based on the request, you submitted through a web form on our website on <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>,
we are sending the requested domain registry record statement attached to this email.

If you did not make the request, please report this matter to us at podpora@nic.cz.

Yours sincerely
Support of <?cs var:defaults.company_en ?>

', 'plain', 1, 1, 1, DEFAULT);
