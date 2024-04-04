The `RUN` command in a Dockerfile is used to execute commands during the image build process. The MySQL server needs to be running when you're executing MySQL commands, but the server does not persist across different `RUN` commands or after the image build process is completed.

The entrypoint script is executed when a container is started from the image, not during the image build process. Therefore, you should include the commands to start the MySQL server, set the root password, and execute other MySQL commands in the entrypoint script.

Here's an example of how you can modify your entrypoint script:

```bash
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
```

In this script, the MySQL server is started, the root password is set, and then the server is stopped. After this, you can include your other entrypoint commands.

Please note that this is just a suggestion and the actual solution might vary depending on the exact configuration and state of your MySQL server. It's always a good practice to check the MySQL server logs for any error messages or warnings. If the problem persists, I recommend checking the MySQL server documentation or seeking help from the MySQL community. They might be able to provide more specific guidance based on the exact version and configuration of your MySQL server.




Look these lines how can I move it in my entrypoint ?

ENV MYSQL_ROOT_PASSWORD=O5Nz88BTPc6krzQ2gQuXJMOEroVKiY9po1LZSy1UQBk
RUN mysqld_safe & \
    sleep 5s && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" && \
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown