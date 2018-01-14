INSERT INTO mail_template VALUES
(14, 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> deletion',
'Vážený zákazníku,

vzhledem ke skutečnosti, že <?cs if:type == #1 ?>kontaktní osoba<?cs elif:type == #2 ?>sada nameserverů<?cs elif:type == #4 ?>sada klíčů<?cs /if ?> s identifikátorem <?cs var:handle ?>
nebyla po stanovenou dobu používána, tedy připojena k doméně<?cs if:type == #1 ?> nebo používána jako účet mojeID<?cs /if ?>, uvedenou <?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs elif:type == #4 ?>sadu klíčů<?cs /if ?> ke dni <?cs var:deldate ?> rušíme.

Zrušení této <?cs if:type == #1 ?>kontaktní osoby<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?> nemá žádný vliv na funkčnost Vašich
zaregistrovaných doménových jmen, protože není možné zrušit <?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs elif:type == #4 ?>sadu klíčů<?cs /if ?>, která se nachází u některé domény.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> identified with <?cs var:handle ?>
was not used during the determined period, i.e. attached to a domain<?cs if:type == #1 ?> or used as mojeID account<?cs /if ?>, we are
cancelling the aforementioned <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>set of nameservers<?cs elif:type == #4 ?>set of keysets<?cs /if ?> as of <?cs var:deldate ?>.

Cancellation of the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> has no influence on functionality of your
registred domains, since it is impossible to cancel a <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> assigned to a domain.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
