# PuzzleTime Development Makefile
# Run `make help` for available commands

.PHONY: help dev stop logs shell console db-console docs docs-build test lint clean

# Default target
help:
	@echo "PuzzleTime Development Commands"
	@echo ""
	@echo "Development:"
	@echo "  make dev          Start development environment (Docker)"
	@echo "  make stop         Stop all containers"
	@echo "  make logs         Follow container logs"
	@echo "  make shell        Open shell in web container"
	@echo "  make console      Open Rails console"
	@echo "  make db-console   Open PostgreSQL console"
	@echo ""
	@echo "Documentation:"
	@echo "  make docs         Serve docs locally (http://localhost:8000)"
	@echo "  make docs-build   Build static docs site"
	@echo ""
	@echo "Testing & Quality:"
	@echo "  make test         Run test suite"
	@echo "  make lint         Run Rubocop linter"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean        Remove temporary files and containers"
	@echo "  make setup        Initial project setup"

# =============================================================================
# Development
# =============================================================================

dev:
	@echo "Starting development environment..."
	./bin/dev

stop:
	docker compose down

logs:
	docker compose logs -f

shell:
	docker compose exec web bash

console:
	docker compose exec web bin/rails console

db-console:
	docker compose exec ptimedb psql -U puzzletime puzzletime_development

# =============================================================================
# Documentation
# =============================================================================

docs:
	@echo "Serving docs at http://localhost:8000"
	@echo "Press Ctrl+C to stop"
	@command -v mkdocs >/dev/null 2>&1 || { echo "Installing mkdocs-material..."; pip install mkdocs-material; }
	mkdocs serve

docs-build:
	@command -v mkdocs >/dev/null 2>&1 || { echo "Installing mkdocs-material..."; pip install mkdocs-material; }
	mkdocs build

# =============================================================================
# Testing & Quality
# =============================================================================

test:
	docker compose exec web bin/rails test

test-local:
	bin/rails test

lint:
	docker compose exec web bin/rubocop

lint-local:
	bin/rubocop

# =============================================================================
# Setup & Maintenance
# =============================================================================

setup:
	@echo "Setting up development environment..."
	cp -n .env.example .env 2>/dev/null || true
	docker compose build
	docker compose run --rm web bin/rails db:setup
	@echo "Setup complete! Run 'make dev' to start."

clean:
	@echo "Cleaning up..."
	docker compose down -v --remove-orphans
	rm -rf tmp/cache tmp/pids tmp/sockets
	rm -rf site/  # MkDocs build output
	@echo "Clean complete."

# =============================================================================
# Production (deploy/)
# =============================================================================

.PHONY: prod-test prod-stop prod-logs

prod-test:
	@echo "Starting production test environment..."
	cd deploy && docker compose -f docker-compose.test.yml --env-file .env.prod up --build

prod-stop:
	cd deploy && docker compose -f docker-compose.test.yml --env-file .env.prod down

prod-logs:
	cd deploy && docker compose -f docker-compose.test.yml --env-file .env.prod logs -f

