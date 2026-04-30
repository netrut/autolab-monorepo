import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router: express.Router = express.Router();

/**
 * Vehicles Routes
 * Base path: /api/vehicles
 * All routes require authentication
 */

// Mock vehicle data
const mockVehicles = [
  {
    id: 1,
    user_id: 1,
    brand: 'Toyota',
    model: 'Camry',
    year: 2022,
    license_plate: 'ABC123',
    vin: 'JTKBE26K759033278',
    color: 'Silver',
    mileage: 15420,
    status: 'active',
    created_at: '2023-05-10T08:30:00Z',
    updated_at: '2024-04-15T14:22:00Z'
  },
  {
    id: 2,
    user_id: 1,
    brand: 'Honda',
    model: 'Civic',
    year: 2021,
    license_plate: 'XYZ789',
    vin: '2HGCV51K95H608285',
    color: 'Red',
    mileage: 28650,
    status: 'active',
    created_at: '2023-06-15T10:45:00Z',
    updated_at: '2024-04-14T11:45:00Z'
  },
  {
    id: 3,
    user_id: 2,
    brand: 'Tesla',
    model: 'Model 3',
    year: 2023,
    license_plate: 'EV123',
    vin: '5YJ3E1EA5KF123456',
    color: 'Black',
    mileage: 8200,
    status: 'active',
    created_at: '2023-07-20T09:15:00Z',
    updated_at: '2024-04-13T16:30:00Z'
  },
  {
    id: 4,
    user_id: 2,
    brand: 'Ford',
    model: 'Mustang',
    year: 2020,
    license_plate: 'MUSCLE1',
    vin: '1ZVBP8CF5LF101234',
    color: 'Blue',
    mileage: 42100,
    status: 'maintenance',
    created_at: '2023-08-10T13:20:00Z',
    updated_at: '2024-02-28T10:15:00Z'
  }
];

// List all vehicles
router.get('/', (req: any, res: any) => {
  res.json(mockVehicles);
});

// Get vehicle by ID
router.get('/:id', (req: any, res: any) => {
  const vehicle = mockVehicles.find(v => v.id === parseInt(req.params.id));
  if (!vehicle) {
    return res.status(404).json({ error: 'Vehicle not found' });
  }
  res.json(vehicle);
});

// Add a vehicle
router.post('/', (req: any, res: any) => {
  const newVehicle = { id: mockVehicles.length + 1, ...req.body };
  mockVehicles.push(newVehicle);
  res.status(201).json(newVehicle);
});

// Update vehicle
router.put('/:id', (req: any, res: any) => {
  const vehicle = mockVehicles.find(v => v.id === parseInt(req.params.id));
  if (!vehicle) {
    return res.status(404).json({ error: 'Vehicle not found' });
  }
  Object.assign(vehicle, req.body);
  res.json(vehicle);
});

// Delete vehicle
router.delete('/:id', (req: any, res: any) => {
  const index = mockVehicles.findIndex(v => v.id === parseInt(req.params.id));
  if (index === -1) {
    return res.status(404).json({ error: 'Vehicle not found' });
  }
  const deleted = mockVehicles.splice(index, 1);
  res.json({ message: 'Vehicle deleted', vehicle: deleted[0] });
});

export default router;
