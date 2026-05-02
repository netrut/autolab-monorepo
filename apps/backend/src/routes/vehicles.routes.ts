import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { vehicleController } from '../controllers/vehicleController.js';

const router: express.Router = express.Router();

router.use(authMiddleware);

router.get('/', vehicleController.list);
router.get('/:id', vehicleController.getById);
router.post('/', vehicleController.create);
router.put('/:id', vehicleController.update);
router.delete('/:id', vehicleController.remove);

export default router;
