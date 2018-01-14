INSERT INTO mail_template VALUES
(17, 1,
'Potvrzení o přijaté záloze / Confirmation of received advance payment',
'Vážení obchodní přátelé,

v příloze zasíláme daňový doklad na přijatou zálohu pro zónu <?cs var:zone ?>.
Tento daňový doklad slouží k uplatnění nároku na odpočet DPH přijaté zálohy

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Enclosed with this letter, we are sending you a tax document for the advance
payment received for the <?cs var:zone ?> zone. This tax document can be used
to claim VAT deduction for the advance payment.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
