---
--- reminder module mail templates
---

INSERT INTO mail_type (id, name, subject) VALUES (23, 'annual_contact_reminder', 'Ověření správnosti údajů');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
 (23, 'plain', 1,
'
English version of the e-mail is entered below the Czech version

Vážená paní, vážený pane,

dovolujeme si Vás zdvořile požádat  o kontrolu správnosti údajů,
které nyní evidujeme u Vašeho  kontaktu v centrálním registru
doménových jmen.

ID kontaktu v registru: <?cs var:handle ?>
Organizace: <?cs var:organization ?>
Jméno: <?cs var:name ?>
Adresa: <?cs var:address ?>
<?cs var:ident_type ?>: <?cs var:ident_value ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar ?>

Se žádostí o opravu údajů se neváhejte obrátit na svého vybraného registrátora.

Aktuální, úplné a správné  informace v registru znamenají Vaši jistotu,
že Vás důležité informace o Vaší doméně zastihnou vždy a včas na správné adrese.
Nedočkáte se tak nepříjemného překvapení v podobě nefunkční či zrušené domény.
Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé,
neúplné či zavádějící údaje mohou být v souladu s Pravidly registrace doménových
jmen v ccTLD .cz důvodem ke zrušení registrace doménového jména!

Chcete mít snadnější přístup ke správě Vašich údajů? Založte si mojeID. Kromě nástroje,
kterým můžete snadno a bezpečně spravovat údaje v centrálním registru,
získáte také prostředek pro jednoduché přihlašování k Vašim oblíbeným webovým službám
jediným jménem a heslem.

Pro více informací nás neváhejte kontaktovat!

Úplný výpis z registru obsahující všechny domény a další objekty přiřazené
k shora uvedenému  kontaktu naleznete v příloze.

Váš tým CZ.NIC.

Příloha:

Seznam domén kde je kontakt v roli držitele nebo administrativního
nebo dočasného kontaktu:
<?cs each:item = domains ?><?cs var:item ?><?cs /each ?>

Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:
<?cs each:item = nssets ?><?cs var:item ?><?cs /each ?>

Seznam sad klíčů, kde je kontakt v roli technického kontaktu:
<?cs each:item = keysets ?><?cs var:item ?><?cs /each ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (23, 23);
