# 🔐 CREDENTIALS VAULT - Keep This Safe!

**Purpose:** Secure storage for all passwords and API keys  
**Status:** 🔒 CONFIDENTIAL  
**Keep in:** Password manager (1Password, LastPass, Bitwarden)  
**Never commit to Git:** Add to `.gitignore`

---

## ⚠️ IMPORTANT

This file contains **SENSITIVE INFORMATION**:
- ❌ **NEVER** commit to Git
- ❌ **NEVER** share with anyone
- ❌ **NEVER** paste in chat/email
- ❌ **NEVER** leave on public computer
- ✅ **ALWAYS** use password manager
- ✅ **ALWAYS** encrypt backups
- ✅ **ALWAYS** rotate passwords periodically

---

## 📋 TABLE OF CONTENTS

1. GitHub Credentials
2. Supabase Credentials
3. Firebase Credentials
4. Vercel Credentials
5. Google Play Store
6. Email Accounts
7. API Keys & Tokens
8. Backup & Recovery

---

## 1️⃣ GITHUB CREDENTIALS

### GitHub Account

```
Username:               [Your GitHub username]
Email:                 [Your email address]
Account URL:           https://github.com/[username]
Profile Type:          Personal / Organization
Status:                Created
```

### SSH Key (Optional)

```
SSH Key Location:       ~/.ssh/id_ed25519
SSH Key Fingerprint:    [Your SSH fingerprint]
Public Key:             [Your public key - OK to share]
Private Key:            [KEEP SECRET - in ~/.ssh/]
Status:                 ✅ Added to GitHub
```

### Personal Access Token

```
Token Name:             autolab-token
Token Scope:            repo, workflow, admin:repo_hook
Token Value:            ghp_[token-here]
Created:                [Date]
Expires:                [Date or Never]
Status:                 [Active/Inactive]
```

**How to create:**
- GitHub → Settings → Developer settings → Personal access tokens
- Create new token with 'repo' scope
- Copy and paste value here

---

## 2️⃣ SUPABASE CREDENTIALS

### Supabase Account

```
Email:                  autolabstation@gmail.com
Password:               [Supabase account password - NOT database password!]
Account URL:            https://app.supabase.com
Status:                 ✅ Account created & verified
Two-Factor Auth:        [Enable for security]
```

### Supabase Project: autolab-db

```
Project Name:           autolab-db
Project ID:             [Your unique project ID]
Project URL:            https://app.supabase.com/project/[PROJECT_ID]
Region:                 Asia - Singapore (or India - Mumbai)
Database Version:       PostgreSQL 15.x
Free Tier Status:       ✅ Using free tier
```

### Database Credentials

```
Database User:          postgres
Database Password:      AutoLabDB@2024!Secure
Database Host:          db.[PROJECT_ID].supabase.co
Database Port:          5432
Database Name:          postgres
SSL Mode:               require
```

### Connection Strings

**Production (use this in backend):**
```
postgresql://postgres:AutoLabDB@2024!Secure@db.[PROJECT_ID].supabase.co:5432/postgres
```

**Pooling (optional for high traffic):**
```
postgresql://postgres:[PASSWORD]@db.[PROJECT_ID].supabase.co:6543/postgres
```

### Supabase API Keys

```
Anon Key (public):      [Your anon key - OK to share]
Service Role Key:       [KEEP SECRET - for backend only]
JWT Secret:             [Your JWT signing key]
```

**How to get:**
- Supabase dashboard → Settings → API
- Copy Anon Key and Service Role Key

---

## 3️⃣ FIREBASE CREDENTIALS

### Firebase Account

```
Google Account:         autolabstation@gmail.com
Firebase Project Name:  [Your project name]
Firebase Project ID:    [Your project ID]
Firebase Console:       https://console.firebase.google.com
Status:                 ✅ Project created
```

### Firebase Service Account

```
Service Account Email:  [Your service account email]
Service Account ID:     [Your service account ID]
Private Key ID:         [Your private key ID]
Private Key:            [KEEP SECRET - in serviceAccountKey.json]
Location:               apps/backend/firebase/serviceAccountKey.json
Status:                 ✅ Downloaded & secured
```

⚠️ **WARNING:** Never commit serviceAccountKey.json to Git!

### Firebase Web Config

```
API Key:                [Your API key]
Auth Domain:            [Your auth domain]
Database URL:           [Your database URL]
Project ID:             [Firebase project ID]
Storage Bucket:         [Your storage bucket]
Messaging Sender ID:    [Your sender ID]
App ID:                 [Your app ID]
Measurement ID:         [Optional]
```

**Location:**
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Web: `firebase.json` config

---

## 4️⃣ VERCEL CREDENTIALS

### Vercel Account

```
Email:                  [Your Vercel email]
Account Name:           [Your account name]
Team Name:              [Your team - if applicable]
Account URL:            https://vercel.com/[account]
Status:                 [Account created/Not yet]
Tier:                   [Free/Pro/Enterprise]
```

### Vercel API Token

```
Token Name:             autolab-deployment
Token Value:            [Your token - KEEP SECRET]
Created:                [Date]
Expires:                [Date or Never]
Scope:                  Full access (or limited)
Status:                 [Active/Inactive]
```

**How to create:**
- Vercel dashboard → Settings → Tokens
- Create new token with 'Full Access'
- Copy and paste value here

### Vercel Projects

```
Backend Project (Express API)
- Name:                 autolab-backend
- URL:                  https://autolab-backend.vercel.app
- Branch:               main
- Status:               [Not deployed yet]
- Environment:          [prod/staging]

Admin Dashboard (Next.js)
- Name:                 autolab-dashboard
- URL:                  https://autolab-dashboard.vercel.app
- Branch:               main
- Status:               [Not deployed yet]
- Environment:          [prod/staging]
```

---

## 5️⃣ GOOGLE PLAY STORE

### Google Play Console

```
Email:                  autolabstation@gmail.com
Console URL:            https://play.google.com/console
Account Status:         [Enrolled/Not enrolled]
Developer Account Fee:  $25 (one-time)
Status:                 [Paid/Pending]
```

### App Signing Credentials

```
App Package Name:       com.example.autolab
Upload Key (Keystore):
  - File:               autolab-key.jks
  - Password:           [KEEP SECRET]
  - Alias:              [Your alias]
  - Alias Password:     [KEEP SECRET]
  - Location:           apps/flutter-app/android/app/autolab-key.jks
  
App Signing Certificate:
  - SHA1:               [Your SHA1 fingerprint]
  - SHA256:             [Your SHA256 fingerprint]
  - Upload Certificate: [Your upload certificate fingerprint]
```

### App Details

```
App Name:               AutoLab
App ID:                 [Play Store assigned ID]
Store Listing URL:      https://play.google.com/store/apps/details?id=com.example.autolab
Current Version:        [Version number]
Release Status:         [Published/Draft/Closed]
```

---

## 6️⃣ EMAIL ACCOUNTS

### Primary Project Email

```
Email:                  autolabstation@gmail.com
Password:               [KEEP SECRET]
Recovery Email:         [Your recovery email]
Two-Factor Auth:        ✅ Enabled
Status:                 ✅ Active
Services Using This:
  - GitHub
  - Supabase
  - Firebase
  - Google Play Store
  - Vercel
```

### Email Recovery Codes

```
Recovery Email:         [Your alternate email]
Recovery Phone:         [Your phone number]
Backup Codes:           [Save these safely - don't paste here!]
Status:                 ✅ Configured
```

---

## 7️⃣ API KEYS & TOKENS

### Email Service: Brevo

```
Service:                Brevo (formerly Sendinblue)
Account Email:          autolabstation@gmail.com
Account URL:            https://app.brevo.com
API Key:                [Your Brevo API key - KEEP SECRET]
Sender Email:           autolabstation@gmail.com
Sender Name:            AutoLab
Sender Domain:          [Your verified domain - optional]
Status:                 [Account created/Not yet]
Monthly Limit:          300 emails (free tier)
```

**How to get:**
1. Sign up at https://www.brevo.com
2. Go to Settings → SMTP & API
3. Copy your API key
4. Use in backend `.env` as `BREVO_API_KEY`

### SMS Service: Third-Party API (Choose One)

**Option 1: Twilio**
```
Service:                Twilio
Account SID:            [Your Account SID]
Auth Token:             [Your Auth Token - KEEP SECRET]
Phone Number:           [Your Twilio phone number]
Account URL:            https://www.twilio.com/console
Status:                 [Account created/Not yet]
Free Trial Credit:      $15 (expires after 30 days)
```

**Option 2: AWS SNS**
```
Service:                Amazon SNS (Simple Notification Service)
Region:                 us-east-1
Access Key ID:          [Your access key]
Secret Access Key:      [Your secret key - KEEP SECRET]
Account URL:            https://console.aws.amazon.com/sns
Status:                 [Account created/Not yet]
```

**Option 3: Vonage (Nexmo)**
```
Service:                Vonage (formerly Nexmo)
API Key:                [Your API key]
API Secret:             [Your API secret - KEEP SECRET]
Phone Number:           [Your Vonage phone number]
Account URL:            https://dashboard.nexmo.com
Status:                 [Account created/Not yet]
```

**How to choose:**
- **Twilio:** Most reliable, well-documented, good for global reach
- **AWS SNS:** Best if using AWS infrastructure, cost-effective at scale
- **Vonage:** Good alternative, competitive pricing

### Backend Environment Variables

**File:** `apps/backend/.env`

```env
# Database
DATABASE_URL=postgresql://postgres:AutoLabDB@2024!Secure@db.[PROJECT_ID].supabase.co:5432/postgres

# Express
API_PORT=3000
NODE_ENV=development
JWT_SECRET=[Your JWT secret - GENERATE NEW!]

# Email (Brevo)
BREVO_API_KEY=[Your Brevo API key - KEEP SECRET]
BREVO_SENDER_EMAIL=autolabstation@gmail.com
BREVO_SENDER_NAME=AutoLab

# SMS (Third-party service - Choose one)
# Option 1: Twilio
TWILIO_ACCOUNT_SID=[Your Twilio Account SID]
TWILIO_AUTH_TOKEN=[Your Twilio Auth Token - KEEP SECRET]
TWILIO_PHONE_NUMBER=+1234567890

# Option 2: AWS SNS
AWS_SNS_REGION=us-east-1
AWS_SNS_ACCESS_KEY=[Your AWS access key]
AWS_SNS_SECRET_KEY=[Your AWS secret key - KEEP SECRET]

# Option 3: Vonage (Nexmo)
VONAGE_API_KEY=[Your Vonage API key]
VONAGE_API_SECRET=[Your Vonage API secret - KEEP SECRET]
VONAGE_PHONE_NUMBER=[Your Vonage phone number]

# Firebase (for FCM push notifications)
FIREBASE_PROJECT_ID=[Your Firebase project ID]
FIREBASE_PRIVATE_KEY=[Your Firebase private key - KEEP SECRET]
FIREBASE_CLIENT_EMAIL=[Your Firebase service account email]

# Logging
LOG_LEVEL=info
```

### Dashboard Environment Variables

**File:** `apps/admin-dashboard/.env.local`

```env
# Backend API
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_API_URL_PROD=https://autolab-backend.vercel.app

# Database (if needed)
DATABASE_URL=postgresql://postgres:AutoLabDB@2024!Secure@db.[PROJECT_ID].supabase.co:5432/postgres

# Authentication
NEXTAUTH_SECRET=[Generate with: openssl rand -base64 32]
NEXTAUTH_URL=http://localhost:3001
NEXTAUTH_URL_PROD=https://autolab-dashboard.vercel.app

# Firebase
NEXT_PUBLIC_FIREBASE_API_KEY=[Your Firebase API key]
NEXT_PUBLIC_FIREBASE_PROJECT_ID=[Your Firebase project ID]
```

### Flutter Configuration

**Note:** Flutter app hardcodes API URL (no .env file)

```dart
// lib/backend/api_client.dart
const String API_URL = 'http://localhost:3000';  // Development
const String API_URL_PROD = 'https://autolab-backend.vercel.app';  // Production
```

---

## 8️⃣ PASSWORD ROTATION SCHEDULE

Track when you last changed each password:

```
Supabase Account:       Last changed: [Date]    Next change: [Date+90days]
Supabase Database:      Last changed: [Date]    Next change: [Date+90days]
Firebase Account:       Last changed: [Date]    Next change: [Date+90days]
Google Play:            Last changed: [Date]    Next change: [Date+90days]
GitHub:                 Last changed: [Date]    Next change: [Date+90days]
Vercel:                 Last changed: [Date]    Next change: [Date+90days]
Email (Primary):        Last changed: [Date]    Next change: [Date+90days]
```

**Recommended:** Change passwords every 90 days in production

---

## 🔒 BACKUP & RECOVERY

### Where to Save This File

```
✅ Password Manager:
   - 1Password
   - LastPass
   - Bitwarden
   - Dashlane
   
✅ Encrypted Storage:
   - Encrypted USB drive
   - Encrypted hard drive
   - iCloud Keychain (Mac)
   - Windows Credential Manager

❌ NEVER save in:
   - Plain text files on computer
   - Cloud storage (Google Drive, Dropbox)
   - Email
   - Chat applications
   - Notes app
```

### Backup Recovery Instructions

```
If credentials lost:

1. GitHub:
   - Use password recovery via email
   - Create new SSH keys
   
2. Supabase:
   - Use password recovery via email
   - Request database password reset
   - Update all apps with new connection string
   
3. Firebase:
   - Use Google account recovery
   - Download new service account key
   - Update backend environment
   
4. Google Play Store:
   - Use Google account recovery
   - Regenerate upload key (if needed)
   
5. Vercel:
   - Use account recovery via email
   - Create new API token
   - Update CI/CD with new token
```

---

## 📝 SECURITY CHECKLIST

Daily:
- [ ] Computer locked when away
- [ ] VPN enabled (if using public WiFi)
- [ ] Anti-virus software running
- [ ] Browser extensions up-to-date

Weekly:
- [ ] Check for suspicious account activity
- [ ] Verify no unauthorized apps connected
- [ ] Review recent commits on GitHub

Monthly:
- [ ] Check password manager for duplicates
- [ ] Review all connected devices
- [ ] Update all passwords

Quarterly:
- [ ] Change critical passwords (database, admin, API)
- [ ] Review API token expiration dates
- [ ] Test backup & recovery process
- [ ] Review and revoke unused API keys

---

## 🆘 EMERGENCY PROCEDURES

### Account Compromised

```
1. Change password immediately
2. Revoke all API tokens
3. Check account activity logs
4. Disconnect all sessions
5. Enable 2FA if not already enabled
6. Notify team members
7. Review recent code commits
8. Audit all deployed versions
```

### Lost Database Password

```
1. Go to Supabase dashboard
2. Click Settings → Database
3. Find "Reset database password"
4. Enter new password
5. Update all .env files
6. Restart all services
7. Test connections
```

### Leaked API Keys

```
1. Revoke the leaked key immediately
2. Generate new key
3. Update all applications
4. Redeploy with new key
5. Monitor for unauthorized activity
6. Document the incident
7. Review what data was accessed
```

---

## ✅ INITIAL SETUP CHECKLIST

After completing setup guides, verify you have:

- [ ] GitHub account and SSH key
- [ ] Supabase account and database created
- [ ] Database password: AutoLabDB@2024!Secure
- [ ] Connection string saved
- [ ] Firebase project created
- [ ] Service account key downloaded
- [ ] Google Play Developer account
- [ ] App signing keystore file
- [ ] Vercel account created
- [ ] All passwords in password manager
- [ ] Backup copy of critical credentials
- [ ] 2FA enabled on all accounts

---

## 📞 QUICK REFERENCE

### When You Need Connection String:
→ Supabase Dashboard → Settings → Database → Connection strings

### When You Need Firebase Key:
→ Firebase Console → Project Settings → Service Accounts

### When You Need Vercel Token:
→ Vercel Dashboard → Settings → Tokens

### When You Need Google Play Key:
→ Google Play Console → Release → App signing

---

## 🎯 Next Steps

✅ Credentials saved securely!

→ **Next:** `04_EXPRESS_BACKEND.md` (Create backend with API)

Use this vault to find credentials when needed for:
- Backend `.env` configuration
- Frontend `.env.local` configuration
- GitHub Secrets for CI/CD
- Vercel Environment Variables
- Firebase configuration

---

**Last Updated:** April 27, 2026  
**Status:** 🔒 CONFIDENTIAL  
**Keep:** In password manager, NOT in Git, NOT in chat

→ You're securing your application! 🔒

Next: Start building the backend!
