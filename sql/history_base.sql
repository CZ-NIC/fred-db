CREATE TABLE History (
        ID SERIAL PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action, -- link into table action
        valid_from TIMESTAMP NOT NULL DEFAULT NOW(),
        valid_to TIMESTAMP,
        next INTEGER
);

COMMENT ON TABLE history IS
'Main evidence table with modified data, it join historic tables modified during same operation
create - in case of any change';
COMMENT ON COLUMN history.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN history.action IS 'link to action which cause modification';
COMMENT ON COLUMN history.valid_from IS 'date from which was this history created';
COMMENT ON COLUMN history.valid_to IS 'date to which was history actual (NULL if it still is)';
COMMENT ON COLUMN history.next IS 'next history id';

CREATE INDEX history_action_idx ON history (action);
CREATE INDEX history_action_valid_from_idx ON history (valid_from);
CREATE UNIQUE INDEX history_next_idx ON history (next);

