-- Reason of state change
CREATE TABLE object_state_request_reason
(
    object_state_request_id INTEGER NOT NULL REFERENCES object_state_request (id),
    -- state present/absent
    state_on BOOL NOT NULL,
    reason VARCHAR(300) NOT NULL,
    PRIMARY KEY (object_state_request_id,state_on)
);

-- Enable contact state serverBlocked
UPDATE enum_object_states SET types='{1,3}' WHERE name='serverBlocked';
