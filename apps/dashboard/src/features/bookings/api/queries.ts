import { queryOptions } from '@tanstack/react-query';
import { getBookings } from './service';
import type { Booking, BookingFilters } from './types';

export type { Booking };

export const bookingKeys = {
  all: ['bookings'] as const,
  list: (filters: BookingFilters) => [...bookingKeys.all, 'list', filters] as const,
  detail: (id: string) => [...bookingKeys.all, 'detail', id] as const
};

export const bookingsQueryOptions = (filters: BookingFilters) =>
  queryOptions({
    queryKey: bookingKeys.list(filters),
    queryFn: () => getBookings(filters)
  });
