export type Service = {
  id: string | number;
  name: string;
  description?: string;
  category: string;
  price: number;
  duration_minutes?: number;
  status: 'available' | 'unavailable';
  created_at?: string;
  updated_at?: string;
};

export type ServiceFilters = {
  page?: number;
  limit?: number;
  category?: string;
  search?: string;
  sort?: string;
};

export type ServicesResponse = {
  success: boolean;
  time: string;
  message: string;
  total_services: number;
  offset: number;
  limit: number;
  services: Service[];
};

export type ServiceMutationPayload = {
  name: string;
  description: string;
  category: string;
  price: number;
  status: string;
};
