import { mutationOptions } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { createBooking, updateBooking, cancelBooking } from './service';
import { bookingKeys } from './queries';
import type { BookingMutationPayload } from './types';

export const createBookingMutation = mutationOptions({
  mutationFn: (data: BookingMutationPayload) => createBooking(data),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: bookingKeys.all })
});

export const updateBookingMutation = mutationOptions({
  mutationFn: ({ id, values }: { id: string; values: Partial<BookingMutationPayload> & { status?: string } }) =>
    updateBooking(id, values),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: bookingKeys.all })
});

export const cancelBookingMutation = mutationOptions({
  mutationFn: (id: string) => cancelBooking(id),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: bookingKeys.all })
});
