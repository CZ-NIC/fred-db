---
--- Ticket #9475
---

INSERT INTO mail_type (id, name, subject) VALUES (29, 'contact_check_notice', 'Výzva k opravě či doložení správnosti údajů kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(29, 'plain', 1,
'Kontakt id <?cs var:contact_handle ?> - výzva k opravě či doložení správnosti údajů

Vážená paní, vážený pane,
v příloze Vám zasíláme výzvu k opravě či doložení správnosti údajů, které jsou uvedeny u kontaktu id <?cs var:contact_handle ?> (originál odchází s mezinárodní dodejkou prostřednictvím pošty).
V případě jakýchkoliv dotazů či nejasností nás neprodleně kontaktujte.

                                            S pozdravem,
                                            podpora <?cs var:defaults.company ?>

Dear Sirs,
in the attachment you can find a notice to correct or provide evidence of correct data set to the contact id <?cs var:contact_handle ?> (the original was sent to the mail address with international confirmation of delivery).
In case of any questions do not hesitate to contact us.

                                            Best Regards,
                                            support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (29, 29);


INSERT INTO mail_type (id, name, subject) VALUES (30, 'second_contact_update_call', 'Druhá výzva k opravě či doložení správnosti údajů kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(30, 'plain', 1,
'Kontakt id <?cs var:contact_handle ?> - II. výzva k opravě či doložení správnosti údajů

Vážená paní, vážený pane,
do dnešního dne nedošlo k opravě údajů, které jsou uvedeny u kontaktu id <?cs var:contact_handle ?>. Zásilka odeslaná na adresu uvedenou u tohoto kontaktu v centrálním registru, se vrátila.
Nebudou-li údaje kontaktu id <?cs var:contact_handle ?> opraveny (případně doložena jejich správnost) do <?cs var:contact_update_till ?>, může CZ.NIC v souladu s Pravidly registrace doménových jmen v ccTLD .cz zrušit registraci doménových jmen, u kterých je tento kontakt uveden jako držitel.

                                            S pozdravem,
                                            podpora <?cs var:defaults.company ?>

Dear Sirs,
let us inform you that up to this day the data set to the contact id <?cs var:contact_handle ?> have not been corrected yet. The letter sent to the address set in the contact in central registry has returned.
In case the data set in the contact id <?cs var:contact_handle ?> are not corrected (or provided the evidence of correct data) till <?cs var:contact_update_till ?> can CZ.NIC in accordance with Rules of Domain Name Registration under ccTLD .cz cancel registration of domain names where this contact is also the owner.

                                            Kind Regards,
                                            support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (30, 30);
