DOCKER_COMPOSE_DIR=./.builds
DOCKER_COMPOSE_HTTPD_FILE=-f $(DOCKER_COMPOSE_DIR)/docker-compose-build-httpd.yml
DOCKER_COMPOSE_PHP_FILE=-f $(DOCKER_COMPOSE_DIR)/docker-compose-build-php.yml
DOCKER_COMPOSE_DB_FILE=-f $(DOCKER_COMPOSE_DIR)/docker-compose-build-db.yml
DOCKER_COMPOSE=docker-compose --env-file $(DOCKER_COMPOSE_DIR)/build.env
comma=,
space=
space +=
TAG_LIST = $(subst $(comma),$(space),$(TAGS))
TZ := Europe/Berlin
APACHE24_VERSION := 2.4.46
PHP74_VERSION := 7.4.11
PHP73_VERSION := 7.3.23
PHP56_VERSION := 5.6.40
MARIADB104_VERSION := 10.4.13
MARIADB105_VERSION := 10.5.5

REPLACES=build-httpd build-php build-db build
SERVICE=$(filter-out $(REPLACES),$(MAKECMDGOALS))



DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##all: get-service

.env:
ifeq (,$(wildcard ./.env))
	cp ./.env-example ./.env
endif

## Build all latest images and tag as :latest
.PHONY: build
build: build-httpd build-php build-db

## Build all latest httpd images and tag as :latest
.PHONY: build-httpd
build-httpd:
	@echo BUILD_TZ=$(TZ) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo APACHE24_VERSION=$(APACHE24_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_HTTPD_FILE) build $(SERVICE)
	rm -f $(DOCKER_COMPOSE_DIR)/build.env

## Build all latest php images and tag as :latest
.PHONY: build-php
build-php:
	@echo BUILD_TZ=$(TZ) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo PHP74_VERSION=$(PHP74_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo PHP73_VERSION=$(PHP73_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo PHP56_VERSION=$(PHP56_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PHP_FILE) build $(SERVICE)
	rm -f $(DOCKER_COMPOSE_DIR)/build.env

## Build all latest db images and tag as :latest
.PHONY: build-db
build-db:
	@echo BUILD_TZ=$(TZ) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo MARIADB104_VERSION=$(MARIADB104_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	@echo MARIADB105_VERSION=$(MARIADB105_VERSION) >> $(DOCKER_COMPOSE_DIR)/build.env
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_DB_FILE) build $(SERVICE)
	rm -f $(DOCKER_COMPOSE_DIR)/build.env

.PHONY: docker-init
docker-init: #.env ## Make sure the .env file exists for docker

.PHONY: docker-build-from-scratch
docker-build-from-scratch: docker-init ## Build all docker images from scratch, without cache etc. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
#	$(DOCKER_COMPOSE) rm -fs $(CONTAINER) && \
#	$(DOCKER_COMPOSE) build --pull --no-cache --parallel $(CONTAINER) && \
#	$(DOCKER_COMPOSE) up -d --force-recreate $(CONTAINER)

.PHONY: docker-test
docker-test: docker-init docker-up ## Run the infrastructure tests for the docker setup
#	sh $(DOCKER_COMPOSE_DIR)/docker-test.sh

.PHONY: docker-build
docker-build: docker-init ## Build all docker images. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
#	$(DOCKER_COMPOSE) build --parallel $(CONTAINER) && \
#	$(DOCKER_COMPOSE) up -d --force-recreate $(CONTAINER)

.PHONY: docker-prune
docker-prune: ## Remove unused docker resources via 'docker system prune -a -f --volumes'
#	docker system prune -a -f --volumes

.PHONY: docker-up
docker-up: docker-init ## Start all docker containers. To only start one container, use CONTAINER=<service>
#	$(DOCKER_COMPOSE) up -d $(CONTAINER)

.PHONY: docker-down
docker-down: docker-init ## Stop all docker containers. To only stop one container, use CONTAINER=<service>
#	$(DOCKER_COMPOSE) down $(CONTAINER)
