# Bring Your Own Stack

Web infra playground

# Features

* A sample **[Ruby](https://www.ruby-lang.org/)** web application based on **[Sinatra](http://sinatrarb.com/)** and served by **[Puma](http://puma.io/)**
  * Includes a **[node exporter](https://prometheus.io/docs/guides/node-exporter/)** for Prometheus
* **[Nginx](https://www.nginx.com/)** serving as reverse proxy on port **8080**
* **[PostgreSQL](https://www.postgresql.org/)** as database server
* **[Memcached](https://memcached.org/)** as cache server
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
curl htt://localhost:8080
curl htt://localhost:8080/articles
curl htt://localhost:8080/articles/1
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
4. Add new dashboard
   - Navigate to `http://localhost:3000/dashboard/import`
   - Copy and paste the JSON content from [docker/grafana/System-1540737820549.json](docker/grafana/System-1540737820549.json)
   - Make sure you select the Prometheus source when importing the JSON
