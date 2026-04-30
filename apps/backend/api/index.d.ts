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
declare const app: any;
/**
 * ============================================
 * EXPORT FOR VERCEL
 * ============================================
 */
export default app;
//# sourceMappingURL=index.d.ts.map