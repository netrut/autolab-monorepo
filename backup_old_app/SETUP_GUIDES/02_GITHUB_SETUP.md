# 🔧 GITHUB SETUP GUIDE

**Purpose:** Create GitHub repository and set up version control  
**Time:** 20-30 minutes  
**Prerequisites:** GitHub account  
**Next:** 03_SUPABASE_DATABASE.md

---

## 📋 Overview

You'll:
1. Create a new GitHub repository
2. Clone it to your computer
3. Set up monorepo structure
4. Initial commit and push

---

## 🚀 STEP 1: CREATE GITHUB REPOSITORY

### Step 1A: Go to GitHub

1. **Open browser:** https://github.com
2. **Click:** Sign in (use your account)
3. **You should see:** Your dashboard with repositories

---

### Step 1B: Create New Repository

1. **Click:** "+" icon (top right)
2. **Select:** "New repository"

---

### Step 1C: Fill Repository Details

**Form fields to fill:**

```
Repository name:        autolab-monorepo
Description:            Professional AutoLab App - Flutter + Backend + Dashboard
Visibility:             Public (or Private if you prefer)
Initialize with:
  ✅ Add a README file
  ✅ Add .gitignore (select: Node)
  ✅ Choose a license (select: MIT License)
```

**Screenshot reference:**
```
https://github.com/new
```

---

### Step 1D: Create Repository

1. **Click:** "Create repository" button
2. **Wait:** GitHub creates the repo
3. **You'll see:** Repository page with initial files

---

## 📥 STEP 2: CLONE REPOSITORY TO YOUR COMPUTER

### Step 2A: Get Repository URL

1. **On GitHub,** click **"Code"** button (green)
2. **Copy** the URL shown
   - HTTPS: `https://github.com/YOUR_USERNAME/autolab-monorepo.git`
   - SSH: `git@github.com:YOUR_USERNAME/autolab-monorepo.git`

**Which one to use?**
- **HTTPS:** Easier, uses password (recommended for beginners)
- **SSH:** More secure, requires SSH key (advanced)

→ **Use HTTPS for now**

---

### Step 2B: Open Terminal and Clone

**On Mac/Linux:**

```bash
# Open Terminal

# Navigate to where you want the project
cd ~/Documents

# Clone the repository
git clone https://github.com/YOUR_USERNAME/autolab-monorepo.git

# Go into the folder
cd autolab-monorepo

# You should see these files:
# - README.md
# - .gitignore
# - LICENSE
```

**On Windows:**

```bash
# Open Command Prompt (or PowerShell)

# Navigate to Documents
cd Documents

# Clone repository
git clone https://github.com/YOUR_USERNAME/autolab-monorepo.git

# Enter folder
cd autolab-monorepo
```

---

## 🏗️ STEP 3: CREATE MONOREPO FOLDER STRUCTURE

### Step 3A: Create Main Folders

From inside `autolab-monorepo/` folder:

```bash
# Create main folders
mkdir -p apps/flutter-app
mkdir -p apps/backend
mkdir -p apps/admin-dashboard
mkdir -p packages/shared-types
mkdir -p packages/shared-utils
mkdir -p docs
mkdir -p .github/workflows
mkdir -p config

# Verify structure
ls -la

# You should see:
# - apps/
# - packages/
# - docs/
# - .github/
# - config/
# - README.md
# - .gitignore
# - LICENSE
```

---

### Step 3B: Create Package.json for Root

Create file: `package.json`

```bash
# Using terminal
cat > package.json << 'EOF'
{
  "name": "autolab-monorepo",
  "version": "1.0.0",
  "description": "Professional AutoLab Application - Flutter + Backend + Dashboard",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "install-all": "pnpm install",
    "backend:dev": "cd apps/backend && npm run dev",
    "backend:build": "cd apps/backend && npm run build",
    "dashboard:dev": "cd apps/admin-dashboard && npm run dev",
    "dashboard:build": "cd apps/admin-dashboard && npm run build",
    "flutter:run": "cd apps/flutter-app && flutter pub get && flutter run",
    "flutter:build": "cd apps/flutter-app && flutter build apk"
  },
  "keywords": [
    "flutter",
    "backend",
    "dashboard",
    "monorepo"
  ],
  "author": "Your Name",
  "license": "MIT"
}
EOF
```

---

### Step 3C: Create .gitignore Updates

The `.gitignore` already exists, but add these lines:

```bash
# Open .gitignore and add these lines:

# Environment files
.env
.env.local
.env.*.local
.env.production.local

# Dependencies
node_modules/
yarn.lock
pnpm-lock.yaml
package-lock.json

# Build outputs
dist/
build/
.next/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*

# Firebase
serviceAccountKey.json
*.key.json

# Flutter
.flutter-plugins
.packages
.dart_tool/
flutter_export_environment.sh

# Prisma
.prisma/
```

---

### Step 3D: Create README for Root

```bash
cat > README_SETUP.md << 'EOF'
# 🚀 AutoLab Monorepo - Setup Instructions

This is a monorepo containing:
- 📱 Flutter mobile app
- 💻 Node.js/Express backend API
- 📊 Next.js admin dashboard

## Quick Start

```bash
# Install dependencies
pnpm install

# Start backend (Terminal 1)
npm run backend:dev

# Start dashboard (Terminal 2)
npm run dashboard:dev

# Start Flutter (Terminal 3)
npm run flutter:run
```

## Folder Structure

```
autolab-monorepo/
├── apps/
│   ├── flutter-app/    # Mobile application
│   ├── backend/        # Express API
│   └── admin-dashboard/ # Next.js admin
├── packages/
│   ├── shared-types/   # Shared TypeScript types
│   └── shared-utils/   # Shared utilities
├── docs/               # Documentation
└── .github/workflows/  # CI/CD pipelines
```

## Documentation

- `SETUP_GUIDES/README.md` - Complete setup guide
- `SETUP_GUIDES/00_MONOREPO_STRUCTURE.md` - Understand structure
- `SETUP_GUIDES/01_WHAT_TO_COPY.md` - What to migrate
- `SETUP_GUIDES/03_SUPABASE_DATABASE.md` - Database setup

## Next Steps

1. Follow `SETUP_GUIDES/03_SUPABASE_DATABASE.md` for database setup
2. Follow `SETUP_GUIDES/04_EXPRESS_BACKEND.md` to create backend
3. Follow `SETUP_GUIDES/05_NEXT_JS_DASHBOARD.md` for admin panel
4. Follow `SETUP_GUIDES/06_FLUTTER_FRONTEND.md` for mobile app

---

**Status:** 🏗️ Under Construction  
**Last Updated:** April 27, 2026
EOF
```

---

## 📝 STEP 4: INITIAL COMMIT AND PUSH

### Step 4A: Stage Files

```bash
# Check what changed
git status

# You should see:
# - New folders (apps/, packages/, etc.)
# - Modified: .gitignore
# - New: package.json
# - New: README_SETUP.md
```

---

### Step 4B: Add Files to Git

```bash
# Add all new files
git add .

# Verify staged files
git status

# You should see green "A" (Added) marks
```

---

### Step 4C: Commit

```bash
# Create commit message
git commit -m "Initial monorepo setup with folder structure"

# You should see:
# [main xxxxx] Initial monorepo setup...
# X files changed, X insertions(+)
```

---

### Step 4D: Push to GitHub

```bash
# Push to GitHub
git push origin main

# You should see:
# Enumerating objects...
# Compressing objects...
# Writing objects...
# remote: Processing hooks...
```

---

### Step 4E: Verify on GitHub

1. **Go to:** https://github.com/YOUR_USERNAME/autolab-monorepo
2. **You should see:**
   - Folder structure (apps/, packages/, docs/, etc.)
   - `package.json` file
   - `.gitignore` file
   - `README.md` from GitHub initialization

✅ **Congratulations! Your monorepo is on GitHub!**

---

## 🔑 STEP 5: CONFIGURE GIT (FIRST TIME ONLY)

If you haven't configured Git before:

```bash
# Set your name
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your@email.com"

# Verify configuration
git config --global --list
```

---

## 🔐 STEP 6: OPTIONAL - SETUP SSH KEY (For security)

If you want to use SSH instead of HTTPS:

### Step 6A: Generate SSH Key

```bash
# Mac/Linux
ssh-keygen -t ed25519 -C "your@email.com"

# Press Enter for default file location
# Press Enter for no passphrase (or enter one)

# You'll see:
# Your identification has been saved in ~/.ssh/id_ed25519
```

---

### Step 6B: Add SSH Key to GitHub

1. **Copy SSH key:**
```bash
# Mac
pbcopy < ~/.ssh/id_ed25519.pub

# Linux
cat ~/.ssh/id_ed25519.pub
```

2. **Go to GitHub:** Settings → SSH and GPG keys
3. **Click:** "New SSH key"
4. **Paste** your key and click "Add SSH key"

---

### Step 6C: Update Remote URL (Optional)

```bash
# If you want to switch to SSH
git remote set-url origin git@github.com:YOUR_USERNAME/autolab-monorepo.git

# Verify
git remote -v
```

---

## 📋 GIT WORKFLOW FOR FUTURE

### Daily Commit Pattern

```bash
# 1. Make changes
# 2. Check status
git status

# 3. Add changes
git add .

# 4. Commit with message
git commit -m "Feature: Add user authentication"

# 5. Push to GitHub
git push origin main

# 6. Create Pull Request (if in team)
# 7. Merge to main
```

### Branch Strategy (For Team)

```bash
# Create feature branch
git checkout -b feature/user-auth

# Make changes and commit
git commit -m "Add user authentication"

# Push branch to GitHub
git push origin feature/user-auth

# Create Pull Request on GitHub
# Get review from team
# Merge to main
```

---

## ✅ VERIFICATION CHECKLIST

- [ ] GitHub account created
- [ ] Repository created: `autolab-monorepo`
- [ ] Repository cloned to your computer
- [ ] Folder structure created:
  - [ ] `apps/flutter-app/`
  - [ ] `apps/backend/`
  - [ ] `apps/admin-dashboard/`
  - [ ] `packages/shared-types/`
  - [ ] `packages/shared-utils/`
  - [ ] `docs/`
  - [ ] `.github/workflows/`
- [ ] `package.json` created
- [ ] `.gitignore` updated
- [ ] Initial commit made
- [ ] Pushed to GitHub successfully
- [ ] Repository visible on GitHub.com

---

## 🚀 Next Steps

✅ You now have GitHub repository set up!

**Now it's time to set up the database.**

→ **Next:** `03_SUPABASE_DATABASE.md`

---

## 📞 Troubleshooting

### "git: command not found"
- Install Git from: https://git-scm.com/
- Restart terminal after installation

### "fatal: Authentication failed"
- Check username and password
- Or use SSH key instead of HTTPS

### "Permission denied (publickey)"
- SSH key issue
- Either add SSH key to GitHub, or use HTTPS instead

### "already exists and is not an empty directory"
- Folder already exists
- Delete it or use different name
- Then clone again

---

## 📚 Git Resources

- Git documentation: https://git-scm.com/doc
- GitHub documentation: https://docs.github.com/
- Git cheat sheet: https://git-scm.com/cheatsheet

---

**Last Updated:** April 27, 2026  
**Time:** 20-30 minutes  
**Next file:** 03_SUPABASE_DATABASE.md

→ Continue to set up Supabase database
