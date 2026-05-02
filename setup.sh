#!/bin/bash

################################################################################
# AutoLab Monorepo - Complete Setup Script
# ============================================================================== 
# Purpose: One-shot setup for desktop, local development, or new codespaces
# Usage: ./setup.sh
# Compatibility: Linux (Ubuntu/Debian), macOS, GitHub Codespaces
################################################################################
#chmod +x setup.sh && ls -l setup.sh

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script variables
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STEP=0

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_step() {
    STEP=$((STEP + 1))
    echo -e "${GREEN}[Step $STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_error "$1 is not installed"
        return 1
    fi
}

################################################################################
# System Requirements Check
################################################################################

check_system_requirements() {
    print_header "Checking System Requirements"

    # Check OS
    OS_TYPE=$(uname -s)
    if [[ "$OS_TYPE" == "Linux" ]] || [[ "$OS_TYPE" == "Darwin" ]]; then
        print_success "Compatible OS detected: $OS_TYPE"
    else
        print_error "Unsupported OS: $OS_TYPE (Only Linux and macOS are supported)"
        exit 1
    fi

    # Check Node.js
    if ! check_command node; then
        print_warning "Node.js is not installed. Attempting installation..."
        install_nodejs
    else
        NODE_VERSION=$(node --version)
        print_info "Node.js version: $NODE_VERSION"
    fi

    # Check npm
    if ! check_command npm; then
        print_error "npm is not installed. Please install Node.js with npm"
        exit 1
    else
        NPM_VERSION=$(npm --version)
        print_info "npm version: $NPM_VERSION"
    fi

    # Check git
    if ! check_command git; then
        print_error "git is not installed. Please install git"
        exit 1
    fi

    print_success "All required tools are available"
}

################################################################################
# Node.js Installation
################################################################################

install_nodejs() {
    print_step "Installing Node.js..."
    
    OS_TYPE=$(uname -s)
    
    if [[ "$OS_TYPE" == "Linux" ]]; then
        # Using NodeSource repository for Ubuntu/Debian
        if command -v apt &> /dev/null; then
            print_info "Installing Node.js via apt..."
            sudo apt-get update
            sudo apt-get install -y nodejs npm
        else
            print_error "Could not find apt package manager. Please install Node.js manually."
            exit 1
        fi
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        # Using Homebrew for macOS
        if command -v brew &> /dev/null; then
            print_info "Installing Node.js via Homebrew..."
            brew install node
        else
            print_error "Homebrew not found. Please install Node.js manually from https://nodejs.org/"
            exit 1
        fi
    fi
    
    print_success "Node.js installed successfully"
}

################################################################################
# Project Setup
################################################################################

setup_project() {
    print_header "Setting Up AutoLab Monorepo"
    
    # Navigate to project directory
    cd "$PROJECT_DIR"
    print_step "Working in: $PROJECT_DIR"
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        print_error "package.json not found in $PROJECT_DIR"
        exit 1
    fi
    print_success "Found package.json"
}

################################################################################
# Install Dependencies
################################################################################

install_dependencies() {
    print_header "Installing Dependencies"
    
    cd "$PROJECT_DIR"
    
    print_step "Installing root dependencies..."
    npm install
    print_success "Root dependencies installed"
    
    print_step "Installing backend dependencies..."
    cd "$PROJECT_DIR/apps/backend"
    npm install
    print_success "Backend dependencies installed"
    
    print_step "Installing dashboard dependencies..."
    cd "$PROJECT_DIR/apps/dashboard"
    npm install
    print_success "Dashboard dependencies installed"
    
    cd "$PROJECT_DIR"
}

################################################################################
# Environment Setup
################################################################################

setup_environment() {
    print_header "Setting Up Environment Files"
    
    # Backend environment file
    print_step "Configuring backend environment..."
    BACKEND_ENV="$PROJECT_DIR/apps/backend/.env"
    
    if [ ! -f "$BACKEND_ENV" ]; then
        if [ -f "$PROJECT_DIR/apps/backend/.env.example" ]; then
            cp "$PROJECT_DIR/apps/backend/.env.example" "$BACKEND_ENV"
            print_success "Created backend .env from template"
            print_warning "IMPORTANT: Update $BACKEND_ENV with your actual credentials:"
            print_warning "  - DATABASE_URL (Supabase PostgreSQL)"
            print_warning "  - JWT_SECRET"
            print_warning "  - GMAIL_USER and GMAIL_PASS"
            print_warning "  - HSP_SMS_USERNAME and HSP_SMS_API_KEY"
            print_warning "  - REDIS_URL (optional, for OTP caching)"
        else
            print_warning "Backend .env.example not found. Creating basic .env..."
            create_backend_env_template
        fi
    else
        print_info "Backend .env already exists"
    fi
    
    # Dashboard environment file
    print_step "Configuring dashboard environment..."
    DASHBOARD_ENV="$PROJECT_DIR/apps/dashboard/.env.local"
    
    if [ ! -f "$DASHBOARD_ENV" ]; then
        cat > "$DASHBOARD_ENV" << 'EOF'
# Dashboard Backend Configuration
NEXT_PUBLIC_BACKEND_URL=http://localhost:3000

# Build Configuration
BUILD_STANDALONE=

# Update with your production URL when deploying
EOF
        print_success "Created dashboard .env.local"
        print_warning "Update NEXT_PUBLIC_BACKEND_URL if running backend on different port"
    else
        print_info "Dashboard .env.local already exists"
    fi
}

################################################################################
# Create Backend Env Template
################################################################################

create_backend_env_template() {
    cat > "$PROJECT_DIR/apps/backend/.env" << 'EOF'
# Database - Get credentials from Supabase
DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@your-db.supabase.co:5432/postgres"

# Server Configuration
NODE_ENV=development
PORT=3000
API_URL=http://localhost:3000

# JWT Configuration
JWT_SECRET=your-secret-key-change-this-in-production
JWT_EXPIRY=7d

# Email Configuration (Gmail)
GMAIL_USER=your-email@gmail.com
GMAIL_PASS=your-app-specific-password

# SMS Configuration (HSP Media Network)
HSP_SMS_USERNAME=your_username
HSP_SMS_API_KEY=your_api_key
HSP_SMS_SENDER=AUTOLAB

# Redis Configuration (optional, for OTP caching)
REDIS_URL=redis://localhost:6379

# Frontend URLs (for CORS)
FLUTTER_APP_URL=com.autolab.app
ADMIN_DASHBOARD_URL=http://localhost:3001
PRODUCTION_URL=https://api.autolab.com

# Firebase Configuration (for FCM push notifications - if needed)
FIREBASE_PROJECT_ID=your-firebase-project
FIREBASE_PRIVATE_KEY=your-firebase-key
EOF
    print_success "Created backend .env template"
}

################################################################################
# Prisma Setup
################################################################################

setup_prisma() {
    print_header "Setting Up Prisma ORM"
    
    cd "$PROJECT_DIR/apps/backend"
    
    print_step "Generating Prisma client..."
    npm run prisma:generate
    print_success "Prisma client generated"
    
    print_warning "Database migrations will need to be run with:"
    print_info "  cd apps/backend"
    print_info "  npm run prisma:migrate"
    print_warning "This requires DATABASE_URL to be configured and database to be accessible"
}

################################################################################
# Verification
################################################################################

verify_setup() {
    print_header "Verifying Setup"
    
    cd "$PROJECT_DIR"
    
    # Check root node_modules
    if [ -d "node_modules" ]; then
        print_success "Root node_modules directory exists"
    fi
    
    # Check backend setup
    if [ -d "apps/backend/node_modules" ]; then
        print_success "Backend node_modules directory exists"
    fi
    
    if [ -f "apps/backend/.env" ]; then
        print_success "Backend .env file exists"
    fi
    
    # Check dashboard setup
    if [ -d "apps/dashboard/node_modules" ]; then
        print_success "Dashboard node_modules directory exists"
    fi
    
    if [ -f "apps/dashboard/.env.local" ]; then
        print_success "Dashboard .env.local file exists"
    fi
    
    # Check Prisma
    if [ -f "apps/backend/node_modules/.prisma/client" ] || [ -d "apps/backend/node_modules/.prisma/client" ]; then
        print_success "Prisma client generated"
    fi
}

################################################################################
# Print Quick Start Guide
################################################################################

print_quick_start() {
    print_header "Quick Start Guide"
    
    echo -e "${GREEN}Setup completed successfully!${NC}\n"
    
    echo -e "${YELLOW}IMPORTANT - Next Steps:${NC}"
    echo ""
    echo -e "1. ${BLUE}Configure Environment Variables${NC}"
    echo "   • Backend: Edit apps/backend/.env with your actual credentials"
    echo "   • Dashboard: Edit apps/dashboard/.env.local if needed"
    echo ""
    echo -e "2. ${BLUE}Database Setup${NC}"
    echo "   • Create a PostgreSQL database (Supabase recommended)"
    echo "   • Update DATABASE_URL in apps/backend/.env"
    echo "   • Run: cd apps/backend && npm run prisma:migrate"
    echo ""
    echo -e "3. ${BLUE}Optional - Setup Redis (for OTP caching)${NC}"
    echo "   • Install Redis locally or use a cloud provider"
    echo "   • Update REDIS_URL in apps/backend/.env"
    echo ""
    echo -e "${GREEN}To Start Development:${NC}"
    echo ""
    echo "   # Terminal 1 - Backend API (port 3000)"
    echo "   cd apps/backend"
    echo "   npm run dev"
    echo ""
    echo "   # Terminal 2 - Dashboard (port 3000 or 3001)"
    echo "   cd apps/dashboard"
    echo "   npm run dev"
    echo ""
    echo "   # Terminal 3 - Flutter App (if available)"
    echo "   cd apps/flutter-app"
    echo "   flutter pub get"
    echo "   flutter run"
    echo ""
    echo -e "${BLUE}Useful Commands:${NC}"
    echo "   npm run backend:dev       # Start backend development server"
    echo "   npm run dashboard:dev     # Start dashboard development server"
    echo "   npm run backend:build     # Build backend for production"
    echo "   npm run dashboard:build   # Build dashboard for production"
    echo ""
    echo -e "${YELLOW}Documentation:${NC}"
    echo "   • Read: SETUP_GUIDES/README.md"
    echo "   • Backend: SETUP_GUIDES/04_EXPRESS_BACKEND.md"
    echo "   • Dashboard: SETUP_GUIDES/05_NEXT_JS_DASHBOARD.md"
    echo "   • Database: SETUP_GUIDES/03_SUPABASE_DATABASE.md"
    echo ""
}

################################################################################
# Optional Services Setup Info
################################################################################

print_optional_services() {
    print_header "Optional Services Information"
    
    echo -e "${YELLOW}Redis Setup (for OTP caching):${NC}"
    echo ""
    echo "  Linux (Ubuntu/Debian):"
    echo "    sudo apt-get install redis-server"
    echo "    redis-server  # Start Redis"
    echo ""
    echo "  macOS (with Homebrew):"
    echo "    brew install redis"
    echo "    redis-server  # Start Redis"
    echo ""
    echo "  Docker (any OS):"
    echo "    docker run -d -p 6379:6379 redis:latest"
    echo ""
    echo -e "${YELLOW}PostgreSQL Setup (if not using Supabase):${NC}"
    echo ""
    echo "  Linux (Ubuntu/Debian):"
    echo "    sudo apt-get install postgresql postgresql-contrib"
    echo "    sudo service postgresql start"
    echo ""
    echo "  macOS (with Homebrew):"
    echo "    brew install postgresql"
    echo "    brew services start postgresql"
    echo ""
    echo "  Docker (any OS):"
    echo "    docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=yourpassword postgres"
    echo ""
    echo -e "${GREEN}Recommended:${NC} Use Supabase for Database (it's free and includes PostgreSQL)"
    echo "    Visit: https://supabase.com"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    print_header "AutoLab Monorepo Setup"
    echo "Starting setup process..."
    echo ""
    
    # Execute setup steps
    check_system_requirements
    setup_project
    install_dependencies
    setup_environment
    setup_prisma
    verify_setup
    
    # Print guides
    print_quick_start
    print_optional_services
    
    print_header "Setup Complete! 🎉"
    echo -e "${GREEN}Your AutoLab environment is ready for development.${NC}"
    echo ""
}

# Run main function
main

exit 0
