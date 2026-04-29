# 🚀 AutoLab Backend API

Express.js REST API backend for AutoLab application - Optimized for Vercel deployment with single-handler architecture.

## ✨ Key Features

- **Single Express Handler** - All routes consolidated into one Vercel function (no 12-function limit)
- **Complete REST API** - Authentication, bookings, users, services, vehicles endpoints
- **Security First** - Helmet, CORS, rate limiting, JWT authentication, input validation
- **Production Ready** - TypeScript, error handling, logging, comprehensive testing
- **Database Integrated** - Prisma ORM with PostgreSQL (Supabase)
- **Fully Tested** - 11 automated tests, 100% pass rate

## 🏗️ Architecture

### Single Handler Approach
```
Client → Vercel → api/index.ts (Single Function)
                  ├─ Express App
                  ├─ Middleware Stack
                  ├─ Route Matching
                  └─ Response
```

**Why this approach?**
- ✅ Unlimited routes in 1 function
- ✅ Bypasses Vercel's 12-function limit
- ✅ Better performance (single cold start)
- ✅ Simpler deployment

## 📁 Project Structure

```
apps/backend/
├── api/
│   └── index.ts                    ← Vercel Entry Point (Single Handler)
├── src/
│   ├── config/
│   │   ├── env.ts                  ← Environment configuration
│   │   ├── database.ts             ← Database setup
│   │   └── constants.ts            ← Constants
│   ├── controllers/                ← Business logic
│   ├── middleware/                 ← Express middleware
│   ├── routes/                     ← API route definitions
│   ├── services/                   ← External services (Email, SMS, JWT, Redis)
│   ├── types/                      ← TypeScript definitions
│   ├── utils/                      ← Helper functions
│   └── server.ts                   ← Local development server
├── prisma/
│   ├── schema.prisma               ← Database schema
│   ├── migrations/                 ← Database migrations
│   └── seed.ts                     ← Seed script
├── dist/                           ← Compiled output
├── vercel.json                     ← Vercel configuration
├── tsconfig.json                   ← TypeScript config
├── package.json                    ← Dependencies
└── .env                            ← Environment variables
```

## 🔄 Routes

### Authentication (Public)
```
POST   /api/auth/register           Register new user
POST   /api/auth/login              User login
POST   /api/auth/send-otp           Send OTP to phone
POST   /api/auth/verify-otp         Verify OTP
GET    /api/auth/verify-email       Verify email
POST   /api/auth/forgot-password    Request password reset
POST   /api/auth/reset-password     Reset password
```

### Bookings (Protected)
```
GET    /api/bookings                Get user bookings
POST   /api/bookings                Create booking
PUT    /api/bookings/:id            Update booking
DELETE /api/bookings/:id            Cancel booking
```

### Users (Protected)
```
GET    /api/users/profile           Get user profile
PUT    /api/users/profile           Update profile
GET    /api/users/:id               Get user (admin)
DELETE /api/users/profile           Delete account
```

### Services (Public)
```
GET    /api/services                List services
GET    /api/services/:id            Get service
POST   /api/services                Create service (admin)
```

### Vehicles (Protected)
```
GET    /api/vehicles                Get vehicles
POST   /api/vehicles                Add vehicle
PUT    /api/vehicles/:id            Update vehicle
DELETE /api/vehicles/:id            Delete vehicle
```

### Health & Docs
```
GET    /health                      Health check
GET    /                            API documentation
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- pnpm
- PostgreSQL database (Supabase)
- Redis (optional, for caching)

### Installation

```bash
# Install dependencies
pnpm install

# Setup environment variables
cp .env.example .env
# Edit .env with your credentials

# Generate Prisma types
npm run prisma:generate

# Run database migrations
npm run prisma:migrate

# (Optional) Seed database
npm run prisma:seed
```

### Development

```bash
# Start development server
npm run dev

# Server runs on http://localhost:3000
```

### Testing

```bash
# Run API tests
bash TEST_API.sh

# Build for production
npm run build

# Lint code
npm run lint
```

## 🧪 Testing

### Automated Tests
```bash
bash TEST_API.sh
```

**Test Coverage:**
- ✓ Health check endpoint
- ✓ API documentation
- ✓ User registration
- ✓ Login (with email verification check)
- ✓ OTP sending
- ✓ Password reset
- ✓ Route validation
- ✓ Error handling
- ✓ Rate limiting
- ✓ CORS validation
- ✓ Invalid JSON handling

### Manual Testing

```bash
# Health check
curl http://localhost:3000/health

# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "phone": "9876543210",
    "password": "TestPassword123!",
    "name": "Test User"
  }'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123!"
  }'
```

## 📦 Environment Variables

```env
# Database
DATABASE_URL=postgresql://...

# Server
NODE_ENV=development
PORT=3000
API_URL=http://localhost:3000

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRY=7d

# Email (Gmail)
GMAIL_USER=your-email@gmail.com
GMAIL_PASS=your-app-password

# Email (Bravo)
BRAVO_API_KEY=...
BRAVO_MCP_SERVER_API_KEY=...

# SMS (HSP Media Network)
HSP_SMS_USERNAME=...
HSP_SMS_API_KEY=...
HSP_SMS_SENDER=...

# Redis
REDIS_URL=redis://localhost:6379

# CORS URLs
FLUTTER_APP_URL=com.autolab.app
ADMIN_DASHBOARD_URL=http://localhost:3001
PRODUCTION_URL=https://api.autolab.com

# Firebase
FIREBASE_PROJECT_ID=...
FIREBASE_PRIVATE_KEY=...
FIREBASE_CLIENT_EMAIL=...
```

## 🔒 Security Features

- **Helmet** - HTTP security headers
- **CORS** - Cross-origin request validation
- **Rate Limiting** - 100 requests/15 minutes per IP
- **JWT** - Secure token-based authentication
- **Password Hashing** - bcryptjs encryption
- **Input Validation** - Joi schema validation
- **Error Handling** - Secure error messages
- **HTTPS** - Enforced by Vercel

## 📊 Build & Deployment

### Build
```bash
npm run build
# Output: dist/
```

### Local Testing
```bash
npm run dev
bash TEST_API.sh
```

### Deploy to Vercel

**Option A: Automatic (Recommended)**
```bash
git push origin main
# Vercel auto-deploys on push
```

**Option B: Manual**
```bash
vercel --prod
```

### Verify Production
```bash
curl https://your-domain.vercel.app/health
```

## 📚 Documentation

- **[QUICK_START.md](./QUICK_START.md)** - Fast deployment guide
- **[MIGRATION_COMPLETE.md](./MIGRATION_COMPLETE.md)** - Migration summary
- **[VERCEL_MIGRATION_GUIDE.md](./VERCEL_MIGRATION_GUIDE.md)** - Comprehensive guide
- **[TEST_API.sh](./TEST_API.sh)** - Test suite

## 🛠️ npm Scripts

```bash
npm run dev              # Start development server
npm run build            # Build for production
npm run start            # Start production server
npm run prisma:generate  # Generate Prisma types
npm run prisma:migrate   # Run database migrations
npm run prisma:seed      # Seed database
npm run test             # Run tests
npm run lint             # Lint code
```

## 🐛 Troubleshooting

### Build Fails
```bash
npm run build    # Check TypeScript errors
npm run lint     # Check linting errors
```

### Database Connection Error
- Verify `DATABASE_URL` in `.env`
- Check database is accessible
- Verify credentials are correct

### CORS Errors
- Check `CORS_URLS` in environment variables
- Verify client URL is in allowed list

### Rate Limiting
- API allows 100 requests per 15 minutes per IP
- Different IPs have separate limits

### Authentication Fails
- Verify `JWT_SECRET` is set
- Check token format: `Authorization: Bearer <token>`

## 📝 Migration Notes

This backend has been optimized for Vercel deployment:
- ✅ Single Express handler (`api/index.ts`)
- ✅ All routes consolidated
- ✅ No function limit concerns
- ✅ Production ready

**Previous Architecture**: Multiple serverless functions (5-12) exceeding limits
**Current Architecture**: Single handler with unlimited routes

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/feature-name`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/feature-name`
4. Submit pull request

## 📄 License

MIT License - See LICENSE file

## 📞 Support

For issues or questions:
1. Check [QUICK_START.md](./QUICK_START.md)
2. Review [VERCEL_MIGRATION_GUIDE.md](./VERCEL_MIGRATION_GUIDE.md)
3. Run test suite: `bash TEST_API.sh`

---

**Status**: ✅ Production Ready
**Last Updated**: April 29, 2026
**Version**: 1.0.0
**Test Coverage**: 11/11 passing (100%)
