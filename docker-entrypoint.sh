#!/bin/bash
set -e

# Use default values if the variables are not set
: "${MYSQL_ROOT_PASSWORD:=O5Nz88BTPc6krzQ2gQuXJMOEroVKiY9po1LZSy1UQBk}"
: "${MYSQL_DATABASE:=wordpress}"
: "${MYSQL_USER:=wpuser}"
: "${MYSQL_PASSWORD:=wpuser}"

# If the command executed is 'mariadbd'
if [ "$1" = 'mariadbd' ]; then
    # Check if we are running as root
    if [ "$(id -u)" = '0' ]; then
        # Start the MySQL server in the background as root
        mysqld_safe &

        # Wait for the server to start up
        sleep 5s

        # Set the root password only if it is not already set
        if mysqladmin -u root password >/dev/null 2>&1; then
            mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
        else
            echo "Root user in MySQL has a password."
        fi

        # Stop the server
        mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

        # If we are, use gosu to step down from root
        exec gosu mysql "$BASH_SOURCE" "$@"
    fi

    # Start the MySQL server in the background
    "$@" --skip-networking --socket=/tmp/mysql.sock &

    # Wait for the server to start up
    mysql=( mysql --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" -hlocalhost --socket=/tmp/mysql.sock )
    for i in {30..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi

    # Create a new database only if it does not already exist
    if [ -n "$MYSQL_DATABASE" ]; then
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
    fi

    # Create a new user only if it does not already exist
    if [ -n "$MYSQL_USER" -a -n "$MYSQL_PASSWORD" ]; then
        echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" | "${mysql[@]}"
        echo "GRANT ALL ON *.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
        echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
    fi

    # Stop the server
    if ! mysqladmin --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" -hlocalhost --socket=/tmp/mysql.sock shutdown; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi

    echo
    echo 'MySQL init process done. Ready for start up.'
    echo
fi

# Run the command (this will start the MySQL server)
exec "$@"
