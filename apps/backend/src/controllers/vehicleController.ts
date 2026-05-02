import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware.js';

const prisma = new PrismaClient();

export const vehicleController = {
  async list(req: AuthRequest, res: Response) {
    try {
      const vehicles = await prisma.vehicle.findMany({
        where: { user_id: req.user!.userId },
        orderBy: { created_at: 'desc' },
      });
      res.json(vehicles);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicles' });
    }
  },

  async getById(req: AuthRequest, res: Response) {
    try {
      const vehicle = await prisma.vehicle.findFirst({
        where: { id: req.params.id, user_id: req.user!.userId },
      });
      if (!vehicle) return res.status(404).json({ error: 'Vehicle not found' });
      res.json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicle' });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      const vehicle = await prisma.vehicle.create({
        data: { ...req.body, user_id: req.user!.userId },
      });
      res.status(201).json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create vehicle' });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.vehicle.findFirst({
        where: { id: req.params.id, user_id: req.user!.userId },
      });
      if (!existing) return res.status(404).json({ error: 'Vehicle not found' });

      const vehicle = await prisma.vehicle.update({
        where: { id: req.params.id },
        data: req.body,
      });
      res.json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update vehicle' });
    }
  },

  async remove(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.vehicle.findFirst({
        where: { id: req.params.id, user_id: req.user!.userId },
      });
      if (!existing) return res.status(404).json({ error: 'Vehicle not found' });

      await prisma.vehicle.delete({ where: { id: req.params.id } });
      res.json({ message: 'Vehicle deleted' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete vehicle' });
    }
  },
};
