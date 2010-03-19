---
--- UPGRADE SCRIPT 2.2.0 -> 2.3.0 (data modification part)
---

---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '2.3.0' WHERE id = 1;

---
--- Ticket #1670 Banking refactoring
---

INSERT INTO enum_bank_code (name_full,name_short,code) VALUES ('Fio, družstevní záložna', 'FIOZ', '2010');
UPDATE bank_account SET balance = 0.0 WHERE balance IS NULL;

INSERT INTO bank_account VALUES (DEFAULT, NULL, '36153615', 'Akademie', '0300', 0, NULL, NULL);

---
--- data migration
--- bank_statement_head -> bank_statement
---
INSERT INTO bank_statement
                           (id, account_id, num, create_date, balance_old_date,
                            balance_old, balance_new, balance_credit, balance_debet,
                            file_id)

    SELECT id, account_id, num, create_date, balance_old_date, balance_old, balance_new,
           balance_credit, balance_debet, NULL
       FROM bank_statement_head
      ORDER BY id;

---
--- bank_statement_item && bank_ebanka_list -> bank_payement
--- (should be ordered by account_date or not?, crtime set to NOW()?)
---

INSERT INTO bank_payment
                         (statement_id, account_id, account_number, bank_code,
                          code, type, status, konstsym, varsymb, specsymb,
                          price, account_evid, account_date, account_memo,
                          invoice_id, account_name, crtime)

        SELECT NULL, ebanka.account_id, trim(both ' ' from ebanka.account_number),
                trim(both ' ' from ebanka.bank_code), 1, NULL::integer, 1,
                trim(both ' ' from ebanka.konstsym), trim(both from ebanka.varsymb),
                NULL, ebanka.price, trim(both ' ' from ebanka.ident) as account_evid,
                ebanka.crdate AS account_date, trim(both ' ' from ebanka.memo),
                ebanka.invoice_id, trim(both ' ' from ebanka.name), NOW()
           FROM bank_ebanka_list ebanka
        UNION ALL
        SELECT csob.statement_id,
               (SELECT ba.id
                   FROM bank_account ba
                  WHERE ba.account_number = csob.account_number AND ba.bank_code = csob.bank_code
                 LIMIT 1
               ),
               trim(both ' ' from csob.account_number), trim(both ' ' from csob.bank_code),
               1, NULL::integer, 1, trim(both ' ' from csob.konstsym), trim(both ' ' from csob.varsymb),
               trim(both ' ' from csob.specsymb), csob.price, trim(both ' ' from csob.account_evid) as account_evid,
               csob.account_date AS account_date, trim(both ' ' from csob.account_memo), csob.invoice_id, NULL,
               NOW()
           FROM bank_statement_item csob
          ORDER BY account_date, account_evid;


---
--- Fix account_memo field for csob payments
---

UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='771' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='772' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='773' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='774' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='775' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='776' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='777' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='778' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='779' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='780' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='781' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='782' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='783' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='784' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.') WHERE account_evid='785' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='786' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='787' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='790' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='791' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='792' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='793' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='794' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='795' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='796' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='797' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='798' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='801' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='802' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='803' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='804' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='805' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='806' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='807' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='808' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='809' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='810' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='812' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='813' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='814' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='815' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='816' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='817' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='818' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='819' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='820' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='821' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='822' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='825' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='826' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='827' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='828' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='829' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='830' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='831' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='832' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='833' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='834' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='835' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='836' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='837' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='838' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='839' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='840' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='841' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='842' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='843' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='844' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='845' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='846' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='847' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='848' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='849' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='850' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='853' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='854' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='855' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='856' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='857' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='858' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='859' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='860' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='861' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='862' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='863' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='864' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='865' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='866' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='867' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='868' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='869' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='870' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='871' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='872' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='873' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='874' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='875' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='876' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZ-NIC / Gransy s.r.o.             ') WHERE account_evid='877' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='878' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='879' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='880' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='883' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='884' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='38' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='885' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='886' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='887' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='888' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='889' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='890' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='891' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='892' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='893' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='894' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='895' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='896' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='897' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='898' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='901' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='902' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='903' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='904' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='905' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='906' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='907' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='908' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='909' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='910' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='911' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='912' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='913' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='914' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='915' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='916' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='917' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='918' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='919' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='920' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='921' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='922' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='923' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='926' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='927' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='928' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='929' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='930' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'GANDI - kredit                     prevod mezi ucty') WHERE account_evid='931' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'INSTRA - kredit                    prevod mezi ucty') WHERE account_evid='932' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='933' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='934' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='935' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='936' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='937' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='938' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='939' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='940' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='941' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='942' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='943' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='944' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='945' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='946' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='947' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='948' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='949' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='950' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='951' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='952' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='955' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='956' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='957' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='958' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='959' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='960' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='961' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='962' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='963' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='964' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='965' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='966' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='967' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='968' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='969' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='970' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='971' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='972' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='973' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='974' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='975' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='978' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='979' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='980' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='981' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='982' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='983' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='984' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='985' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='986' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='987' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='988' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='989' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='990' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='991' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='992' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='993' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='994' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='995' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='996' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='997' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='998' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1001' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1002' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1003' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1004' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1005' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1006' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.   ') WHERE account_evid='1007' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1008' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '                                   ') WHERE account_evid='1009' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1010' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1013' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1014' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1015' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1016' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC                              ') WHERE account_evid='1017' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1018' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1019' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1020' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1021' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1022' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1023' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1024' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1025' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1026' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1027' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1028' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1029' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1030' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'NMG-CZ.NIC - reg. poplatky') WHERE account_evid='1031' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.') WHERE account_evid='1032' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1033' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1035' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1036' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1037' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1038' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1039' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1040' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1043' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1044' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1045' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1046' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1047' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1048' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1049' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1050' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1051' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1052' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1053' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1054' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1055' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1056' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1057' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.') WHERE account_evid='1058' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1061' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1062' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1063' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1064' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1065' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1066' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1069' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1070' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1071' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1072' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1073' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1074' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1075' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1076' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1077' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'PYORD000007878160193336') WHERE account_evid='1078' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1079' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1080' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1081' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1082' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1083' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1084' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1085' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1086' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1087' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1088' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1089' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1090' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1091' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1092' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1093' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1094' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1095' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1096' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1097' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1098' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1099' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'Zaloha registratora Web4U s.r.o.') WHERE account_evid='1100' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1101' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1102' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1105' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1106' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1107' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1108' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1109' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1110' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1111' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1112' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1113' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1114' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1115' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1116' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1117' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1118' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1119' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1120' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1121' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1122' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1123' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from '') WHERE account_evid='1124' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1125' AND account_id=4;
UPDATE bank_payment SET account_memo=trim(both ' ' from 'CZNIC') WHERE account_evid='1126' AND account_id=4;

---
--- Typo fixes
---

---
--- Ticket #3107 - object state description typo
---
UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept out of zone'
WHERE
    state_id = 5 AND lang = 'EN';


UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept in zone'
WHERE
    state_id = 6 AND lang = 'EN';

---
--- Upgrade to fixes from SVN r8467 and r9590 - Fix typos
---

UPDATE
    enum_object_states_desc
SET
    description = 'Není povoleno prodloužení registrace objektu'
WHERE
    state_id = 2 AND lang = 'CS';

UPDATE
    enum_object_states_desc
SET
    description = 'Registration renewal prohibited'
WHERE
    state_id = 2 AND lang = 'EN';



UPDATE
    enum_reason
SET
    reason = 'bad format of contact handle'
WHERE
    id = 1;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('bad format of nsset handle', 'neplatný formát ukazatele nssetu')
WHERE
    id = 2;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatný formát názvu domény'
WHERE
    id = 3;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('within protection period.', 'je v ochranné lhůtě')
WHERE
    id = 7;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatná IP adresa'
WHERE
    id = 8;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatný formát názvu jmenného serveru DNS'
WHERE
    id = 9;

UPDATE
    enum_reason
SET
    reason_cs = 'duplicitní adresa jmenného serveru DNS'
WHERE
    id = 10;

UPDATE
    enum_reason
SET
    reason_cs = 'nepovolená  IP adresa glue záznamu'
WHERE
    id = 11;

UPDATE
    enum_reason
SET
    reason_cs = 'jsou zapotřebí alespoň dva DNS servery'
WHERE
    id = 12;

UPDATE
    enum_reason
SET
    reason_cs = 'perioda je nad maximální dovolenou hodnotou'
WHERE
    id = 14;

UPDATE
    enum_reason
SET
    reason_cs = 'perioda neodpovídá dovolenému intervalu'
WHERE
    id = 15;

UPDATE
    enum_reason
SET
    reason_cs = 'neznámé msgID'
WHERE
    id = 17;

UPDATE
    enum_reason
SET
    reason_cs = 'datum vypršení platnosti se nepoužívá'
WHERE
    id = 18;

UPDATE
    enum_reason
SET
    reason_cs = 'nelze odstranit jmenný server DNS'
WHERE
    id = 21;

UPDATE
    enum_reason
SET
    reason_cs = 'nelze přidat jmenný server DNS'
WHERE
    id = 22;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Can not remove technical contact', 'nelze vymazat technický kontakt')
WHERE
    id = 23;

UPDATE
    enum_reason
SET
    reason = 'Technical contact does not exist'
WHERE
    id = 25;

UPDATE
    enum_reason
SET
    reason_cs = 'Administrátorský kontakt je již přiřazen k tomuto objektu'
WHERE
    id = 26;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Administrative contact does not exist', 'Administrátorský kontakt neexistuje')
WHERE
    id = 27;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('nsset handle does not exist.', 'sada jmenných serverů není vytvořena')
WHERE
    id = 28;

UPDATE
    enum_reason
SET
    reason_cs = 'jmenný server DNS je již přiřazen sadě jmenných serverů'
WHERE
    id = 30;

UPDATE
    enum_reason
SET
    reason_cs = 'jmenný server DNS není přiřazen sadě jmenných serverů'
WHERE
    id = 31;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Registration is prohibited', 'Registrace je zakázána')
WHERE
    id = 36;

UPDATE
    enum_reason
SET
    reason = 'Bad format of keyset handle'
WHERE
    id = 39;

UPDATE
    enum_reason
SET
    reason = 'Keyset handle does not exist'
WHERE
    id = 40;

UPDATE
    enum_reason
SET
    reason = 'DSRecord is not set for this keyset'
WHERE
    id = 45;

UPDATE
    enum_reason
SET
    reason = 'Digest must be 40 characters long'
WHERE
    id = 47;

UPDATE
    enum_reason
SET
    reason = 'Object does not belong to the registrar'
WHERE
    id = 48;

UPDATE
    enum_reason
SET
    reason = 'Too many nameservers in this nsset'
WHERE
    id = 52;

UPDATE
    enum_reason
SET
    reason_cs = 'Pole ``flags'''' musí být 0, 256 nebo 257'
WHERE
    id = 54;

UPDATE
    enum_reason
SET
    reason = 'Field ``key'''' contains invalid character'
WHERE
    id = 58;

UPDATE
    enum_reason
SET
    reason = 'DNSKey does not exist for this keyset'
WHERE
    id = 60;




UPDATE
    mail_templates
SET
    template = 
'English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received
the identification number <?cs var:reqid ?>, we are sending you the requested
password that belongs to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE
    id = 1;


UPDATE
    mail_templates
SET
    template = 
' English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti, podané prostřednictvím registrátora
<?cs var:registrar ?>, Vám zasíláme požadované heslo
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the registrar <?cs var:registrar ?>,
we are sending the requested password that belongs to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   This message is being sent only to the e-mail address that we have on file
for a particular person in the Central Registry of Domain Names.

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE
    id = 2;


---
--- Ticket #3477
---

UPDATE mail_templates SET template =
'
Výsledek technické kontroly sady nameserverů <?cs var:handle ?>
Result of technical check on NS set <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Control type : periodická / periodic 
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
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
sestavit řetěz důvěry:
For following domains belonging to NS set was unable to create 
key chain of trust:
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
' WHERE id = 16;


