import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router: express.Router = express.Router();

/**
 * Bookings Routes
 * Base path: /api/bookings
 * All routes require authentication
 */

// Apply authentication middleware to all routes
router.use(authMiddleware);

// Get all bookings for the authenticated user
// GET /api/bookings
// router.get('/', bookingsController.getUserBookings);

// Get a specific booking
// GET /api/bookings/:id
// router.get('/:id', bookingsController.getBooking);

// Create a new booking
// POST /api/bookings
// router.post('/', bookingsController.createBooking);

// Update a booking
// PUT /api/bookings/:id
// router.put('/:id', bookingsController.updateBooking);

// Cancel a booking
// DELETE /api/bookings/:id
// router.delete('/:id', bookingsController.cancelBooking);

export default router;
