import express from 'express';

const router: express.Router = express.Router();

/**
 * Services Routes
 * Base path: /api/services
 * Public routes for browsing services
 */

// List all available services
// GET /api/services
// router.get('/', servicesController.listServices);

// Get service by ID
// GET /api/services/:id
// router.get('/:id', servicesController.getService);

// Search services
// GET /api/services/search?q=...
// router.get('/search', servicesController.searchServices);

export default router;
