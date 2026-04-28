# 📊 NEXT.JS ADMIN DASHBOARD SETUP - shadcn/ui Edition

**Purpose:** Build modern admin dashboard with Next.js App Router + shadcn/ui  
**Time:** 2-3 days of coding  
**Complexity:** Intermediate  
**Tech:** Next.js 14+, React 18+, TypeScript, App Router, Tailwind CSS, shadcn/ui  
**Base:** kiranism/next-shadcn-dashboard-starter  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Build

A professional admin dashboard with:

- ✅ **App Router** (Modern, not deprecated Pages Router)
- ✅ **Server Components** (Better performance)
- ✅ **Route Groups** (Organized structure)
- ✅ **Protected Routes** (Authentication required)
- ✅ **Middleware** (Auth checks)
- ✅ **User Management** (CRUD dashboard)
- ✅ **Analytics** (Charts and metrics)
- ✅ **Vehicle Management** (Display all vehicles)
- ✅ **Service Management** (Service listings)
- ✅ **Booking Management** (Booking overview)
- ✅ **Dark Mode** (Toggle theme)
- ✅ **Responsive Design** (Mobile-friendly)
- ✅ **API Integration** (Call backend independently)

---

## 📋 Prerequisites

Before starting:

- ✅ Node.js 18+ installed
- ✅ npm or pnpm installed
- ✅ Express backend running (from 04_EXPRESS_BACKEND.md)
- ✅ Backend API URL ready
- ✅ GitHub repo created
- ✅ Read: ARCHITECTURE_CLARIFICATIONS.md (App Router, independent apps)

---

## 🚀 PROJECT SETUP

### Step 1: Create Admin Dashboard with Next.js

```bash
cd /path/to/autolab-monorepo/apps
npx create-next-app@latest admin-dashboard \
  --typescript \
  --eslint \
  --tailwind \
  --app \
  --src-dir \
  --no-git

cd admin-dashboard
```

Answer prompts:
```
✔ Would you like to use TypeScript with this project? › Yes
✔ Would you like to use ESLint? › Yes
✔ Would you like to use Tailwind CSS for styling? › Yes
✔ Would you like your code inside a `src/` directory? › Yes
✔ Would you like to use App Router? › Yes (IMPORTANT!)
✔ Would you like to use Turbopack for next dev? › No
✔ Would you like to customize the import alias? › No
```

### Step 2: Project Structure

```
admin-dashboard/
├── src/
│   ├── app/
│   │   ├── layout.tsx              (Root layout)
│   │   ├── page.tsx                (Home/Redirect)
│   │   ├── error.tsx               (Error boundary)
│   │   ├── not-found.tsx           (404 page)
│   │   │
│   │   ├── (auth)/                 (Route group: Auth pages)
│   │   │   ├── layout.tsx          (Auth layout - no sidebar)
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   └── register/
│   │   │       └── page.tsx
│   │   │
│   │   └── (dashboard)/             (Route group: Protected pages)
│   │       ├── layout.tsx           (Dashboard layout with sidebar)
│   │       ├── page.tsx             (Dashboard home)
│   │       ├── dashboard/
│   │       │   ├── page.tsx         (Analytics dashboard)
│   │       │   └── layout.tsx
│   │       ├── users/
│   │       │   ├── page.tsx         (Users list)
│   │       │   ├── [id]/
│   │       │   │   └── page.tsx     (User details)
│   │       │   └── layout.tsx
│   │       ├── vehicles/
│   │       │   ├── page.tsx         (Vehicles list)
│   │       │   └── [id]/
│   │       │       └── page.tsx
│   │       ├── services/
│   │       │   ├── page.tsx
│   │       │   └── [id]/
│   │       │       └── page.tsx
│   │       ├── bookings/
│   │       │   ├── page.tsx
│   │       │   └── [id]/
│   │       │       └── page.tsx
│   │       ├── analytics/
│   │       │   └── page.tsx
│   │       └── settings/
│   │           └── page.tsx
│   │
│   ├── components/
│   │   ├── ui/                     (Reusable components)
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Modal.tsx
│   │   │   └── Table.tsx
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   ├── Header.tsx
│   │   │   ├── Footer.tsx
│   │   │   └── Navigation.tsx
│   │   ├── forms/
│   │   │   ├── LoginForm.tsx
│   │   │   ├── UserForm.tsx
│   │   │   └── ServiceForm.tsx
│   │   └── dashboard/
│   │       ├── StatCard.tsx
│   │       ├── Chart.tsx
│   │       ├── RecentUsers.tsx
│   │       └── UsersList.tsx
│   │
│   ├── lib/
│   │   ├── api.ts                  (API client)
│   │   ├── auth.ts                 (Auth utilities)
│   │   ├── constants.ts
│   │   └── utils.ts
│   │
│   ├── hooks/
│   │   ├── useAuth.ts              (Auth hook)
│   │   ├── useApi.ts               (API hook)
│   │   └── useTheme.ts             (Theme hook)
│   │
│   ├── types/
│   │   ├── index.ts                (Type definitions)
│   │   ├── api.ts                  (API response types)
│   │   └── user.ts
│   │
│   ├── styles/
│   │   ├── globals.css
│   │   └── variables.css
│   │
│   └── middleware.ts               (Next.js middleware for auth)
│
├── public/
├── .env.local                      (Local config)
├── .env.example                    (Template in Git)
├── package.json
├── tsconfig.json
├── next.config.js
├── tailwind.config.ts
├── postcss.config.js
├── .gitignore
├── .eslintrc.json
├── README.md
└── prettier.config.js
```

### Step 3: Install Additional Dependencies

```bash
npm install axios zustand clsx tailwind-merge recharts next-themes js-cookie
```

Explanation:
- `axios` - HTTP client for API calls
- `zustand` - State management (lightweight)
- `clsx` - Conditional class names
- `tailwind-merge` - Merge Tailwind classes
- `recharts` - Chart library
- `next-themes` - Dark mode support
- `js-cookie` - Cookie management

### Step 4: Environment Variables

Create `.env.example`:

```bash
# Backend API
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=AutoLab Admin

# Admin dashboard settings
NEXT_PUBLIC_ITEMS_PER_PAGE=10
NEXT_PUBLIC_THEME=light

# For Vercel deployment
VERCEL_URL=
```

Copy to `.env.local`:

```bash
cp .env.example .env.local
# Edit .env.local with your values
```

---

## 🏗️ STEP-BY-STEP IMPLEMENTATION

### STEP 1: Create Root Layout

Create `src/app/layout.tsx`:

```typescript
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Providers } from '@/components/providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'AutoLab Admin Dashboard',
  description: 'Manage your vehicle services efficiently',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### STEP 2: Create Providers Component

Create `src/components/providers.tsx`:

```typescript
'use client';

import { ThemeProvider } from 'next-themes';
import React from 'react';

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="light" enableSystem>
      {children}
    </ThemeProvider>
  );
}
```

### STEP 3: Create Auth Middleware

Create `src/middleware.ts`:

```typescript
import { NextRequest, NextResponse } from 'next/server';

// Public routes that don't need authentication
const publicRoutes = ['/login', '/register', '/forgot-password'];

export function middleware(request: NextRequest) {
  const token = request.cookies.get('auth-token')?.value;
  const { pathname } = request.nextUrl;

  // If no token and trying to access protected route
  if (!token && !publicRoutes.includes(pathname)) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // If has token and trying to access auth routes
  if (token && publicRoutes.includes(pathname)) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
};
```

### STEP 4: Create API Client

Create `src/lib/api.ts`:

```typescript
import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to every request
apiClient.interceptors.request.use((config) => {
  const token = typeof window !== 'undefined' 
    ? localStorage.getItem('auth-token')
    : null;

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

// Handle 401 responses
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Clear token and redirect to login
      if (typeof window !== 'undefined') {
        localStorage.removeItem('auth-token');
        localStorage.removeItem('user');
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

### STEP 5: Create Login Page

Create `src/app/(auth)/login/page.tsx`:

```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import apiClient from '@/lib/api';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await apiClient.post('/api/auth/login', {
        email,
        password,
      });

      const { token, user } = response.data;

      // Save token and user info
      localStorage.setItem('auth-token', token);
      localStorage.setItem('user', JSON.stringify(user));

      // Redirect to dashboard
      router.push('/dashboard');
    } catch (err: any) {
      setError(err.response?.data?.error || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full bg-white p-8 rounded-lg shadow">
        <h1 className="text-2xl font-bold mb-6 text-center">
          AutoLab Admin
        </h1>

        {error && (
          <div className="bg-red-50 text-red-600 p-3 rounded mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleLogin}>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
              required
            />
          </div>

          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700">
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>

        <p className="mt-4 text-center text-sm text-gray-600">
          <Link href="/forgot-password" className="text-blue-600 hover:underline">
            Forgot password?
          </Link>
        </p>
      </div>
    </div>
  );
}
```

### STEP 6: Create Dashboard Layout

Create `src/app/(dashboard)/layout.tsx`:

```typescript
'use client';

import { ReactNode } from 'react';
import Sidebar from '@/components/layout/Sidebar';
import Header from '@/components/layout/Header';

export default function DashboardLayout({ children }: { children: ReactNode }) {
  return (
    <div className="flex h-screen bg-gray-100">
      {/* Sidebar */}
      <Sidebar />

      {/* Main content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <Header />

        {/* Page content */}
        <main className="flex-1 overflow-auto p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

### STEP 7: Create Sidebar Component

Create `src/components/layout/Sidebar.tsx`:

```typescript
'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  BarChart3,
  Users,
  Car,
  Wrench,
  Calendar,
  Settings,
} from 'lucide-react';

const menuItems = [
  { href: '/dashboard', icon: BarChart3, label: 'Dashboard' },
  { href: '/users', icon: Users, label: 'Users' },
  { href: '/vehicles', icon: Car, label: 'Vehicles' },
  { href: '/services', icon: Wrench, label: 'Services' },
  { href: '/bookings', icon: Calendar, label: 'Bookings' },
  { href: '/settings', icon: Settings, label: 'Settings' },
];

export default function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="w-64 bg-gray-900 text-white flex flex-col">
      {/* Logo */}
      <div className="p-6 border-b border-gray-800">
        <h2 className="text-2xl font-bold">AutoLab</h2>
        <p className="text-gray-400 text-sm">Admin Dashboard</p>
      </div>

      {/* Menu */}
      <nav className="flex-1 px-3 py-6 space-y-2">
        {menuItems.map((item) => {
          const Icon = item.icon;
          const isActive = pathname.startsWith(item.href);

          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg transition ${
                isActive
                  ? 'bg-blue-600'
                  : 'text-gray-300 hover:bg-gray-800'
              }`}
            >
              <Icon size={20} />
              <span>{item.label}</span>
            </Link>
          );
        })}
      </nav>

      {/* Footer */}
      <div className="p-6 border-t border-gray-800">
        <p className="text-gray-400 text-sm">© 2024 AutoLab</p>
      </div>
    </aside>
  );
}
```

### STEP 8: Create Header Component

Create `src/components/layout/Header.tsx`:

```typescript
'use client';

import { useRouter } from 'next/navigation';
import { useState, useEffect } from 'react';
import { LogOut, User } from 'lucide-react';

export default function Header() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [showMenu, setShowMenu] = useState(false);

  useEffect(() => {
    // Get user from localStorage
    const userData = localStorage.getItem('user');
    if (userData) {
      setUser(JSON.parse(userData));
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('auth-token');
    localStorage.removeItem('user');
    router.push('/login');
  };

  return (
    <header className="bg-white border-b border-gray-200 px-6 py-4 flex justify-between items-center">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
      </div>

      <div className="relative">
        <button
          onClick={() => setShowMenu(!showMenu)}
          className="flex items-center space-x-2 px-4 py-2 rounded-lg hover:bg-gray-100"
        >
          <User size={20} />
          <span>{user?.name || 'Admin'}</span>
        </button>

        {showMenu && (
          <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg">
            <button
              onClick={handleLogout}
              className="w-full flex items-center space-x-2 px-4 py-2 text-red-600 hover:bg-red-50"
            >
              <LogOut size={20} />
              <span>Logout</span>
            </button>
          </div>
        )}
      </div>
    </header>
  );
}
```

### STEP 9: Create Dashboard Home Page

Create `src/app/(dashboard)/dashboard/page.tsx`:

```typescript
import StatCard from '@/components/dashboard/StatCard';
import RecentUsers from '@/components/dashboard/RecentUsers';
import { BarChart, LineChart } from 'recharts';

const data = [
  { name: 'Jan', users: 400, bookings: 240 },
  { name: 'Feb', users: 300, bookings: 221 },
  { name: 'Mar', users: 200, bookings: 229 },
  { name: 'Apr', users: 278, bookings: 200 },
];

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-900">Welcome to AutoLab</h1>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          label="Total Users"
          value="1,234"
          change="+12%"
          trend="up"
        />
        <StatCard
          label="Total Vehicles"
          value="2,456"
          change="+5%"
          trend="up"
        />
        <StatCard
          label="Total Bookings"
          value="3,789"
          change="+18%"
          trend="up"
        />
        <StatCard
          label="Revenue"
          value="$45,230"
          change="+8%"
          trend="up"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold mb-4">Users & Bookings</h3>
          {/* Add recharts here */}
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold mb-4">Monthly Trends</h3>
          {/* Add chart here */}
        </div>
      </div>

      {/* Recent Users */}
      <RecentUsers />
    </div>
  );
}
```

### STEP 10: Create StatCard Component

Create `src/components/dashboard/StatCard.tsx`:

```typescript
'use client';

import { TrendingUp, TrendingDown } from 'lucide-react';

interface StatCardProps {
  label: string;
  value: string | number;
  change: string;
  trend: 'up' | 'down';
}

export default function StatCard({ label, value, change, trend }: StatCardProps) {
  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <p className="text-gray-600 text-sm font-medium">{label}</p>
      <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
      <div className="flex items-center mt-2 space-x-1">
        {trend === 'up' ? (
          <TrendingUp className="text-green-600" size={16} />
        ) : (
          <TrendingDown className="text-red-600" size={16} />
        )}
        <span
          className={`text-sm font-medium ${
            trend === 'up' ? 'text-green-600' : 'text-red-600'
          }`}
        >
          {change}
        </span>
      </div>
    </div>
  );
}
```

### STEP 11: Create Users Page

Create `src/app/(dashboard)/users/page.tsx`:

```typescript
'use client';

import { useState, useEffect } from 'react';
import apiClient from '@/lib/api';
import Link from 'next/link';

interface User {
  id: string;
  email: string;
  name: string;
  phone: string;
  role: string;
  createdAt: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await apiClient.get('/api/users');
      setUsers(response.data.users || []);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading users...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-900">Users</h1>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase">
                Name
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase">
                Email
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase">
                Phone
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase">
                Role
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {users.map((user) => (
              <tr key={user.id}>
                <td className="px-6 py-4 text-sm text-gray-900">{user.name}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{user.email}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{user.phone}</td>
                <td className="px-6 py-4 text-sm text-gray-600">{user.role}</td>
                <td className="px-6 py-4 text-sm">
                  <Link
                    href={`/users/${user.id}`}
                    className="text-blue-600 hover:underline"
                  >
                    View
                  </Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
```

---

## 🧪 Testing the Dashboard

### Step 1: Start the Backend

```bash
cd apps/backend
npm run dev
```

### Step 2: Start the Dashboard

```bash
cd apps/admin-dashboard
npm run dev
```

Open: http://localhost:3001

### Step 3: Login

```
Email: user@example.com
Password: Password123!
```

---

## 🎨 Why App Router (Not Pages Router)

| Feature | Pages Router | App Router | Benefit |
|---------|--------------|-----------|---------|
| Modern | ❌ Legacy | ✅ Latest | Future-proof |
| Server Components | ❌ No | ✅ Yes | Better performance |
| Route Groups | ❌ No | ✅ Yes | Better organization |
| Middleware | ⚠️ Limited | ✅ Full | Better auth handling |
| Performance | Good | ✅ Excellent | Faster pages |
| **Our Choice** | **NOT USED** | **✅ USED** | **Modern, fast, organized** |

---

## 🔒 Security Features

✅ **JWT Authentication**  
✅ **Token in localStorage**  
✅ **Middleware protection**  
✅ **API interceptors**  
✅ **CORS enabled**  
✅ **Environment variables**  

---

## 📋 Remaining Components (Will create)

- `RecentUsers.tsx` - Show recent registrations
- `Chart.tsx` - Visualize data
- `UserForm.tsx` - Add/edit users
- `VehiclesPage` - Vehicle management
- `ServicesPage` - Service management
- `BookingsPage` - Booking management

---

## ✅ Verification Checklist

- [ ] Next.js project created with App Router
- [ ] Dependencies installed
- [ ] Environment variables configured
- [ ] Login page created
- [ ] Dashboard layout created
- [ ] Sidebar and header components working
- [ ] Can login with backend API
- [ ] Dashboard page displays
- [ ] Users page fetches data
- [ ] All pages responsive

---

## 📱 Complete App Router Structure

```
(auth) group
├── login/          - Public auth page
├── register/       - Public registration
└── forgot-password/ - Public password reset

(dashboard) group
├── page.tsx                - Dashboard home
├── dashboard/              - Analytics
├── users/                  - User management
│   └── [id]/              - User details
├── vehicles/              - Vehicle management
├── services/              - Service management
├── bookings/              - Booking management
└── settings/              - Admin settings
```

---

## 🚀 Next Steps

1. ✅ Dashboard running locally
2. ⏳ Create remaining pages (Vehicles, Services, Bookings)
3. ⏳ Add charts and analytics
4. ⏳ Deploy to Vercel
5. ⏳ Connect with Flutter frontend

---

## 📚 Key Advantages of App Router

```typescript
// 1. ROUTE GROUPS - Organize without affecting URL
(auth)/        // URLs: /login, /register
(dashboard)/   // URLs: /dashboard, /users

// 2. SERVER COMPONENTS - Default
// No 'use client' = runs on server
// Better security, faster, smaller JS

// 3. MIDDLEWARE - Protect routes
// Centralized auth logic
// Runs before pages load

// 4. LAYOUTS - Shared UI
// Different layouts for different routes
// Auth pages different from dashboard

// 5. API ROUTES - Backend in Next.js
// app/api/users/route.ts
// GET, POST, PUT, DELETE in same file
```

---

**Status:** ✅ Next.js Admin Dashboard Guide Complete  
**Router Type:** ✅ App Router (Modern, not Pages Router)  
**Independence:** ✅ Completely independent app  
**Ready to implement:** Yes

---

**→ Next Guide:** `06_FLUTTER_FRONTEND.md` (coming next)
