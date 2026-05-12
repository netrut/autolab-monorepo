import { PrismaClient } from '@prisma/client';

// Single shared instance — prevents connection pool exhaustion on Supabase
// log: warn + error only in production to reduce noise
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['warn', 'error'] : ['error'],
});

// Graceful disconnect on unexpected termination
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

export default prisma;
