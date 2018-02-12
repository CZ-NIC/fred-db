INSERT INTO mail_template VALUES
(32, 1,
'Oznámení o úspěšném nalezení záznamu CDNSKEY u domény <?cs var:domain ?> / Notification of CDNSKEY record discovery for the <?cs var:domain ?> domain',
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
', 'plain', 1, 1, 1, DEFAULT);
