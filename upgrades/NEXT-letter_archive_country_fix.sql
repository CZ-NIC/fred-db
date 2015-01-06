---
--- Ticket #12465 - fix address country in letter_archive
---
UPDATE letter_archive SET postal_address_country = enum_country.country
 FROM enum_country
 WHERE letter_archive.postal_address_country <> enum_country.country
 AND ( upper(letter_archive.postal_address_country) = upper(enum_country.country)
 OR upper(letter_archive.postal_address_country) = enum_country.id);

ALTER TABLE letter_archive ADD CONSTRAINT
 letter_archive_postal_address_country_fkey FOREIGN KEY
 (postal_address_country) REFERENCES enum_country (country);


