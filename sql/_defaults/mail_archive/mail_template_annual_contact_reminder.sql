INSERT INTO mail_template VALUES
(23, 1,
'Ověření správnosti údajů',
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás zdvořile požádat o kontrolu správnosti údajů,
které nyní evidujeme u Vašeho kontaktu v Centrálním registru
doménových jmen.

Kontaktní osoba je potřebná pro registraci domény či domén, jejichž seznam uvádíme níže.

V případě nesrovnalostí v údajích se prosím spojte přímo s určeným registrátorem kontaktu, kterého naleznete v následujícím výpisu, neboť my změny údajů neprovádíme.

ID kontaktu v registru: <?cs var:handle ?>
Organizace: <?cs var:organization ?>
Jméno: <?cs var:name ?>
Adresa: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Datum narození: <?cs
elif:ident_type == "OP"?>Číslo OP: <?cs
elif:ident_type == "PASS"?>Číslo pasu: <?cs
elif:ident_type == "ICO"?>IČO: <?cs
elif:ident_type == "MPSV"?>Identifikátor MPSV: <?cs
elif:ident_type == "BIRTHDAY"?>Datum narození: <?cs
/if ?> <?cs var:ident_value ?><?cs
/if ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_cz ?>Další informace poskytnuté registrátorem:
<?cs var:registrar_memo_cz ?><?cs /if ?>

V případě, že jsou údaje správné, nereagujte prosím na tento e-mail.

Aktuální, úplné a správné informace v registru znamenají Vaši jistotu,
že Vás důležité informace o Vaší doméně zastihnou vždy a včas na správné adrese.
Nedočkáte se tak nepříjemného překvapení v podobě nefunkční či zrušené domény.

Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné
či zavádějící údaje mohou být v souladu s Pravidly registrace doménových jmen
v ccTLD .cz důvodem ke zrušení registrace doménového jména.

Úplný výpis z registru obsahující všechny domény a další objekty přiřazené
k shora uvedenému kontaktu naleznete v příloze.

S pozdravem
podpora <?cs var:defaults.company_cs ?>


Příloha:

<?cs if:domains.0 ?>Seznam domén, kde je kontakt v roli držitele nebo administrativního
kontaktu:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>Kontakt není uveden u žádného doménového jména.<?cs /if ?><?cs if:nssets.0 ?>

Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Seznam sad klíčů, kde je kontakt v roli technického kontaktu:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>



Dear customer,

Please check that your contact information we currently have on file
in the Central Registry of Domain Names, is correct.

The contact is required for the registration of the domain(s) listed below.

Do not hesitate to contact your designated registrar in the case the data are incorrect, since we do not perform changes of the data.

Contact ID in the registry: <?cs var:handle ?>
Organization: <?cs var:organization ?>
Name: <?cs var:name ?>
Address: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Birth date: <?cs
elif:ident_type == "OP"?>Personal ID: <?cs
elif:ident_type == "PASS"?>Passport number: <?cs
elif:ident_type == "ICO"?>ID number: <?cs
elif:ident_type == "MPSV"?>MSPV ID: <?cs
elif:ident_type == "BIRTHDAY"?>Birth day: <?cs
/if ?> <?cs var:ident_value ?><?cs
/if ?>
VAT No.: <?cs var:dic ?>
Phone: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
Email: <?cs var:email ?>
Notification email: <?cs var:notify_email ?>
Designated registrar: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_en ?>Other information provided by your registrar:
<?cs var:registrar_memo_en ?><?cs /if ?>

Please, do not take any measures if your data are correct.

Having up-to-date, complete and correct information in the registry is crucial
to reach you with all the important information about your domain name in time
and at the correct contact address. Check your contact details now and avoid unpleasant
surprises such as a non-functional or expired domain.

We would also like to inform you that in accordance with the Rules of Domain Name
Registration for the .cz ccTLD, incorrect, false, incomplete or misleading
information can be grounds for the cancellation of a domain name registration.

You can find a complete listing of your domain names and other objects
associated with your contact attached below.

Yours sincerely
Support of <?cs var:defaults.company_en ?>


Attachment:

<?cs if:domains.0 ?>Domains where the contact is their holder or administrative contact:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>The contact is not linked to any domain name.<?cs /if ?><?cs if:nssets.0 ?>

Sets of name servers where the contact is their technical contact:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Keysets where the contact is their technical contact:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>
', 'plain', 1, 1, 1, DEFAULT);
