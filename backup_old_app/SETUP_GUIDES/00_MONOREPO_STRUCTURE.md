# 🏗️ MONOREPO STRUCTURE GUIDE

**Purpose:** Understand the folder layout for the complete AutoLab application  
**Time:** 10-15 minutes to read  
**Next:** 01_WHAT_TO_COPY.md

---

## 📁 Why Monorepo?

A monorepo (single repository with multiple apps) is best for:
- ✅ Shared code between apps
- ✅ Consistent versioning
- ✅ Easier dependency management
- ✅ Single CI/CD pipeline
- ✅ Team coordination
- ✅ Professional setup

---

## 🎯 Complete Directory Structure

```
autolab-monorepo/                          (Root folder)
│
├── 📂 apps/                                (All applications)
│   ├── 📱 flutter-app/                     (Mobile application)
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app_state.dart
│   │   │   ├── auth/
│   │   │   ├── pages/
│   │   │   ├── components/
│   │   │   └── backend/
│   │   ├── assets/
│   │   ├── android/
│   │   ├── ios/
│   │   ├── web/
│   │   ├── pubspec.yaml
│   │   └── README.md
│   │
│   ├── 💻 backend/                        (Node.js/Express API)
│   │   ├── src/
│   │   │   ├── index.ts                   (Main entry point - combine all APIs)
│   │   │   ├── server.ts
│   │   │   ├── routes/
│   │   │   │   ├── index.ts               (Main routes file - export all routes)
│   │   │   │   ├── auth.ts
│   │   │   │   ├── users.ts
│   │   │   │   ├── vehicles.ts
│   │   │   │   ├── services.ts
│   │   │   │   └── bookings.ts
│   │   │   ├── controllers/
│   │   │   │   ├── index.ts               (Export all controllers)
│   │   │   │   ├── authController.ts
│   │   │   │   ├── userController.ts
│   │   │   │   └── ...
│   │   │   ├── middleware/
│   │   │   │   ├── index.ts               (Export all middleware)
│   │   │   │   ├── auth.ts
│   │   │   │   ├── errorHandler.ts
│   │   │   │   └── validation.ts
│   │   │   ├── services/
│   │   │   │   ├── index.ts               (Export all services)
│   │   │   │   ├── emailService.ts
│   │   │   │   └── fcmService.ts
│   │   │   └── utils/
│   │   ├── prisma/
│   │   │   ├── schema.prisma              (Database schema - 6 models)
│   │   │   ├── seed.ts                    (Test data)
│   │   │   └── migrations/
│   │   ├── tests/
│   │   ├── .env                           (Secrets - NOT in Git)
│   │   ├── .env.example                   (Template for team)
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── .gitignore
│   │   └── README.md
│   │
│   └── 📊 admin-dashboard/                (Next.js Admin Panel)
│       ├── app/
│       │   ├── layout.tsx
│       │   ├── page.tsx
│       │   ├── dashboard/
│       │   ├── users/
│       │   ├── services/
│       │   ├── analytics/
│       │   └── settings/
│       ├── components/
│       │   ├── ui/
│       │   ├── forms/
│       │   └── charts/
│       ├── lib/
│       ├── public/
│       ├── .env.local
│       ├── .env.example
│       ├── package.json
│       ├── tsconfig.json
│       ├── next.config.js
│       ├── tailwind.config.js
│       ├── .gitignore
│       └── README.md
│
├── 📂 packages/                            (Shared code)
│   ├── shared-types/
│   │   ├── src/
│   │   │   ├── api.ts                     (API response types)
│   │   │   ├── models.ts                  (Database models)
│   │   │   └── constants.ts               (Shared constants)
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── shared-utils/
│       ├── src/
│       │   ├── formatters.ts
│       │   ├── validators.ts
│       │   └── helpers.ts
│       ├── package.json
│       └── tsconfig.json
│
├── 📂 docs/                                (Documentation)
│   ├── API.md                             (API endpoint documentation)
│   ├── DATABASE.md                        (Database schema docs)
│   ├── DEPLOYMENT.md                      (Deployment instructions)
│   ├── ARCHITECTURE.md                    (System architecture)
│   └── CONTRIBUTING.md                    (For team members)
│
├── 📂 .github/
│   └── workflows/
│       ├── backend-tests.yml              (Test backend)
│       ├── backend-deploy.yml             (Deploy to Vercel)
│       ├── dashboard-deploy.yml           (Deploy admin panel)
│       └── mobile-build.yml               (Build Flutter)
│
├── 📂 config/                             (Shared configuration)
│   ├── docker-compose.yml                 (Local dev environment)
│   ├── environment.example.json           (Config template)
│   └── .env.example                       (All env vars)
│
├── 🔧 Root Files
│   ├── package.json                       (Monorepo root)
│   ├── pnpm-workspace.yaml               (PNPM workspaces)
│   ├── .gitignore                        (Git ignore rules)
│   ├── .prettierrc                       (Code formatting)
│   ├── .eslintrc                         (Linting rules)
│   ├── README.md                         (Main project readme)
│   ├── LICENSE
│   ├── CHANGELOG.md
│   └── VERSION                           (Version: 1.0.0)
```

---

## 📊 File Breakdown

### Apps Folder (3 Applications)

#### 1. **Flutter App** (`apps/flutter-app/`)
**What:** Mobile application for users
**Technology:** Flutter + Dart
**Size:** ~500 KB (APK)
**Runs on:** Android, iOS, Web
**Key files:**
- `lib/main.dart` - Entry point
- `pubspec.yaml` - Dependencies
- `lib/auth/` - Login/registration
- `lib/pages/` - Screens
- `lib/backend/` - API client

**Connects to:** Express backend API

#### 2. **Express Backend** (`apps/backend/`)
**What:** REST API server
**Technology:** Node.js + Express + Prisma
**Size:** ~50 MB (with node_modules)
**Runs on:** Vercel (serverless)
**Key files:**
- `src/index.ts` - Main entry point (combine all APIs)
- `src/server.ts` - Express server configuration
- `src/routes/index.ts` - Main routes file (export all routes)
- `src/routes/auth.ts`, `users.ts`, `vehicles.ts` - Individual API routes
- `src/controllers/index.ts` - Export all controllers
- `src/middleware/index.ts` - Export all middleware
- `src/services/index.ts` - Export all services
- `prisma/schema.prisma` - Database schema
- `package.json` - Dependencies
- `.env` - Secrets (passwords, keys)

**Connects to:** Supabase PostgreSQL, Firebase (optional)

**Index Files Explanation:**
- **src/index.ts** - Creates the Express app and combines all routes/middleware
- **src/routes/index.ts** - Exports all route modules (auth, users, vehicles, etc.)
- **src/controllers/index.ts** - Central export point for all controller functions
- **src/middleware/index.ts** - Central export point for all middleware functions
- **src/services/index.ts** - Central export point for all service modules

#### 3. **Admin Dashboard** (`apps/admin-dashboard/`)
**What:** Web interface for admins
**Technology:** Next.js 14 + React + TypeScript
**Size:** ~30 MB (with node_modules)
**Runs on:** Vercel (serverless)
**Key files:**
- `app/layout.tsx` - Layout
- `app/dashboard/` - Dashboard pages
- `app/api/route.ts` - Internal API routes
- `package.json` - Dependencies
- `.env.local` - Secrets

**Connects to:** Express backend API

---

---

## 📁 Backend Index Files Architecture

### Purpose of Index Files

Index files (`index.ts`) in each backend folder organize and centralize exports, making it easy to:
- ✅ Manage multiple APIs in one place
- ✅ Keep imports clean throughout the app
- ✅ Add/remove routes/controllers/middleware easily
- ✅ Maintain consistent structure

### Example: How Index Files Work

#### 1. **src/index.ts** - Main Entry Point
```typescript
import express from 'express';
import { authRoutes, userRoutes, vehicleRoutes, serviceRoutes, bookingRoutes } from './routes';
import { authMiddleware, errorHandler } from './middleware';

const app = express();

// Global middleware
app.use(express.json());
app.use(authMiddleware);

// All routes combined in one place
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/vehicles', vehicleRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/bookings', bookingRoutes);

// Error handling
app.use(errorHandler);

export default app;
```

#### 2. **src/routes/index.ts** - Combine All Routes
```typescript
export { authRoutes } from './auth';
export { userRoutes } from './users';
export { vehicleRoutes } from './vehicles';
export { serviceRoutes } from './services';
export { bookingRoutes } from './bookings';
```

#### 3. **src/routes/auth.ts** - Individual Route Module
```typescript
import express from 'express';
import { loginController, registerController } from '../controllers';

export const authRoutes = express.Router();

authRoutes.post('/login', loginController);
authRoutes.post('/register', registerController);
```

#### 4. **src/controllers/index.ts** - Export All Controllers
```typescript
export { loginController, registerController } from './authController';
export { getUserController, updateUserController } from './userController';
export { getVehiclesController, createVehicleController } from './vehicleController';
// ... more controllers
```

#### 5. **src/middleware/index.ts** - Export All Middleware
```typescript
export { authMiddleware } from './auth';
export { errorHandler } from './errorHandler';
export { validateRequest } from './validation';
```

#### 6. **src/services/index.ts** - Export All Services
```typescript
export { EmailService } from './emailService';
export { FCMService } from './fcmService';
export { UserService } from './userService';
```

### Benefits of This Structure

| Feature | Benefit |
|---------|---------|
| **Centralized Exports** | Easy to see all available functions/routes |
| **Scalable** | Add new route/controller/service easily |
| **Maintainable** | Changes in one place ripple through |
| **Clean Imports** | Instead of `../../../controllers/authController`, use `../../controllers` |
| **Team-Friendly** | New developers see structure at a glance |

### Adding New API

To add a new API (e.g., `ratings`):

**Step 1:** Create `src/routes/ratings.ts`
```typescript
import express from 'express';
import { getRatingsController, createRatingController } from '../controllers';

export const ratingRoutes = express.Router();
ratingRoutes.get('/', getRatingsController);
ratingRoutes.post('/', createRatingController);
```

**Step 2:** Update `src/routes/index.ts`
```typescript
export { ratingRoutes } from './ratings';  // Add this line
```

**Step 3:** Update `src/index.ts`
```typescript
app.use('/api/ratings', ratingRoutes);  // Add this line
```

That's it! No other changes needed.

---

#### 1. **Shared Types** (`packages/shared-types/`)
**Purpose:** TypeScript types used in multiple apps
**Example:**
```typescript
// User interface
export interface User {
  id: string;
  email: string;
  roleId: 1 | 2; // 1=admin, 2=customer
}

// API response
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message: string;
}
```

**Used by:** Backend, Dashboard, Flutter (JSON parsing)

#### 2. **Shared Utils** (`packages/shared-utils/`)
**Purpose:** Helper functions for all apps
**Example:**
- `formatDate()` - Format dates consistently
- `validateEmail()` - Email validation
- `calculateDistance()` - Distance calculation

---

### Workflows Folder (CI/CD)

#### GitHub Actions Pipelines
```yaml
backend-tests.yml      → Run tests on every commit
backend-deploy.yml     → Deploy to Vercel automatically
dashboard-deploy.yml   → Deploy dashboard on commit
mobile-build.yml       → Build Flutter APK/IPA
```

---

## 🔄 How Apps Connect

```
┌─────────────────────────────────────────┐
│        Flutter Mobile App (Users)       │
│        (Running on Android/iOS)         │
└────────────────┬────────────────────────┘
                 │
                 │ HTTP Requests
                 │ (REST API calls)
                 ↓
┌─────────────────────────────────────────┐
│   Express Backend (API Server)          │
│   (Running on Vercel - Serverless)      │
└────────────────┬────────────────────────┘
                 │
                 │ SQL Queries
                 │ (Prisma ORM)
                 ↓
┌─────────────────────────────────────────┐
│  PostgreSQL Database (Supabase)         │
│  (6 tables: users, vehicles, services)  │
└─────────────────────────────────────────┘

                 Also:
┌─────────────────────────────────────────┐
│  Next.js Admin Dashboard (Web)          │
│  (Running on Vercel - Serverless)       │
└────────────────┬────────────────────────┘
                 │
                 │ HTTP Requests
                 │ (REST API calls)
                 ↓
            (Same Express Backend)
```

---

## 🚀 Development Workflow

### Local Development (Your Computer)

```bash
# 1. Clone repo
git clone <repo-url>
cd autolab-monorepo

# 2. Install all dependencies
pnpm install

# 3. Start services
docker-compose up -d            # Start PostgreSQL locally (optional)

# 4. Start backend
cd apps/backend
npm run dev                      # Runs on http://localhost:3000

# 5. In new terminal, start dashboard
cd apps/admin-dashboard
npm run dev                      # Runs on http://localhost:3001

# 6. In new terminal, start Flutter
cd apps/flutter-app
flutter pub get
flutter run -d chrome          # Run on web/mobile emulator
```

### Production Deployment (Cloud)

```bash
# 1. Push to GitHub
git push origin main

# 2. GitHub Actions automatically:
#    - Tests backend
#    - Deploys backend to Vercel
#    - Deploys dashboard to Vercel

# 3. Flutter app:
#    - Build locally: flutter build apk
#    - Upload to Google Play Store manually
```

---

## 📊 Technology Stack Overview

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Mobile** | Flutter + Dart | iOS & Android app |
| **Web Admin** | Next.js + React | Admin dashboard |
| **API** | Express.js | REST API server |
| **Database** | PostgreSQL | Data storage |
| **ORM** | Prisma | Database queries |
| **Auth** | Firebase (or custom) | User authentication |
| **Hosting** | Vercel | Serverless deployment |
| **Git** | GitHub | Version control |
| **CI/CD** | GitHub Actions | Automated testing/deploy |

---

## 🔐 Environment Variables

Each app has its own `.env` file:

```
apps/backend/.env
├── DATABASE_URL           → Supabase connection
├── JWT_SECRET            → Token signing key
├── FIREBASE_KEY          → Firebase service account
├── API_PORT              → Server port (3000)
└── NODE_ENV              → dev/production

apps/admin-dashboard/.env.local
├── NEXT_PUBLIC_API_URL   → Backend URL
├── DATABASE_URL          → (optional, if using DB)
├── NEXTAUTH_SECRET       → Auth signing key
└── NEXTAUTH_URL          → Dashboard URL

apps/flutter-app/
└── No .env (uses hardcoded API URL from backend)
```

---

## 📈 Scalability

This structure is built to scale:

✅ **Easy to add more apps** (e.g., Admin Mobile App)  
✅ **Shared packages** reduce duplication  
✅ **Microservices ready** (can split apps later)  
✅ **Multi-team ready** (each team owns their app)  
✅ **Monorepo tools** (pnpm workspaces, Turborepo)  

---

## 🎯 Best Practices Included

### 1. **Separation of Concerns**
- Each app has its own folder
- Shared code in `packages/`
- Clear responsibility boundaries

### 2. **Type Safety**
- TypeScript everywhere
- Shared types in `packages/shared-types/`
- Prisma generates database types

### 3. **Environment Management**
- `.env` for secrets (never in Git)
- `.env.example` for team template
- Different configs per environment

### 4. **Version Control**
- `.gitignore` to exclude node_modules, .env, dist
- Git workflows for collaboration
- Clean commit history

### 5. **Testing**
- Tests folder for each app
- GitHub Actions CI pipeline
- Automated testing on every commit

### 6. **Documentation**
- README in each app folder
- API documentation
- Database schema docs
- Architecture diagrams

---

## 📋 Comparison: Monorepo vs Multi-Repo

| Aspect | Monorepo | Multi-Repo |
|--------|----------|-----------|
| **Setup time** | 1 week | 3 weeks |
| **Code sharing** | ✅ Easy | ❌ Complex |
| **Version control** | ✅ Single | ❌ Multiple |
| **CI/CD** | ✅ Unified | ❌ Separate |
| **Team coordination** | ✅ Easy | ❌ Hard |
| **Deployment** | ✅ Coordinated | ❌ Independent |
| **Learning curve** | ⚠️ Medium | ✅ Easy |

**Winner for this project:** ✅ **Monorepo** (best practice)

---

## ✅ Verification Checklist

After setup, verify structure:

- [ ] `apps/flutter-app/` exists with full Flutter project
- [ ] `apps/backend/` exists with Express/Prisma
- [ ] `apps/admin-dashboard/` exists with Next.js
- [ ] `packages/shared-types/` exists with TS types
- [ ] `.github/workflows/` exists with CI/CD
- [ ] `.gitignore` includes `.env` and `node_modules`
- [ ] `README.md` explains the structure
- [ ] All `package.json` files reference correct paths
- [ ] No circular dependencies between apps
- [ ] Each app has its own `.env.example`

---

## 🎯 Next Steps

✅ You now understand the monorepo structure!

→ **Next:** `01_WHAT_TO_COPY.md` (What to extract from current codebase)

---

## 📞 Key Takeaways

1. **Monorepo = 3 apps in 1 repository** (Flutter, Backend, Dashboard)
2. **Apps communicate via REST API** (Express backend)
3. **Shared code in packages/** (types, utils)
4. **CI/CD automated** (GitHub Actions)
5. **Deployed on Vercel** (Next.js & Express)
6. **Database on Supabase** (PostgreSQL)

**This is professional, scalable, and production-ready!** 🚀

---

**Last Updated:** April 27, 2026  
**Time to read:** 10-15 minutes  
**Next file:** 01_WHAT_TO_COPY.md

→ Continue to learn what to extract from your current codebase
