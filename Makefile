# Makfile

ENV_FILE ?= ./.env
include $(ENV_FILE)
export

COMPOSE_PROJECT_NAME ?= byos
DOCKER_ROOT          ?= ./docker
WEBAPP_ROOT          ?= ./webapp

DOCKER_CMD  = cd $(DOCKER_ROOT) && docker-compose

.PHONY: build start stop clean database

build:
	cp $(WEBAPP_ROOT)/Gemfile* $(DOCKER_ROOT)/webapp/
	mkdir -p storage/grafana-data
	chmod 777 storage/grafana-data
	$(DOCKER_CMD) build --pull

start:
	$(DOCKER_CMD) up

stop:
	$(DOCKER_CMD) stop

clean: stop
	rm $(DOCKER_ROOT)/webapp/Gemfile*
	$(DOCKER_CMD) rm -f

shell:
	$(DOCKER_CMD) exec webapp /bin/ash

database:
	$(DOCKER_CMD) exec database psql -U $(DB_USERNAME) $(DB_DATABASE)
