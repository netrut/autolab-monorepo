import { Response } from "express";
import { PrismaClient } from "@prisma/client";
import { AuthRequest } from "../middleware/auth.middleware.js";
import prisma from '../config/prisma.js';


export const vehicleController = {
  async list(req: AuthRequest, res: Response) {
    try {
      const { page = '1', limit = '10', search, status, sort } = req.query as Record<string, string>;
      const pageNum = Math.max(1, parseInt(page));
      const limitNum = Math.min(100, Math.max(1, parseInt(limit)));
      const skip = (pageNum - 1) * limitNum;

      // Scope to vehicles mapped to this user in vehicle_user_map
      const userId = req.user?.userId;
      let vehicleIds: string[] | undefined;
      if (userId) {
        const maps = await prisma.vehicleUserMap.findMany({
          where: { user_id: userId },
          select: { vehicle_id: true },
        });
        vehicleIds = maps.map(m => m.vehicle_id);
      }

      const where: any = {};
      if (vehicleIds !== undefined) where.id = { in: vehicleIds };
      if (status) where.is_active = status === 'active';
      if (search) {
        where.OR = [
          { brand: { contains: search, mode: 'insensitive' } },
          { model: { contains: search, mode: 'insensitive' } },
          { registration_number: { contains: search, mode: 'insensitive' } }
        ];
      }

      let orderBy: any = { created_at: 'desc' };
      if (sort) {
        try { const [{ id, desc }] = JSON.parse(sort); orderBy = { [id]: desc ? 'desc' : 'asc' }; } catch { /* ignore */ }
      }

      const [vehicles, total] = await Promise.all([
        prisma.vehicle.findMany({
          where, skip, take: limitNum, orderBy,
          include: { users: { select: { id: true, email: true, display_name: true } } }
        }),
        prisma.vehicle.count({ where })
      ]);

      res.json({ vehicles, total_vehicles: total, page: pageNum, limit: limitNum, offset: skip });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicles' });
    }
  },

  async getById(req: AuthRequest, res: Response) {
    try {
      const vehicle = await prisma.vehicle.findUnique({ where: { id: req.params.id } });
      if (!vehicle) return res.status(404).json({ error: 'Vehicle not found' });
      res.json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicle' });
    }
  },

  async lookupByReg(req: AuthRequest, res: Response) {
    try {
      const reg = (req.query.reg as string)?.trim().toUpperCase();
      if (!reg) return res.status(400).json({ error: 'reg query param required' });
      const vehicle = await prisma.vehicle.findFirst({
        where: { registration_number: { equals: reg, mode: 'insensitive' } },
        select: { id: true, brand: true, model: true, vehicle_type: true, registration_number: true, user_id: true }
      });
      if (!vehicle) return res.json({ exists: false });
      res.json({ exists: true, vehicle });
    } catch (error) {
      res.status(500).json({ error: 'Lookup failed' });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      const vehicle = await prisma.vehicle.create({
        data: { ...req.body, user_id: req.body.user_id || req.user?.userId }
      });

      // Auto-add creator to vehicle_user_map as owner
      const ownerId = vehicle.user_id;
      await prisma.vehicleUserMap.upsert({
        where: { vehicle_id_user_id: { vehicle_id: vehicle.id, user_id: ownerId } },
        create: { vehicle_id: vehicle.id, user_id: ownerId, role: 'owner' },
        update: { role: 'owner' },
      });

      res.status(201).json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create vehicle' });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.vehicle.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'Vehicle not found' });
      const vehicle = await prisma.vehicle.update({
        where: { id: req.params.id },
        data: { ...req.body, updated_at: new Date() }
      });
      res.json(vehicle);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update vehicle' });
    }
  },

  async remove(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.vehicle.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'Vehicle not found' });
      await prisma.vehicle.update({
        where: { id: req.params.id },
        data: { is_active: false, updated_at: new Date() }
      });
      res.json({ message: 'Vehicle deactivated' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to deactivate vehicle' });
    }
  },
};
