import { Response } from 'express';
import { AuthRequest } from '../middleware/auth.middleware.js';
import prisma from '../config/prisma.js';


export const notificationController = {

  // GET /api/notifications
  async list(req: AuthRequest, res: Response) {
    try {
      const { page = '1', limit = '30' } = req.query as Record<string, string>;
      const skip = (parseInt(page) - 1) * parseInt(limit);

      const [notifications, total, unread] = await Promise.all([
        prisma.notification.findMany({
          where: { user_id: req.user!.userId },
          orderBy: { sent_at: 'desc' },
          skip,
          take: parseInt(limit),
        }),
        prisma.notification.count({ where: { user_id: req.user!.userId } }),
        prisma.notification.count({
          where: { user_id: req.user!.userId, is_read: false },
        }),
      ]);

      res.json({ notifications, total, unread_count: unread });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch notifications' });
    }
  },

  // GET /api/notifications/unread-count
  async unreadCount(req: AuthRequest, res: Response) {
    try {
      const count = await prisma.notification.count({
        where: { user_id: req.user!.userId, is_read: false },
      });
      res.json({ count });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch unread count' });
    }
  },

  // PUT /api/notifications/:id/read
  async markRead(req: AuthRequest, res: Response) {
    try {
      await prisma.notification.updateMany({
        where: { id: req.params.id, user_id: req.user!.userId },
        data: { is_read: true, read_at: new Date() },
      });
      res.json({ ok: true });
    } catch (error) {
      res.status(500).json({ error: 'Failed to mark notification as read' });
    }
  },

  // PUT /api/notifications/read-all
  async markAllRead(req: AuthRequest, res: Response) {
    try {
      await prisma.notification.updateMany({
        where: { user_id: req.user!.userId, is_read: false },
        data: { is_read: true, read_at: new Date() },
      });
      res.json({ ok: true });
    } catch (error) {
      res.status(500).json({ error: 'Failed to mark all as read' });
    }
  },
};
