INSERT INTO mail_type (id, name, subject) VALUES (21, 'mojeid_identification', 'Informace k žádosti o identifikaci / Information about identification request ');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(21, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Informace k založení žádosti o identifikaci

Vážený zákazníku,

   datum:  <?cs var:reqdate ?>
   typ:  <?cs if:rtype == #1 ?>identifikace typu sms<?cs elif:rtype == #2 ?>identifikace typu dopis<?cs /if ?>
   handle:  <?cs var:handle ?> 
   1.heslo: <?cs var:passwd ?> 
   url: <?cs var:url ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>

Information about submitted identification request

Dear customer,

   date:  <?cs var:reqdate ?>
   type:  <?cs if:rtype == #1 ?>sms identification<?cs elif:rtype == #2 ?>snail mail identification<?cs /if ?>
   handle:  <?cs var:handle ?> 
   1.passwd: <?cs var:passwd ?> 
   url: <?cs var:url ?>

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (21, 21);
