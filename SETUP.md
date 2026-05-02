# 🚀 AutoLab Setup Guide - Desktop & Codespaces

Complete guide for setting up AutoLab on your desktop, laptop, or new codespaces.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Prerequisites](#prerequisites)
3. [Installation Steps](#installation-steps)
4. [Environment Configuration](#environment-configuration)
5. [Database Setup](#database-setup)
6. [Running Development Servers](#running-development-servers)
7. [Troubleshooting](#troubleshooting)
8. [Project Structure](#project-structure)

---

## ⚡ Quick Start

### For Linux/macOS Users:

```bash
# Clone the repository (if not already done)
git clone https://github.com/yourusername/autolab-monorepo.git
cd autolab-monorepo

# Make setup script executable
chmod +x setup.sh

# Run setup (will take 5-10 minutes)
./setup.sh
```

### For Windows Users:

```cmd
# Clone the repository (if not already done)
git clone https://github.com/yourusername/autolab-monorepo.git
cd autolab-monorepo

# Run setup (will take 5-10 minutes)
setup.bat
```

### For GitHub Codespaces:

```bash
# Inside your codespace terminal, run:
chmod +x setup.sh
./setup.sh
```

---

## 📦 Prerequisites

### System Requirements

- **Node.js**: v18.0.0 or higher
- **npm**: v9.0.0 or higher
- **Git**: v2.0.0 or higher
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 2GB free space

### Operating Systems Supported

✅ **Linux** (Ubuntu 20.04+, Debian, CentOS)  
✅ **macOS** (10.15+)  
✅ **Windows** (Windows 10+)  
✅ **GitHub Codespaces** (Ubuntu-based)

### Optional but Recommended

- **Docker** (for running PostgreSQL and Redis in containers)
- **Redis** (for OTP caching - optional)
- **PostgreSQL** (if not using Supabase)

---

## 💾 Installation Steps

### Step 1: Install Node.js (if needed)

**Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**macOS (with Homebrew):**
```bash
brew install node
```

**Windows:**
- Download from https://nodejs.org/
- Run the installer and follow the prompts
- Restart your terminal after installation

### Step 2: Clone the Repository

```bash
git clone https://github.com/yourusername/autolab-monorepo.git
cd autolab-monorepo
```

### Step 3: Run Setup Script

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

**Windows:**
```cmd
setup.bat
```

**GitHub Codespaces:**
```bash
chmod +x setup.sh
./setup.sh
```

The script will automatically:
- ✅ Check system requirements
- ✅ Verify Node.js and npm installation
- ✅ Install all npm dependencies
- ✅ Create environment configuration files
- ✅ Generate Prisma ORM client
- ✅ Provide next steps guide

---

## 🔐 Environment Configuration

### Backend Configuration (apps/backend/.env)

The setup script creates a `.env` file from the template. You must update it with real credentials:

```env
# Database (Use Supabase - free tier available)
DATABASE_URL="postgresql://user:password@host:5432/postgres"

# Server
NODE_ENV=development
PORT=3000
API_URL=http://localhost:3000

# JWT Tokens
JWT_SECRET=your-secret-key-here
JWT_EXPIRY=7d

# Email (Gmail)
GMAIL_USER=your-email@gmail.com
GMAIL_PASS=your-app-specific-password  # NOT your regular password!

# SMS (HSP Media Network)
HSP_SMS_USERNAME=your_username
HSP_SMS_API_KEY=your_api_key
HSP_SMS_SENDER=AUTOLAB

# Redis (optional, for OTP caching)
REDIS_URL=redis://localhost:6379

# CORS Configuration
FLUTTER_APP_URL=com.autolab.app
ADMIN_DASHBOARD_URL=http://localhost:3001
PRODUCTION_URL=https://api.autolab.com
```

#### Getting Gmail App Password:

1. Enable 2-Factor Authentication on your Google Account
2. Go to https://myaccount.google.com/apppasswords
3. Select "Mail" and "Windows Computer" (or your device)
4. Copy the 16-character password
5. Paste it in `GMAIL_PASS` (without spaces)

### Dashboard Configuration (apps/dashboard/.env.local)

```env
# Backend API URL
NEXT_PUBLIC_BACKEND_URL=http://localhost:3000

# Build Configuration (for production)
BUILD_STANDALONE=
```

---

## 📊 Database Setup

### Using Supabase (Recommended - FREE)

1. **Create Account**: Go to https://supabase.com
2. **Create Project**: Click "New Project" → Fill details → Create
3. **Get Connection String**:
   - Go to Settings → Database → Connection String
   - Copy PostgreSQL connection string
   - Update `DATABASE_URL` in `apps/backend/.env`

4. **Run Migrations**:
   ```bash
   cd apps/backend
   npm run prisma:migrate
   ```

### Using Local PostgreSQL

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install postgresql postgresql-contrib
sudo service postgresql start
```

**macOS (Homebrew):**
```bash
brew install postgresql
brew services start postgresql
```

**Windows:**
- Download installer from https://www.postgresql.org/download/windows/
- Install and note the password you set
- Use in connection string: `postgresql://postgres:PASSWORD@localhost:5432/autolab`

**Docker (Any OS):**
```bash
docker run -d \
  -e POSTGRES_PASSWORD=autolab123 \
  -e POSTGRES_DB=autolab \
  -p 5432:5432 \
  postgres:15
```

### Run Database Migrations

```bash
cd apps/backend
npm run prisma:migrate
```

This will:
- Create all required tables
- Set up relationships
- Initialize indexes

---

## 🎯 Running Development Servers

### Terminal 1 - Backend API (Port 3000)

```bash
cd apps/backend
npm run dev
```

Expected output:
```
✓ Prisma client generated
✓ Server listening on http://localhost:3000
```

### Terminal 2 - Dashboard (Port 3001)

```bash
cd apps/dashboard
npm run dev
```

Expected output:
```
▲ Next.js 14.x
- Local:        http://localhost:3000
- Environments: .env.local

```

### Terminal 3 - Flutter App (Optional)

```bash
cd apps/flutter-app
flutter pub get
flutter run
```

---

## 🛠 Available Commands

### Root Level
```bash
npm run install-all      # Install all dependencies
npm run backend:dev      # Start backend development server
npm run backend:build    # Build backend for production
npm run dashboard:dev    # Start dashboard development server
npm run dashboard:build  # Build dashboard for production
npm run flutter:run      # Run Flutter app
```

### Backend
```bash
cd apps/backend
npm run dev              # Start development with hot reload
npm run build            # Build for production
npm run start            # Start production server
npm run prisma:generate  # Generate Prisma client
npm run prisma:migrate   # Run database migrations
npm run prisma:seed      # Seed database with sample data
npm run test             # Run tests
npm run lint             # Run ESLint
```

### Dashboard
```bash
cd apps/dashboard
npm run dev              # Start development server
npm run build            # Build for production
npm run start            # Start production server
npm run lint             # Run linter
npm run format           # Format code
```

---

## 📁 Project Structure

```
autolab-monorepo/
├── apps/
│   ├── backend/              # Express.js REST API
│   │   ├── src/
│   │   │   ├── routes/       # API endpoints
│   │   │   ├── controllers/  # Business logic
│   │   │   ├── middleware/   # Auth, validation
│   │   │   └── models/       # Data models
│   │   ├── prisma/
│   │   │   ├── schema.prisma # Database schema
│   │   │   └── seed.ts       # Sample data
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── .env             # Environment variables
│   │
│   ├── dashboard/            # Next.js Admin Dashboard
│   │   ├── src/
│   │   │   ├── app/         # App Router pages
│   │   │   ├── components/  # React components
│   │   │   └── lib/         # Utilities
│   │   ├── package.json
│   │   ├── next.config.ts
│   │   └── .env.local       # Environment variables
│   │
│   └── flutter-app/          # Flutter Mobile App
│       ├── lib/
│       ├── ios/
│       ├── android/
│       └── pubspec.yaml
│
├── packages/
│   ├── shared-types/         # Shared TypeScript types
│   └── shared-utils/         # Shared utilities
│
├── SETUP_GUIDES/             # Setup documentation
├── setup.sh                  # Linux/macOS setup script
├── setup.bat                 # Windows setup script
├── package.json              # Root package.json
└── README.md                 # Project README
```

---

## 🆘 Troubleshooting

### Node.js Command Not Found

**Problem**: `node: command not found`

**Solution**:
1. Install Node.js from https://nodejs.org/
2. Restart your terminal
3. Verify: `node --version`

### Port Already in Use

**Backend (3000) in use**:
```bash
# Find process using port 3000
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Kill the process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows

# Or use different port
PORT=3001 npm run dev
```

### Database Connection Failed

```
Error: P1000 Authentication failed against database server
```

**Solution**:
1. Verify `DATABASE_URL` in `.env` is correct
2. Check if PostgreSQL is running
3. Verify username/password
4. Ensure database exists
5. Check network/firewall

### npm Install Fails

```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

### Setup Script Permission Denied (Linux/macOS)

```bash
# Make script executable
chmod +x setup.sh

# Then run
./setup.sh
```

---

## 📚 Additional Resources

- **Backend Docs**: [SETUP_GUIDES/04_EXPRESS_BACKEND.md](../SETUP_GUIDES/04_EXPRESS_BACKEND.md)
- **Dashboard Docs**: [SETUP_GUIDES/05_NEXT_JS_DASHBOARD.md](../SETUP_GUIDES/05_NEXT_JS_DASHBOARD.md)
- **Database Docs**: [SETUP_GUIDES/03_SUPABASE_DATABASE.md](../SETUP_GUIDES/03_SUPABASE_DATABASE.md)
- **Project Structure**: [SETUP_GUIDES/00_MONOREPO_STRUCTURE.md](../SETUP_GUIDES/00_MONOREPO_STRUCTURE.md)

---

## ✅ Verification Checklist

After setup, verify everything is working:

- [ ] Node.js installed: `node --version` (v18+)
- [ ] npm installed: `npm --version` (v9+)
- [ ] Root dependencies installed: `ls node_modules` (should exist)
- [ ] Backend dependencies installed: `ls apps/backend/node_modules`
- [ ] Dashboard dependencies installed: `ls apps/dashboard/node_modules`
- [ ] Backend .env created: `ls apps/backend/.env`
- [ ] Dashboard .env.local created: `ls apps/dashboard/.env.local`
- [ ] Prisma generated: `ls apps/backend/node_modules/.prisma/client`
- [ ] Backend runs: `cd apps/backend && npm run dev` (should listen on 3000)
- [ ] Dashboard runs: `cd apps/dashboard && npm run dev` (should start dev server)

---

## 🚀 What's Next?

1. **Configure Credentials**:
   - Add database credentials
   - Add email credentials
   - Add SMS credentials

2. **Run Migrations**:
   - Set up database schema
   - Seed initial data

3. **Start Development**:
   - Run backend server
   - Run dashboard server
   - Test API endpoints

4. **Read Documentation**:
   - Review setup guides
   - Understand architecture
   - Plan your features

---

## 💬 Getting Help

If you encounter issues:

1. **Check Troubleshooting Section** above
2. **Read Documentation** in SETUP_GUIDES folder
3. **Check GitHub Issues** in the repository
4. **Create a New Issue** with:
   - Error message (full text)
   - Steps to reproduce
   - Your OS and Node.js version
   - Setup method used

---

**Happy Coding! 🎉**
