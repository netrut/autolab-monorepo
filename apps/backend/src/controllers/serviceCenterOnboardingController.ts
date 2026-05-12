import { Response } from 'express';
import { AuthRequest } from '../middleware/auth.middleware.js';
import prisma from '../config/prisma.js';

export const serviceCenterOnboardingController = {

  // POST /api/service-centers/onboard
  // Step 1: create draft service centre (returns id for subsequent steps)
  async createDraft(req: AuthRequest, res: Response) {
    try {
      const {
        name, phone, email, description, address, city, state, pincode,
        category, maps_link, latitude, longitude,
        vehicle_types, service_types, brands_serviced,
        working_hours, accepts_bookings,
      } = req.body;

      if (!name || !phone) {
        return res.status(400).json({ error: 'name and phone are required' });
      }

      const center = await prisma.serviceCenter.create({
        data: {
          name, phone,
          email: email ?? null,
          description: description ?? null,
          address: address ?? null,
          city: city ?? null,
          state: state ?? null,
          pincode: pincode ?? null,
          category: category ?? 'service_center',
          maps_link: maps_link ?? null,
          latitude: latitude ?? null,
          longitude: longitude ?? null,
          vehicle_types: vehicle_types ?? [],
          service_types: service_types ?? [],
          brands_serviced: brands_serviced ?? [],
          working_hours: working_hours ?? null,
          accepts_bookings: accepts_bookings ?? true,
          onboarding_status: 'draft',
          owner_user_id: req.user!.userId,
        },
      });

      // Create empty details row
      await prisma.serviceCenterDetails.create({
        data: { service_center_id: center.id },
      });

      // Auto-add owner to service_center_user_map with role 'owner'
      await prisma.serviceCenterUserMap.upsert({
        where: {
          service_center_id_user_id: {
            service_center_id: center.id,
            user_id: req.user!.userId,
          },
        },
        create: {
          service_center_id: center.id,
          user_id: req.user!.userId,
          role: 'owner',
        },
        update: { role: 'owner' },
      });

      res.status(201).json(center);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to create service centre' });
    }
  },

  // PUT /api/service-centers/onboard/:id/details
  // Steps 2–4: update business details, owner, bank
  async updateDetails(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;

      // Verify ownership
      const center = await prisma.serviceCenter.findUnique({ where: { id } });
      if (!center) return res.status(404).json({ error: 'Service centre not found' });
      if (center.owner_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised' });
      }

      const {
        trade_name, business_type, year_established, website, logo_url, whatsapp_number,
        gst_number, pan_number, shop_reg_number, trade_license, msme_number,
        owner_name, owner_phone, owner_email, designation, aadhaar_last4,
        account_holder, bank_name, account_number_encrypted, ifsc_code, upi_id,
        documents,
      } = req.body;

      const details = await prisma.serviceCenterDetails.upsert({
        where: { service_center_id: id },
        create: {
          service_center_id: id,
          trade_name, business_type, year_established, website, logo_url, whatsapp_number,
          gst_number, pan_number, shop_reg_number, trade_license, msme_number,
          owner_name, owner_phone, owner_email, designation, aadhaar_last4,
          account_holder, bank_name, account_number_encrypted, ifsc_code, upi_id,
          documents: documents ?? [],
        },
        update: {
          ...(trade_name !== undefined && { trade_name }),
          ...(business_type !== undefined && { business_type }),
          ...(year_established !== undefined && { year_established }),
          ...(website !== undefined && { website }),
          ...(logo_url !== undefined && { logo_url }),
          ...(whatsapp_number !== undefined && { whatsapp_number }),
          ...(gst_number !== undefined && { gst_number }),
          ...(pan_number !== undefined && { pan_number }),
          ...(shop_reg_number !== undefined && { shop_reg_number }),
          ...(trade_license !== undefined && { trade_license }),
          ...(msme_number !== undefined && { msme_number }),
          ...(owner_name !== undefined && { owner_name }),
          ...(owner_phone !== undefined && { owner_phone }),
          ...(owner_email !== undefined && { owner_email }),
          ...(designation !== undefined && { designation }),
          ...(aadhaar_last4 !== undefined && { aadhaar_last4 }),
          ...(account_holder !== undefined && { account_holder }),
          ...(bank_name !== undefined && { bank_name }),
          ...(account_number_encrypted !== undefined && { account_number_encrypted }),
          ...(ifsc_code !== undefined && { ifsc_code }),
          ...(upi_id !== undefined && { upi_id }),
          ...(documents !== undefined && { documents }),
          updated_at: new Date(),
        },
      });

      res.json(details);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update details' });
    }
  },

  // PUT /api/service-centers/onboard/:id/submit
  // Final step: mark as submitted for admin review
  async submit(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      const center = await prisma.serviceCenter.findUnique({ where: { id } });
      if (!center) return res.status(404).json({ error: 'Service centre not found' });
      if (center.owner_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised' });
      }

      const updated = await prisma.serviceCenter.update({
        where: { id },
        data: { onboarding_status: 'submitted', updated_at: new Date() },
      });

      await prisma.serviceCenterDetails.update({
        where: { service_center_id: id },
        data: { submitted_at: new Date() },
      });

      res.json(updated);
    } catch (error) {
      res.status(500).json({ error: 'Failed to submit' });
    }
  },

  // GET /api/service-centers/onboard/mine
  // List service centres owned by the current user
  async mine(req: AuthRequest, res: Response) {
    try {
      const centers = await prisma.serviceCenter.findMany({
        where: { owner_user_id: req.user!.userId },
        include: { details: true },
        orderBy: { created_at: 'desc' },
      });
      res.json({ centers });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch your service centres' });
    }
  },

  // GET /api/service-centers/onboard/:id
  // Get single centre with details (owner only)
  async getOne(req: AuthRequest, res: Response) {
    try {
      const center = await prisma.serviceCenter.findUnique({
        where: { id: req.params.id },
        include: { details: true },
      });
      if (!center) return res.status(404).json({ error: 'Not found' });
      if (center.owner_user_id !== req.user!.userId) {
        return res.status(403).json({ error: 'Not authorised' });
      }
      res.json(center);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch service centre' });
    }
  },
};
