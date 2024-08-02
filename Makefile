DOCKER_COMPOSE_FILE	= ./srcs/docker-compose.yml
DOCKER_VOLUMES		= inception-nginx-log inception-mariadb-data inception-wordpress-html
DOCKER_VOLUME_PATHS	= $(addprefix $(HOME)/data/inception/, mariadb/data wordpress/html nginx/log)

all: up

up: mkdir-volume
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

re: down mkdir-volume
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

mkdir-volume:
	@for volume in $(DOCKER_VOLUME_PATHS); do \
		if [ -d "$$volume" ]; then \
			echo "Directory $$volume already exists."; \
		else \
			mkdir -p $$volume && echo "Created directory $$volume."; \
		fi \
	done

clean: down
	docker volume rm $(DOCKER_VOLUMES) > /dev/null 2>&1 && (echo "Success remove volumes") || (echo "Failed to remove volumes")
	sudo rm -rf $(HOME)/data/inception && (echo "Success remove local data") || (echo "Failed to remove local data")

.PHONY: all up down re logs clean mkdir-volume
