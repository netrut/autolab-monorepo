import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router: express.Router = express.Router();

/**
 * Services Routes
 * Base path: /api/services
 * Services represent maintenance, repairs, customization, etc.
 */

// Mock services data
const mockServices = [
  {
    id: 1,
    name: 'Regular Maintenance',
    description: 'Oil change, filter replacement, fluid checks',
    category: 'maintenance',
    price: 150,
    duration_minutes: 45,
    status: 'active',
    created_at: '2023-01-10T08:00:00Z',
    updated_at: '2024-04-15T14:22:00Z'
  },
  {
    id: 2,
    name: 'Tire Rotation',
    description: 'Rotate tires for even wear',
    category: 'maintenance',
    price: 80,
    duration_minutes: 30,
    status: 'active',
    created_at: '2023-02-05T09:00:00Z',
    updated_at: '2024-04-14T11:45:00Z'
  },
  {
    id: 3,
    name: 'Brake Inspection',
    description: 'Complete brake system inspection and pad replacement if needed',
    category: 'inspection',
    price: 120,
    duration_minutes: 60,
    status: 'active',
    created_at: '2023-03-12T10:30:00Z',
    updated_at: '2024-04-13T16:30:00Z'
  },
  {
    id: 4,
    name: 'Battery Replacement',
    description: 'Replace old battery with new one',
    category: 'repair',
    price: 200,
    duration_minutes: 30,
    status: 'active',
    created_at: '2023-04-18T11:15:00Z',
    updated_at: '2024-04-12T15:00:00Z'
  },
  {
    id: 5,
    name: 'AC Repair',
    description: 'Air conditioning system repair and recharge',
    category: 'repair',
    price: 250,
    duration_minutes: 90,
    status: 'active',
    created_at: '2023-05-22T08:45:00Z',
    updated_at: '2024-04-11T13:20:00Z'
  },
  {
    id: 6,
    name: 'Engine Alignment',
    description: '4-wheel alignment and suspension check',
    category: 'repair',
    price: 180,
    duration_minutes: 75,
    status: 'active',
    created_at: '2023-06-29T14:00:00Z',
    updated_at: '2024-04-10T10:45:00Z'
  },
  {
    id: 7,
    name: 'Custom Paint',
    description: 'Custom paint job and detailing',
    category: 'customization',
    price: 1500,
    duration_minutes: 480,
    status: 'active',
    created_at: '2023-07-15T09:30:00Z',
    updated_at: '2024-04-09T16:15:00Z'
  }
];

// Get all services
router.get('/', (req: any, res: any) => {
  res.json(mockServices);
});

// Get service by ID
router.get('/:id', (req: any, res: any) => {
  const service = mockServices.find(s => s.id === parseInt(req.params.id));
  if (!service) {
    return res.status(404).json({ error: 'Service not found' });
  }
  res.json(service);
});

// Create a new service
router.post('/', (req: any, res: any) => {
  const newService = { id: mockServices.length + 1, ...req.body };
  mockServices.push(newService);
  res.status(201).json(newService);
});

// Update a service
router.put('/:id', (req: any, res: any) => {
  const service = mockServices.find(s => s.id === parseInt(req.params.id));
  if (!service) {
    return res.status(404).json({ error: 'Service not found' });
  }
  Object.assign(service, req.body);
  res.json(service);
});

// Delete service
router.delete('/:id', (req: any, res: any) => {
  const index = mockServices.findIndex(s => s.id === parseInt(req.params.id));
  if (index === -1) {
    return res.status(404).json({ error: 'Service not found' });
  }
  const deleted = mockServices.splice(index, 1);
  res.json({ message: 'Service deleted', service: deleted[0] });
});

export default router;
