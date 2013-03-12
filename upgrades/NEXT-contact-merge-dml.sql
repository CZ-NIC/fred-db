---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.14.0-merge-contact-test' WHERE id = 1;


---
--- Ticket #7653
---
INSERT INTO MessageType VALUES (17, 'update_domain');
INSERT INTO MessageType VALUES (18, 'update_nsset');
INSERT INTO MessageType VALUES (19, 'update_keyset');


---
--- Ticket #7732
---
INSERT INTO mail_type (id, name, subject) VALUES (28, 'merge_contacts_auto', 'Oznámení o sloučení duplicitních záznamů');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(28, 'plain', 1,
'Oznámení o sloučení duplicitních záznamů

Vážený zákazníku,

    z důvodu zjednodušení administrace a správy kontaktů v registru byly v souladu s Pravidly registrace doménových jmen odstavec 11.10 provedeny následující změny:
Došlo ke sjednocení duplicitních kontaktů, které mají různé identifikátory a přitom obsahují shodné údaje. Všechny duplicitní kontakty byly převedeny pod jeden s identifikátorem <?cs var:dst_contact_handle ?>. Identifikační číslo požadavku je <?cs var:request_id ?>.

<?cs if:domain_registrant_list.0 ?>Držitel byl změněn u domén:<?cs each:item = domain_registrant_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:domain_admin_list.0 ?>

Administrativní kontakt byl změněn u domén:<?cs each:item = domain_admin_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:nsset_tech_list.0 ?>

Technický kontakt byl změněn u sad nameserverů:<?cs each:item = nsset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keyset_tech_list.0 ?>

Technický kontakt byl změněn u sad klíčů:<?cs each:item = keyset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:removed_list.0 ?>

Následující duplicitní kontakty byly odstraněny:<?cs each:item = removed_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?>

                                            S pozdravem
                                            podpora <?cs var:defaults.company ?>

Information concerning the merging of duplicate entries

Dear Customer,

    To simplify the administration and management of contact data in the register, the following changes have been implemented in accordance with the Domain Name Registration Rules, Section 11.10:
Duplicate contact entries with different identifiers but identical contents were unified. All duplicate contact details were merged into a single entry carrying the identifier <?cs var:dst_contact_handle ?>. The identification number of the request is <?cs var:request_id ?>.

<?cs if:domain_registrant_list.0 ?>Holders were changed for the following domains:<?cs each:item = domain_registrant_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:domain_admin_list.0 ?>

Administrative contacts were changed for the following domains:<?cs each:item = domain_admin_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:nsset_tech_list.0 ?>

Technical contacts were changed for the following nameserver sets:<?cs each:item = nsset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keyset_tech_list.0 ?>

Technical contacts were changed for the following key sets:<?cs each:item = keyset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:removed_list.0 ?>

The following duplicate contact entries were removed:<?cs each:item = removed_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?>

                                            Yours sincerely
                                            support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (28, 28);


---
--- Ticket #7652
---
INSERT INTO enum_object_type (id,name) VALUES ( 1 , 'contact' );
INSERT INTO enum_object_type (id,name) VALUES ( 2 , 'nsset' );
INSERT INTO enum_object_type (id,name) VALUES ( 3 , 'domain' );
INSERT INTO enum_object_type (id,name) VALUES ( 4 , 'keyset' );

ALTER TABLE object_registry ADD CONSTRAINT object_registry_type_fkey FOREIGN KEY (type)
      REFERENCES enum_object_type (id);

