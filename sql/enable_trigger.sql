--enable trigger at the end of script
ALTER TABLE public_request ENABLE TRIGGER trigger_lock_public_request;

ALTER TABLE object_state_request ENABLE TRIGGER trigger_lock_object_state_request;
