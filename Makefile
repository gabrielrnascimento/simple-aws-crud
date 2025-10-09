# Docker Log Management Makefile
# Usage: make <command>

.PHONY: help logs logs-api logs-db logs-all logs-follow logs-tail logs-grep logs-since logs-until logs-limit clean-logs

# Default target
help:
	@echo "Docker Log Management Commands:"
	@echo "  logs      - Show API container logs"
	@echo "  logs-follow   - Follow API logs in real-time"
	@echo "  logs-tail     - Show last 50 lines of API logs"
	@echo "  logs-grep     - Search logs for specific pattern (usage: make logs-grep PATTERN='error')"
	@echo "  clean-logs    - Clean up old logs"
	@echo ""
	@echo "Container Management:"
	@echo "  status        - Show container status"
	@echo "  restart       - Restart all containers"
	@echo "  stop          - Stop all containers"
	@echo "  start         - Start all containers"
	@echo "  build         - Build and start containers"
	@echo ""
	@echo "Production Deployment:"
	@echo "  deploy-prod   - Deploy to production"
	@echo "  health        - Show container health status"
	@echo ""

# Show API container logs
logs:
	@echo "📊 API Container Logs:"
	@docker logs postgres-crud-api

# Follow API logs in real-time
logs-follow:
	@echo "👀 Following API logs (Ctrl+C to stop):"
	@docker logs -f postgres-crud-api

# Show last 50 lines of API logs
logs-tail:
	@echo "📄 Last 50 lines of API logs:"
	@docker logs --tail 50 postgres-crud-api

# Search logs for specific pattern
logs-grep:
	@if [ -z "$(PATTERN)" ]; then \
		echo "❌ Please provide a pattern: make logs-grep PATTERN='error'"; \
		exit 1; \
	fi
	@echo "🔍 Searching API logs for: $(PATTERN)"
	@docker logs postgres-crud-api 2>&1 | grep -i "$(PATTERN)" || echo "No matches found"


# Clean up old logs (requires Docker 20.10+)
clean-logs:
	@echo "🧹 Cleaning up old logs..."
	@docker system prune -f
	@echo "✅ Log cleanup completed"

# Container status
status:
	@echo "📊 Container Status:"
	@docker-compose ps

# Restart all containers
restart:
	@echo "🔄 Restarting all containers..."
	@docker-compose restart
	@echo "✅ Containers restarted"

# Stop all containers
stop:
	@echo "🛑 Stopping all containers..."
	@docker-compose down
	@echo "✅ Containers stopped"

# Start all containers
start:
	@echo "🚀 Starting all containers..."
	@docker-compose up -d
	@echo "✅ Containers started"

# Build and start containers
build:
	@echo "🔨 Building and starting containers..."
	@docker-compose up -d --build
	@echo "✅ Containers built and started"

# Production deployment
deploy-prod:
	@echo "🚀 Deploying to production..."
	@docker-compose -f docker-compose.prod.yml up -d --build
	@echo "✅ Production deployment completed"

# Show container health status
health:
	@echo "🏥 Container Health Status:"
	@docker inspect --format='{{.State.Health.Status}}' postgres-crud-api 2>/dev/null || echo "No health check configured"
	@docker inspect --format='{{.State.Status}}' postgres-crud-db 2>/dev/null || echo "Database container status"