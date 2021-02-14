.DEFAULT_GOAL := help

up: ## Create and start docker containers (run in the background)
	@cd .docker && docker-compose up -d

down: ## Stop and remove containers, networks, images, and volumes
	@cd .docker && docker-compose down

restart: ## Restart services
	@cd .docker && docker-compose stop && docker-compose up -d

install: ## Install project
	@cd .docker && ./install.sh

enter: ## Enter workspace as 'www-data' 
	@cd .docker && docker-compose exec --user=www-data php-fpm bash

enter-root: ## Enter workspace as 'root'
	@cd .docker && docker-compose exec --user=root php-fpm bash

log: ## View output from containers
	@cd .docker && docker-compose logs

stop: ## Stop docker services
	@cd .docker && docker-compose stop

build: ## Build or rebuild docker images from the current project files
	@cd .docker && docker-compose build

composer: ## Run the 'composer update' command
	@cd .docker && docker-compose exec --user=www-data php-fpm composer update

redis-flush: ## Flush the Redis cache (shorthand is 'rf')
	@cd .docker && docker exec -i $$(docker-compose ps -q redis) redis-cli FLUSHALL
rf: redis-flush

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
