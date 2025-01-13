############################################################

PROJECT:= inception

COMPOSE_PATH = ./srcs/docker-compose.yml

BASE = docker-compose -p $(PROJECT) -f $(COMPOSE_PATH)

############################################################

up: down
	$(BASE) up --build -d --remove-orphans

build: down
	$(BASE) build

down:
	$(BASE) down --remove-orphans

logs:
	$(BASE) logs -f

ps:
	$(BASE) ps

run:
	@$(BASE) run -d "$(filter-out $@,$(MAKECMDGOALS))"

############################################################

it:
	$(BASE) exec -it "$(filter-out $@,$(MAKECMDGOALS))" "/bin/bash"

restart:
	$(BASE) restart $(filter-out $@,$(MAKECMDGOALS))



