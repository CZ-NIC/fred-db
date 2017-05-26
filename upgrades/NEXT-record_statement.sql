---
--- Ticket #18680 - registry record statement printout
---

INSERT INTO enum_filetype (id, name) VALUES (11, 'record statement');

INSERT INTO mail_type (id, name, subject) VALUES (35, 'record_statement', 'Výpis z registru / Registry record statement');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'record_statement'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(35, 'plain', 1,
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>, Vám v příloze zasíláme požadovaný výpis z registru doménových jmen.

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto skutečnost na adresu podpora@nic.cz.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

based on the request, you submitted through a web form on our website on <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>,
we are sending the requested domain registry record statement attached to this email.

If you did not make the request, please report this matter to us at podpora@nic.cz.

Yours sincerely
Support of <?cs var:defaults.company_en ?>

');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (35, 35);
