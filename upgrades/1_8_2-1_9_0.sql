--
--  block requests answer emails
--

INSERT INTO mail_type (id, name, subject) VALUES (20, 'request_block', 'Informace o vyřízení žádosti / Information about processing of request ');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(20, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Informace o vyřízení žádosti

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které bylo přiděleno identifikační 
číslo <?cs var:reqid ?>, Vám oznamujeme, že požadovaná žádost o <?cs if:otype == #1 ?>zablokování<?cs elif:otype == #2 ?>odblokování<?cs /if ?>
<?cs if:rtype == #1 ?>změny dat<?cs elif:rtype == #2 ?>transferu k jinému registrátorovi<?cs /if ?> pro <?cs if:type == #3 ?>doménu<?cs elif:type == #1 ?>kontakt s identifikátorem<?cs elif:type == #2 ?>sadu nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?> 
byla úspěšně realizována.  
<?cs if:otype == #1 ?>
U <?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu s identifikátorem<?cs elif:type == #2 ?>sady nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?> nebude možné provést 
<?cs if:rtype == #1 ?>změnu dat<?cs elif:rtype == #2 ?>transfer k jinému registrátorovi <?cs /if ?> až do okamžiku, kdy tuto blokaci 
zrušíte pomocí příslušného formuláře na stránkách sdružení.
<?cs /if?>
                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>

Information about processing of request

Dear customer,

   Based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received the identification number 
<?cs var:reqid ?>, we are announcing that your request for <?cs if:otype == #1 ?>blocking<?cs elif:otype == #2 ?>unblocking<?cs /if ?>
<?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> for <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?> 
has been realized.
<?cs if:otype == #1 ?>
No <?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> of <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?> 
will be possible until You cancel the blocking option using the 
applicable form on association pages. 
<?cs /if?>
                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (20, 20);
