ALTER TABLE registrar
      ALTER COLUMN dic SET DATA TYPE VARCHAR(50) USING COALESCE(TRIM(dic), ''),
      ALTER COLUMN dic SET NOT NULL,
        ADD CONSTRAINT registrar_dic_check CHECK(TRIM(dic) != '') NOT VALID,

        ADD CONSTRAINT registrar_handle_check CHECK(TRIM(handle) != '') NOT VALID,

      ALTER COLUMN name SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(name), ''),
      ALTER COLUMN name SET NOT NULL,
        ADD CONSTRAINT registrar_name_check CHECK(TRIM(name) != '') NOT VALID,

      ALTER COLUMN organization SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(organization), ''),
      ALTER COLUMN organization SET NOT NULL,
        ADD CONSTRAINT registrar_organization_check CHECK(TRIM(organization) != '') NOT VALID,

      ALTER COLUMN street1 SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(street1), ''),
      ALTER COLUMN street1 SET NOT NULL,
        ADD CONSTRAINT registrar_street1_check CHECK(TRIM(street1) != '') NOT VALID,
      ALTER COLUMN street2 SET DATA TYPE VARCHAR(1024) USING NULLIF(TRIM(street2), ''),
      ALTER COLUMN street3 SET DATA TYPE VARCHAR(1024) USING NULLIF(TRIM(street3), ''),
        -- check if street2 is present OR street3 is not present with respect to the NULL arithmetic
        -- NULL arithmetic: NULL IS TRUE = false
        --                  NULL IS NOT TRUE = true
        ADD CONSTRAINT registrar_street23_check CHECK(TRIM(street2) != '' IS TRUE OR
                                                      TRIM(street3) != '' IS NOT TRUE) NOT VALID,

      ALTER COLUMN city SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(city), ''),
      ALTER COLUMN city SET NOT NULL,
        ADD CONSTRAINT registrar_city_check CHECK(TRIM(city) != '') NOT VALID,

      ALTER COLUMN postalcode SET DATA TYPE VARCHAR(32) USING COALESCE(TRIM(postalcode), ''),
      ALTER COLUMN postalcode SET NOT NULL,
        ADD CONSTRAINT registrar_postalcode_check CHECK(TRIM(postalcode) != '') NOT VALID,

      ALTER COLUMN telephone SET DATA TYPE VARCHAR(32) USING COALESCE(TRIM(postalcode), ''),
      ALTER COLUMN telephone SET NOT NULL,
        ADD CONSTRAINT registrar_telephone_check CHECK(TRIM(telephone) != '') NOT VALID,

      ALTER COLUMN email SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(email), ''),
      ALTER COLUMN email SET NOT NULL,
        ADD CONSTRAINT registrar_email_check CHECK(TRIM(email) != '') NOT VALID,

      ALTER COLUMN url SET DATA TYPE VARCHAR(1024) USING COALESCE(TRIM(url), ''),
      ALTER COLUMN url SET NOT NULL,
        ADD CONSTRAINT registrar_url_check CHECK(TRIM(url) != '') NOT VALID,

      ALTER COLUMN system SET DATA TYPE BOOL USING COALESCE(system, FALSE),
      ALTER COLUMN system SET NOT NULL;
