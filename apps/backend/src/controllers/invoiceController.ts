import { Response } from 'express';
import { Prisma } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware.js';
import { createNotification } from '../services/notificationService.js';
import prisma from '../config/prisma.js';


const INVOICE_INCLUDE = {
  service: {
    include: {
      items: { orderBy: { created_at: 'asc' as const } },
      vehicle: {
        select: {
          brand: true, model: true, year: true,
          registration_number: true, vehicle_type: true, fuel_type: true,
        },
      },
    },
  },
};

export const invoiceController = {

  // POST /api/invoices — create invoice for a service record
  async create(req: AuthRequest, res: Response) {
    try {
      const { service_id, footer_text, notes } = req.body as {
        service_id: string;
        footer_text?: string;
        notes?: string;
      };

      if (!service_id) {
        return res.status(400).json({ error: 'service_id is required' });
      }

      // Check if invoice already exists for this service
      const existing = await prisma.invoice.findUnique({
        where: { service_id },
        include: INVOICE_INCLUDE,
      });
      if (existing) return res.json(existing);

      // Fetch service record
      const service = await prisma.vehicleService.findUnique({
        where: { id: service_id },
        include: { items: true },
      });
      if (!service) {
        return res.status(404).json({ error: 'Service record not found' });
      }

      // Generate invoice number: INV-<year>-<seq>
      const year = new Date().getFullYear();
      const count = await prisma.invoice.count();
      const invoiceNumber = `INV-${year}-${String(count + 1001).padStart(4, '0')}`;

      const itemsCost = service.items.reduce(
        (sum, i) => sum + Number(i.cost ?? 0), 0
      );

      const invoice = await prisma.invoice.create({
        data: {
          service_id,
          vehicle_id: service.vehicle_id,
          user_id: req.user!.userId,
          invoice_number: invoiceNumber,
          service_date: service.service_date,
          total_cost: new Prisma.Decimal(Number(service.total_cost ?? 0)),
          labour_cost: new Prisma.Decimal(Number(service.labour_cost ?? 0)),
          items_cost: new Prisma.Decimal(itemsCost),
          footer_text: footer_text ?? null,
          notes: notes ?? null,
        },
        include: INVOICE_INCLUDE,
      });

      // 7.8 — notify on invoice ready
      await createNotification({
        userId: req.user!.userId,
        type: 'invoice',
        title: 'Invoice Ready',
        body: `Invoice ${invoiceNumber} has been generated. Total: ₹${Number(service.total_cost ?? 0).toFixed(0)}.`,
        entityType: 'invoice',
        entityId: invoice.id,
      });

      res.status(201).json(invoice);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to create invoice' });
    }
  },

  // GET /api/invoices/service/:serviceId
  async getByServiceId(req: AuthRequest, res: Response) {
    try {
      const invoice = await prisma.invoice.findUnique({
        where: { service_id: req.params.serviceId },
        include: INVOICE_INCLUDE,
      });
      if (!invoice) return res.status(404).json({ error: 'Invoice not found' });
      res.json(invoice);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch invoice' });
    }
  },

  // GET /api/invoices/:id
  async getById(req: AuthRequest, res: Response) {
    try {
      const invoice = await prisma.invoice.findUnique({
        where: { id: req.params.id },
        include: INVOICE_INCLUDE,
      });
      if (!invoice) return res.status(404).json({ error: 'Invoice not found' });
      res.json(invoice);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch invoice' });
    }
  },

  // GET /api/invoices/my — list all invoices for the current user's vehicles
  async listMy(req: AuthRequest, res: Response) {
    try {
      const userId = req.user!.userId;
      const invoices = await prisma.invoice.findMany({
        where: { user_id: userId },
        include: INVOICE_INCLUDE,
        orderBy: { created_at: 'desc' },
      });
      res.json({ invoices });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch invoices' });
    }
  },
};
