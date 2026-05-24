# DevSecOps-Project
This repository demonstrates security of every aspect in DevOps Engineering.


# 🛤️ Vibely — Blog Platform

A  blog platform built with a 3-tier architecture — React frontend, Node.js backend, and PostgreSQL database.


---

## ✨ Features

- 📝 Create blog posts with emoji vibes
- ✏️ Edit your existing posts
- 🗑️ Delete posts you're not feeling anymore
- 💬 Comment on posts

## 🏗️ Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Frontend   │────▶│   Backend    │────▶│  PostgreSQL   │
│   (React +   │◀────│  (Node.js +  │◀────│              │
│    Nginx)    │     │   Express)   │     │              │
│   Port 80    │     │  Port 5000   │     │  Port 5432   │
└──────────────┘     └──────────────┘     └──────────────┘
```

## 📁 Project Structure

```
DEVSECOPS-PROJECT/
├── frontend/                # React (Vite) frontend
│   ├── src/                 # React components & pages
│   ├── nginx.conf           # Nginx config for serving the app
│   └── package.json
├── backend/                 # Node.js Express API
│   ├── src/                 # Routes, DB connection
│   └── package.json
├── deploy/                  # EC2 deployment scripts
│   ├── setup.sh             # One-click EC2 setup script
│   └── vibely-nginx.conf    # Nginx reverse proxy config
└── README.md
```

---

## Do not forget to check pre-requisites before starting this project 😉

## 🚀 Deploy on AWS EC2

### Prerequisites

- An AWS EC2 instance running **Ubuntu 22.04+**
- Security Group allowing inbound traffic on ports **22** (SSH) and **80** (HTTP)
- SSH access to the instance

### Step 1: Transfer the Code to EC2

```bash
# From your local machine
scp -r -i your-key.pem ./vibely ubuntu@<EC2_PUBLIC_IP>:~/vibely
```

### Step 2: SSH into the Instance

```bash
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Step 3: Run the Setup Script

The `deploy/setup.sh` script installs everything and configures the app automatically:

```bash
cd ~/DEVSECOPS-PROJECT
chmod +x deploy/setup.sh
./deploy/setup.sh
```

This script will:
1. Update system packages
2. Install **Node.js 20.x**, **PostgreSQL 16**, **Nginx**, and **PM2**
3. Create the database and user
4. Install backend dependencies
5. Build the React frontend
6. Configure Nginx as a reverse proxy
7. Start the backend with PM2 (auto-restarts on crash/reboot)

### Step 4: Access the App

Open your browser and go to:

```
http://<EC2_PUBLIC_IP>
```

### Useful Commands

```bash
pm2 status                          # Check backend status
pm2 logs                            # View backend logs
pm2 restart all                     # Restart backend
sudo systemctl restart nginx        # Restart Nginx
sudo -u postgres psql -d vibely_db  # Connect to database
```

---

## 🧑‍💻 Local Development (Without Docker)

### Prerequisites

- Node.js 20+
- PostgreSQL 16+

### Backend

```bash
cd backend
npm install

# Create a .env file (or export these variables)
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=vibely_user
export DB_PASSWORD=vibely_pass
export DB_NAME=vibely_db
export PORT=5000

npm start
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

The Vite dev server starts on `http://localhost:3000` and proxies `/api` requests to the backend at `http://localhost:5000`.

## Kubernetes Setup for GHCR Access

When deploying this application to a Kubernetes cluster, run the following command once to create a Docker registry secret for pulling images from GitHub Container Registry (GHCR).

Replace the placeholder values with your actual GitHub credentials and Personal Access Token (PAT).

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_PAT \
  --docker-email=YOUR_EMAIL


---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/posts` | Get all posts |
| GET | `/api/posts/:id` | Get single post with comments |
| POST | `/api/posts` | Create a new post |
| PUT | `/api/posts/:id` | Update a post |
| DELETE | `/api/posts/:id` | Delete a post |
| GET | `/api/comments/post/:postId` | Get comments for a post |
| POST | `/api/comments` | Create a comment |
| DELETE | `/api/comments/:id` | Delete a comment |

---

My Learnings :

## PM2

PM2 is a process manager mainly used for Node.js applications.  
It keeps applications running in the background, automatically restarts them if they crash, and helps manage logs and multiple app instances.

Common usage:
- Run Node.js apps as services
- Auto-restart on failure
- Zero-downtime restarts
- Process monitoring

---

## Why `npm run build` is Used in Frontend Applications

`npm run build` creates an optimized production version of the frontend application.

During the build process:
- Minifies JavaScript and CSS
- Removes unused code
- Optimizes assets
- Generates static files for deployment

The output is usually stored inside a `dist/` or `build/` folder and served using NGINX or another web server.

---

## Why Linting is Used

Linting checks code for formatting issues, bad practices, and possible bugs before deployment.

Tools like ESLint help:
- Maintain clean and consistent code
- Catch syntax mistakes early
- Improve readability
- Follow coding standards across teams

Linting improves code quality and reduces avoidable errors.

---

## Difference Between Trivy and Hadolint

### Trivy
Trivy is a security scanner used to find:
- Vulnerabilities in Docker images
- OS package issues
- Secret leaks
- Dependency vulnerabilities

Focus: **Security scanning**

### Hadolint
Hadolint is a Dockerfile linter that checks Dockerfile best practices.

It helps identify:
- Inefficient Docker instructions
- Bad image-building practices
- Syntax and formatting issues

Focus: **Dockerfile quality and standards**

In short:
- Trivy → scans built images for security issues
- Hadolint → checks Dockerfile writing standards before build

---

## Why Kubernetes Requires Lowercase Image Names for GHCR

Kubernetes follows container image naming rules defined by OCI/Docker standards.  
Because of this, GitHub Container Registry (GHCR) image names must be lowercase.

Example:

```bash
ghcr.io/johndoe/my-app:latest


Usage of sites-available, sites-enabled, and /etc/nginx/conf.d
/etc/nginx/sites-available

Stores all NGINX site configuration files.
Think of it as a directory where available website configs are kept.

/etc/nginx/sites-enabled

Contains symbolic links to active site configurations from sites-available.

Only configs linked here are actually loaded by NGINX.

This separation helps:

Enable/disable websites easily
Keep configs organized
Avoid deleting original config files

Example:

ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
/etc/nginx/conf.d

Used for additional NGINX configuration files.

Commonly used for:

Reverse proxy configs
Global settings
Docker/Kubernetes NGINX configs
Small modular configs

Files inside conf.d/ are automatically included by NGINX.