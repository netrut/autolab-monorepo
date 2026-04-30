import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router: express.Router = express.Router();

/**
 * Users Routes
 * Base path: /api/users
 * Most routes require authentication
 */

// Mock user data
const mockUsers = [
  {
    id: 1,
    first_name: 'John',
    last_name: 'Doe',
    email: 'john.doe@example.com',
    phone: '+1-555-0123',
    role: 'Admin',
    status: 'Active',
    created_at: '2023-01-15T10:30:00Z',
    updated_at: '2024-04-15T14:22:00Z'
  },
  {
    id: 2,
    first_name: 'Jane',
    last_name: 'Smith',
    email: 'jane.smith@example.com',
    phone: '+1-555-0456',
    role: 'Technician',
    status: 'Active',
    created_at: '2023-02-20T09:15:00Z',
    updated_at: '2024-04-14T11:45:00Z'
  },
  {
    id: 3,
    first_name: 'Michael',
    last_name: 'Johnson',
    email: 'michael.j@example.com',
    phone: '+1-555-0789',
    role: 'Manager',
    status: 'Active',
    created_at: '2023-03-10T08:00:00Z',
    updated_at: '2024-04-13T16:30:00Z'
  },
  {
    id: 4,
    first_name: 'Sarah',
    last_name: 'Williams',
    email: 'sarah.williams@example.com',
    phone: '+1-555-1011',
    role: 'Customer',
    status: 'Inactive',
    created_at: '2023-04-05T12:45:00Z',
    updated_at: '2024-03-20T10:15:00Z'
  }
];

// List all users
router.get('/', (req: any, res: any) => {
  res.json(mockUsers);
});

// Get user by ID
router.get('/:id', (req: any, res: any) => {
  const user = mockUsers.find(u => u.id === parseInt(req.params.id));
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.json(user);
});

// Get user profile
router.get('/profile', authMiddleware, (req: any, res: any) => {
  res.json(mockUsers[0]);
});

// Update user profile
router.put('/profile', authMiddleware, (req: any, res: any) => {
  res.json({ success: true, message: 'Profile updated' });
});

// Delete user account
router.delete('/profile', authMiddleware, (req: any, res: any) => {
  res.json({ success: true, message: 'Account deleted' });
});

export default router;
