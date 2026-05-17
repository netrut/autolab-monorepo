import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { userPreferencesController } from '../controllers/userPreferencesController.js';

const router: express.Router = express.Router();

router.get('/', authMiddleware, userPreferencesController.get);
router.put('/', authMiddleware, userPreferencesController.update);

export default router;
