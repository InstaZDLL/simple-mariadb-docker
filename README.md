# Simple Mariadb Docker

This repository contains a Dockerfile for building a MariaDB image based on Debian. The image is configured to run MariaDB as a non-root user for security reasons.

## How It Works

The Dockerfile installs MariaDB and other necessary packages on a Debian base image. It also sets up necessary directories and permissions for running MariaDB.

The `docker-entrypoint.sh` script is used to initialize the database and create a user when the container is started. The script checks if it's being run as root, and if so, uses `gosu` to step down from root to the `mysql` user.

Environment variables are used to configure the database. You can set the root password, database name, username, and password using the `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD` environment variables, respectively.

## How to Run the Container

You can run a container from this image using the following command:

```bash
docker run -d --name my-mariadb \
    -e MYSQL_ROOT_PASSWORD=myrootpassword \
    -e MYSQL_DATABASE=mydatabase \
    -e MYSQL_USER=myuser \
    -e MYSQL_PASSWORD=mypassword \
    -p 3306:3306 \
    nayeonyny/mariadb:latest

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
