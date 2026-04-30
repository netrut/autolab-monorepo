import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router: express.Router = express.Router();

/**
 * Users Routes
 * Base path: /api/users
 * Most routes require authentication
 */

// Get user profile
// GET /api/users/profile
// router.get('/profile', authMiddleware, usersController.getProfile);

// Update user profile
// PUT /api/users/profile
// router.put('/profile', authMiddleware, usersController.updateProfile);

// Get user by ID (admin only)
// GET /api/users/:id
// router.get('/:id', authMiddleware, adminMiddleware, usersController.getUserById);

// List all users (admin only)
// GET /api/users
// router.get('/', authMiddleware, adminMiddleware, usersController.listUsers);

// Delete user account
// DELETE /api/users/profile
// router.delete('/profile', authMiddleware, usersController.deleteAccount);

export default router;
