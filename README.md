# Maitre-D

[![Build Badge](https://img.shields.io/circleci/build/github/truggeri/maitre-d/main)](https://circleci.com/gh/truggeri/maitre-d/tree/main)
![Coverage Badge](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)

Description to come...

![RoR Badge](https://img.shields.io/badge/-Ruby_On_Rails-b32424?style=flat&labelColor=cc0000&logo=ruby-on-rails&logoColor=white)
![PostgreSQL Badge](https://img.shields.io/badge/-PostgreSQL-426078?style=flat&labelColor=336791&logo=postgresql&logoColor=white)

[![Docker Badge](https://img.shields.io/badge/-Docker-4b99d4?style=flat&labelColor=2496ED&logo=docker&logoColor=white)](./Dockerfile)

## Bootstrapping User

In order to manage roles, you must first have a user with permission to manage roles. To create this user,
we have provided a hook based upon two ENV being set upon startup.

| ENV | Description |
| --- | --- |
| `SUPERADMIN_USERNAME` | The username/email of the privileged user |
| `SUPERADMIN_PASSWORD` | The password of the user |

The user is created or updated with the given username and password and is given the "manage_roles" role
which allows access to the management dashboard.

## Local Setup

You'll need the following to run the project yourself.

### PostgreSQL Database

This app uses [PostgreSQL 13](https://www.postgresql.org/docs/13/) for it's datastore. In order to configure one, provide a database URL via an environment variable.

```bash
export DATABASE_URL=postgres://<username>:<password>@<host>:<port>
```

This database can be setup in any fashion that you choose. Options include [local install](https://www.postgresql.org/download/), [Docker](https://hub.docker.com/_/postgres?tab=description), or as [a web service](https://www.heroku.com/postgres). If you'd like to use Docker, we have a [Docker Compose](https://docs.docker.com/compose/) [file](./docker-compose.yml) to help,

```bash
cp .env.development.example .env.development
# Add your custom choices for ENV
source .env.development
docker-compose up --detach db
```

### Docker

If you'd like to run the application using Docker, there is a [Dockerfile](./Dockerfile) provided.
To use, build the container first and then run it with your configured database and port settings.

```bash
source .env.development
docker build -t maitre-d .
docker run --rm -e DATABASE_URL=$DATABASE_URL -p 3000:3000 maitre-d
