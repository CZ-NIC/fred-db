---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.19.1' WHERE id = 1;

---
--- Ticket #12377 - company address change
---
UPDATE mail_defaults SET value='Milešovská 1136/5' WHERE name='street';
UPDATE mail_defaults SET value='130 00' WHERE name='postalcode';
UPDATE mail_defaults SET value='Praha 3' WHERE name='city';

UPDATE mail_vcard SET vcard =
'BEGIN:VCARD
VERSION:2.1
N:podpora CZ. NIC, z.s.p.o.
FN:podpora CZ. NIC, z.s.p.o.
ORG:CZ.NIC, z.s.p.o.
TITLE:zákaznická podpora
TEL;WORK;VOICE:+420 222 745 111
TEL;WORK;FAX:+420 222 745 112
ADR;WORK:;;Milešovská 1136/5;Praha 3;;130 00;Česká republika
URL;WORK:http://www.nic.cz
EMAIL;PREF;INTERNET:podpora@nic.cz
REV:20150109T111928Z
END:VCARD
'
WHERE id =1;


---
--- Ticket #12465 - fix address country in letter_archive
---
ANALYZE letter_archive;

UPDATE letter_archive SET postal_address_country = enum_country.country
 FROM enum_country
 WHERE letter_archive.postal_address_country <> enum_country.country
   AND (upper(letter_archive.postal_address_country) = upper(enum_country.country));

UPDATE letter_archive SET postal_address_country = enum_country.country
 FROM enum_country
 WHERE letter_archive.postal_address_country <> enum_country.country
   AND (upper(letter_archive.postal_address_country) = enum_country.id);

ALTER TABLE letter_archive ADD CONSTRAINT
 letter_archive_postal_address_country_fkey FOREIGN KEY
 (postal_address_country) REFERENCES enum_country (country);
