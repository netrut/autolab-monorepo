import { Response } from 'express';
import { AuthRequest } from '../middleware/auth.middleware.js';
import { createNotification } from '../services/notificationService.js';
import prisma from '../config/prisma.js';


const REQUEST_SELECT = {
  id: true, type: true, from_user_id: true, to_user_id: true,
  entity_type: true, entity_id: true, role: true, status: true,
  message: true, created_at: true, updated_at: true,
  from_user: { select: { id: true, display_name: true, email: true } },
  to_user:   { select: { id: true, display_name: true, email: true } },
};

export const requestController = {

  // POST /api/requests — send a request
  async send(req: AuthRequest, res: Response) {
    try {
      const { type, to_user_id, entity_type, entity_id, role, message } = req.body;
      const from_user_id = req.user!.userId;

      if (!type || !entity_type || !entity_id) {
        return res.status(400).json({ error: 'type, entity_type, entity_id are required' });
      }

      // Resolve to_user_id automatically for service_center joins
      let resolved_to_user_id = to_user_id ?? null;
      if (entity_type === 'service_center' && !resolved_to_user_id) {
        const center = await prisma.serviceCenter.findUnique({
          where: { id: entity_id },
          select: { owner_user_id: true },
        });
        resolved_to_user_id = center?.owner_user_id ?? null;
      }

      // Prevent duplicate pending requests
      const existing = await prisma.request.findFirst({
        where: { from_user_id, entity_type, entity_id, status: 'pending' },
      });
      if (existing) return res.json(existing);

      const request = await prisma.request.create({
        data: { type, from_user_id, to_user_id: resolved_to_user_id,
                entity_type, entity_id, role: role ?? 'user',
                message: message ?? null },
        select: REQUEST_SELECT,
      });

      // 7.8 — notify recipient if known
      if (resolved_to_user_id) {
        await createNotification({
          userId: resolved_to_user_id,
          type: 'request',
          title: 'New Access Request',
          body: `Someone has requested ${entity_type === 'vehicle' ? 'vehicle access' : 'to join your service centre'}.`,
          requestId: request.id,
          entityType: entity_type,
          entityId: entity_id,
        });
      }

      res.status(201).json(request);
    } catch (error) {
      res.status(500).json({ error: 'Failed to send request' });
    }
  },

  // GET /api/requests/received — requests sent TO the current user
  async listReceived(req: AuthRequest, res: Response) {
    try {
      const { status } = req.query as Record<string, string>;
      const where: any = { to_user_id: req.user!.userId };
      if (status) where.status = status;
      const requests = await prisma.request.findMany({
        where, orderBy: { created_at: 'desc' }, select: REQUEST_SELECT,
      });
      res.json({ requests });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch received requests' });
    }
  },

  // GET /api/requests/sent — requests sent BY the current user
  async listSent(req: AuthRequest, res: Response) {
    try {
      const { status } = req.query as Record<string, string>;
      const where: any = { from_user_id: req.user!.userId };
      if (status) where.status = status;
      const requests = await prisma.request.findMany({
        where, orderBy: { created_at: 'desc' }, select: REQUEST_SELECT,
      });
      res.json({ requests });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch sent requests' });
    }
  },

  // GET /api/requests/pending-count — count of pending received requests
  async pendingCount(req: AuthRequest, res: Response) {
    try {
      const count = await prisma.request.count({
        where: { to_user_id: req.user!.userId, status: 'pending' },
      });
      res.json({ count });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch pending count' });
    }
  },

  // PUT /api/requests/:id/accept — 6.9: accept + update map tables
  async accept(req: AuthRequest, res: Response) {
    try {
      const request = await prisma.request.findUnique({ where: { id: req.params.id } });
      if (!request) return res.status(404).json({ error: 'Request not found' });
      if (request.to_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised to accept this request' });
      }

      // Update request status
      const updated = await prisma.request.update({
        where: { id: req.params.id },
        data: { status: 'accepted', updated_at: new Date() },
        select: REQUEST_SELECT,
      });

      // 6.9 — update the appropriate map table
      if (request.entity_type === 'vehicle') {
        await prisma.vehicleUserMap.upsert({
          where: { vehicle_id_user_id: { vehicle_id: request.entity_id, user_id: request.from_user_id } },
          create: { vehicle_id: request.entity_id, user_id: request.from_user_id, role: request.role },
          update: { role: request.role },
        });
      } else if (request.entity_type === 'service_center') {
        await prisma.serviceCenterUserMap.upsert({
          where: { service_center_id_user_id: { service_center_id: request.entity_id, user_id: request.from_user_id } },
          create: { service_center_id: request.entity_id, user_id: request.from_user_id, role: request.role },
          update: { role: request.role },
        });
      }

      // 7.8 — notify sender of acceptance
      await createNotification({
        userId: request.from_user_id,
        type: 'request',
        title: 'Request Accepted',
        body: `Your ${request.entity_type === 'vehicle' ? 'vehicle access' : 'service centre join'} request was accepted.`,
        requestId: request.id,
        entityType: request.entity_type,
        entityId: request.entity_id,
      });

      res.json(updated);
    } catch (error) {
      res.status(500).json({ error: 'Failed to accept request' });
    }
  },

  // PUT /api/requests/:id/reject
  async reject(req: AuthRequest, res: Response) {
    try {
      const request = await prisma.request.findUnique({ where: { id: req.params.id } });
      if (!request) return res.status(404).json({ error: 'Request not found' });
      if (request.to_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised' });
      }
      const updated = await prisma.request.update({
        where: { id: req.params.id },
        data: { status: 'rejected', updated_at: new Date() },
        select: REQUEST_SELECT,
      });

      // 7.8 — notify sender of rejection
      await createNotification({
        userId: request.from_user_id,
        type: 'request',
        title: 'Request Rejected',
        body: `Your ${request.entity_type === 'vehicle' ? 'vehicle access' : 'service centre join'} request was rejected.`,
        requestId: request.id,
        entityType: request.entity_type,
        entityId: request.entity_id,
      });

      res.json(updated);
    } catch (error) {
      res.status(500).json({ error: 'Failed to reject request' });
    }
  },

  // PUT /api/requests/:id/cancel — sender cancels their own pending request
  async cancel(req: AuthRequest, res: Response) {
    try {
      const request = await prisma.request.findUnique({ where: { id: req.params.id } });
      if (!request) return res.status(404).json({ error: 'Request not found' });
      if (request.from_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised' });
      }
      const updated = await prisma.request.update({
        where: { id: req.params.id },
        data: { status: 'cancelled', updated_at: new Date() },
        select: REQUEST_SELECT,
      });
      res.json(updated);
    } catch (error) {
      res.status(500).json({ error: 'Failed to cancel request' });
    }
  },
};
