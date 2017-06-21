---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.28.0' WHERE id = 1;


---
--- Ticket #19293
---

INSERT INTO mail_type (id, name, subject) VALUES (32, 'akm_candidate_state_ok', 'Oznámení o úspěšném nalezení záznamu CDNSKEY u domény <?cs var:domain ?> / Notification of CDNSKEY record discovery for the <?cs var:domain ?> domain');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) SELECT id,1 FROM mail_type WHERE name='akm_candidate_state_ok';
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(32, 'plain', 1,
'The English version of the email follows the Czech version

Vážený zákazníku,

náš systém pro automatizovanou správu klíčů DNSSEC nalezl jeden nebo více platných záznamů CDNSKEY na všech jmenných serverech Vaší domény <?cs var:domain ?>. 
Nalezené záznamy CDNSKEY obsahovaly následující klíč/klíče:

<?cs each:item = keys ?><?cs var:item ?>
<?cs /each ?>

Datum a čas nálezu: <?cs var:datetime ?>

Ve shodě s RFC 7344 a RFC 8078 považujeme přítomnost těchto záznamů za žádost o zveřejnění těchto klíčů v zóně <?cs var:zone ?>, a Vaše doména je tak nyní v režimu přechodu na automatizovanou správu klíčů DNSSEC.

Od této chvíle denně kontrolujeme přítomnost uvedených záznamů CDNSKEY na jmenných serverech Vaší domény. Pokud po dobu následujících <?cs var:days_to_left ?> dnů nezaregistrujeme žádnou změnu záznamů CDNSKEY na žádném z těchto jmenných serverů, budou uvedené klíče uloženy do nově vygenerované sady klíčů v centrálním registru a následně zveřejněny prostřednictvím záznamů DS v zóně <?cs var:zone ?>. Pokud na tento e-mail nijak nezareagujete, Vaše doména bude fungovat jako doposud, jen bude nově chráněna systémem DNSSEC a správa klíčů DNSSEC pak bude probíhat automaticky na základě Vámi zveřejňovaných záznamů CDNSKEY.

Proces zařazení Vaší domény do režimu s automatizovanou správou klíčů DNSSEC lze zastavit odebráním záznamů CDNSKEY v uvedené lhůtě <?cs var:days_to_left ?> dnů.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Our automated DNSSEC-key management system has discovered one or more valid CDNSKEY records on all DNS servers of your domain <?cs var:domain ?>. The CDNSKEY record(s) contained the following key(s):

<?cs each:item = keys ?><?cs var:item ?>
<?cs /each ?>

Discovered at: <?cs var:datetime ?>

In compliance with RFC 7344 and RFC 8078, we are considering the presence of these records as a request to publish these keys in the <?cs var:zone ?> zone and therefore your domain is now in the mode of transition to the automated DNSSEC-key management.

 From now on, the presence of the stated CDNSKEY records on the domain servers of your domain will be checked on a daily basis. Unless we notice any change of CDNSKEY records on any of these DNS servers in the next <?cs var:days_to_left ?> days, these keys will be stored in a new keyset in the central registry and subsequently published as DS records in the <?cs var:zone ?> zone. Unless you react to this email, your domain will keep working as until now and besides, it will be newly protected by DNSSEC and the administration of DNSSEC keys will then run automatically based on your published CDNSKEY records.

The process of transition of your domain to the automated DNSSEC-key management can be stopped by removing CDNSKEY records within the <?cs var:days_to_left ?>-day period.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (32, 32);

INSERT INTO mail_type (id, name, subject) VALUES (33, 'akm_candidate_state_ko', 'Oznámení o vyřazení domény <?cs var:domain ?> ze systému automatizované správy klíčů DNSSEC / Notification of the <?cs var:domain ?> domain exclusion from the automated DNSSEC-key management');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) SELECT id,1 FROM mail_type WHERE name='akm_candidate_state_ko';
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(33, 'plain', 1,
'The English version of the email follows the Czech version

Vážený zákazníku,

náš systém pro automatizovanou správu klíčů DNSSEC zjistil konfiguraci jmenných serverů a záznamů CDNSKEY, která nevyhovuje podmínkám pro přechod do režimu automatizované správy klíčů DNSSEC. Dokud neprovedete změnu uvedené konfigurace, Vaše doména <?cs var:domain ?> nebude zařazena do automatizované správy klíčů DNSSEC.

Datum a čas nálezu: <?cs var:datetime ?>

Ve shodě s RFC 7344 a RFC 8078 však stále probíhá pravidelná kontrola Vašich jmenných serverů. Jakmile na nich nalezneme vyhovující konfiguraci záznamů CDNSKEY, zahájíme přechod Vaší domény do režimu automatizované správy klíčů DNSSEC.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Our automated DNSSEC-key management system has detected a configuration of DNS servers and CDNSKEY records which does not meet the conditions for the automated DNSSEC-key management. Unless you change the configuration, your <?cs var:domain ?> domain will not be included in the automated DNSSEC-key management.

Detected at: <?cs var:datetime ?>

However, in compliance with RFC 7344 and RFC 8078, your DNS servers still will be checked regularly. Once we detect a suitable configuration of CDNSKEY records, we will initiate the transition of your domain to the automated DNSSEC-key management mode.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (33, 33);

INSERT INTO mail_type (id, name, subject) VALUES (34, 'akm_keyset_update', 'Oznámení o nalezení nového platného CDNSKEY záznamu u domény <?cs var:domain ?> / Notification of a discovery of a new valid CDNSKEY record for the <?cs var:domain ?> domain');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) SELECT id,1 FROM mail_type WHERE name='akm_keyset_update';
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(34, 'plain', 1,
'The English version of the email follows the Czech version

Vážený zákazníku,

náš systém pro automatizovanou správu klíčů DNSSEC nalezl na jmenných serverech Vaší domény <?cs var:domain ?> jeden nebo více nových platných záznamů CDNSKEY s následujícím klíčem/klíči:

<?cs each:item = keys ?><?cs var:item ?>
<?cs /each ?>

Datum a čas nálezu: <?cs var:datetime ?>

Ve shodě s RFC 7344 a RFC 8078 považujeme přítomnost těchto záznamů za žádost o zveřejnění těchto klíčů v zóně <?cs var:zone ?>. S ohledem na to, že tento klíč/klíče se liší od aktuálně zveřejňovaných klíčů v zóně <?cs var:zone ?>, provedeme aktualizaci automaticky spravované sady klíčů v registru, a poté budou v zóně <?cs var:zone ?> pro vaši doménu <?cs var:domain ?> zveřejněny pouze výše uvedené nové klíče. Žádná další akce od Vás není v tomto ohledu požadována.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Our automated DNSSEC key management system has discovered one or more new valid CDNSKEY records with following key(s) on DNS servers of your domain <?cs var:domain ?>:

<?cs each:item = keys ?><?cs var:item ?>
<?cs /each ?>

Discovered at: <?cs var:datetime ?>

In compliance with RFC 7344 and RFC 8078, we are considering the presence of these records as a request to publish these keys in the <?cs var:zone ?> zone. Given that this key (keys) is different from the keys currently published in the <?cs var:zone ?> zone, we will update the automatically managed keyset in the registry and as a result, only the aforementioned new keys will be published for your <?cs var:domain ?> domain in the <?cs var:zone ?> zone. There is no need for any other activity on your part in this matter.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (34, 34);
