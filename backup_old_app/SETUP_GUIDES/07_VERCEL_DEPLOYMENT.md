# 🚀 VERCEL DEPLOYMENT - Express Backend & Next.js Dashboard

**Purpose:** Deploy backend API and admin dashboard to Vercel production  
**Time:** 2-3 hours  
**Complexity:** Intermediate  
**Tech:** Vercel, GitHub, Environment Variables  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Do

- ✅ Create Vercel account
- ✅ Deploy Express backend
- ✅ Deploy Next.js admin dashboard
- ✅ Configure custom domains
- ✅ Set environment variables
- ✅ Monitor deployments
- ✅ Configure CI/CD

---

## 📋 Prerequisites

- ✅ GitHub account with both repos
- ✅ Express backend code (from 04_EXPRESS_BACKEND.md)
- ✅ Next.js dashboard code (from 05_NEXT_JS_DASHBOARD.md)
- ✅ Supabase database (from 03_SUPABASE_DATABASE.md)
- ✅ Brevo and SMS API credentials

---

## 🚀 STEP-BY-STEP DEPLOYMENT

### STEP 1: Create Vercel Account

**Click-by-click:**

1. Go to **https://vercel.com**
2. Click **"Sign Up"** (top right)
3. Choose **"Continue with GitHub"**
4. Authorize Vercel to access GitHub
5. Complete onboarding

✅ **Done:** Vercel account ready

---

### STEP 2: Deploy Express Backend

#### Part A: Prepare Express for Vercel

Your Express backend needs to work on Vercel's serverless environment.

Update `package.json`:

```json
{
  "name": "autolab-backend",
  "version": "1.0.0",
  "engines": {
    "node": "18.x"
  },
  "scripts": {
    "dev": "nodemon src/index.ts",
    "start": "node dist/index.js",
    "build": "tsc",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "prisma": "^5.3.1",
    "@prisma/client": "^5.3.1",
    "jsonwebtoken": "^9.1.0",
    "bcryptjs": "^2.4.3",
    "axios": "^1.5.0",
    "joi": "^17.11.0"
  }
}
```

Create `vercel.json`:

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "express",
  "functions": {
    "src/index.ts": {
      "runtime": "nodejs18.x"
    }
  },
  "routes": [
    {
      "src": "/(.*)",
      "dest": "src/index.ts"
    }
  ],
  "env": [
    "DATABASE_URL",
    "JWT_SECRET",
    "BREVO_API_KEY",
    "SMS_PROVIDER",
    "TWILIO_ACCOUNT_SID",
    "TWILIO_AUTH_TOKEN",
    "TWILIO_PHONE_NUMBER",
    "NODE_ENV"
  ]
}
```

#### Part B: Deploy to Vercel

1. Open **Vercel Dashboard**
2. Click **"Add New..."** → **"Project"**
3. Select **Backend GitHub repository**
4. Click **"Import"**
5. **Configure project:**
   - Framework: **Node.js**
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`

6. **Add environment variables:**

Click **"Environment Variables"** and add:

| Variable | Value |
|----------|-------|
| DATABASE_URL | Your Supabase PostgreSQL URL |
| JWT_SECRET | Your JWT secret (from 11_CREDENTIALS_VAULT.md) |
| BREVO_API_KEY | Your Brevo API key |
| SMS_PROVIDER | `TWILIO` (or AWS_SNS, VONAGE) |
| TWILIO_ACCOUNT_SID | Your Twilio SID |
| TWILIO_AUTH_TOKEN | Your Twilio token |
| TWILIO_PHONE_NUMBER | Your Twilio number |
| NODE_ENV | `production` |

7. Click **"Deploy"**
8. Wait for deployment (5-10 minutes)
9. Click **"Visit"** when done

✅ **Done:** Backend deployed  
📝 **Note down:** Backend URL (e.g., `https://autolab-backend.vercel.app`)

---

### STEP 3: Configure Express for Vercel API Routes

Vercel works best with API route structure. Update your Express app:

Create `api/index.ts`:

```typescript
import express, { Express } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';

dotenv.config();

const app: Express = express();
const prisma = new PrismaClient();

// Middleware
app.use(cors());
app.use(express.json());

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// Auth routes
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Your login logic here
    // Return { token, user }
    
    res.json({ token: 'jwt_token', user: {} });
  } catch (error) {
    res.status(400).json({ error: 'Login failed' });
  }
});

// ... More routes

export default app;
```

Then in `vercel.json`:

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".vercel/output/functions",
  "framework": "express",
  "functions": {
    "api/index.ts": {
      "runtime": "nodejs18.x"
    }
  }
}
```

---

### STEP 4: Deploy Next.js Dashboard

#### Part A: Prepare Dashboard

Create `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    unoptimized: true,
  },
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
  },
};

module.exports = nextConfig;
```

Create `.env.production`:

```bash
NEXT_PUBLIC_API_URL=https://autolab-backend.vercel.app
```

Update `lib/api-client.ts`:

```typescript
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

export const apiClient = {
  get: async (path: string) => {
    const response = await fetch(`${API_URL}${path}`, {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    });
    return response.json();
  },

  post: async (path: string, data: any) => {
    const response = await fetch(`${API_URL}${path}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    return response.json();
  },
};
```

#### Part B: Deploy Dashboard

1. Open **Vercel Dashboard**
2. Click **"Add New..."** → **"Project"**
3. Select **Admin Dashboard GitHub repo**
4. Click **"Import"**
5. **Configure:**
   - Framework: **Next.js**
   - Build Command: `npm run build`
   - Output Directory: `.next`

6. **Add environment variables:**

| Variable | Value |
|----------|-------|
| NEXT_PUBLIC_API_URL | https://autolab-backend.vercel.app |

7. Click **"Deploy"**
8. Wait for deployment

✅ **Done:** Dashboard deployed  
📝 **Note down:** Dashboard URL (e.g., `https://autolab-admin.vercel.app`)

---

### STEP 5: Connect Custom Domains (Optional)

#### For Backend:

1. Go to **Vercel Dashboard** → **Backend Project**
2. Click **"Settings"** → **"Domains"**
3. Click **"Add Domain"**
4. Enter: `api.autolab.com`
5. Update DNS (at your domain provider):

```
Name: api
Type: CNAME
Value: cname.vercel.com
```

6. Wait 5-10 minutes for DNS propagation
7. Vercel will auto-verify

#### For Dashboard:

1. Go to **Vercel Dashboard** → **Dashboard Project**
2. Click **"Settings"** → **"Domains"**
3. Click **"Add Domain"**
4. Enter: `admin.autolab.com`
5. Update DNS:

```
Name: admin
Type: CNAME
Value: cname.vercel.com
```

6. Wait for verification

✅ **Now accessible at:**
- Backend: `https://api.autolab.com`
- Dashboard: `https://admin.autolab.com`

---

### STEP 6: Verify Deployments

#### Test Backend:

```bash
curl https://autolab-backend.vercel.app/api/health
```

Response should be:
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### Test Dashboard:

1. Visit `https://autolab-admin.vercel.app`
2. Should load admin dashboard
3. Check console for any errors
4. Test API calls from dashboard

---

### STEP 7: Enable CI/CD (Automatic Deploys)

By default, Vercel auto-deploys on every push to main branch.

**To customize:**

1. Go to **Vercel Dashboard** → **Project Settings**
2. Click **"Git"**
3. Set **"Production Branch"** to `main`
4. Set **"Preview Branches"** to auto-deploy pull requests
5. Done! (No manual deploys needed)

---

### STEP 8: Monitor Deployments

#### View Logs:

1. **Vercel Dashboard** → **Project**
2. Click **"Deployments"** tab
3. Click any deployment to see logs
4. Check **"Runtime Logs"** for errors

#### View Analytics:

1. Click **"Analytics"** tab
2. View:
   - Request count
   - Response times
   - Error rates
   - Edge requests

---

## 🔒 Environment Variables Reference

### Backend Env Variables:

```bash
# Database
DATABASE_URL=postgresql://user:pass@db.supabase.co:5432/autolab

# JWT
JWT_SECRET=your_jwt_secret_key_here

# Email (Brevo)
BREVO_API_KEY=your_brevo_api_key_here

# SMS (Choose one)
SMS_PROVIDER=TWILIO

# Twilio
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# OR AWS SNS
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# OR Vonage
VONAGE_API_KEY=your_api_key
VONAGE_API_SECRET=your_secret
VONAGE_PHONE_NUMBER=your_phone

# Node environment
NODE_ENV=production
```

### Dashboard Env Variables:

```bash
# API endpoint
NEXT_PUBLIC_API_URL=https://autolab-backend.vercel.app

# Optional: Analytics
NEXT_PUBLIC_ANALYTICS_ID=your_analytics_id
```

---

## 📊 Deployment Checklist

- [ ] Vercel account created
- [ ] Backend deployed successfully
- [ ] Dashboard deployed successfully
- [ ] Environment variables configured
- [ ] Health check API working
- [ ] Dashboard can reach backend
- [ ] Custom domains configured (optional)
- [ ] CI/CD enabled
- [ ] Logs checked and no errors
- [ ] Both apps accessible publicly

---

## 🐛 Troubleshooting

### "Deployment Failed"

1. Check **Logs** in Vercel Dashboard
2. Verify environment variables are set
3. Ensure `package.json` has correct scripts
4. Check build command is correct

### "Cannot reach backend"

1. Verify backend URL in dashboard
2. Check CORS is enabled in backend
3. Verify environment variables in backend
4. Test backend URL directly in browser

### "Build command failed"

1. Check logs for specific error
2. Run locally: `npm run build`
3. Fix errors locally first
4. Push to GitHub and redeploy

### "Cold start timeout"

1. Optimize dependencies
2. Remove unused packages
3. Use serverless-optimized packages
4. Check database connection pool size

---

## 🎯 Next Steps

1. ✅ Both apps deployed to Vercel
2. ⏳ Set up GitHub Actions (08_GITHUB_ACTIONS.md)
3. ⏳ Configure Firebase & FCM (09_FIREBASE_DETAILS.md)
4. ⏳ Publish to Play Store (10_GOOGLE_PLAY_STORE.md)

---

**Status:** ✅ Complete Vercel Deployment Guide  
**Ready to implement:** Yes  
**Difficulty:** Intermediate

---

**→ Next Guide:** `08_GITHUB_ACTIONS.md` (coming next)
