import { Response } from 'express';
import { AuthRequest } from '../middleware/auth.middleware.js';
import prisma from '../config/prisma.js';

export const userPreferencesController = {
  async get(req: AuthRequest, res: Response) {
    try {
      const userId = req.user!.userId;
      let prefs = await prisma.userPreference.findUnique({ where: { user_id: userId } });
      if (!prefs) {
        prefs = await prisma.userPreference.create({ data: { user_id: userId } });
      }
      res.json(prefs);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch preferences' });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      const userId = req.user!.userId;
      const allowed = [
        'notify_service_reminder', 'notify_booking_updates',
        'notify_parts_expiry', 'notify_join_requests',
        'reminder_days_before', 'default_vehicle_type', 'dark_mode',
      ];
      const data: any = {};
      for (const key of allowed) {
        if (req.body[key] !== undefined) data[key] = req.body[key];
      }
      const prefs = await prisma.userPreference.upsert({
        where: { user_id: userId },
        update: { ...data, updated_at: new Date() },
        create: { user_id: userId, ...data },
      });
      res.json(prefs);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update preferences' });
    }
  },
};
