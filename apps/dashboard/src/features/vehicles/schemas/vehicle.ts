import * as z from 'zod';

export const vehicleSchema = z.object({
  user_id: z.string().min(1, 'User is required'),
  vehicle_type: z.string().min(1, 'Vehicle type is required'),
  brand: z.string().min(1, 'Brand is required'),
  model: z.string().min(1, 'Model is required'),
  year: z.number({ message: 'Year is required' }).min(1900).max(new Date().getFullYear() + 1),
  registration_number: z.string().optional(),
  vehicle_color: z.string().optional(),
  fuel_type: z.string().optional(),
  transmission: z.string().optional(),
  notes: z.string().optional(),
  is_active: z.boolean().optional()
});

export type VehicleFormValues = z.infer<typeof vehicleSchema>;
