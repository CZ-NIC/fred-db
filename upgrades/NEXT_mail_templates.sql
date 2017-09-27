UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

z důvodu zjednodušení administrace a správy kontaktů v registru byly v souladu s Pravidly registrace doménových jmen, čl. 13.1, provedeny následující změny:

Došlo ke sjednocení duplicitních kontaktů, které mají různé identifikátory, a přitom obsahují shodné údaje. Všechny duplicitní kontakty byly převedeny pod jediný s identifikátorem <?cs var:dst_contact_handle ?>.

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
podpora <?cs var:defaults.company_cs ?>



Dear Customer,

To simplify the administration and management of contact data in the registry, the following changes have been implemented in accordance with the Domain Name Registration Rules, Article 13.1:

Duplicate contact entries having different identifiers but identical contents have been unified. All duplicate contact details were merged into a single entry carrying the identifier <?cs var:dst_contact_handle ?>.

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
Support of <?cs var:defaults.company_en ?>
' WHERE id = 28;
