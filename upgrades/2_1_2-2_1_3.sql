
ALTER TABLE mail_type ALTER subject TYPE varchar(550);

UPDATE mail_type SET subject = 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder of the need to settle fees for the domain <?cs var:domain ?>' WHERE name = 'expiration_notify';

UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about inactivation of the domain <?cs var:domain ?> from DNS' WHERE name = 'expiration_dns_owner';

UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>' WHERE name = 'expiration_register_owner';

UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about withdrawal of the domain <?cs var:domain ?> from DNS' WHERE name = 'expiration_dns_tech';

UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>' WHERE name = 'expiration_register_tech';

UPDATE mail_type SET subject = 'Oznámení vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation' WHERE name = 'expiration_validation_before';

UPDATE mail_type SET subject = 'Oznámení o vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation' WHERE name = 'expiration_validation';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o registraci <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> registration notification' WHERE name = 'notification_create';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení změn <?cs call:typesubst("cs") ?> <?cs var:handle ?>/ Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> changes' WHERE name = 'notification_update';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o transferu <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> transfer notification' WHERE name = 'notification_transfer';

UPDATE mail_type SET subject = 'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Domain name <?cs var:handle ?> renew notification' WHERE name = 'notification_renew';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification' WHERE name = 'notification_unused';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification' WHERE name = 'notification_delete';

UPDATE mail_templates SET template =
'English version of the e-mail is entered below the Czech version

Zaslání potvrzení o přijaté záloze

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad na přijatou zálohu pro zónu <?cs var:zone ?>. Tento daňový doklad 
slouží k uplatnění nároku na odpočet DPH přijaté zálohy

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Accepted Advance Payment Confirmation

Dear business partners,

  Enclosed with this letter, we are sending a tax document for the advance
payment accepted for the zone <?cs var:zone ?>. This tax document can be used to claim VAT deduction for
the advance payment.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
' WHERE id = 17;

UPDATE mail_templates SET template = 
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad za služby registrací doménových jmen a 
udržování záznamů o doménových jménech za období od <?cs var:fromdate ?>
do <?cs var:todate ?> pro zónu <?cs var:zone ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Monthly Bill Dispatching

Dear business partners,

  Enclosed with this letter, we are sending a tax document for the domain name
registration services and the maintenance of domain name records for the period
from <?cs var:fromdate ?> to <?cs var:todate ?> for the zone <?cs var:zone ?>.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
' WHERE id = 18;

UPDATE mail_templates SET template =
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  jelikož v období od <?cs var:fromdate ?> do <?cs var:todate ?> v zóně <?cs var:zone ?> Vaše společnost neprovedla
žádnou registraci doménového jména ani prodloužení platnosti doménového
jména a nedošlo tak k čerpání žádných placených služeb, nebude pro toto
období vystaven daňový doklad.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Monthly Bill Dispatching

Dear business partners,

  Since your company has not performed any domain name registration or domain
name validity extension in the period from <?cs var:fromdate ?> to <?cs var:todate ?> for the zone <?cs var:zone ?>,
hence not drawing any paid services, no tax document will be issued for this
period.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
' WHERE id = 19;
