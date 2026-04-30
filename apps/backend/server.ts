/**
 * AutoLab Backend - Vercel entrypoint
 *
 * Vercel scans the package root for an entrypoint file. This wrapper gives it
 * a root-level server file while keeping the actual app implementation in api/index.ts.
 */

import app from './api/index';

export default app;