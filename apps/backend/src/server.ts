import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { env } from './config/env';
import authRoutes from './routes/auth.routes';

const app = express();

// Middleware
app.use(helmet());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

app.use(cors({
  origin: [
    env.cors.adminDashboard,
    env.cors.production,
    'http://localhost:3000',
    'http://localhost:3001',
  ],
  credentials: true,
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
});

app.use('/api/', limiter);

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Server is running',
    timestamp: new Date().toISOString(),
    environment: env.server.nodeEnv,
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'AutoLab API - Single Handler',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/auth',
    },
  });
});

// Routes
app.use('/api/auth', authRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.path} does not exist`,
    path: req.path,
  });
});

// Error handling
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
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

// Start server
const PORT = env.server.port || 5000;
app.listen(PORT, () => {
  console.log(`🚀 AutoLab Backend Server`);
  console.log(`📍 Running at http://localhost:${PORT}`);
  console.log(`🌍 Environment: ${env.server.nodeEnv}`);
  console.log(`📊 API Health: http://localhost:${PORT}/health`);
  console.log(`🔐 Auth Routes: http://localhost:${PORT}/api/auth`);
});