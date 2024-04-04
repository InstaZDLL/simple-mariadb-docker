#!/bin/bash
set -e

if [ "${1#-}" != "$1" ]; then
    set -- mysqld "$@"
fi

if [ "$1" = 'mysqld' -a -z "$(id -u)" ]; then
    chown -R mysql .
    exec gosu mysql "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mysqld' ]; then
    DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

    if [ ! -d "$DATADIR/mysql" ]; then
        if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
            echo >&2 'error: database is uninitialized and password option is not specified '
            echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD'
            exit 1
        fi

        mkdir -p "$DATADIR"

        echo 'Initializing database'
        mysql_install_db --datadir="$DATADIR" --rpm
        echo 'Database initialized'

        "$@" --skip-networking &
        pid="$!"

        mysql=( mysql --protocol=socket -uroot )

        for i in {30..0}; do
            if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
                break
            fi
            echo 'MySQL init process in progress...'
            sleep 1
        done
        if [ "$i" = 0 ]; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
            mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
        fi

        echo "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" | "${mysql[@]}"

        if [ "$MYSQL_DATABASE" ]; then
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
        fi

        if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
            echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" | "${mysql[@]}"

            if [ "$MYSQL_DATABASE" ]; then
                echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
            fi
        fi

        echo
        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
                *.sh)     echo "$0: running $f"; . "$f" ;;
                *.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
                *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
                *)        echo "$0: ignoring $f" ;;
            esac
            echo
        done

        if ! kill -s TERM "$pid" || ! wait "$pid"; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        echo
        echo 'MySQL init process done. Ready for start up.'
        echo
    fi
fi

exec "$@"