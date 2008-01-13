#!/bin/bash
TABLES=$(echo "\dt" | psql fred -U fred -At 2>/dev/null)
if [ "$TABLES" = "" ]; then
    createuser fred -SDR -U postgres
    createdb fred -O fred -E UTF8 -U postgres
    createlang -U postgres plpgsql fred
    psql fred -U fred -f /usr/share/fred-db/structure.sql >/dev/null 2>&1
fi
