export type Booking = {
  id: string;
  user_id: string;
  vehicle_id: string;
  service_center_id: string;
  service_type: string;
  booking_date: string;
  status: string | null;
  notes: string | null;
  created_at: string | null;
  updated_at: string | null;
  users?: { id: string; email: string; display_name: string | null };
  vehicles?: { id: string; brand: string; model: string; license_plate: string | null };
  service_centers?: { id: string; name: string; city: string | null };
};

export type BookingFilters = {
  page?: number;
  limit?: number;
  status?: string;
  search?: string;
  sort?: string;
};

export type BookingsResponse = {
  bookings: Booking[];
  total_bookings: number;
  page: number;
  limit: number;
  offset: number;
};

export type BookingMutationPayload = {
  user_id: string;
  vehicle_id: string;
  service_center_id: string;
  service_type: string;
  booking_date: string;
  notes?: string;
};
