import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware.js';
import bcryptjs from 'bcryptjs';

const prisma = new PrismaClient();

const USER_SELECT = {
  id: true, email: true, phone_number: true, display_name: true,
  avatar_url: true, role_id: true, is_active: true, created_at: true, updated_at: true
};

export const userController = {
  async list(req: AuthRequest, res: Response) {
    try {
      const { page = '1', limit = '10', search, role, sort } = req.query as Record<string, string>;
      const pageNum = Math.max(1, parseInt(page));
      const limitNum = Math.min(100, Math.max(1, parseInt(limit)));
      const skip = (pageNum - 1) * limitNum;

      const where: any = {};
      if (search) {
        where.OR = [
          { email: { contains: search, mode: 'insensitive' } },
          { display_name: { contains: search, mode: 'insensitive' } },
          { phone_number: { contains: search, mode: 'insensitive' } }
        ];
      }
      if (role) where.role_id = parseInt(role) || role;

      let orderBy: any = { created_at: 'desc' };
      if (sort) {
        try { const [{ id, desc }] = JSON.parse(sort); orderBy = { [id]: desc ? 'desc' : 'asc' }; } catch { /* ignore */ }
      }

      const [users, total] = await Promise.all([
        prisma.user.findMany({ where, skip, take: limitNum, orderBy, select: USER_SELECT }),
        prisma.user.count({ where })
      ]);

      res.json({ users, total_users: total, page: pageNum, limit: limitNum, offset: skip });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch users' });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      const { email, phone_number, display_name, password, role_id, is_active } = req.body;
      const existing = await prisma.user.findFirst({ where: { email } });
      if (existing) return res.status(400).json({ error: 'User with this email already exists' });

      const password_hash = password ? await bcryptjs.hash(password, 10) : await bcryptjs.hash('AutoLab@2024', 10);
      const user = await prisma.user.create({
        data: { email, phone_number, display_name, password_hash, role_id: role_id ?? 2, is_active: is_active ?? true },
        select: USER_SELECT
      });
      res.status(201).json(user);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create user' });
    }
  },

  async updateById(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.user.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'User not found' });

      const { display_name, phone_number, avatar_url, role_id, is_active } = req.body;
      const user = await prisma.user.update({
        where: { id: req.params.id },
        data: {
          ...(display_name !== undefined && { display_name }),
          ...(phone_number !== undefined && { phone_number }),
          ...(avatar_url !== undefined && { avatar_url }),
          ...(role_id !== undefined && { role_id }),
          ...(is_active !== undefined && { is_active }),
          updated_at: new Date()
        },
        select: USER_SELECT
      });
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update user' });
    }
  },

  async deleteById(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.user.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'User not found' });
      await prisma.user.delete({ where: { id: req.params.id } });
      res.json({ message: 'User deleted successfully' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete user' });
    }
  },

  async getProfile(req: AuthRequest, res: Response) {
    try {
      const user = await prisma.user.findUnique({
        where: { id: req.user!.userId },
        select: { ...USER_SELECT, bio: true, address: true }
      });
      if (!user) return res.status(404).json({ error: 'User not found' });
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch profile' });
    }
  },

  async updateProfile(req: AuthRequest, res: Response) {
    try {
      const { display_name, phone_number, avatar_url, bio, address } = req.body;
      const user = await prisma.user.update({
        where: { id: req.user!.userId },
        data: {
          ...(display_name !== undefined && { display_name }),
          ...(phone_number !== undefined && { phone_number }),
          ...(avatar_url !== undefined && { avatar_url }),
          ...(bio !== undefined && { bio }),
          ...(address !== undefined && { address }),
          updated_at: new Date()
        },
        select: USER_SELECT
      });
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update profile' });
    }
  },

  async deleteProfile(req: AuthRequest, res: Response) {
    try {
      await prisma.user.delete({ where: { id: req.user!.userId } });
      res.json({ message: 'Account deleted' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete account' });
    }
  },

  async getById(req: AuthRequest, res: Response) {
    try {
      const user = await prisma.user.findUnique({ where: { id: req.params.id }, select: USER_SELECT });
      if (!user) return res.status(404).json({ error: 'User not found' });
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch user' });
    }
  }
};
