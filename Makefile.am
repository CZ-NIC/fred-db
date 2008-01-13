pkgdata_DATA = structure.sql
dist_pkgdata_SCRIPTS = createdb.sh
CLEANFILES = structure.sql
EXTRA_DIST = $(srcdir)/sql/*.sql $(srcdir)/orderedsql.sh \
             $(srcdir)/fred-db.spec

structure.sql:
	$(srcdir)/orderedsql.sh > structure.sql

