INSERT INTO mail_template VALUES
(7, 1, 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation',
'Vážený zákazníku,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:exregdate ?> zrušeno.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that you are stated as the technical contact for the set
<?cs var:nsset ?> of nameservers assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was cancelled as of <?cs var:exregdate ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
