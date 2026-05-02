import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware.js';

const prisma = new PrismaClient();

export const vehicleController = {
  async list(req: AuthRequest, res: Response) {
    try {
      // If user is authenticated, return only their vehicles
      // If not authenticated (dev mode), return all vehicles
      const where = req.user?.userId ? { user_id: req.user.userId } : {};
      
      const vehicles = await prisma.vehicle.findMany({
        where,
        orderBy: { created_at: 'desc' },
      });
      res.json(vehicles);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicles' });
    }
  },

  async getById(req: AuthRequest, res: Response) {
    try {
      const where: any = { id: req.params.id };
      if (req.user?.userId) {
        where.user_id = req.user.userId;
      }

      const vehicle = await prisma.vehicle.findFirst({ where });
      if (!vehicle) return res.status(404).json({ error: 'Vehicle not found' });
      res.json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicle' });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      // Require authentication for create
      if (!req.user?.userId) {
        return res.status(401).json({ error: 'Authentication required to create vehicle' });
      }

      const vehicle = await prisma.vehicle.create({
        data: { ...req.body, user_id: req.user.userId },
      });
      res.status(201).json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create vehicle' });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      // Require authentication for update
      if (!req.user?.userId) {
        return res.status(401).json({ error: 'Authentication required to update vehicle' });
      }

      const existing = await prisma.vehicle.findFirst({
        where: { id: req.params.id, user_id: req.user.userId },
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
      // Require authentication for delete
      if (!req.user?.userId) {
        return res.status(401).json({ error: 'Authentication required to delete vehicle' });
      }

      const existing = await prisma.vehicle.findFirst({
        where: { id: req.params.id, user_id: req.user.userId },
      });
      if (!existing) return res.status(404).json({ error: 'Vehicle not found' });

      await prisma.vehicle.delete({ where: { id: req.params.id } });
      res.json({ message: 'Vehicle deleted' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete vehicle' });
    }
  },
};
