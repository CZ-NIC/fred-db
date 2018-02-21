INSERT INTO mail_template VALUES
(16, 1,
'Výsledek technické kontroly sady nameserverů <?cs var:handle ?> / Results of technical check on the NS set <?cs var:handle ?>',
'Sada nameserverů / NS set: <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Check type: periodická / periodic
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "glue_ok" ?>U následujících nameserverů chybí povinný glue záznam:
The required glue record is missing for the following nameservers:
<?cs each:ns = par_test.ns ?>    <?cs var:ns.hostname ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in the NS set are unreachable:
<?cs each:ns = par_test.ns ?>    <?cs var:ns.hostname ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
The NS set does not contain at least two nameservers in different autonomous systems.

<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns.hostname ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns.hostname ?> does not contain a record for any of the domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns.hostname ?> není autoritativní pro domény:
Nameserver <?cs var:ns.hostname ?> is not authoritative for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in the NS set use the same implementation of DNS server.

<?cs /if ?><?cs if:par_test.name == "notrecursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in the NS set are recursive:
<?cs each:ns = par_test.ns ?>    <?cs var:ns.hostname ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "notrecursive4all" ?>Následující nameservery v sadě nameserverů zodpověděly dotaz rekurzivně:
Following nameservers in the NS set answered a query recursively:
<?cs each:ns = par_test.ns ?>    <?cs var:ns.hostname ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "dnsseckeychase" ?>Pro následující domény přislušející sadě nameserverů nebylo možno
ověřit validitu podpisu DNSSEC:
For the following domains belonging to the NS set, the DNSSEC signature
could not be validated:
<?cs each:domain = par_test.ns ?>    <?cs var:domain ?>
<?cs /each ?><?cs /if ?><?cs /def ?>
=== Chyby / Errors ==================================================

<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Varování / Warnings =============================================

<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Upozornění / Notices ============================================

<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=====================================================================


S pozdravem / Your sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
