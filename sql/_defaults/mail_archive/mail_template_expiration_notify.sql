INSERT INTO mail_template VALUES
(3, 1, 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder to settle fees for the <?cs var:domain ?> domain',
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud Váš registrátor neprodloužil
platnost doménového jména <?cs var:domain ?>. Vzhledem k tomu, že doménové
jméno bylo za uplynulé období zaplaceno pouze do <?cs var:exdate ?>, nachází se
nyní v takzvané ochranné lhůtě. V případě, že platba za doménové jméno nebude včas
uhrazena, budou v souladu s Pravidly registrace doménových jmen následovat
tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme o doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

V této situaci máte následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace doménového jména,

2. nebo si v seznamu na našich stránkách (<?cs var:defaults.registrarlistpage ?>)
   vyberte jiného určeného registrátora a jeho prostřednictvím zajistěte
   prodloužení registrace doménového jména.

3. Za prodloužení platnosti domény neplaťte, doména bude zrušena automaticky
   ve stanoveném termínu.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

We would like to inform you that as of <?cs var:checkdate ?>, your registrar
did not extend the registration of the domain name <?cs var:domain ?>. Concerning
the fact that the fee for the domain name in question has been paid only
for a period ending on <?cs var:exdate ?>, your domain name has now entered
the so-called protection period. Unless a registrar of your choice extends
your registration, the following steps will be adopted in accordance with
the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will become inaccessible (exclusion from DNS).
<?cs var:exregdate ?> - The final cancellation of the domain name registration.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

To remedy the existing situation, you can choose one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended;

2. Or choose another registrar from those listed on our pages (<?cs var:defaults.registrarlistpage ?>)
   in order to extend the registration of your domain name;

3. Or do not pay for the extension of the domain registration, the domain
   will be cancelled on the specified date.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
