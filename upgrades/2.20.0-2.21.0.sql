---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.21.0' WHERE id = 1;


---
--- Ticket #13042 - domainbrowser waring_letter flag
---
ALTER TABLE contact_history ADD COLUMN warning_letter boolean DEFAULT NULL;

ALTER TABLE contact ADD COLUMN warning_letter boolean DEFAULT NULL;
COMMENT ON COLUMN contact.warning_letter IS
    'user preference whether to send domain expiration letters '
    '(NULL - no user preference; TRUE - send domain expiration letters; '
    'FALSE - don''t send domain expiration letters';


---
--- Ticket #12975 - letter send limits
---
CREATE INDEX message_contact_history_map_contact_object_registry_id_idx
    ON message_contact_history_map (contact_object_registry_id);


---
--- Ticket #12392 - mail template fix
---
UPDATE mail_templates SET template =
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain?> z DNS

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení doménového jména <?cs var:domain ?>. Vzhledem k této
skutečnosti a na základě Pravidel registrace doménových jmen,
<?cs var:defaults.company ?> pozastavuje registraci doménového jména a vyřazuje
ji ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exregdate ?> neobdrží <?cs var:defaults.company ?> od vašeho
registrátora platbu za prodloužení platnosti doménového jména, bude
doménové jméno definitivně uvolněno pro použití dalším zájemcem, a to
ke dni <?cs var:exregdate ?>.

Prosíme kontaktujte svého určeného registrátora <?cs var:registrar ?>
za účelem prodloužení doménového jména.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod správným variabilním symbolem, na správné číslo
účtu a ve správné výši, a tyto informace svému určenému registrátorovi
sdělte.

Harmonogram plánovaných akcí:

<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about inactivation of the <?cs var:domain?> domain from DNS

Dear customer,

We would like to notify you that the payment for extension of the domain name
<?cs var:domain ?> has not been received yet. With regard to that fact
and in accordance with Rules for domain names registrations, <?cs var:defaults.company ?>
is suspending the domain name registration and is withdrawing it from the
<?cs var:zone ?> zone.

In case that by <?cs var:exregdate ?>, <?cs var:defaults.company ?> will not receive the payment
for extension of the domain name from your registrar, your domain name will
be definitely released for a use by another applicant on <?cs var:exregdate ?>.

Please, contact your designated registrar <?cs var:registrar ?>
for a purpose of extension of the domain name.

If you believe that the payment was made, please, check first if the payment
was made with the correct variable symbol, to the correct account number, and
with the correct amount, and convey this information to your designated
registrar.

Time-schedule of planned events:

<?cs var:exregdate ?> - Definitive cancellation of the domain name registration.

At this moment, we have the following information about the domain in our
records:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE id = 4;


---
--- Ticket #12175 - registrar vat - not null
---
ALTER TABLE registrar ALTER COLUMN vat SET NOT NULL;

COMMENT ON COLUMN Registrar.VAT IS 'whether VAT should be counted in invoicing';


---
--- Ticket #13007 - send mojeid card
---
INSERT INTO message_type  (id, type) VALUES (11, 'mojeid_card');
INSERT INTO enum_filetype (id, name) VALUES (10, 'mojeid card');
INSERT INTO message_type_forwarding_service_map (message_type_id, service_handle)
    SELECT
        id, 'OPTYS'::message_forwarding_service
      FROM
        message_type
      WHERE
        type = 'mojeid_card';


---
--- Ticket #11770 - object state name delimiter constraint
---
ALTER TABLE enum_object_states ADD CONSTRAINT name_delimiter_check
    CHECK (name NOT LIKE '%,%');


---
--- Ticket #11770 - object_states
---
UPDATE enum_object_states SET importance=2     WHERE name = 'expired';
UPDATE enum_object_states SET importance=4     WHERE name = 'mojeidContact';
UPDATE enum_object_states SET importance=8     WHERE name = 'outzone';
UPDATE enum_object_states SET importance=16    WHERE name = 'identifiedContact';
UPDATE enum_object_states SET importance=32    WHERE name = 'conditionallyIdentifiedContact';
UPDATE enum_object_states SET importance=64    WHERE name = 'validatedContact';
UPDATE enum_object_states SET importance=128   WHERE name = 'serverOutzoneManual';
UPDATE enum_object_states SET importance=256   WHERE name = 'serverInzoneManual';
UPDATE enum_object_states SET importance=512   WHERE name = 'notValidated';
UPDATE enum_object_states SET importance=1024  WHERE name = 'linked';
UPDATE enum_object_states SET importance=2048  WHERE name = 'serverUpdateProhibited';
UPDATE enum_object_states SET importance=4096  WHERE name = 'serverTransferProhibited';
UPDATE enum_object_states SET importance=8192  WHERE name = 'serverRegistrantChangeProhibited';
UPDATE enum_object_states SET importance=16384 WHERE name = 'serverRenewProhibited';
UPDATE enum_object_states SET importance=32768 WHERE name = 'serverDeleteProhibited';
UPDATE enum_object_states SET importance=65536 WHERE name = 'serverBlocked';

