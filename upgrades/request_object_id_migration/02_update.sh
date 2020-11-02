#!/bin/bash

failcheck() {
    local -r action=$1
    # shellcheck disable=SC2154
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    case $action in
        on)
            set -e
            trap 'printf "command \"%s\" failed with exit code %s." "$last_command" "$?" >&2' EXIT
            ;;
        off)
            set +e
            trap '' EXIT
            ;;
    esac
}

failcheck on

# shellcheck source=02_update.conf
. "02_update.conf"

psql_wrapper() {
    local -r query="$1"
    local -r access="${2:-ro}"

    if [[ "$access" == "rw" ]]; then
        local -r user=$user_rw;
    else
        local -r user=$user_ro;
    fi

    if $debug; then
        printf "QUERY:\\n%s\\n\\n" "$query"
    fi
    if [[ -n "$logfile" ]]; then
        if [[ "$access" == "rw" ]]; then
            printf "%s\\n" "$query" >> "$logfile"
        else
            printf "/*\\n%s\\n*/\\n" "$query" >> "$logfile"
        fi
    fi
    if ! $dry_run || [[ "$access" == "ro" ]]; then
        failcheck off
        RETVAL=$(printf "\\set ON_ERROR_STOP on\\n%s" "$query" | psql --tuples-only --no-psqlrc --host "$host" --port "$port" --username "$user" "$dbname");
        result=$?
        case $result in
            0) printf "success\\n";;
            1) printf "FATAL ERROR: client error\\n" >&2; exit ;;
            2) printf "FATAL ERROR: database error\\n" >&2; exit ;;
            3) printf "FATAL ERROR: SQL error\\n" >&2; exit ;;
        esac
        failcheck
        if [[ -n "$logfile" ]]; then
            if [[ "$access" == "ro" ]]; then
                printf "/*\\n%s\\n*/\\n" "$RETVAL" >> "$logfile"
            fi
        fi
    fi
}

migrate() {
    local -r tablename=$1
    if [[ $# -eq 1 ]]; then
        local -r query="
UPDATE $tablename ror
   SET object_bigid = object_id
 WHERE ror.object_bigid IS NULL;";
        printf "migrate records (NOT NULL)\\n"
    else
        local -r -i from_id=$2
        local -r -i to_id=$3
        local -r query="
UPDATE $tablename ror
   SET object_bigid = object_id
 WHERE ror.id IN (
     SELECT id FROM $child
      WHERE ror.object_bigid IS NULL
        AND ror.id >= $from_id
        AND ror.id < $to_id
        FOR UPDATE
        SKIP LOCKED);";
        printf "migrate records (%s..%s)\\n" "$from_id" "$to_id"
    fi

    psql_wrapper "$query" "rw";
}

migrate_records() {
    local -r select_kids_query="
SELECT pgcch.relname
  FROM pg_inherits pgi
  JOIN pg_class AS pgcch
    ON inhrelid = pgcch.oid
  JOIN pg_class AS pgcp
    ON inhparent = pgcp.oid
 WHERE pgcp.relname = 'request_object_ref';"

    psql_wrapper "$select_kids_query"
    #RETVAL="a
    #b"
    local -r children=$RETVAL

    for child in $children; do
        psql_wrapper "SELECT COUNT(id) FROM $child;"
        local -i count_id=$RETVAL
        if [[ $count_id -eq 0 ]]; then
            continue;
        fi

        psql_wrapper "SELECT MIN(id) FROM $child;"
        local -i min_id=$RETVAL
        #local -i min_id=100

        psql_wrapper "SELECT MAX(id) FROM $child;"
        local -i max_id=$RETVAL
        #local -i max_id=500

        records=$((max_id - min_id))
        batches="$(((records / batch_size) + 1))"

        printf "child table: \"%s\"\\n" "$child"
        printf "records up to: %s\\n" "$records"
        printf "batch size: %s\\n" "$batch_size"
        printf "number of batches set to: %s\\n" "$batches"
        printf "\\n"

        for batch_idx in $(seq 0 $((batches-1))); do
            printf "batch #%s of %s\\n" "$((batch_idx + 1))" "$batches"
            migrate "$child" "$((min_id + (batch_idx * batch_size)))" "$((min_id + (batch_idx + 1) * batch_size))"
        done
        migrate "$child"

        psql_wrapper "CREATE INDEX CONCURRENTLY IF NOT EXISTS ${child}_object_bigid_idx ON ${child}(object_bigid);" "rw";
    done
}

migrate_records

failcheck off
