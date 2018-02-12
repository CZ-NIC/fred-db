INSERT INTO mail_template VALUES
(34, 1,
'Oznámení o nalezení nového platného CDNSKEY záznamu u domény <?cs var:domain ?> / Notification of a discovery of a new valid CDNSKEY record for the <?cs var:domain ?> domain',
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
', 'plain', 1, 1, 1, DEFAULT);
