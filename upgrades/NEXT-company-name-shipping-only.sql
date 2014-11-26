ALTER TABLE contact_address ADD CONSTRAINT company_name_shipping_only 
                                CHECK (company_name IS NULL OR
                                       type='SHIPPING'::contact_address_type);
