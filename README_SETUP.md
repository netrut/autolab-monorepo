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

```text
autolab-monorepo/
├── apps/
│   ├── flutter-app/     # Mobile application
│   ├── backend/         # Express API
│   └── admin-dashboard/ # Next.js admin
├── packages/
│   ├── shared-types/    # Shared TypeScript types
│   └── shared-utils/    # Shared utilities
├── docs/                # Documentation
└── .github/workflows/   # CI/CD pipelines
```

## Documentation

- SETUP_GUIDES/README.md - Complete setup guide
- SETUP_GUIDES/00_MONOREPO_STRUCTURE.md - Understand structure
- SETUP_GUIDES/01_WHAT_TO_COPY.md - What to migrate
- SETUP_GUIDES/03_SUPABASE_DATABASE.md - Database setup

## Next Steps

1. Follow SETUP_GUIDES/03_SUPABASE_DATABASE.md for database setup
2. Follow SETUP_GUIDES/04_EXPRESS_BACKEND.md to create backend
3. Follow SETUP_GUIDES/05_NEXT_JS_DASHBOARD.md for admin panel
4. Follow SETUP_GUIDES/06_FLUTTER_FRONTEND.md for mobile app

---

**Status:** 🏗️ Under Construction  
**Last Updated:** April 27, 2026