INSERT INTO mail_template VALUES
(5, 1, 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation',
'Vážený zákazníku,

dovolujeme si Vás upozornit, že Váš registrátor neprodloužil platnost registrace
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen rušíme registraci
tohoto doménového jména.

V případě zájmu o opětovnou registraci domény prosím kontaktujte kteréhokoli registrátora ze seznamu na našich stránkách (<?cs var:defaults.registrarlistpage ?>).

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

we would like to inform you that your registrar has not extended the registration
of the domain name <?cs var:domain ?>. Due to this fact and based on the Domain Name Registration Rules, we are cancelling the registration of this domain name.

If you are interested in the registration of the domain again, please contact any registrar listed
on our pages (<?cs var:defaults.registrarlistpage ?>).

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
