INSERT INTO MessageType (id, name) VALUES (22, 'update_contact');

COMMENT ON TABLE MessageType IS
'table with message number codes and its names

id - name
01 - credit
02 - techcheck
03 - transfer_contact
04 - transfer_nsset
05 - transfer_domain
06 - delete_contact
07 - delete_nsset
08 - delete_domain
09 - imp_expiration
10 - expiration
11 - imp_validation
12 - validation
13 - outzone
14 - transfer_keyset
15 - idle_delete_keyset
17 - update_domain
18 - update_nsset
19 - update_keyset
20 - delete_contact
21 - delete_domain
22 - update_contact';
