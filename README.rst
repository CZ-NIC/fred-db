======
README
======

A set of sql scripts, which together create a database of central registry.
It is necessity for creating database to call scripts in the right order.
For this purpose serves orderedsql.sh script, which print out sql commands
how they should go. For creating database call

``./orderedsql.sh | psql fred -U fred``

Then it's necessity to have some records in registrar and registracacl tables.
registrar.sql script is enough for testing.
