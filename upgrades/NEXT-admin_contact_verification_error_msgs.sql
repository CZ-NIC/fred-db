UPDATE enum_contact_test_status_localization SET description='Test does not apply to the data.' WHERE lang='en' AND name='skipped';
UPDATE enum_contact_test_status_localization SET description=E'Test couldn\'t be completed due to an error.' WHERE lang='en' AND name='error';
UPDATE enum_contact_test_status_localization SET description='No problem was found.' WHERE lang='en' AND name='ok';
UPDATE enum_contact_test_status_localization SET description='Test found invalid data.' WHERE lang='en' AND name='fail';
