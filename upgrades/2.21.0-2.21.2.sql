---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.21.2' WHERE id = 1;


UPDATE mail_templates SET template =
'
Výsledek technické kontroly sady nameserverů <?cs var:handle ?>
Result of technical check on NS set <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Control type : periodická / periodic
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "glue_ok" ?>U následujících nameserverů chybí povinný glue záznam:
The required glue record is missing for the following nameservers:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in NS set are not reachable:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
In NS set are no two nameservers in different autonomous systems.

<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns ?> does not contain record for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> není autoritativní pro domény:
Nameserver <?cs var:ns ?> is not authoritative for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in NS set use the same implementation of DNS server.

<?cs /if ?><?cs if:par_test.name == "notrecursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in NS set are recursive:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "notrecursive4all" ?>Následující nameservery v sadě nameserverů zodpověděly rekurzivně dotaz:
Following nameservers in NS set answered recursively a query:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "dnsseckeychase" ?>Pro následující domény přislušející sadě nameserverů nebylo možno
ověřit validitu DNSSEC podpisu:
For following domains belonging to NS set was unable to validate
DNSSEC signature:
<?cs each:domain = par_test.ns ?>    <?cs var:domain ?>
<?cs /each ?><?cs /if ?><?cs /def ?>
=== Chyby / Errors ==================================================

<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Varování / Warnings =============================================

<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Upozornění / Notice =============================================

<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=====================================================================


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
'
WHERE id = 16;

