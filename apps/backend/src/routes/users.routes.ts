import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { userController } from '../controllers/userController.js';

const router: express.Router = express.Router();

router.use(authMiddleware);

// Admin endpoints
router.get('/', userController.list);
router.post('/', userController.create);
router.put('/:id', userController.updateById);
router.delete('/:id', userController.deleteById);

// Profile endpoints (authenticated user's own profile)
router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);
router.delete('/profile', userController.deleteProfile);

// Get by ID
router.get('/:id', userController.getById);

export default router;
