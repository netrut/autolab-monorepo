import { Response } from 'express';
import { AuthRequest } from '../middleware/auth.middleware.js';
import { createNotification } from '../services/notificationService.js';
import prisma from '../config/prisma.js';


export const bookingController = {
  async list(req: AuthRequest, res: Response) {
    try {
      const { page = '1', limit = '10', status, search, sort, service_center_id } = req.query as Record<string, string>;
      const pageNum = Math.max(1, parseInt(page));
      const limitNum = Math.min(100, Math.max(1, parseInt(limit)));
      const skip = (pageNum - 1) * limitNum;

      // Scope to vehicles accessible by the logged-in user via vehicle_user_map
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
      if (vehicleIds !== undefined) where.vehicle_id = { in: vehicleIds };
      if (status) where.status = status;
      if (service_center_id) where.service_center_id = service_center_id;
      if (search) {
        where.OR = [
          { service_type: { contains: search, mode: 'insensitive' } },
          { users: { email: { contains: search, mode: 'insensitive' } } },
          { users: { display_name: { contains: search, mode: 'insensitive' } } },
          { vehicles: { brand: { contains: search, mode: 'insensitive' } } },
          { vehicles: { registration_number: { contains: search, mode: 'insensitive' } } }
        ];
      }

      let orderBy: any = { created_at: 'desc' };
      if (sort) {
        try { const [{ id, desc }] = JSON.parse(sort); orderBy = { [id]: desc ? 'desc' : 'asc' }; } catch { /* ignore */ }
      }

      const [bookings, total] = await Promise.all([
        prisma.booking.findMany({
          where, skip, take: limitNum, orderBy,
          include: {
            vehicles: true,
            service_centers: true,
            users: { select: { id: true, email: true, display_name: true } }
          }
        }),
        prisma.booking.count({ where })
      ]);

      res.json({ bookings, total_bookings: total, page: pageNum, limit: limitNum, offset: skip });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch bookings' });
    }
  },

  async getById(req: AuthRequest, res: Response) {
    try {
      const booking = await prisma.booking.findUnique({
        where: { id: req.params.id },
        include: {
          vehicles: true,
          service_centers: true,
          users: { select: { id: true, email: true, display_name: true } }
        }
      });
      if (!booking) return res.status(404).json({ error: 'Booking not found' });
      res.json(booking);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch booking' });
    }
  },

  async create(req: AuthRequest, res: Response) {
    try {
      const { user_id, vehicle_id, service_center_id, service_type, booking_date, notes } = req.body;

      // Use provided user_id (admin dashboard) or fall back to authenticated user
      const bookingUserId = user_id || req.user!.userId;

      const vehicle = await prisma.vehicle.findUnique({ where: { id: vehicle_id } });
      if (!vehicle) return res.status(404).json({ error: 'Vehicle not found' });

      const center = await prisma.serviceCenter.findUnique({ where: { id: service_center_id } });
      if (!center) return res.status(404).json({ error: 'Service center not found' });

      const booking = await prisma.booking.create({
        data: {
          user_id: bookingUserId,
          vehicle_id,
          service_center_id,
          service_type,
          booking_date: new Date(booking_date),
          notes
        },
        include: {
          vehicles: true,
          service_centers: true,
          users: { select: { id: true, email: true, display_name: true } }
        }
      });
      res.status(201).json(booking);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create booking' });
    }
  },

  async update(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.booking.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'Booking not found' });

      const { service_type, booking_date, status, notes } = req.body;
      const booking = await prisma.booking.update({
        where: { id: req.params.id },
        data: {
          ...(service_type !== undefined && { service_type }),
          ...(booking_date !== undefined && { booking_date: new Date(booking_date) }),
          ...(status !== undefined && { status }),
          ...(notes !== undefined && { notes }),
          updated_at: new Date()
        },
        include: {
          vehicles: true,
          service_centers: true,
          users: { select: { id: true, email: true, display_name: true } }
        }
      });
      // 7.8 — notify booking owner on status change
      if (status && status !== existing.status) {
        await createNotification({
          userId: existing.user_id,
          type: 'booking_update',
          title: 'Booking Status Updated',
          body: `Your booking status has been updated to: ${status}.`,
          entityType: 'booking',
          entityId: req.params.id,
        });
      }
      res.json(booking);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update booking' });
    }
  },

  async cancel(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.booking.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'Booking not found' });

      const booking = await prisma.booking.update({
        where: { id: req.params.id },
        data: { status: 'cancelled', updated_at: new Date() }
      });
      res.json({ message: 'Booking cancelled', booking });
    } catch (error) {
      res.status(500).json({ error: 'Failed to cancel booking' });
    }
  }
};
