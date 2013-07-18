---
--- #8645, #8716
---
CREATE TABLE mail_type_priority
(
    mail_type_id integer primary key references mail_type(id),
    priority integer not null
);

---
--- Ticket #8289 - new column 'importance'
---
ALTER TABLE enum_object_states ADD COLUMN importance INTEGER;

---
--- pyfred + domainbrowser
---
CREATE OR REPLACE VIEW domains_by_nsset_view AS
    SELECT nsset, COUNT(nsset) AS number FROM domain WHERE nsset IS NOT NULL GROUP BY nsset;
CREATE OR REPLACE VIEW domains_by_keyset_view AS
    SELECT keyset, COUNT(keyset) AS number FROM domain WHERE keyset IS NOT NULL GROUP BY keyset;

---
--- Collect states into one string
--- Usage: SELECT get_state_descriptions(53, 'CS');
--- retval: string ca be splited by row delimiter '\n' and column delimiter '\t':
---      [[external, importance, name, description], ...]
--- example: 't\t20\toutzone\tDomain is not generated into zone\nf\t\texpirationWarning\tExpires '
---          'within 30 days\nf\t\tunguarded\tDomain is 30 days after expiration\nf\t\tnssetMissi'
---          'ng\tDomain has not associated nsset'
---
CREATE OR REPLACE FUNCTION get_state_descriptions(object_id bigint, lang_code varchar)
RETURNS TEXT
AS $$
SELECT array_to_string(ARRAY((
    SELECT
        array_to_string(ARRAY[eos.external::char,
        COALESCE(eos.importance::varchar, ''),
        eos.name,
        COALESCE(osd.description, '')], E'#')
    FROM object_state os
    JOIN enum_object_states eos ON eos.id = os.state_id
    JOIN enum_object_states_desc osd ON osd.state_id = eos.id AND lang = $2
    WHERE os.object_id = $1
        AND os.valid_from <= CURRENT_TIMESTAMP
        AND (os.valid_to IS NULL OR os.valid_to > CURRENT_TIMESTAMP)
    ORDER BY eos.importance
)), E'&')
$$ LANGUAGE SQL;

