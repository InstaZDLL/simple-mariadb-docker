# Simple Mariadb Docker

This repository contains a Dockerfile for building a MariaDB image based on Debian. The image is configured to run MariaDB as a non-root user for security reasons.

## How It Works

The Dockerfile installs MariaDB and other necessary packages on a Debian base image. It also sets up necessary directories and permissions for running MariaDB.

The `docker-entrypoint.sh` script is used to initialize the database and create a user when the container is started. The script checks if it's being run as root, and if so, uses `gosu` to step down from root to the `mysql` user.

Environment variables are used to configure the database. You can set the root password, database name, username, and password using the `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD` environment variables, respectively.

## Environment Variables
The following environment variables can be set when running the Docker container:

| ENV | Default value | Example | Description |
| --- | ------------- | ------- | ----------- |
| MYSQL\_ROOT\_PASSWORD | random | myrootpassword | By default, the root password is randomly generated. You can specify a specific root password if required. |
| MYSQL\_DATABASE | wordpress | mydatabase | The name of the first database. |
| MYSQL\_USER | wpuser | myuser | The username first user. |
| MYSQL\_PASSWORD | wpuser | mypassword | The password for the first user. |

## How to Run the Container

You can run a container from this image using the following command:

```bash
docker run -d --name some-mariadb -p 3306:3306 nayeonyny/mariadb:latest
```

## Author

- [@InstaZDLL](https://github.com/InstaZDLL)

## License

```text
Copyright (C) 2024 Ethan Besson

Licensed under the Academic Free License version 3.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://opensource.org/license/afl-3-0-php/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
