# Bring Your Own Stack

Web infra playground

# Features

* A sample **[Ruby](https://www.ruby-lang.org/)** web application based on **[Sinatra](http://sinatrarb.com/)** and served by **[Puma](http://puma.io/)**
  * Includes a **[metrics exporter](https://prometheus.io/docs/guides/node-exporter/)** for Prometheus
* **[Nginx](https://www.nginx.com/)** serving as reverse proxy on port **8080**
* **[PostgreSQL](https://www.postgresql.org/)** as database server
  * Includes a **[metrics exporter](https://github.com/wrouesnel/postgres_exporter)** for Prometheus
* **[Memcached](https://memcached.org/)** as cache server
  * Includes a **[metrics exporter](https://github.com/prometheus/memcached_exporter)** for Prometheus
* **[Prometheus](https://prometheus.io/)** as stats and monitoring tool
* **[Grafana](https://grafana.com/)** as a visualisation tool for data collected by Prometheus

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
curl http://localhost:8080
curl http://localhost:8080/articles
curl http://localhost:8080/articles/1
```

# Generate trafic

```
ruby trafic/trafic.rb --help
```

# Monitor

* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)

## Setup Grafana with Prometheus

1. Navigate to http://localhost:3000
2. Login with `admin:admin`
3. Add a datasource
   - Name: `Prometheus`
   - Type: `Prometheus`
   - Url: `http://localhost:9090`
   - Access: `Browser`
4. Add dashboards
   - Navigate to `http://localhost:3000/dashboard/import`
   - Import the JSON dashboards (select the Prometheus source when importing the JSON):
     - System Webapp [docker/grafana/system-webapp.json](docker/grafana/system-webapp.json)
     - Postgres [docker/grafana/postgres.json](docker/grafana/postgres.json)
     - Memcached [docker/grafana/memcached.json](docker/grafana/memcached.json)
