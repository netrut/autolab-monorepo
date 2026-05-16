import * as dotenv from 'dotenv';

dotenv.config();

const requiredEnvVars = [
  'DATABASE_URL',
  'JWT_SECRET',
  'BRAVO_API_KEY',
];

requiredEnvVars.forEach((envVar) => {
  if (!process.env[envVar]) {
    throw new Error(`Missing required environment variable: ${envVar}`);
  }
});

export const env = {
  database: {
    url: process.env.DATABASE_URL!,
  },
  server: {
    nodeEnv: process.env.NODE_ENV || 'development',
    port: parseInt(process.env.PORT || '3000'),
    apiUrl: process.env.API_URL || 'http://localhost:3000',
  },
  jwt: {
    secret: process.env.JWT_SECRET!,
    expiry: process.env.JWT_EXPIRY || '7d',
  },
  email: {
    brevo: {
      apiKey: process.env.BRAVO_API_KEY!,
      senderEmail: process.env.BREVO_SENDER_EMAIL || 'autolabstation@gmail.com',
      senderName: process.env.BREVO_SENDER_NAME || 'AutoLab',
    },
  },
  sms: {
    hsp: {
      username: process.env.HSP_SMS_USERNAME || '',
      apiKey: process.env.HSP_SMS_API_KEY || '',
      senderName: process.env.HSP_SMS_SENDER || 'AUTOLAB',
    },
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  cors: {
    flutterApp: process.env.FLUTTER_APP_URL || 'com.autolab.app',
    adminDashboard: process.env.DASHBOARD_URL || 'http://localhost:3001',
    production: process.env.PRODUCTION_URL || 'https://api.autolab.com',
  },
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID || '',
    privateKey: process.env.FIREBASE_PRIVATE_KEY || '',
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL || '',
  },
};
