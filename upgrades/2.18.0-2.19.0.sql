---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.19.0' WHERE id = 1;


----
---- additional contact addresses
----
CREATE TYPE contact_address_type AS ENUM ('MAILING', 'BILLING', 'SHIPPING');

CREATE TABLE contact_address (
    id SERIAL CONSTRAINT contact_address_pkey PRIMARY KEY,
    contactid INTEGER NOT NULL CONSTRAINT contact_address_contactid_fkey REFERENCES contact (id),
    type contact_address_type NOT NULL,
    company_name VARCHAR(1024),
    street1 VARCHAR(1024),
    street2 VARCHAR(1024),
    street3 VARCHAR(1024),
    city VARCHAR(1024),
    stateorprovince VARCHAR(1024),
    postalcode VARCHAR(32),
    country CHAR(2) CONSTRAINT contact_address_country_fkey REFERENCES enum_country (id),
    CONSTRAINT contact_address_contactid_type_key UNIQUE (contactid,type)
);

CREATE TABLE contact_address_history (
        historyid INTEGER NOT NULL CONSTRAINT contact_address_history_historyid_fkey REFERENCES history (id),
        id INTEGER NOT NULL,
        contactid INTEGER NOT NULL CONSTRAINT contact_address_history_contactid_fkey REFERENCES object_registry (id),
        type contact_address_type NOT NULL,
        company_name VARCHAR(1024),
        street1 VARCHAR(1024),
        street2 VARCHAR(1024),
        street3 VARCHAR(1024),
        city VARCHAR(1024),
        stateorprovince VARCHAR(1024),
        postalcode VARCHAR(32),
        country CHAR(2) CONSTRAINT contact_address_history_country_fkey REFERENCES enum_country (id),
        CONSTRAINT contact_address_history_pkey PRIMARY KEY (id,historyid)
    );

COMMENT ON TABLE contact_address_history IS
'Historic data from contact_address table.
creation - actual data will be copied here from original table in case of any change in contact_address table';


CREATE INDEX object_state_valid_to_idx ON object_state (valid_to);
DROP INDEX object_state_object_id_idx;-- uses object_state_now_idx instead


---
--- new public request for mojeid re-identification
---
INSERT INTO enum_public_request_type (id, name, description) VALUES
    (19, 'mojeid_contact_reidentification', 'MojeID full identification repeated');


CREATE INDEX public_request_objects_map_object_id_index ON public_request_objects_map (object_id);

