############################################################

PROJECT:= inception

COMPOSE_PATH = ./srcs/docker-compose.yml

BASE = docker compose -p $(PROJECT) -f $(COMPOSE_PATH)

############################################################

up: down
	$(BASE) up --build -d

build: down
	$(BASE) build --no-cache

down:
	$(BASE) down --remove-orphans

logs:
	$(BASE) logs -f

ps:
	$(BASE) ps

fclean: down
	docker system prune -af --volumes

it:
	$(BASE) exec -it "$(filter-out $@,$(MAKECMDGOALS))" "/bin/bash"

restart:
	$(BASE) restart $(filter-out $@,$(MAKECMDGOALS))



