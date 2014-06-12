---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.17.0' WHERE id = 1;


---
--- admin. contact verification
---
insert into enum_contact_check_status (id, handle) values('1', 'enqueue_req') ;
insert into enum_contact_check_status (id, handle) values('2', 'enqueued') ;
insert into enum_contact_check_status (id, handle) values('3', 'running') ;
insert into enum_contact_check_status (id, handle) values('4', 'auto_to_be_decided') ;
insert into enum_contact_check_status (id, handle) values('5', 'auto_ok') ;
insert into enum_contact_check_status (id, handle) values('6', 'auto_fail') ;
insert into enum_contact_check_status (id, handle) values('7', 'ok') ;
insert into enum_contact_check_status (id, handle) values('8', 'fail_req') ;
insert into enum_contact_check_status (id, handle) values('9', 'fail') ;
insert into enum_contact_check_status (id, handle) values('10', 'invalidated') ;
insert into enum_contact_test_status (id, handle) values('1', 'enqueued') ;
insert into enum_contact_test_status (id, handle) values('2', 'running') ;
insert into enum_contact_test_status (id, handle) values('3', 'skipped') ;
insert into enum_contact_test_status (id, handle) values('4', 'error') ;
insert into enum_contact_test_status (id, handle) values('5', 'manual') ;
insert into enum_contact_test_status (id, handle) values('6', 'ok') ;
insert into enum_contact_test_status (id, handle) values('7', 'fail') ;
insert into enum_contact_testsuite (id, handle) values('1', 'automatic') ;
insert into enum_contact_testsuite (id, handle) values('2', 'manual') ;
insert into enum_contact_testsuite (id, handle) values('3', 'thank_you') ;
insert into enum_contact_test (id, handle) values('1', 'name_syntax') ;
insert into enum_contact_test (id, handle) values('2', 'phone_syntax') ;
insert into enum_contact_test (id, handle) values('3', 'email_syntax') ;
insert into enum_contact_test (id, handle) values('4', 'cz_address_existence') ;
insert into enum_contact_test (id, handle) values('5', 'contactability') ;
insert into enum_contact_test (id, handle) values('6', 'email_host_existence') ;
insert into enum_contact_test (id, handle) values('7', 'send_letter') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('1', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('2', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('3', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('4', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('5', '2') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('6', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('7', '3') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('1', 'en', 'enqueued', 'Test is ready to be run.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('2', 'en', 'running', 'Test is running.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('3', 'en', 'skipped', 'Test run was intentionally skipped.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('4', 'en', 'error', 'Error happened during test run.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('5', 'en', 'manual', 'Result is inconclusive and evaluation by human is needed.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('6', 'en', 'ok', 'Test result is OK.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('7', 'en', 'fail', 'Test result is FAIL.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('1', 'en', 'enqueue_req', 'Request to create check.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('2', 'en', 'enqueued', 'Check is created.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('3', 'en', 'running', 'Tests contained in this check haven''t finished yet.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('4', 'en', 'auto_to_be_decided', 'Automatic tests evaluation gave no result.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('5', 'en', 'auto_ok', 'Automatic tests evaluation proposes status ok.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('6', 'en', 'auto_fail', 'Automatic tests evaluation proposes status fail. ') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('7', 'en', 'ok', 'Data were manually evaluated as valid.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('8', 'en', 'fail_req', 'Data are probably invalid, needs confirmation.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('9', 'en', 'fail', 'Data were manually evaluated as invalid.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('10', 'en', 'invalidated', 'Check was manually set to be ignored.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('1', 'en', 'automatic', 'Tests without any contact owner cooperation.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('2', 'en', 'manual', 'Tests where contact owner is actively taking part or is being informed.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('3', 'en', 'thank_you', '"Thank you" letter used for contactability testing') ;
insert into enum_contact_test_localization (id, lang, name, description) values('1', 'en', 'name_syntax', 'Testing syntactical validity of name') ;
insert into enum_contact_test_localization (id, lang, name, description) values('2', 'en', 'phone_syntax', 'Testing syntactical validity of phone') ;
insert into enum_contact_test_localization (id, lang, name, description) values('3', 'en', 'email_syntax', 'Testing syntactical validity of e-mail') ;
insert into enum_contact_test_localization (id, lang, name, description) values('4', 'en', 'cz_address_existence', 'Testing address against official dataset (CZ only)') ;
insert into enum_contact_test_localization (id, lang, name, description) values('5', 'en', 'contactability', 'Testing if contact is reachable by e-mail or letter') ;
insert into enum_contact_test_localization (id, lang, name, description) values('6', 'en', 'email_host_existence', 'Testing if e-mail host exists') ;
insert into enum_contact_test_localization (id, lang, name, description) values('7', 'en', 'send_letter', 'Testing if contact is reachable by letter') ;
insert into enum_filetype (id, name) values('8', 'contact check notice') ;
insert into enum_filetype (id, name) values('9', 'contact check thank you') ;
insert into message_type (id, type) values('9', 'contact_check_notice') ;
insert into message_type (id, type) values('10', 'contact_check_thank_you') ;


---
--- Ticket #9475
---

INSERT INTO mail_type (id, name, subject) VALUES (29, 'contact_check_notice', 'Výzva k opravě či doložení správnosti údajů kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(29, 'plain', 1,
'Kontakt id <?cs var:contact_handle ?> - výzva k opravě či doložení správnosti údajů

Vážená paní, vážený pane,
v příloze Vám zasíláme výzvu k opravě či doložení správnosti údajů, které jsou uvedeny u kontaktu id <?cs var:contact_handle ?> (originál odchází s mezinárodní dodejkou prostřednictvím pošty).
V případě jakýchkoliv dotazů či nejasností nás neprodleně kontaktujte.

                                            S pozdravem,
                                            podpora <?cs var:defaults.company ?>

Dear Sirs,
in the attachment you can find a notice to correct or provide evidence of correct data set to the contact id <?cs var:contact_handle ?> (the original was sent to the mail address with international confirmation of delivery).
In case of any questions do not hesitate to contact us.

                                            Best Regards,
                                            support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (29, 29);


INSERT INTO mail_type (id, name, subject) VALUES (30, 'contact_check_warning', 'Druhá výzva k opravě či doložení správnosti údajů kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(30, 'plain', 1,
'Kontakt id <?cs var:contact_handle ?> - II. výzva k opravě či doložení správnosti údajů

Vážená paní, vážený pane,
do dnešního dne nedošlo k opravě údajů, které jsou uvedeny u kontaktu id <?cs var:contact_handle ?>. Zásilka odeslaná na adresu uvedenou u tohoto kontaktu v centrálním registru, se vrátila.
Nebudou-li údaje kontaktu id <?cs var:contact_handle ?> opraveny (případně doložena jejich správnost) do <?cs var:contact_update_till ?>, může CZ.NIC v souladu s Pravidly registrace doménových jmen v ccTLD .cz zrušit registraci doménových jmen, u kterých je tento kontakt uveden jako držitel.

                                            S pozdravem,
                                            podpora <?cs var:defaults.company ?>

Dear Sirs,
let us inform you that up to this day the data set to the contact id <?cs var:contact_handle ?> have not been corrected yet. The letter sent to the address set in the contact in central registry has returned.
In case the data set in the contact id <?cs var:contact_handle ?> are not corrected (or provided the evidence of correct data) till <?cs var:contact_update_till ?> can CZ.NIC in accordance with Rules of Domain Name Registration under ccTLD .cz cancel registration of domain names where this contact is also the owner.

                                            Kind Regards,
                                            support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (30, 30);


---
--- admin contact verification contact states
--- TODO: migration actual contacts with state_id 25 to 26
---
UPDATE enum_object_states SET name='contactPassedManualVerification' WHERE id=25;
INSERT INTO enum_object_states VALUES (26,'contactInManualVerification','{1}','t','t', NULL);
INSERT INTO enum_object_states VALUES (27,'contactFailedManualVerification','{1}','t','t', NULL);

UPDATE enum_object_states_desc SET description='Kontakt byl ověřen zákaznickou podporou CZ.NIC' WHERE state_id=25 AND lang='CS';
INSERT INTO enum_object_states_desc VALUES (26, 'CS', 'Kontakt je ověřován zákaznickou podporou CZ.NIC');
INSERT INTO enum_object_states_desc VALUES (27, 'CS', 'Ověření kontaktu zákaznickou podporou bylo neúspěšné');

UPDATE enum_object_states_desc SET description='Contact has been verified by CZ.NIC customer support' WHERE state_id=25 AND lang='EN';
INSERT INTO enum_object_states_desc VALUES (26, 'EN', 'Contact is being verified by CZ.NIC customer support');
INSERT INTO enum_object_states_desc VALUES (27, 'EN', 'Contact has failed the verification by CZ.NIC customer support');


---
--- new poll message type
---
INSERT INTO MessageType VALUES (21, 'delete_domain');



---
--- Ticket #6115 mail template fix
---

UPDATE mail_templates SET template =
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain?> z DNS

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení doménového jména <?cs var:domain ?>. Vzhledem k této
skutečnosti a na základě Pravidel registrace doménových jmen,
<?cs var:defaults.company ?> pozastavuje registraci doménového jména a vyřazuje
ji ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exregdate ?> neobdrží <?cs var:defaults.company ?> od vašeho
registrátora platbu za prodloužení platnosti doménového jména, bude
doménové jméno definitivně uvolněno pro použití dalším zájemcem, a to
ke dni <?cs var:exregdate ?>.

Prosíme kontaktujte Vašeho Určeného registrátora <?cs var:registrar ?>
za účelem prodloužení doménového jména.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod správným variabilním symbolem, na správné číslo
účtu a ve správné výši a tyto informace svému Určenému registrátorovi
sdělte.

Harmonogram plánovaných akcí:

<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about inactivation of the <?cs var:domain?> domain from DNS

Dear customer,

We would like to notify you that the payment for extension of the domain name
<?cs var:domain ?> has not been received yet. With regard to that fact
and in accordance with Rules for domain names registrations, <?cs var:defaults.company ?>
is suspending the domain name registration and is withdrawing it from the
<?cs var:zone ?> zone.

In case that by <?cs var:exregdate ?>, <?cs var:defaults.company ?> will not receive the payment
for extension of the domain name from your registrar, your domain name will
be definitely released for a use by another applicant on <?cs var:exregdate ?>.

Please, contact your designated registrar <?cs var:registrar ?>
for a purpose of extension of the domain name.

If you believe that the payment was made, please, check first if the payment
was made with the correct variable symbol, to the correct account number, and
with the correct amount, and convey this information to your designated
registrar.

Time-schedule of planned events:

<?cs var:exregdate ?> - Definitive cancellation of the domain name registration.

At this moment, we have the following information about the domain in our
records:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE id = 4;


---
--- Ticket #9014
---
UPDATE mail_type SET subject = 'MojeID - změna e-mailu' WHERE id = 24;

UPDATE mail_templates SET template =
'Vážený uživateli,

k dokončení procedury změny e-mailu zadejte prosím kód PIN1: <?cs var:pin ?>

Váš tým CZ.NIC'
WHERE id = 24;



---
--- Ticket #11028 mojeid mail template fix
---

UPDATE mail_templates SET template =
'
Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontaktních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít Váš účet mojeID používat.
Zároveň Vám pošleme poštou dopis s kódem PIN3, po jehož zadání bude Váš
účet plně aktivní.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Váš tým <?cs var:defaults.company ?>
'
WHERE id = 21;

