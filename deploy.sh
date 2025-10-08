#!/bin/bash

# Deployment script for EC2 with RDS
# This script helps deploy the PostgreSQL CRUD API to EC2

set -e

echo "🚀 Starting deployment to EC2..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env.production exists
if [ ! -f .env.production ]; then
    echo "❌ .env.production file not found. Please create it from env.production.example"
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml --env-file .env.production down || true

# Build and start new containers
echo "🔨 Building and starting containers..."
docker-compose -f docker-compose.prod.yml --env-file .env.production up -d --build

# Wait for health check
echo "⏳ Waiting for application to be healthy..."
sleep 30

# Check if application is running
if curl -f http://localhost:3000/health > /dev/null 2>&1; then
    echo "✅ Application deployed successfully!"
    echo "🌐 API is available at: http://localhost:3000"
    echo "📊 Health check: http://localhost:3000/health"
    echo "👥 Users API: http://localhost:3000/api/users"
    echo "📦 Products API: http://localhost:3000/api/products"
else
    echo "❌ Application health check failed. Check logs:"
    docker logs postgres-crud-api
    exit 1
fi

echo "🎉 Deployment completed!"
