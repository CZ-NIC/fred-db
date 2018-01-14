INSERT INTO mail_template VALUES
(13, 1,
'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Notification of <?cs var:handle ?> domain name renewal',
'<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>
=====================================================================
Oznámení o prodloužení platnosti / Notification of renewal
===================================================================== 
Obnovení domény / Domain renewal
Domény / Domain : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Vážený zákazníku,
Dear customer,

žádost byla úspěšně zpracována, prodloužení platnosti bylo provedeno. 
The request was processed successfully, the domain has been renewed. 

Při každé změně doporučujeme aktualizovat údaje o doméně, vyhnete se
tak možným problémům souvisejícím s prodlužováním platnosti či manipulací
s doménou osobami, které již nejsou oprávněny je provádět.
We recommend updating domain data in the registry after every change
to avoid possible problems with domain renewal or with domain manipulation
done by persons who are not authorized anymore.

Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné
či zavádějící údaje mohou být v souladu s Pravidly registrace doménových jmen
v ccTLD .cz důvodem ke zrušení registrace doménového jména.
We would also like to inform you that in accordance with the
Domain Name Registration Rules for the .cz ccTLD, incorrect, false, incomplete or misleading
information can be grounds for the cancellation of a domain name registration.

Detail domény najdete na <?cs call:whoislink(3, handle) ?>
Details of the domain can be seen at <?cs call:whoislink(3, handle) ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
