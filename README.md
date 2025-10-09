# PostgreSQL CRUD API

A simple Node.js API with CRUD operations for PostgreSQL database, designed for deployment on EC2 with RDS.

## API Endpoints

### Health Check

- `GET /health` - API health status

### Users

- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Products

- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create new product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

## Quick Start

### Local Development

1. **Clone and install dependencies:**

   ```bash
   npm install
   ```

2. **Setup environment:**

   ```bash
   cp env.example .env
   # Edit .env with your database credentials
   ```

3. **Run with Docker Compose (includes PostgreSQL):**

   ```bash
   docker-compose up --build
   ```

4. **Or run locally:**

   ```bash
   npm run dev
   ```

### Production Deployment on EC2

#### Setting Environment Variables on EC2

For production deployments, you can set environment variables globally on your EC2 instance using `/etc/environment`:

1. **Edit the environment file:**

   ```bash
   sudo vim /etc/environment
   ```

2. **Add your environment variables:**

   ```bash
   DB_HOST=your-rds-endpoint.amazonaws.com
   DB_PORT=5432
   DB_NAME=your-database-name
   DB_USER=your-username
   DB_PASSWORD=your-password
   PORT=3000
   NODE_ENV=production
   ```

3. **Apply the changes:**

   ```bash
   # Reload environment variables for current session
   source /etc/environment
   
   # Or restart the system to apply globally
   sudo reboot
   ```

4. **Verify the variables are set:**

   ```bash
   echo $DB_HOST
   echo $NODE_ENV
   ```

**Note:** Variables set in `/etc/environment` are available system-wide and will persist across reboots. This is useful when you want to avoid using `.env` files in production.

#### Prepare your EC2 instance

   **For Amazon Linux 2 / CentOS / RHEL:**

   ```bash
   # Download and run the installation script
   curl -fsSL https://raw.githubusercontent.com/your-repo/postgres-crud-api/main/install-docker.sh -o install-docker.sh
   chmod +x install-docker.sh
   ./install-docker.sh
   ```

   **For Ubuntu/Debian:**

   ```bash
   # Download and run the installation script
   curl -fsSL https://raw.githubusercontent.com/your-repo/postgres-crud-api/main/install-docker-ubuntu.sh -o install-docker-ubuntu.sh
   chmod +x install-docker-ubuntu.sh
   ./install-docker-ubuntu.sh
   ```

   **Or install manually:**

   ```bash
   # Install Docker
   sudo yum update -y
   sudo yum install -y docker
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user
   
   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

#### Deploy your application

   ```bash
   # Clone your repository
   git clone <your-repo-url>
   cd postgres-crud-api
   
   # Setup production environment
   cp env.production.example .env.production
   # Edit .env.production with your RDS credentials
   
   # Build and run
   docker-compose -f docker-compose.prod.yml up -d --build
   ```

#### Nginx Configuration and Setup

This project includes nginx configuration for serving your application with proper API proxying and static file serving.

**Prerequisites:**

- Nginx installed on your EC2 instance
- Your Node.js application running on port 3000

**Install Nginx (if not already installed):**

```bash
# Amazon Linux 2 / CentOS / RHEL
sudo yum install -y nginx

# Ubuntu/Debian
sudo apt update
sudo apt install -y nginx

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

**Configure Nginx:**

The project includes two convenient Makefile targets for nginx setup:

1. **Complete Setup** (recommended for first-time setup):

   ```bash
   make nginx-setup
   ```

   This will:
   - Validate required files (`update-nginx-config.sh` and `index.html`)
   - Run the nginx configuration script
   - Set up proper file permissions
   - Copy your `index.html` to the web directory

2. **Configuration Update Only** (for updates):

   ```bash
   make nginx-update
   ```

   This will:
   - Update nginx configuration only
   - Reload nginx with new settings

**Manual Configuration:**

If you prefer to configure nginx manually:

```bash
# Make the script executable
chmod +x update-nginx-config.sh

# Run the configuration script
sudo ./update-nginx-config.sh
```

**What the nginx configuration does:**

- **Static Files**: Serves your `index.html` and other static files from `/var/www/app`
- **API Proxying**: Routes `/api/*` requests to your Node.js app on port 3000
- **Health Checks**: Proxies `/health` requests to your app's health endpoint
- **Fallback**: Serves `index.html` for any unmatched routes (useful for SPA routing)

**Nginx Configuration Details:**

The `nginx.config` file includes:

- Server block listening on port 80
- Root directory set to `/var/www/app`
- Proxy configuration for API routes with proper headers
- Health check endpoint proxying
- Static file serving with fallback to `index.html`

**Security Groups:**

Make sure your EC2 security group allows:

- **Port 80** (HTTP) - for nginx
- **Port 22** (SSH) - for server access
- **Port 3000** (optional) - only if you need direct access to your Node.js app

**Troubleshooting Nginx:**

```bash
# Check nginx status
sudo systemctl status nginx

# Test nginx configuration
sudo nginx -t

# View nginx logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# Restart nginx
sudo systemctl restart nginx

# Reload configuration
sudo systemctl reload nginx
```

**File Structure After Setup:**

```bash
/var/www/app/          # Web directory
├── index.html         # Your frontend application
└── ...                # Other static files

/etc/nginx/
├── sites-available/
│   └── default        # Your nginx configuration
└── backups/           # Configuration backups
    └── default_backup_*.conf
```

## Environment Variables

### Development (.env)

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=postgres
DB_PASSWORD=password
PORT=3000
NODE_ENV=development
```

### Production (.env.production)

```env
DB_HOST=your-rds-endpoint.amazonaws.com
DB_PORT=5432
DB_NAME=your-database-name
DB_USER=your-username
DB_PASSWORD=your-password
PORT=3000
NODE_ENV=production
```

## API Usage Examples

### Create a User

```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30
  }'
```

### Get All Users

```bash
curl http://localhost:3000/api/users
```

### Create a Product

```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "stock": 10
  }'
```

### Update a Product

```bash
curl -X PUT http://localhost:3000/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Gaming Laptop",
    "description": "High-performance gaming laptop",
    "price": 1299.99,
    "stock": 5
  }'
```

## Database Schema

### Users Table

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  age INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Products Table

```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Docker Commands

### Build and Run

```bash
# Build image
docker build -t postgres-crud-api .

# Run container
docker run -p 3000:3000 --env-file .env postgres-crud-api
```

### Docker Compose

```bash
# Development (with local PostgreSQL)
docker-compose up --build

# Production (with external RDS)
docker-compose -f docker-compose.prod.yml --env-file .env.production up -d --build
```

## Monitoring and Health Checks

The API includes health check endpoints and Docker health checks:

- **Health endpoint:** `GET /health`
- **Docker health check:** Built into the container
- **Logs:** Available via `docker logs <container-name>`

## Security Features

- Helmet.js for security headers
- Input validation
- SQL injection protection (parameterized queries)
- CORS configuration
- Non-root user in Docker container

## Troubleshooting

### Common Issues

1. **Database connection failed:**
   - Check your RDS endpoint and credentials
   - Ensure security groups allow connections on port 5432
   - Verify database exists and user has proper permissions

2. **Port already in use:**
   - Change the PORT in your environment variables
   - Or stop the process using the port: `sudo lsof -ti:3000 | xargs kill -9`

3. **Docker build fails:**
   - Ensure Docker is running
   - Check Dockerfile syntax
   - Verify all required files are present

### Logs

```bash
# View container logs
docker logs postgres-crud-api

# Follow logs in real-time
docker logs -f postgres-crud-api
```

## Project Structure

```bash
├── src/
│   ├── config/
│   │   └── database.js          # Database connection
│   ├── controllers/
│   │   ├── userController.js    # User CRUD operations
│   │   └── productController.js # Product CRUD operations
│   ├── models/
│   │   ├── User.js              # User model
│   │   └── Product.js           # Product model
│   ├── routes/
│   │   ├── userRoutes.js        # User routes
│   │   └── productRoutes.js     # Product routes
│   └── server.js                # Main server file
├── Dockerfile                   # Docker configuration
├── docker-compose.yml          # Development Docker Compose
├── docker-compose.prod.yml     # Production Docker Compose
├── install-docker.sh           # Docker installation for Amazon Linux
├── install-docker-ubuntu.sh   # Docker installation for Ubuntu/Debian
├── deploy.sh                   # EC2 deployment script
├── nginx.config                # Nginx configuration template
├── update-nginx-config.sh      # Nginx setup script
├── index.html                  # Frontend application
├── Makefile                    # Build automation and deployment commands
├── package.json                # Dependencies
└── README.md                   # This file
```

## License

MIT License
