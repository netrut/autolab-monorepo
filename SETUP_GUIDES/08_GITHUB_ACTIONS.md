# ⚙️ GITHUB ACTIONS CI/CD - Automated Testing & Deployment

**Purpose:** Automate testing, building, and deployment with GitHub Actions  
**Time:** 2-3 hours  
**Complexity:** Intermediate  
**Tech:** GitHub Actions, YAML, Workflows  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Do

- ✅ Create GitHub Actions workflows
- ✅ Auto-test on pull requests
- ✅ Auto-deploy to Vercel on merge
- ✅ Run linting checks
- ✅ Build verification
- ✅ Database migrations (optional)
- ✅ Slack notifications

---

## 📋 Prerequisites

- ✅ GitHub repository with backend & dashboard code
- ✅ Vercel account (from 07_VERCEL_DEPLOYMENT.md)
- ✅ Vercel API token
- ✅ PostgreSQL database

---

## 🚀 STEP-BY-STEP SETUP

### STEP 1: Get Vercel API Token

1. Go to **Vercel Dashboard**
2. Click your **Account** (bottom left)
3. Click **"Settings"**
4. Click **"Tokens"**
5. Click **"Create"**
6. Name: `GitHub Actions`
7. Copy token
8. **SAVE THIS** - you'll need it shortly

---

### STEP 2: Create GitHub Secrets

For **Backend Repository:**

1. Go to **GitHub** → **Repository**
2. Click **"Settings"** → **"Secrets and variables"** → **"Actions"**
3. Click **"New repository secret"**

Add these secrets:

| Secret Name | Value |
|------------|-------|
| VERCEL_TOKEN | Your Vercel API token |
| VERCEL_ORG_ID | From Vercel Account Settings |
| VERCEL_PROJECT_ID | From backend project settings |
| DATABASE_URL | Your Supabase database URL |
| JWT_SECRET | Your JWT secret |
| BREVO_API_KEY | Your Brevo API key |
| TWILIO_ACCOUNT_SID | Your Twilio SID |
| TWILIO_AUTH_TOKEN | Your Twilio token |
| TWILIO_PHONE_NUMBER | Your Twilio number |

#### Get Vercel IDs:

**VERCEL_ORG_ID:**
1. Visit **https://vercel.com/account**
2. Look for "Team ID" or "ORG_ID"

**VERCEL_PROJECT_ID:**
1. Go to **Vercel Dashboard** → **Backend Project**
2. Click **"Settings"**
3. Find "Project ID"

---

### STEP 3: Create Backend Workflow

Create `.github/workflows/backend-test-deploy.yml`:

```yaml
name: Backend - Test & Deploy

on:
  push:
    branches: [main, develop]
    paths:
      - 'backend/**'
      - '.github/workflows/backend-test-deploy.yml'
  pull_request:
    branches: [main, develop]
    paths:
      - 'backend/**'

env:
  NODE_VERSION: '18.x'

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: autolab_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: cd backend && npm install

      - name: Run linting
        run: cd backend && npm run lint --if-present

      - name: Run tests
        run: cd backend && npm test --if-present
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/autolab_test
          JWT_SECRET: test_secret
          NODE_ENV: test

      - name: Build
        run: cd backend && npm run build
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          JWT_SECRET: ${{ secrets.JWT_SECRET }}

  deploy:
    name: Deploy to Vercel
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Vercel
        uses: vercel/action@v4
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          github-comment: true
          github-token: ${{ secrets.GITHUB_TOKEN }}

      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          payload: |
            {
              "text": "Backend Deployment",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Backend Deployment*\nStatus: ${{ job.status }}\nBranch: ${{ github.ref }}\nCommit: ${{ github.sha }}"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

### STEP 4: Create Dashboard Workflow

Create `.github/workflows/dashboard-test-deploy.yml`:

```yaml
name: Dashboard - Test & Deploy

on:
  push:
    branches: [main, develop]
    paths:
      - 'admin-dashboard/**'
      - '.github/workflows/dashboard-test-deploy.yml'
  pull_request:
    branches: [main, develop]
    paths:
      - 'admin-dashboard/**'

env:
  NODE_VERSION: '18.x'

jobs:
  test:
    name: Test & Build
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: cd admin-dashboard && npm install

      - name: Run linting
        run: cd admin-dashboard && npm run lint --if-present

      - name: Build
        run: cd admin-dashboard && npm run build
        env:
          NEXT_PUBLIC_API_URL: https://autolab-backend.vercel.app

      - name: Run tests
        run: cd admin-dashboard && npm test --if-present --passWithNoTests

  deploy:
    name: Deploy to Vercel
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Vercel
        uses: vercel/action@v4
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_DASHBOARD_PROJECT_ID }}
          github-comment: true
          github-token: ${{ secrets.GITHUB_TOKEN }}

      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          payload: |
            {
              "text": "Dashboard Deployment",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Dashboard Deployment*\nStatus: ${{ job.status }}\nBranch: ${{ github.ref }}\nCommit: ${{ github.sha }}"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

### STEP 5: Create Database Migration Workflow (Optional)

Create `.github/workflows/migrations.yml`:

```yaml
name: Database Migrations

on:
  push:
    branches: [main]
    paths:
      - 'backend/prisma/migrations/**'

jobs:
  migrate:
    name: Run Migrations
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18.x'
          cache: 'npm'

      - name: Install dependencies
        run: cd backend && npm install

      - name: Run migrations
        run: cd backend && npx prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Generate Prisma client
        run: cd backend && npx prisma generate

      - name: Notify Slack
        if: failure()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          payload: |
            {
              "text": "⚠️ Migration Failed",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Migration Failed*\nCommit: ${{ github.sha }}\nAuthor: ${{ github.actor }}"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

### STEP 6: Create Flutter Build Workflow (Optional)

Create `.github/workflows/flutter-build.yml`:

```yaml
name: Flutter - Build

on:
  push:
    branches: [main, develop]
    paths:
      - 'mobile-app/**'
  pull_request:
    branches: [main, develop]
    paths:
      - 'mobile-app/**'

jobs:
  build:
    name: Build Flutter App
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.8'
          channel: 'stable'

      - name: Get dependencies
        run: cd mobile-app && flutter pub get

      - name: Analyze
        run: cd mobile-app && flutter analyze

      - name: Format check
        run: cd mobile-app && flutter format --set-exit-if-changed .

      - name: Build APK
        run: cd mobile-app && flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: mobile-app/build/app/outputs/flutter-app/release/app-release.apk

      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          payload: |
            {
              "text": "Flutter Build",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Flutter Build*\nStatus: ${{ job.status }}\nBranch: ${{ github.ref }}"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

### STEP 7: Setup Slack Notifications (Optional)

1. Go to **Slack Workspace Settings** → **Apps**
2. Search for **"Incoming Webhooks"**
3. Click **"Add New"**
4. Choose channel (e.g., `#deployments`)
5. Click **"Add Incoming WebHooks Integration"**
6. Copy **Webhook URL**
7. Go to **GitHub** → **Repository** → **Settings** → **Secrets**
8. Add secret: `SLACK_WEBHOOK_URL` = your webhook URL

---

### STEP 8: Test Workflows

1. Make a small change to `backend/package.json`
2. Push to a feature branch
3. Create **Pull Request**
4. Check **Actions** tab - should see workflow running
5. When tests pass, merge to `main`
6. Check **Actions** again - should deploy to Vercel

---

## 📊 Workflow Triggers

### Backend Workflow Runs When:

- ✅ Pushed to `main` or `develop` branch
- ✅ Changes in `backend/` folder
- ✅ Pull request to `main` or `develop`

### Dashboard Workflow Runs When:

- ✅ Pushed to `main` or `develop` branch
- ✅ Changes in `admin-dashboard/` folder
- ✅ Pull request to `main` or `develop`

### Migrations Run When:

- ✅ Pushed to `main` branch
- ✅ Changes in `backend/prisma/migrations/` folder

---

## 🔧 Useful GitHub Actions

### Check Workflow Status:

1. Go to **Repository** → **Actions** tab
2. Click workflow name
3. View logs and status
4. See deployment link

### Re-run Failed Workflow:

1. Click failed workflow
2. Click **"Re-run failed jobs"**
3. Fixes deploy automatically

### Cancel Workflow:

1. Go to **Actions** tab
2. Click running workflow
3. Click **"Cancel workflow"**

---

## 📋 Workflow Reference

### Environment Variables Available:

```yaml
github.ref              # Branch reference (refs/heads/main)
github.sha              # Commit SHA
github.actor            # Username who triggered
github.event_name       # 'push' or 'pull_request'
job.status              # 'success' or 'failure'
secrets.*               # Your secrets
```

### Common Actions:

```yaml
# Checkout code
- uses: actions/checkout@v4

# Setup Node
- uses: actions/setup-node@v4
  with:
    node-version: '18.x'
    cache: 'npm'

# Setup Flutter
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.32.8'

# Upload artifacts
- uses: actions/upload-artifact@v3
  with:
    name: app.apk
    path: ./build/app-release.apk

# Deploy to Vercel
- uses: vercel/action@v4
  with:
    vercel-token: ${{ secrets.VERCEL_TOKEN }}
    vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
    vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

---

## ✅ Verification Checklist

- [ ] GitHub repository created
- [ ] Vercel account connected to GitHub
- [ ] GitHub secrets added
- [ ] Backend workflow file created
- [ ] Dashboard workflow file created
- [ ] Workflows triggered on push
- [ ] Tests passing
- [ ] Auto-deployment to Vercel working
- [ ] Slack notifications (optional) working
- [ ] All branches have CI/CD enabled

---

## 🐛 Troubleshooting

### Workflow not running

1. Check workflow file syntax (YAML)
2. Verify `on:` triggers match your changes
3. Check **Actions** tab for errors

### Tests failing in CI

1. Check logs in **Actions** tab
2. Run locally: `npm test`
3. Fix locally, then push

### Deploy not working

1. Verify Vercel secrets are correct
2. Check VERCEL_PROJECT_ID is accurate
3. Verify branch protection settings

### Slack notification not working

1. Check SLACK_WEBHOOK_URL secret is set
2. Verify webhook URL is correct
3. Test webhook URL directly

---

## 🎯 Next Steps

1. ✅ CI/CD pipeline setup complete
2. ⏳ Configure Firebase & FCM (09_FIREBASE_DETAILS.md)
3. ⏳ Publish to Play Store (10_GOOGLE_PLAY_STORE.md)

---

**Status:** ✅ Complete GitHub Actions Guide  
**Ready to implement:** Yes  
**Difficulty:** Intermediate

---

**→ Next Guide:** `09_FIREBASE_DETAILS.md` (coming next)
