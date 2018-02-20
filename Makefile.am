pkgdata_DATA = structure.sql
sbin_SCRIPTS = fred-dbmanager
upgradesdir = $(pkgdatadir)/upgrades
upgrades_DATA = $(srcdir)/upgrades/*.sql

CLEANFILES = structure.sql fred-dbmanager
EXTRA_DIST = \
		$(srcdir)/sql/*.sql \
		$(srcdir)/sql/mail_archive/*.sql \
		$(srcdir)/sql/_defaults/mail_archive/*.sql \
		$(srcdir)/orderedsql.sh \
		$(srcdir)/upgrades/*.sql \
		fred-db.spec

structure.sql: \
		$(srcdir)/sql/*.sql \
		$(srcdir)/sql/mail_archive/*.sql \
		$(srcdir)/sql/_defaults/mail_archive/*.sql \
		$(srcdir)/orderedsql.sh
	$(srcdir)/orderedsql.sh > structure.sql
