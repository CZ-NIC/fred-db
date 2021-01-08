#!/bin/bash

failcheck() {
    local -r action=$1
    # shellcheck disable=SC2154
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    case $action in
        on)
            set -e
            # shellcheck disable=SC2154
            trap 'printf "command \"%s\" failed with exit code %s." "$last_command" "$?" >&2' EXIT
            ;;
        off)
            set +e
            trap '' EXIT
            ;;
    esac
}

failcheck on

default_options() {
    help=false
    usage=false

    # print queries to stdout
    debug=true

    # do not write to the database
    dry_run=true

    # database host
    host=localhost

    # database port
    port=5432

    # user with RW access for update queries
    user_rw=logd

    # user with RO or RW access for read-only queries
    user_ro=logd

    # database name
    dbname=fredlog

    # log queries to file
    # - read-only queries will be commented out, becouse
    #   their results will be hardcoded into update queries
    logfile=02_update.log

    # how many rows will be updated at once
    batch_size=1000
}

parse_options() {
    options=$#
    opts=""
    leave=false

    while [[ $# -gt 0 && "$leave" == "false" ]]; do
        case "$1" in
            -h|--help)
                help=true
                ;;
            --no-debug)
                debug=false
                ;;
            --no-dry-run)
                dry_run=false
                ;;
            --host|--host=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then host=${1#*=};
                else opts="$opts $1"; shift; host="$1"; fi
                ;;
            --port|--port=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then port=${1#*=};
                else opts="$opts $1"; shift; port="$1"; fi
                ;;
            --user-rw|--user-rw=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then user_rw=${1#*=};
                else opts="$opts $1"; shift; user_rw="$1"; fi
                ;;
            --user-ro|--user-ro=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then user_ro=${1#*=};
                else opts="$opts $1"; shift; user_ro="$1"; fi
                ;;
            --dbname|--dbname=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then dbname=${1#*=};
                else opts="$opts $1"; shift; dbname="$1"; fi
                ;;
            --logfile|--logfile=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then logfile=${1#*=};
                else opts="$opts $1"; shift; logfile="$1"; fi
                ;;
            --batch-size|--batch-size=*)
                if [[ "$1" =~ ^-.*=.*$ ]]; then batch_size=${1#*=};
                else opts="$opts $1"; shift; batch_size="$1"; fi
                ;;
            --)
                leave=true
                ;;
            -*)
                usage=true
                ;;
            *)
                leave=true
                ;;
        esac
        if ! $leave; then opts="$opts $1"; fi
        if ! $leave; then shift; fi
    done;
    to_shift=$((options - $#))
}

process_options() {
    if $usage; then
        usage
        exit 1;
    fi

    if $help; then
        usage
        exit 0;
    fi
}

print_options() {
    if ! $debug; then printf -- "--no-debug\\n"; fi
    if ! $dry_run; then printf -- "--no-dry-run %s\\n"; fi
    printf -- "--host %s\\n" "$host"
    printf -- "--port %s\\n" "$port"
    printf -- "--user-rw %s\\n" "$user_rw"
    printf -- "--user-ro %s\\n" "$user_ro"
    printf -- "--dbname %s\\n" "$dbname"
    printf -- "--logfile %s\\n" "$logfile"
    printf -- "--batch-size %s\\n" "$batch_size"
}

options() {
    default_options
    parse_options "$@"
    process_options
    print_options
}

usage() {
    printf "Usage: %s --no-debug --no-dry-run --host <host> --port <port> --user-rw <user_rw> --user-ro <user_ro> --dbname <dbname> --logfile <logfile> --batch-size <batch_size>\\n" "$0"
}

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
        FOR UPDATE);";
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
    local -r children=$RETVAL

    for child in $children; do
        psql_wrapper "SELECT COUNT(id) FROM $child;"
        local -i count_id=$RETVAL
        if [[ $count_id -eq 0 ]]; then
            continue;
        fi

        psql_wrapper "SELECT MIN(id) FROM $child;"
        local -i min_id=$RETVAL

        psql_wrapper "SELECT MAX(id) FROM $child;"
        local -i max_id=$RETVAL

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

options "$@"
if [[ "$to_shift" -gt 0 ]]; then shift $to_shift; to_shift=0; fi

migrate_records

failcheck off
