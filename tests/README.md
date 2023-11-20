<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Humhub, verified and packaged by Elestio

[Humhub](https://github.com/mriedmann/humhub-docker) is a feature rich and highly flexible OpenSource Social Network Kit written in PHP. This container provides a quick, flexible and lightweight way to set up a proof-of-concept for detailed evaluation.

<img src="https://github.com/elestio-examples/humhub/raw/main/humhub.png" alt="Humhub" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/humhub">fully managed Humhub</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you are interested in an open source all-in-one devops platform with the ability to manage git repositories, manage issues, and run continuous integrations.

[![deploy](https://github.com/elestio-examples/humhub/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?soft=humhub)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/humhub.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:64869`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        version: "3.3"
        services:
        humhub:
            image: elestio4test/humhub:latest
            restart: always
            ports:
            - "172.17.0.1:64869:80"
            environment:
            HUMHUB_ADMIN_LOGIN: admin
            HUMHUB_ADMIN_EMAIL: ${ADMIN_EMAIL}
            HUMHUB_ADMIN_PASSWORD: ${ADMIN_PASSWORD}
            HUMHUB_DB_USER: ${HUMHUB_DB_USER}
            HUMHUB_DB_PASSWORD: ${HUMHUB_DB_PASSWORD}
            HUMHUB_DB_HOST: "db"
            HUMHUB_DB_NAME: "humhub"
            HUMHUB_AUTO_INSTALL: 1
            HUMHUB_DEBUG: 1
            HUMHUB_PROTO: "https"
            HUMHUB_HOST: ${DOMAIN}
            # Mailer install setup
            HUMHUB_MAILER_SYSTEM_EMAIL_ADDRESS: ${HUMHUB_MAILER_SYSTEM_EMAIL_ADDRESS}
            HUMHUB_MAILER_SYSTEM_EMAIL_NAME: "HumHub"
            HUMHUB_MAILER_TRANSPORT_TYPE: "smtp"
            HUMHUB_MAILER_HOSTNAME: ${HUMHUB_MAILER_HOSTNAME}
            HUMHUB_MAILER_PORT: ${HUMHUB_MAILER_PORT}
            HUMHUB_MAILER_USERNAME: ${HUMHUB_MAILER_USERNAME}
            HUMHUB_MAILER_PASSWORD: ${HUMHUB_MAILER_PASSWORD}
            #HUMHUB_MAILER_ENCRYPTION:
            HUMHUB_MAILER_ALLOW_SELF_SIGNED_CERTS: 0
            # Cache Config
            HUMHUB_CACHE_EXPIRE_TIME: 3600
            HUMHUB_CACHE_CLASS: yii\redis\Cache
            HUMHUB_QUEUE_CLASS: humhub\modules\queue\driver\Redis
            HUMHUB_REDIS_HOSTNAME: redis
            HUMHUB_REDIS_PORT: 6379
            HUMHUB_REDIS_PASSWORD: ${HUMHUB_REDIS_PASSWORD}
            volumes:
            - "./storage/config:/var/www/localhost/htdocs/protected/config"
            - "humhub-uploads:/var/www/localhost/htdocs/uploads"
            - "humhub-assets:/var/www/localhost/htdocs/assets"
            - "humhub-modules:/var/www/localhost/htdocs/protected/modules"
            - "humhub-themes:/var/www/localhost/htdocs/themes"
        db:
            image: elestio/mariadb:10.4
            restart: always
            environment:
            MYSQL_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
            MYSQL_DATABASE: "humhub"
            MYSQL_USER: ${HUMHUB_DB_USER}
            MYSQL_PASSWORD: ${HUMHUB_DB_PASSWORD}
            volumes:
            - "./storage/mysql:/var/lib/mysql"
            ports:
            - 172.17.0.1:35011:3306
        redis:
            image: elestio/redis:7.0
            restart: always
            expose:
            - "6379"
            volumes:
            - ./storage/redis:/data
            command: --requirepass ${HUMHUB_REDIS_PASSWORD}

        pma:
            image: elestio/phpmyadmin:latest
            restart: always
            links:
            - db:db
            ports:
            - "172.17.0.1:33682:80"
            environment:
            PMA_HOST: db
            PMA_PORT: 3306
            PMA_USER: humhub
            PMA_PASSWORD: ${ADMIN_PASSWORD}
            UPLOAD_LIMIT: 500M
            MYSQL_USERNAME: humhub
            MYSQL_ROOT_PASSWORD: ${ADMIN_PASSWORD}
            depends_on:
            - db

        volumes:
        humhub-uploads:
            driver: local
            driver_opts:
            type: none
            device: ${PWD}/storage/uploads
            o: bind
        humhub-assets:
            driver: local
            driver_opts:
            type: none
            device: ${PWD}/storage/assets
            o: bind
        humhub-modules:
            driver: local
            driver_opts:
            type: none
            device: ${PWD}/storage/modules
            o: bind
        humhub-themes:
            driver: local
            driver_opts:
            type: none
            device: ${PWD}/storage/themes
            o: bind


### Environment variables

|       Variable       | Value (example) |
| :------------------: | :-------------: |
| SOFTWARE_VERSION_TAG |     latest      |
|     INITIAL_USER     |      root       |
|     ADMIN_EMAIL      |  test@mail.com  |
|    ADMIN_PASSWORD    |    password     |
|   HUMHUB_DB_USER     |    user         |
|  HUMHUB_DB_PASSWORD  |    password     |

# Maintenance

## Logging

The Elestio Humhub Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/mriedmann/humhub-docker">Humhub Github repository</a>

- <a target="_blank" href="https://docs.humhub.org/">Humhub documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/humhub">Elestio/Humhub Github repository</a>
