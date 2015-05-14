---
--- Ticket #11770 - object_states
---

UPDATE enum_object_states SET importance=2 WHERE name='expired';
UPDATE enum_object_states SET importance=4 WHERE name='mojeidContact';
UPDATE enum_object_states SET importance=8 WHERE name='outzone';
UPDATE enum_object_states SET importance=16 WHERE name='identifiedContact';
UPDATE enum_object_states SET importance=32 WHERE name='conditionallyIdentifiedContact';
UPDATE enum_object_states SET importance=64 WHERE name='validatedContact';
UPDATE enum_object_states SET importance=128 WHERE name='serverOutzoneManual';
UPDATE enum_object_states SET importance=256 WHERE name='serverInzoneManual';
UPDATE enum_object_states SET importance=512 WHERE name='notValidated';
UPDATE enum_object_states SET importance=1024 WHERE name='linked';
UPDATE enum_object_states SET importance=2048 WHERE name='serverUpdateProhibited';
UPDATE enum_object_states SET importance=4096 WHERE name='serverTransferProhibited';
UPDATE enum_object_states SET importance=8192 WHERE name='serverRegistrantChangeProhibited';
UPDATE enum_object_states SET importance=16384 WHERE name='serverRenewProhibited';
UPDATE enum_object_states SET importance=32768 WHERE name='serverDeleteProhibited';
UPDATE enum_object_states SET importance=65536 WHERE name='serverBlocked';

