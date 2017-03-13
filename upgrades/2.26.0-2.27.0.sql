---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.27.0' WHERE id = 1;


---
--- Ticket #14538 Fix domain exclusion mail template
---
UPDATE mail_templates
SET template=
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že jste dosud neprodloužil registraci
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti tak na
základě Pravidel registrace doménových jmen rušíme delegaci doménového
jména a vyřazujeme Vaši doménu ze zóny <?cs var:zone ?>.

Pokud nejpozději do <?cs var:day_before_exregdate ?> neprodloužíte prostřednictvím
určeného registrátora registraci doménového jména, dojde následujícího dne
definitivně k zániku jeho registrace a toto doménové jméno bude k dispozici
pro registraci i ostatním zájemcům.

Jestliže se domníváte, že jste o prodloužení registrace domény u určeného
registrátora již žádal, neváhejte ho neprodleně kontaktovat a zjistit
příčinu, proč dosud k prodloužení registrace nedošlo. Připomínáme, že
určeného registrátora můžete kdykoliv změnit.

Co se bude dít, pokud k prodloužení nedojde:

<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme o Vaší doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Určený registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

We would like to notify you that you still have not extended the registration
of the domain name <?cs var:domain ?>. With regard to that fact
and in accordance with the Domain Name Registration Rules, we are
suspending the domain name registration and excluding it from the
<?cs var:zone ?> zone.

Unless you extend the registration of your domain name through your
designated registrar by <?cs var:day_before_exregdate ?>, 
the registration will be cancelled definitely
and your domain name will be released for use by another applicant.

If you believe that you have already asked your designated registrar
to extend the registration, do not hesitate to contact them again
and find out why the extension has not occurred. Let us remind you
that you can switch to another registrar any time.

What is going to happen unless the domain is extended:

<?cs var:exregdate ?> - The final cancellation of the domain name registration.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Designated registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrative contact: <?cs var:item ?>
<?cs /each ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
'
WHERE id=4;


---
--- Ticket #17972 - nameserver name db constraint
---
CREATE OR REPLACE FUNCTION domain_name_syntax_check(fqdn text) RETURNS bool AS $$
SELECT bool_and(label_length > 0 AND label_length <= 63
    AND domain_name_length > 0 AND domain_name_length <= 255 -- RFC1035#section-2.3.4 size limits
    AND label !~* '[^a-z0-9-]' AND left(label,1) != '-' AND right(label,1) != '-') -- LDH and RFC1123#section-2.1 syntax
  FROM (SELECT label, length(label) AS label_length, length(domain_name) + 1 AS domain_name_length -- +1 for optional trailing dot
    FROM (SELECT unnest(string_to_array(domain_name, '.'))::text AS label, domain_name
      FROM (SELECT CASE WHEN right($1::text,1) = '.' THEN left($1::text,-1) ELSE $1::text END) AS tmp1(domain_name) -- removed optional trailing dot
    ) AS tmp2) AS tmp3;
$$ LANGUAGE SQL RETURNS NULL ON NULL INPUT;

ALTER TABLE host ADD CONSTRAINT domain_name_check CHECK (domain_name_syntax_check(fqdn));


---
--- Ticket #17973 - domain name db constraint
---
ALTER TABLE object_registry ADD CONSTRAINT domain_name_check CHECK (type <> get_object_type_id('domain') OR domain_name_syntax_check(name));
