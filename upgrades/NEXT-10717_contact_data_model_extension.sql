CREATE TYPE contact_address_type AS ENUM ('MAILING','BILLING','SHIPPING');

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

-- DROP TABLE contact_address_history CASCADE;
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
