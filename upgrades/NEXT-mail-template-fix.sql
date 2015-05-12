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



