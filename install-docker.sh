#!/bin/bash

# Docker Installation Script for Amazon Linux 2 / CentOS / RHEL
# This script installs Docker and Docker Compose on EC2 instances

set -e

echo "🐳 Starting Docker installation on EC2..."

# Update system packages
echo "📦 Updating system packages..."
sudo yum update -y

# Install required packages
echo "🔧 Installing required packages..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository
echo "➕ Adding Docker repository..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
echo "🐳 Installing Docker..."
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
echo "🚀 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group (so you can run docker without sudo)
echo "👤 Adding ec2-user to docker group..."
sudo usermod -a -G docker ec2-user

# Install Docker Compose
echo "🔧 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create symlink for easier access
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verify installations
echo "✅ Verifying installations..."
docker --version
docker-compose --version

# Test Docker
echo "🧪 Testing Docker installation..."
sudo docker run hello-world

echo ""
echo "🎉 Docker and Docker Compose installed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Log out and log back in (or run 'newgrp docker') to apply group changes"
echo "2. Clone your repository: git clone <your-repo-url>"
echo "3. Navigate to your project: cd postgres-crud-api"
echo "4. Setup environment: cp env.production.example .env.production"
echo "5. Edit .env.production with your RDS credentials"
echo "6. Deploy: ./deploy.sh"
echo ""
echo "⚠️  Important: You need to log out and log back in for the docker group changes to take effect!"
echo "   Or run: newgrp docker"
