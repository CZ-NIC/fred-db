-- Add public requests used in MojeID function update_transfer_contact_prepare
INSERT INTO enum_public_request_type (id,name,description)
VALUES(20,'mojeid_prevalidated_unidentified_contact_transfer','MojeID pre-validated contact without identification transfer'),
      (21,'mojeid_prevalidated_contact_transfer','MojeID pre-validated contact transfer');
