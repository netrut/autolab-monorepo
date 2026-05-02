import * as z from 'zod';

export const userSchema = z.object({
  display_name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Please enter a valid email'),
  phone_number: z.string().min(1, 'Phone number is required'),
  role_id: z.string().min(1, 'Please select a role'),
  is_active: z.boolean()
});

export type UserFormValues = z.infer<typeof userSchema>;
