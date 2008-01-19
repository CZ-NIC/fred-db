#!/bin/bash

# This script ensures that database is installed and configured properly 
# for connection of database user 'fred'. Script has to be run under 
# postgresql administrator privileges (usually as user postgres)

if [ "$USER" != "postgres" ]
then
    echo "Must be run under user 'postgres'"
    exit 1;
fi

# First check if connection is configured in pg_hba file. This file is
# located in postgresql cluster in PGDATA directory. If located elsewhere
# run this script with path to pg_hba file as first parametr

PGHBA=$PGDATA/pg_hba.conf  
if [ ! -f $PGHBA ]
then
    if [ "$1" = "" -o ! -f "$1" ]
    then
	echo "Cannot locate pg_hba.conf file"
	exit 2
    else
	PGHBA=$1
    fi
fi

if grep fred $PGHBA >/dev/null 2>&1
then
    /bin/true
else
    # There is no evidence about user fred in authentication file so
    # it can be suspected that user fred will not be allowed to connect
    # This file will be modified to allow local connection for user
    # fred. If this is not intended modify database access options in
    # server fred server configuration files to suite you needs
    {
	echo "# Next three lines were added by script $0"
	echo "# to allow local connection of user fred "
	echo "local fred fred trust"
	echo "host fred fred 127.0.0.1/32 trust"
	echo "host fred fred ::1/128 trust "
	echo
	cat $PGHBA
    } > /tmp/fred-pghba-update-script-$$
    mv /tmp/fred-pghba-update-script-$$ $PGHBA
    # reload new file into postgres
    /usr/bin/pg_ctl reload >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
	echo "Reload of updated configuration failed, try to reload manualy"
	exit 3
    fi
fi

STRUCTSQL=/usr/share/fred-db/structure.sql 
TABLES=$(echo "\dt" | /usr/bin/psql fred -U fred -At 2>/dev/null)
if [ "$TABLES" = "" ]; then
    /usr/bin/createuser fred -SDR > /dev/null 2>&1
    /usr/bin/createdb fred -O fred -E UTF8 > /dev/null 2>&1
    /usr/bin/createlang -U postgres plpgsql fred > /dev/null 2>&1
    /usr/bin/psql fred -U fred -f $STRUCTSQL >/dev/null 2>&1
fi
