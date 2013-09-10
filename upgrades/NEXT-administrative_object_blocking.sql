-- Reason of state change
DROP TABLE IF EXISTS object_state_request_reason;
CREATE TABLE object_state_request_reason
(
    object_state_request_id INTEGER NOT NULL REFERENCES object_state_request (id),
    -- state created
    reason_creation VARCHAR(300) NULL DEFAULT NULL,
    -- state canceled
    reason_cancellation VARCHAR(300) NULL DEFAULT NULL,
    PRIMARY KEY (object_state_request_id)
);

-- Enable contact state serverBlocked
UPDATE enum_object_states SET types='{1,3}' WHERE name='serverBlocked';
