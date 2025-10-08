# PostgreSQL CRUD API

A simple Node.js API with CRUD operations for PostgreSQL database, designed for deployment on EC2 with RDS.

## Features

- ✅ Complete CRUD operations for Users and Products
- ✅ PostgreSQL database integration
- ✅ Docker containerization
- ✅ Production-ready configuration
- ✅ Health check endpoints
- ✅ Input validation
- ✅ Error handling
- ✅ Security headers (Helmet)
- ✅ CORS support
- ✅ Request logging

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

1. **Prepare your EC2 instance:**

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

2. **Deploy your application:**

   ```bash
   # Clone your repository
   git clone <your-repo-url>
   cd postgres-crud-api
   
   # Setup production environment
   cp env.production.example .env.production
   # Edit .env.production with your RDS credentials
   
   # Build and run
   docker-compose -f docker-compose.prod.yml --env-file .env.production up -d --build
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
├── package.json                # Dependencies
└── README.md                   # This file
```

## License

MIT License
