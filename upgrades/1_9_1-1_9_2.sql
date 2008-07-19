UPDATE enum_parameters SET val='1.9.2' WHERE id=1;

UPDATE mail_templates SET template=
'English version of the e-mail is entered below the Czech version

Upozornění na nutnost úhrady domény <?cs var:domain ?>

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
registrace doménového jména <?cs var:domain ?>. Vzhledem k tomu, že doménové
jméno bylo za uplynulé období zaplaceno pouze do <?cs var:exdate ?>, nachází se
nyní v takzvané ochranné lhůtě. V případě, že doménové jméno nebude včas
uhrazeno, budou v souladu s Pravidly registrace doménových jmen nasledovat
tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>
Vzhledem k této situaci máte nyní následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace vašeho doménového jména

2. Nebo si vyberte jiného určeného registrátora a jeho prostřednictvím
   zajistěte prodloužení registrace vašeho doménového jména. Seznam
   registrátorů najdete na stránkách sdružení (Seznam registrátorů)


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Reminder of the need to settle fees for the <?cs var:domain ?> domain name

Dear customer,

We would like to inform you that as of <?cs var:checkdate ?>, the registration
of the domain name <?cs var:domain ?> has not been extended. Concerning
the fact that the fee for the domain name in question has been paid only
for a period ended on <?cs var:exdate ?>, your domain name has now entered
the so-called protective period. Unless a registrar of your choice extends
your registration, the following steps will be adopted in accordance with
the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will not be accessible (exclusion from DNS).
<?cs var:exregdate ?> - Final cancellation of the domain name registration.

At present, our database includes the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>
To ensure adequate remedy of the existing situation, you can choose
one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended.

2. Or choose another registrar in order to extend the registration of your
   domain name. For a list of registrars, please visit association pages
   (List of Registrars)


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE id=3;

UPDATE mail_templates SET template=
'
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Vzhledem ke skutečnosti, že <?cs if:type == #1 ?>kontaktní osoba<?cs elif:type == #2 ?>sada nameserverů<?cs /if ?> <?cs var:handle ?>
<?cs var:name ?> nebyla po stanovenou dobu používána, <?cs var:defaults.company ?> ruší ke dni <?cs var:deldate ?> uvedenou
<?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs /if ?>.

Zrušení <?cs if:type == #1 ?>kontaktní osoby<?cs elif:type == #2 ?>sady nameserverů<?cs /if ?> nemá žádný vliv na funkčnost Vašich 
zaregistrovaných doménových jmen.

With regard to the fact that the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs /if ?> <?cs var:handle ?>
<?cs var:name ?> was not used during the fixed period, <?cs var:defaults.company ?>
is cancelling the aforementioned <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>set of nameservers<?cs /if ?> as of <?cs var:deldate ?>.

Cancellation of <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs /if ?> has no influence on functionality of your
registred domains.
=====================================================================


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
'
WHERE id=14;
