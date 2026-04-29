import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware';

const router: express.Router = express.Router();

/**
 * Vehicles Routes
 * Base path: /api/vehicles
 * All routes require authentication
 */

// Apply authentication middleware to all routes
router.use(authMiddleware);

// Get user's vehicles
// GET /api/vehicles
// router.get('/', vehiclesController.getUserVehicles);

// Get vehicle by ID
// GET /api/vehicles/:id
// router.get('/:id', vehiclesController.getVehicle);

// Add a vehicle
// POST /api/vehicles
// router.post('/', vehiclesController.addVehicle);

// Update vehicle
// PUT /api/vehicles/:id
// router.put('/:id', vehiclesController.updateVehicle);

// Delete vehicle
// DELETE /api/vehicles/:id
// router.delete('/:id', vehiclesController.deleteVehicle);

export default router;
