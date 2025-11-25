.PHONY: help build up down restart logs clean test

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker images
	docker-compose build

up: ## Start all services
	docker-compose up -d
	@echo "Services started!"
	@echo "API: http://localhost:8080"
	@echo "PostgreSQL: localhost:5432"

down: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

logs: ## Show logs from all services
	docker-compose logs -f

logs-api: ## Show logs from API server only
	docker-compose logs -f plana

logs-db: ## Show logs from database only
	docker-compose logs -f db

clean: ## Stop and remove all containers, volumes, and images
	docker-compose down -v --rmi all

ps: ## Show running containers
	docker-compose ps

shell-api: ## Open shell in API container
	docker-compose exec plana bash

shell-db: ## Open PostgreSQL shell
	docker-compose exec db psql -U postgres -d rem_db

test: ## Test the API endpoints
	@echo "Testing registration..."
	@curl -X POST http://localhost:8080/auth/register \
		-H "Content-Type: application/json" \
		-d '{"email":"test@example.com","name":"Test User","password":"password123"}' | jq
	@echo "\n\nTesting login..."
	@curl -X POST http://localhost:8080/auth/login \
		-H "Content-Type: application/json" \
		-d '{"email":"test@example.com","password":"password123"}' | jq
	@echo "\n\nTesting home endpoint..."
	@curl http://localhost:8080/home | jq
