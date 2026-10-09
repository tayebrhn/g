# ============================================================
# TCExam — Developer Automation Makefile
# ============================================================

COMPOSE_DEV = docker compose -f docker-compose.yml -f docker-compose.dev.yml

.PHONY: help dev up down stop restart logs logs-app sh db test clean

help:
	@echo "Available commands:"
	@echo "  make dev      - Start development environment with live hot-reloading"
	@echo "  make down     - Stop development containers"
	@echo "  make restart  - Restart all containers"
	@echo "  make logs     - Follow logs from all containers"
	@echo "  make logs-app - Follow PHP application logs"
	@echo "  make sh       - Open interactive shell in PHP-FPM container"
	@echo "  make db       - Connect to MariaDB command-line client"
	@echo "  make test     - Run configuration and test suite"
	@echo "  make offline-bundle - Rebuild and package offline production bundle (.tar)"
	@echo "  make clean    - Stop containers and remove persistent volumes"

offline-bundle:
	bash docker/build-offline-bundle.sh

dev: up

up:
	@if [ ! -f .env ]; then cp .env.example .env; echo "Initialized .env"; fi
	$(COMPOSE_DEV) up -d
	@echo "TCExam is running at http://localhost:8080/public/code/index.php"
	@echo "Admin Portal:        http://localhost:8080/admin/code/index.php (admin/1234)"

down:
	$(COMPOSE_DEV) down

stop: down

restart:
	$(COMPOSE_DEV) restart

logs:
	$(COMPOSE_DEV) logs -f

logs-app:
	$(COMPOSE_DEV) logs -f app

sh:
	$(COMPOSE_DEV) exec app sh

db:
	$(COMPOSE_DEV) exec db mariadb -u tcexam -ptcexam_secret_pass tcexam

test:
	php test/test_docker_configuration_integrity.php

clean:
	$(COMPOSE_DEV) down -v
