# Docker Log Management Makefile
# Usage: make <command>

.PHONY: help logs logs-api logs-db logs-all logs-follow logs-tail logs-grep logs-since logs-until logs-limit clean-logs

# Default target
help:
	@echo "Docker Log Management Commands:"
	@echo "  logs      	   	- Show API container logs"
	@echo "  logs-follow   	- Follow API logs in real-time"
	@echo "  logs-tail     	- Show last 50 lines of API logs"
	@echo "  logs-grep     	- Search logs for specific pattern (usage: make logs-grep PATTERN='error')"
	@echo "  clean-logs    	- Clean up old logs"
	@echo ""
	@echo "API Container Management:"
	@echo "  status        	- Show API container status"
	@echo "  restart       	- Restart API container"
	@echo "  stop          	- Stop API container"
	@echo "  start         	- Start API container"
	@echo "  build         	- Build and start API container"
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

# Restart API container
restart:
	@echo "🔄 Restarting API container..."
	@docker-compose restart
	@echo "✅ API container restarted"

# Stop API container
stop:
	@echo "🛑 Stopping API container..."
	@docker-compose down
	@echo "✅ API container stopped"

# Start API container production
start:
	@echo "🚀 Starting API container..."
	@docker-compose -f docker-compose.prod.yml up -d
	@echo "✅ API container started"

# Build and start API container
build:
	@echo "🔨 Building and starting API container..."
	@docker-compose -f docker-compose.prod.yml up -d --build
	@echo "✅ API container built and started"