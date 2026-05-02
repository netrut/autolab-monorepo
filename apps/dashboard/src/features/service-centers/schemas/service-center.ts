import * as z from 'zod';

export const serviceCenterSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  phone: z.string().min(1, 'Phone is required'),
  email: z.string().email('Invalid email').optional().or(z.literal('')),
  description: z.string().optional(),
  address: z.string().optional(),
  city: z.string().optional(),
  state: z.string().optional(),
  pincode: z.string().optional(),
  is_verified: z.boolean().optional(),
  is_active: z.boolean().optional()
});

export type ServiceCenterFormValues = z.infer<typeof serviceCenterSchema>;
