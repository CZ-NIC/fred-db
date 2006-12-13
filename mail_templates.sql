\encoding       UTF8

--
-- This script may be called only on just created mail tables, because
-- we assume that sequence numbers are reset to 1 in this script.
--

INSERT INTO mail_type (name, subject) VALUES ('sendauthinfo_pif', 'Zaslání autorizační informace');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránce <?cs var:wwwpage ?> dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející k objektu s identifikátorem <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (1, 1);

INSERT INTO mail_type (name, subject) VALUES ('sendauthinfo_epp', 'Zaslání autorizační informace');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím registrátora 
<?cs var:registrar ?>, jejímž obsahem je žádost o zaslání hesla
příslušející k objektu s identifikátorem <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.


                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (2, 2);

INSERT INTO mail_type (name, subject) VALUES ('expiration_notify', 'Upozornění na nutnost úhrady doménového jména <?cs var:domain ?>');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Upozornění na nutnost úhrady doménového jména <?cs var:domain ?>

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdatetime ?> dosud nedošlo
k prodloužení registrace doménového jména <?cs var:domain ?>.
Vzhledem k tomu, že doménové jméno bylo za uplynulé období zaplaceno pouze
do <?cs var:exdate ?>, nachází se nyní v takzvané ochranné lhůtě.
V případě, že doménové jméno nebude včas uhrazeno, budou v souladu
s Pravidly registrace doménových jmen nasledovat tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrator ?>
<?cs each:item = administrators ?>
Administrátorský kontakt: <?cs var:item ?>
<?cs /each ?>

Vzhledem k této situaci máte nyní následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace vašeho doménového jména

2. Nebo si vyberte jiného určeného registrátora a jeho prostřednictvím
   zajistěte prodloužení registrace vašeho doménového jména. Seznam
   registrátorů najdete na www.nic.cz (Seznam registratoru)



                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



Reminder of the need to settle fees for the <?cs var:domain ?> domain name

Dear customer,

We would like to inform you that as of <?cs var:checkdatetime ?>,
the registration of the domain name <?cs var:domain ?>
has not been extended. Concerning the fact that the fee for the domain name
in question has been paid only for a period ended on <?cs var:exdate ?>,
your domain name has now entered the so-called protective period. Unless
a registrar of your choice extends your registration, the following steps
will be adopted in accordance with the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will not be accessible (exclusion from DNS).
<?cs var:exregdate ?> - Final cancellation of the domain name registration.

At present, our database includes the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Registrar: <?cs var:registrator ?>
<?cs each:item = administrators ?>
Admin contact: <?cs var:item ?>
<?cs /each ?>

To ensure adequate remedy of the existing situation, you can choose
one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended.

2. Or choose another registrar in order to extend the registration of your
   domain name. For a list of registrars, please visit www.nic.cz
   (List of Registrars)



                                                 Yours sincerely
                                                 support <?cs var:defaults.company ?>

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (3, 3);


INSERT INTO mail_type (name, subject) VALUES ('expiration_dns', 'Oznámení o vyřazení domény <?cs var:domain?> z DNS');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Oznámení o vyřazení domény <?cs var:domain?> z DNS

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení či registraci doménového jména <?cs var:domain ?>.
Vzhledem k této skutečnosti a na základě Pravidel registrace doménových
jmen, <?cs var:defaults.company ?> pozastavuje registraci doménového jména
a vyřazuje ji ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exdate ?> neobdrží <?cs var:defaults.company ?>
od vašeho registrátora platbu za prodloužení platnosti doménového jména,
bude doménové jméno definitivně uvolněno pro použití dalším zájemcem, a to
ke dni <?cs var:exregdate ?>.

Prosíme kontaktujte Vašeho Určeného registrátora <?cs var:registrator ?>
za účelem prodloužení doménového jména.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod spravným variabilním symbolem, na správné číslo
účtu a ve spravné výši a tyto informace svému Určenému registrátorovi
sdělte.

Harmonogram plánovaných akcí:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrator ?>
<?cs each:item = administrators ?>
Administrátorský kontakt: <?cs var:item ?>
<?cs /each ?>


                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (4, 4);


INSERT INTO mail_type (name, subject) VALUES ('expiration_register_owner', 'Oznámení o zrušení domény <?cs var:domain ?>');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Oznámení o zrušení domény <?cs var:domain ?>

Vážený zákazníku,

dovolujeme si Vás upozornit, že nebylo provedeno prodloužení registrace
pro doménové jméno <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen , <?cs var:defaults.company ?> ruší
registraci doménového jména.

                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



Dear customer,

we would like to inform you that the registration extension has not yet
been implemented for the domain name <?cs var:domain ?>. Due to
this fact and based on the Domain Name Registration Rules (Pravidla
registrace domenovych jmen), <?cs var:defaults.company ?> is cancelling the domain
name registration.

                                                 Yours sincerely
                                                 support <?cs var:defaults.company ?>

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (5, 5);

INSERT INTO mail_type (name, subject) VALUES ('expiration_register_tech', 'Oznámení o zrušení domény <?cs var:domain ?>');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Oznámení o zrušení domény <?cs var:domain ?>

Vážený technický správce,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:exdate ?> vyřazeno z DNS / zrušeno.

                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (6, 6);

INSERT INTO mail_type (name, subject) VALUES ('expiration_validation', 'Oznámení o vypršení validace enum domény');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'English version is bellow

Oznámení o vypršení validace enum domény.

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdatetime ?> dosud nedošlo k
prodloužení validace doménového jména <?cs var:domain ?>.
Vzhledem k této skutečnosti a na základě Pravidel registrace doménových
jmen, <?cs var:defaults.company ?> ji vyřazuje ze zóny. Doménové jméno je
i nadále registrováno. V případě, že hodláte obnovit validaci uvedeného
doménového jména, kontaktujte prosím svého registrátora a ve spolupráci
s ním zajistěte prodloužení validace vašeho doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrator ?>
<?cs each:item = administrators ?>
Administrátorský kontakt: <?cs var:item ?>
<?cs /each ?>                               

                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (7, 7);

INSERT INTO mail_type (name, subject) VALUES ('notification_create_domain', 'Oznámení o registraci / Registration notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
Oznámení o registraci / Registration notification
======================================================================
Založení domény / Domain create 
Identifikátor domény / Domain handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Žádost byla úspešně zpracována, požadovaná registrace byla provedena. 
The request was completed successfully, required registration was done. 


                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>



English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (8, 8);

INSERT INTO mail_type (name, subject) VALUES ('notification_create_contact', 'Oznámení o registraci / Registration notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
Oznámení o registraci / Registration notification
======================================================================
Založení kontaktu / Contact person create 
Identifikátor kontaktu / Person handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Žádost byla úspešně zpracována, požadovaná registrace byla provedena. 
The request was completed successfully, required registration was done. 


                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>


English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (9, 9);

INSERT INTO mail_type (name, subject) VALUES ('notification_create_nsset', 'Oznámení o registraci / Registration notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
Oznámení o registraci / Registration notification
======================================================================
Založení sady nameserverů / NS set create 
Identifikátor sady nameserverů / NS set handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Žádost byla úspešně zpracována, požadovaná registrace byla provedena. 
The request was completed successfully, required registration was done. 


                                                 S pozdravem
                                                 podpora <?cs var:defaults.company ?>


English version is not available

-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (10, 10);

INSERT INTO mail_type (name, subject) VALUES ('notification_update_domain', 'Oznámení změn / Notification of changes');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů domény / Domain data change 
Identifikátor domény / Domain handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspešně zpracována, požadované změny byly provedeny. 
The request was completed successfully, required changes were done. 
 
--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (11, 11);

INSERT INTO mail_type (name, subject) VALUES ('notification_update_contact', 'Oznámení změn / Notification of changes');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů kontaktu / Contact person data change 
Identifikátor kontaktu / Contact handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspešně zpracována, požadované změny byly provedeny. 
The request was completed successfully, required changes were done. 
 
--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (12, 12);

INSERT INTO mail_type (name, subject) VALUES ('notification_update_nsset', 'Oznámení změn / Notification of changes');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů sady nameserverů / NS set data change 
Identifikátor sady nameserverů / NS set handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspešně zpracována, požadované změny byly provedeny. 
The request was completed successfully, required changes were done. 
 
--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (13, 13);

INSERT INTO mail_type (name, subject) VALUES ('notification_renew', 'Oznámení o prodloužení platnosti / Domain name renew notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení o prodloužení platnosti / Renew notification
===================================================================== 
Dne <?cs var:renewdate ?> bylo provedeno prodloužení platnosti doménového
jména <?cs var:domain ?>
Doménové jméno je prodlouženo do <?cs var:exdate ?>

English version is not available

=====================================================================

--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (14, 14);

INSERT INTO mail_type (name, subject) VALUES ('notification_unused_contact', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Vzhledem ke skutečnosti, že kontaktní osoba <?cs var:handle ?>
<?cs var:name ?> nebyla po dobu stanovenou v Pravidlech registrace
aktivní, <?cs var:defaults.company ?> na základě Pravidel registrace
ruší ke dni <?cs var:deldate ?> uvedenou kontaktní osobu.
=====================================================================


--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (15, 15);

INSERT INTO mail_type (name, subject) VALUES ('notification_unused_nsset', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Vzhledem ke skutečnosti, že sada nameserverů <?cs var:handle ?>
nebyla po dobu stanovenou v Pravidlech registrace aktivní,
<?cs var:defaults.company ?> na základě Pravidel registrace ruší ke dni
<?cs var:deldate ?> uvedenou sadu nameserverů.
=====================================================================


--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (16, 16);

INSERT INTO mail_type (name, subject) VALUES ('notification_delete_contact', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
Oznámení o zrušení / Delete notification 
=====================================================================
Zrušení kontaktu / Contact person data delete
Identifikator kontaktu / person handle : <?cs var:handle ?>
Cislo zadosti / Ticket :  <?cs var:ticket ?>
Registrator / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, požadované zrušení bylo provedeno. 
The request was completed successfully, required delete was done. 
 
=====================================================================

--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (17, 17);

INSERT INTO mail_type (name, subject) VALUES ('notification_delete_nsset', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, template) VALUES
('plain',
'
Oznámení o zrušení / Delete notification 
=====================================================================
Zrušení sady nameserverů / NS set data delete
Identifikátor sady nameserverů / NS set handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, požadované zrušení bylo provedeno. 
The request was completed successfully, required delete was done. 
 
=====================================================================

--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (18, 18);

