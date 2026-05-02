export type Vehicle = {
  id: string;
  user_id: string;
  vehicle_type: string;
  brand: string;
  model: string;
  year: number | null;
  registration_number: string | null;
  vehicle_color: string | null;
  fuel_type: string | null;
  transmission: string | null;
  mileage_km: string | null;
  notes: string | null;
  is_active: boolean | null;
  created_at: string | null;
  updated_at: string | null;
  users?: { id: string; email: string; display_name: string | null };
};

export type VehicleFilters = {
  page?: number;
  limit?: number;
  status?: string;
  search?: string;
  sort?: string;
};

export type VehiclesResponse = {
  vehicles: Vehicle[];
  total_vehicles: number;
  page: number;
  limit: number;
  offset: number;
};

export type VehicleMutationPayload = {
  user_id: string;
  vehicle_type: string;
  brand: string;
  model: string;
  year?: number;
  registration_number?: string;
  vehicle_color?: string;
  fuel_type?: string;
  transmission?: string;
  mileage_km?: number;
  notes?: string;
  is_active?: boolean;
};
