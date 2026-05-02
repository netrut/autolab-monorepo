export type ServiceCenter = {
  id: string;
  name: string;
  description: string | null;
  phone: string;
  email: string | null;
  address: string | null;
  city: string | null;
  state: string | null;
  pincode: string | null;
  rating: string | null;
  is_verified: boolean | null;
  is_active: boolean | null;
  created_at: string | null;
  updated_at: string | null;
};

export type ServiceCenterFilters = {
  page?: number;
  limit?: number;
  search?: string;
  city?: string;
  is_verified?: string;
  sort?: string;
};

export type ServiceCentersResponse = {
  centers: ServiceCenter[];
  total_centers: number;
  page: number;
  limit: number;
  offset: number;
};

export type ServiceCenterMutationPayload = {
  name: string;
  phone: string;
  email?: string;
  description?: string;
  address?: string;
  city?: string;
  state?: string;
  pincode?: string;
  is_verified?: boolean;
  is_active?: boolean;
};
