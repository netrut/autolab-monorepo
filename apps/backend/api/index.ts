/**
 * AutoLab Backend API - Single Handler
 * 
 * This file serves as the main Vercel serverless function entry point.
 * All routes are consolidated here to bypass the 12-function limit on Hobby plan.
 * Vercel counts this entire Express app as ONE function.
 * 
 * Route Structure:
 * - GET  /health           - Health check
 * - POST /api/auth/*       - Authentication routes
 * - GET  /api/bookings/*   - Bookings routes (expandable)
 * - GET  /api/users/*      - Users routes (expandable)
 * - GET  /api/services/*   - Services routes (expandable)
 * - GET  /api/vehicles/*   - Vehicles routes (expandable)
 */

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { env } from '../src/config/env.js';

// Import all route modules
import authRoutes from '../src/routes/auth.routes.js';
import bookingsRoutes from '../src/routes/bookings.routes.js';
import usersRoutes from '../src/routes/users.routes.js';
import servicesRoutes from '../src/routes/services.routes.js';
import vehiclesRoutes from '../src/routes/vehicles.routes.js';

// Initialize Express app
const app: any = express();

/**
 * ============================================
 * SECURITY & PARSING MIDDLEWARE
 * ============================================
 */

// Security headers
app.use(helmet());

// Body parsing with size limits
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// CORS configuration
app.use(cors({
  origin: [
    env.cors.adminDashboard,
    env.cors.production,
    'http://localhost:3000',
    'http://localhost:3001',
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

/**
 * ============================================
 * RATE LIMITING
 * ============================================
 */

// General rate limiter for API routes
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => req.path === '/health', // Don't rate limit health check
});

// Stricter limiter for auth routes (to prevent brute force attacks)
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // Strict limit for auth endpoints
  message: 'Too many authentication attempts, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Don't count successful requests
});

// Apply general rate limiter to /api routes
app.use('/api/', apiLimiter);

/**
 * ============================================
 * PUBLIC ENDPOINTS
 * ============================================
 */

// Health check endpoint (no rate limiting)
app.get('/health', (req: any, res: any) => {
  res.json({
    status: 'OK',
    message: 'Server is running',
    timestamp: new Date().toISOString(),
    environment: env.server.nodeEnv,
  });
});

// Root endpoint with API documentation
app.get('/', (req: any, res: any) => {
  res.json({
    message: 'AutoLab API - Single Handler (Vercel Compatible)',
    version: '1.0.0',
    description: 'All endpoints consolidated into a single Vercel function',
    endpoints: {
      health: {
        path: '/health',
        method: 'GET',
        public: true,
        description: 'Server health check',
      },
      auth: {
        path: '/api/auth/*',
        methods: ['POST', 'GET'],
        public: true,
        description: 'Authentication endpoints (register, login, verify, etc.)',
      },
      bookings: {
        path: '/api/bookings/*',
        methods: ['GET', 'POST', 'PUT', 'DELETE'],
        protected: true,
        description: 'Bookings management',
      },
      users: {
        path: '/api/users/*',
        methods: ['GET', 'POST', 'PUT', 'DELETE'],
        protected: true,
        description: 'User management',
      },
      services: {
        path: '/api/services/*',
        methods: ['GET', 'POST'],
        public: true,
        description: 'Service catalog',
      },
      vehicles: {
        path: '/api/vehicles/*',
        methods: ['GET', 'POST', 'PUT'],
        protected: true,
        description: 'Vehicle management',
      },
    },
  });
});

/**
 * ============================================
 * AUTHENTICATED API ROUTES
 * All routes consolidated into this single handler
 * ============================================
 */

// Authentication routes (less strict rate limiting)
app.use('/api/auth', authLimiter, authRoutes);

// Bookings routes
app.use('/api/bookings', bookingsRoutes);

// Users routes
app.use('/api/users', usersRoutes);

// Services routes
app.use('/api/services', servicesRoutes);

// Vehicles routes
app.use('/api/vehicles', vehiclesRoutes);

/**
 * ============================================
 * ERROR HANDLING
 * ============================================
 */

// 404 handler - must be after all routes
app.use((req: any, res: any) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.path} does not exist`,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
    hint: 'Check the root (GET /) endpoint for available routes',
  });
});

// Global error handler - must be last
app.use((err: any, req: any, res: any, next: any) => {
  console.error('[ERROR]', {
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });

  const statusCode = err.statusCode || err.status || 500;
  const message = err.message || 'Internal server error';

  res.status(statusCode).json({
    error: err.name || 'Error',
    message: message,
    ...(env.server.nodeEnv === 'development' && { stack: err.stack }),
    timestamp: new Date().toISOString(),
  });
});

/**
 * ============================================
 * EXPORT FOR VERCEL
 * ============================================
 */

// Export as default for Vercel serverless function
export default app;

/**
 * ============================================
 * LOCAL DEVELOPMENT SERVER
 * ============================================
 * 
 * For local development, run: npm run dev
 * This will start the Express server on PORT 5000
 */

if (import.meta.url === `file://${process.argv[1]}`){
  const PORT = env.server.port || 5000;
  app.listen(PORT, () => {
    console.log('\n🚀 AutoLab Backend Server Started');
    console.log('═'.repeat(50));
    console.log(`📍 Running at http://localhost:${PORT}`);
    console.log(`🌍 Environment: ${env.server.nodeEnv}`);
    console.log(`📊 Health Check: http://localhost:${PORT}/health`);
    console.log(`📚 API Docs: http://localhost:${PORT}/`);
    console.log('═'.repeat(50));
    console.log('\n✅ Ready to accept requests\n');
  });
}
