/**
 * AutoLab Backend - Vercel entrypoint
 *
 * Vercel scans the package root for an entrypoint file. This wrapper gives it
 * a root-level server file while keeping the actual app implementation in src/index.ts.
 */

import app from './src/index.js';

export default app;