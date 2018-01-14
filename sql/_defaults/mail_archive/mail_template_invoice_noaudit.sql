INSERT INTO mail_template VALUES
(19, 1,
'Zaslání měsíčního vyúčtování / Monthly bill dispatching',
'Vážení obchodní přátelé,

jelikož Vaše společnost neprovedla v období od <?cs var:fromdate ?> do <?cs var:todate ?> v zóně <?cs var:zone ?>
žádnou registraci doménového jména ani prodloužení platnosti doménového
jména, a nedošlo tak k čerpání žádných placených služeb, nebude pro toto
období vystaven daňový doklad.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Since your company has not performed any domain name registration or domain
name validity extension in the period from <?cs var:fromdate ?> to <?cs var:todate ?> for the <?cs var:zone ?> zone,
hence not drawing any paid services, no tax document will be issued for this
period.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
