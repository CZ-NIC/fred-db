INSERT INTO mail_template VALUES
(33, 1,
'Oznámení o vyřazení domény <?cs var:domain ?> ze systému automatizované správy klíčů DNSSEC / Notification of the <?cs var:domain ?> domain exclusion from the automated DNSSEC-key management',
'The English version of the email follows the Czech version

Vážený zákazníku,

náš systém pro automatizovanou správu klíčů DNSSEC zjistil konfiguraci jmenných serverů a záznamů CDNSKEY, která nevyhovuje podmínkám pro přechod do režimu automatizované správy klíčů DNSSEC. Dokud neprovedete změnu uvedené konfigurace, Vaše doména <?cs var:domain ?> nebude zařazena do automatizované správy klíčů DNSSEC.

Datum a čas nálezu: <?cs var:datetime ?>

Ve shodě s RFC 7344 a RFC 8078 však stále probíhá pravidelná kontrola Vašich jmenných serverů. Jakmile na nich nalezneme vyhovující konfiguraci záznamů CDNSKEY, zahájíme přechod Vaší domény do režimu automatizované správy klíčů DNSSEC.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Our automated DNSSEC-key management system has detected a configuration of DNS servers and CDNSKEY records which does not meet the conditions for the automated DNSSEC-key management. Unless you change the configuration, your <?cs var:domain ?> domain will not be included in the automated DNSSEC-key management.

Detected at: <?cs var:datetime ?>

However, in compliance with RFC 7344 and RFC 8078, your DNS servers still will be checked regularly. Once we detect a suitable configuration of CDNSKEY records, we will initiate the transition of your domain to the automated DNSSEC-key management mode.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
