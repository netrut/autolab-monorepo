/**
 * AutoLab Backend API - Single Handler (moved to src)
 *
 * This file is the same single-handler used for Vercel but relocated
 * under `src/` so the package boundary is clear and imports resolve
 * consistently when compiled to `dist/`.
 */

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { env } from './config/env.js';

// Import all route modules
import authRoutes from './routes/auth.routes.js';
import bookingsRoutes from './routes/bookings.routes.js';
import usersRoutes from './routes/users.routes.js';
import servicesRoutes from './routes/services.routes.js';
import vehiclesRoutes from './routes/vehicles.routes.js';

// Initialize Express app
const app: any = express();

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

// Rate limiters
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => req.path === '/health',
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'Too many authentication attempts, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true,
});

app.use('/api/', apiLimiter);

app.get('/health', (req: any, res: any) => {
  res.json({
    status: 'OK',
    message: 'Server is running',
    timestamp: new Date().toISOString(),
    environment: env.server.nodeEnv,
  });
});

app.get('/', (req: any, res: any) => {
  res.json({
    message: 'AutoLab API - Single Handler (Vercel Compatible)',
    version: '1.0.0',
    description: 'All endpoints consolidated into a single Vercel function',
  });
});

app.use('/api/auth', authLimiter, authRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/services', servicesRoutes);
app.use('/api/vehicles', vehiclesRoutes);

app.use((req: any, res: any) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.path} does not exist`,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });
});

app.use((err: any, req: any, res: any, next: any) => {
  console.error('[ERROR]', { message: err.message, stack: err.stack, path: req.path, method: req.method });
  const statusCode = err.statusCode || err.status || 500;
  const message = err.message || 'Internal server error';
  res.status(statusCode).json({ error: err.name || 'Error', message, ...(env.server.nodeEnv === 'development' && { stack: err.stack }), timestamp: new Date().toISOString() });
});

export default app;
