#!/bin/bash
set -e

# Use default values if the variables are not set
: "${MYSQL_ROOT_PASSWORD:=O5Nz88BTPc6krzQ2gQuXJMOEroVKiY9po1LZSy1UQBk}"

# Set the root password
mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"


#############



#############


#!/bin/bash
set -e

# Use default values if the variables are not set
: "${MYSQL_ROOT_PASSWORD:=O5Nz88BTPc6krzQ2gQuXJMOEroVKiY9po1LZSy1UQBk}"

# Start the MySQL server in the background
mysqld_safe &

# Wait for the server to start up
sleep 5s

# Set the root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

# Your other MySQL commands go here

# Stop the server
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# Your other entrypoint commands go here
