import { Response } from 'express';
import { PrismaClient, Prisma } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware.js';

const prisma = new PrismaClient();

// ── Helpers ───────────────────────────────────────────────────────────────────

function calcServiceStatus(services: { next_service_date: Date | null; service_date: Date }[]): string {
  if (!services.length) return 'no_service';
  const sorted = [...services].sort((a, b) =>
    new Date(b.service_date).getTime() - new Date(a.service_date).getTime()
  );
  const latest = sorted[0];
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (latest.next_service_date) {
    const next = new Date(latest.next_service_date);
    next.setHours(0, 0, 0, 0);
    if (next > today) return 'upcoming';
    if (next <= today) return 'due';
  }

  const lastDate = new Date(latest.service_date);
  lastDate.setHours(0, 0, 0, 0);
  const daysSince = Math.floor((today.getTime() - lastDate.getTime()) / 86400000);
  if (daysSince > 90) return 'due';
  return 'completed';
}

// ── Vehicle Service CRUD ──────────────────────────────────────────────────────

export const vehicleServiceController = {

  // GET /api/vehicle-services/vehicles — list all vehicles with service status
  async listVehiclesWithStatus(req: AuthRequest, res: Response) {
    try {
      const { search, status } = req.query as Record<string, string>;
      const userId = req.user?.userId;

      const where: Prisma.VehicleWhereInput = { is_active: true };
      if (userId) where.user_id = userId;
      if (search) {
        where.OR = [
          { registration_number: { contains: search, mode: 'insensitive' } },
          { brand: { contains: search, mode: 'insensitive' } },
          { model: { contains: search, mode: 'insensitive' } },
        ];
      }

      const vehicles = await prisma.vehicle.findMany({
        where,
        orderBy: { created_at: 'desc' },
        include: {
          vehicle_services: {
            select: { service_date: true, next_service_date: true },
            orderBy: { service_date: 'desc' },
          },
        },
      });

      const result = vehicles.map(v => {
        const serviceStatus = calcServiceStatus(
          v.vehicle_services.map(s => ({
            service_date: s.service_date,
            next_service_date: s.next_service_date,
          }))
        );
        const latest = v.vehicle_services[0] ?? null;
        return {
          id: v.id,
          user_id: v.user_id,
          vehicle_type: v.vehicle_type,
          brand: v.brand,
          model: v.model,
          year: v.year,
          registration_number: v.registration_number,
          vehicle_color: v.vehicle_color,
          fuel_type: v.fuel_type,
          transmission: v.transmission,
          service_status: serviceStatus,
          last_service_date: latest?.service_date ?? null,
          next_service_date: latest?.next_service_date ?? null,
          total_services: v.vehicle_services.length,
        };
      });

      const filtered = status
        ? result.filter(v => v.service_status === status)
        : result;

      res.json({ vehicles: filtered, total: filtered.length });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch vehicles with service status' });
    }
  },

  // GET /api/vehicle-services/:vehicleId — service history for a vehicle
  async getServiceHistory(req: AuthRequest, res: Response) {
    try {
      const { vehicleId } = req.params;
      const { page = '1', limit = '20' } = req.query as Record<string, string>;
      const skip = (parseInt(page) - 1) * parseInt(limit);

      const [services, total] = await Promise.all([
        prisma.vehicleService.findMany({
          where: { vehicle_id: vehicleId },
          orderBy: { service_date: 'desc' },
          skip,
          take: parseInt(limit),
          include: {
            items: { orderBy: { created_at: 'asc' } },
            vehicle: {
              select: { brand: true, model: true, registration_number: true, vehicle_type: true },
            },
          },
        }),
        prisma.vehicleService.count({ where: { vehicle_id: vehicleId } }),
      ]);

      res.json({ services, total, page: parseInt(page), limit: parseInt(limit) });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch service history' });
    }
  },

  // GET /api/vehicle-services/record/:id — single service record
  async getServiceRecord(req: AuthRequest, res: Response) {
    try {
      const service = await prisma.vehicleService.findUnique({
        where: { id: req.params.id },
        include: {
          items: { orderBy: { created_at: 'asc' } },
          vehicle: {
            select: { brand: true, model: true, registration_number: true, vehicle_type: true, fuel_type: true },
          },
        },
      });
      if (!service) return res.status(404).json({ error: 'Service record not found' });
      res.json(service);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch service record' });
    }
  },

  // POST /api/vehicle-services — create new service record
  async createService(req: AuthRequest, res: Response) {
    try {
      const {
        vehicle_id, service_date, next_service_date, odometer_km,
        service_type, labour_cost, notes, status, items,
      } = req.body;

      const userId = req.user?.userId ?? req.body.user_id;
      if (!vehicle_id || !service_date) {
        return res.status(400).json({ error: 'vehicle_id and service_date are required' });
      }

      // Calculate total cost
      const itemsTotal = (items ?? []).reduce(
        (sum: number, item: { cost?: number }) => sum + (Number(item.cost) || 0), 0
      );
      const totalCost = itemsTotal + (Number(labour_cost) || 0);

      const service = await prisma.vehicleService.create({
        data: {
          vehicle_id,
          user_id: userId,
          service_date: new Date(service_date),
          next_service_date: next_service_date ? new Date(next_service_date) : null,
          odometer_km: odometer_km ? new Prisma.Decimal(odometer_km) : null,
          service_type: service_type ?? 'general',
          labour_cost: new Prisma.Decimal(labour_cost ?? 0),
          total_cost: new Prisma.Decimal(totalCost),
          notes: notes ?? null,
          status: status ?? 'completed',
          items: {
            create: (items ?? []).map((item: {
              item_name: string; status: string; cost?: number;
              notes?: string; expiry_date?: string;
            }) => ({
              item_name: item.item_name,
              status: item.status,
              cost: new Prisma.Decimal(item.cost ?? 0),
              notes: item.notes ?? null,
              expiry_date: item.expiry_date ? new Date(item.expiry_date) : null,
            })),
          },
        },
        include: { items: true },
      });

      res.status(201).json(service);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to create service record' });
    }
  },

  // PUT /api/vehicle-services/record/:id — update service record
  async updateService(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      const {
        service_date, next_service_date, odometer_km, service_type,
        labour_cost, notes, status, items,
      } = req.body;

      const existing = await prisma.vehicleService.findUnique({ where: { id } });
      if (!existing) return res.status(404).json({ error: 'Service record not found' });

      const itemsTotal = (items ?? []).reduce(
        (sum: number, item: { cost?: number }) => sum + (Number(item.cost) || 0), 0
      );
      const totalCost = itemsTotal + (Number(labour_cost) || 0);

      // Delete old items and recreate
      await prisma.serviceItem.deleteMany({ where: { service_id: id } });

      const service = await prisma.vehicleService.update({
        where: { id },
        data: {
          service_date: service_date ? new Date(service_date) : undefined,
          next_service_date: next_service_date ? new Date(next_service_date) : null,
          odometer_km: odometer_km ? new Prisma.Decimal(odometer_km) : null,
          service_type: service_type ?? undefined,
          labour_cost: labour_cost !== undefined ? new Prisma.Decimal(labour_cost) : undefined,
          total_cost: new Prisma.Decimal(totalCost),
          notes: notes ?? null,
          status: status ?? undefined,
          updated_at: new Date(),
          items: {
            create: (items ?? []).map((item: {
              item_name: string; status: string; cost?: number;
              notes?: string; expiry_date?: string;
            }) => ({
              item_name: item.item_name,
              status: item.status,
              cost: new Prisma.Decimal(item.cost ?? 0),
              notes: item.notes ?? null,
              expiry_date: item.expiry_date ? new Date(item.expiry_date) : null,
            })),
          },
        },
        include: { items: true },
      });

      res.json(service);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update service record' });
    }
  },

  // DELETE /api/vehicle-services/record/:id
  async deleteService(req: AuthRequest, res: Response) {
    try {
      const existing = await prisma.vehicleService.findUnique({ where: { id: req.params.id } });
      if (!existing) return res.status(404).json({ error: 'Service record not found' });
      await prisma.vehicleService.delete({ where: { id: req.params.id } });
      res.json({ message: 'Service record deleted' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete service record' });
    }
  },

  // GET /api/vehicle-services/catalogue?vehicle_type=car
  async getCatalogue(req: AuthRequest, res: Response) {
    try {
      const { vehicle_type } = req.query as Record<string, string>;
      const where: Prisma.ServiceItemCatalogueWhereInput = { is_active: true };
      if (vehicle_type) {
        where.OR = [{ vehicle_type }, { vehicle_type: 'both' }];
      }
      const items = await prisma.serviceItemCatalogue.findMany({
        where,
        orderBy: [{ category: 'asc' }, { sort_order: 'asc' }],
      });
      res.json({ items });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch catalogue' });
    }
  },

  // GET /api/vehicle-services/upcoming — vehicles with upcoming/due service
  async getUpcoming(req: AuthRequest, res: Response) {
    try {
      const userId = req.user?.userId;
      const today = new Date();
      const in30Days = new Date(today.getTime() + 30 * 86400000);

      const where: Prisma.VehicleServiceWhereInput = {
        next_service_date: { lte: in30Days },
      };
      if (userId) where.user_id = userId;

      const services = await prisma.vehicleService.findMany({
        where,
        orderBy: { next_service_date: 'asc' },
        distinct: ['vehicle_id'],
        include: {
          vehicle: {
            select: { brand: true, model: true, registration_number: true, vehicle_type: true },
          },
        },
      });

      res.json({ services, total: services.length });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch upcoming services' });
    }
  },
};
