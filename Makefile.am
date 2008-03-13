pkgdata_DATA = structure.sql
dist_pkgdata_SCRIPTS = createdb.sh
sbin_SCRIPTS = fred-dbmanager
CLEANFILES = structure.sql createdb.sh fred-dbmanager
EXTRA_DIST = $(srcdir)/sql/*.sql $(srcdir)/orderedsql.sh \
             $(srcdir)/fred-db.spec

structure.sql:
	$(srcdir)/orderedsql.sh > structure.sql

