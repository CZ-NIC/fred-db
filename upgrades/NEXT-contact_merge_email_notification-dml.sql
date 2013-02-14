---
--- #7732
---

INSERT INTO mail_type (id, name, subject) VALUES (28, 'merge_contacts_auto', 'Oznámení o sloučení duplicitních záznamů');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(28, 'plain', 1,
'Oznámení o sloučení duplicitních záznamů

Vážený zákazníku,

    z důvodu zjednodušení administrace a správy kontaktů v registru byly v souladu s Pravidly registrace doménových jmen odstavec 11.10 provedeny následující změny:
Došlo ke sjednocení duplicitních kontaktů, které mají různé identifikátory a přitom obsahují shodné údaje. Všechny duplicitní kontakty byly převedeny pod jeden s identifikátorem <?cs var:dst_contact_handle ?>

Držitel byl změněn u domén:
<?cs each:item = domain_registrant_list ?>
    <?cs var:item ?>
<?cs /each ?>

Administrativní kontakt byl změněn u domén:
<?cs each:item = domain_admin_list ?>
    <?cs var:item ?>
<?cs /each ?>

Technický kontakt byl změněn u sad nameserverů:
<?cs each:item = nsset_tech_list ?>
    <?cs var:item ?>
<?cs /each ?>

Technický kontakt byl změněn u sad klíčů:
<?cs each:item = keyset_tech_list ?>
    <?cs var:item ?>
<?cs /each ?>

Následující duplicitní kontakty byly odstraněny:
<?cs each:item = removed_list ?>
    <?cs var:item ?>
<?cs /each ?>

                                            S pozdravem
                                            podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (28, 28);

