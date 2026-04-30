export type Vehicle = {
  id: string | number;
  user_id?: string | number;
  brand: string;
  model: string;
  year: number;
  license_plate: string;
  vin?: string;
  color: string;
  mileage?: number;
  status: 'active' | 'inactive' | 'maintenance';
  created_at?: string;
  updated_at?: string;
};

export type VehicleFilters = {
  page?: number;
  limit?: number;
  status?: string;
  search?: string;
  sort?: string;
};

export type VehiclesResponse = {
  success: boolean;
  time: string;
  message: string;
  total_vehicles: number;
  offset: number;
  limit: number;
  vehicles: Vehicle[];
};

export type VehicleMutationPayload = {
  brand: string;
  model: string;
  year: number;
  license_plate: string;
  color: string;
  status: string;
};
