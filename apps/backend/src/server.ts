/**
 * AutoLab Backend - Local Development Server
 * 
 * This file starts the Express server for local development.
 * It imports the main app from api/index.ts
 */

import app from './index.js';
import { env } from './config/env.js';

const PORT = env.server.port || 3000;

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
