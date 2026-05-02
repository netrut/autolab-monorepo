import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import { AuthRequest } from "../middleware/auth.middleware.js";

const prisma = new PrismaClient();

export const serviceCenterController = {
  async list(req: Request, res: Response) {
    try {
      const { page = '1', limit = '10', city, is_verified, search, sort } = req.query as Record<string, string>;
      const pageNum = Math.max(1, parseInt(page));
      const limitNum = Math.min(100, Math.max(1, parseInt(limit)));
      const skip = (pageNum - 1) * limitNum;

      const where: any = {};
      if (city) where.city = city;
      if (is_verified !== undefined) where.is_verified = is_verified === 'true';
      if (search) {
        where.OR = [
          { name: { contains: search, mode: 'insensitive' } },
          { city: { contains: search, mode: 'insensitive' } },
          { email: { contains: search, mode: 'insensitive' } }
        ];
      }

      let orderBy: any = { rating: 'desc' };
      if (sort) {
        try { const [{ id, desc }] = JSON.parse(sort); orderBy = { [id]: desc ? 'desc' : 'asc' }; } catch { /* ignore */ }
      }

      const [centers, total] = await Promise.all([
        prisma.serviceCenter.findMany({ where, skip, take: limitNum, orderBy }),
        prisma.serviceCenter.count({ where })
      ]);

      res.json({ centers, total_centers: total, page: pageNum, limit: limitNum, offset: skip });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch service centers' });
    }
  },

  async getById(req: Request, res: Response) {
    try {
      const center = await prisma.serviceCenter.findUnique({
        where: { id: req.params.id },
      });
      if (!center) return res.status(404).json({ error: "Service center not found" });
      res.json(center);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch service center" });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      const center = await prisma.serviceCenter.create({ data: req.body });
      res.status(201).json(center);
    } catch (error) {
      res.status(500).json({ error: "Failed to create service center" });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.serviceCenter.findUnique({
        where: { id: req.params.id },
      });
      if (!existing) return res.status(404).json({ error: "Service center not found" });

      const center = await prisma.serviceCenter.update({
        where: { id: req.params.id },
        data: { ...req.body, updated_at: new Date() },
      });
      res.json(center);
    } catch (error) {
      res.status(500).json({ error: "Failed to update service center" });
    }
  },

  async remove(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.serviceCenter.findUnique({
        where: { id: req.params.id },
      });
      if (!existing) return res.status(404).json({ error: "Service center not found" });

      await prisma.serviceCenter.update({
        where: { id: req.params.id },
        data: { is_active: false, updated_at: new Date() },
      });
      res.json({ message: "Service center deactivated" });
    } catch (error) {
      res.status(500).json({ error: "Failed to delete service center" });
    }
  },
};
