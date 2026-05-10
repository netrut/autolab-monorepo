import express from 'express';
import { authMiddleware, optionalAuthMiddleware } from '../middleware/auth.middleware.js';
import { vehicleServiceController } from '../controllers/vehicleServiceController.js';

const router: express.Router = express.Router();

// Public/optional auth
router.get('/catalogue', optionalAuthMiddleware, vehicleServiceController.getCatalogue);

// Protected
router.get('/vehicles', authMiddleware, vehicleServiceController.listVehiclesWithStatus);
router.get('/upcoming', authMiddleware, vehicleServiceController.getUpcoming);
router.get('/record/:id', authMiddleware, vehicleServiceController.getServiceRecord);
router.get('/:vehicleId', authMiddleware, vehicleServiceController.getServiceHistory);
router.post('/', authMiddleware, vehicleServiceController.createService);
router.put('/record/:id', authMiddleware, vehicleServiceController.updateService);
router.delete('/record/:id', authMiddleware, vehicleServiceController.deleteService);

export default router;
