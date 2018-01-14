INSERT INTO mail_template VALUES
(18, 1,
'Zaslání měsíčního vyúčtování / Monthly bill dispatching',
'Vážení obchodní přátelé,

v příloze zasíláme daňový doklad za služby registrací doménových jmen
a udržování záznamů o doménových jménech za období od <?cs var:fromdate ?>
do <?cs var:todate ?> pro zónu <?cs var:zone ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Enclosed with this letter, we are sending a tax document for domain name
registration services and the maintenance of domain name records in the period
from <?cs var:fromdate ?> to <?cs var:todate ?> for the <?cs var:zone ?> zone.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
