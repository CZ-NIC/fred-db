INSERT INTO mail_template VALUES
(6, 1, 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification of the <?cs var:domain ?> domain exclusion from DNS',
'Vážený zákazníku,

vzhledem k tomu, že jste veden jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:statechangedate ?> vyřazeno z DNS.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that you are stated as the technical contact for the set
<?cs var:nsset ?> of nameservers assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was excluded from DNS as of <?cs var:statechangedate ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
