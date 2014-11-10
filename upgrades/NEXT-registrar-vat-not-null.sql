ALTER TABLE registrar ALTER COLUMN vat SET NOT NULL;
COMMENT ON COLUMN Registrar.VAT IS 'whether VAT should be counted in invoicing';
