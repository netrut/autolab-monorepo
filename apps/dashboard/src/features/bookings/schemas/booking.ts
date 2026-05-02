import * as z from 'zod';

export const createBookingSchema = z.object({
  user_id: z.string().min(1, 'User is required'),
  vehicle_id: z.string().min(1, 'Vehicle is required'),
  service_center_id: z.string().min(1, 'Service center is required'),
  service_type: z.string().min(1, 'Service type is required'),
  booking_date: z.string().min(1, 'Booking date is required'),
  notes: z.string().optional()
});

export const updateBookingSchema = z.object({
  status: z.string().min(1, 'Status is required'),
  service_type: z.string().min(1, 'Service type is required'),
  booking_date: z.string().min(1, 'Booking date is required'),
  notes: z.string().optional()
});

export type CreateBookingFormValues = z.infer<typeof createBookingSchema>;
export type UpdateBookingFormValues = z.infer<typeof updateBookingSchema>;
// Keep backward compat
export const bookingSchema = createBookingSchema;
export type BookingFormValues = CreateBookingFormValues;
