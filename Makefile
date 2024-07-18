DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yaml

all: up

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

re: down
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build


logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

.PHONY: all up down re logs
