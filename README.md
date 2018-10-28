# Bring Your Own Stack

Web infra playground

# Features

* A sample ruby web application served by **Puma**
* **Nginx** serving as reverse proxy on port **8080**
* **PostgreSQL** as database server
* **Memcached** as cache server

# Prerequisites

Create a `.env` file at the root of the project and fill it with the right values:

```
# General

COMPOSE_PROJECT_NAME = byos
DOCKER_ROOT = ./docker
WEBAPP_ROOT = ./webapp

# Database

DB_USERNAME = xxx
DB_PASSWORD = xxx
DB_DATABASE = xxx
```

# Build

```
make build
```

# Start

```
make start
```

# Test

```
curl htt://localhost:8080
curl htt://localhost:8080/articles
curl htt://localhost:8080/articles/1
```

# Generate trafic

```
ruby trafic/trafic.rb --help
```
