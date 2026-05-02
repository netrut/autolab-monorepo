export type User = {
  id: string;
  email: string;
  phone_number: string | null;
  display_name: string | null;
  avatar_url: string | null;
  role_id: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
};

export type UserFilters = {
  page?: number;
  limit?: number;
  role?: string;
  search?: string;
  sort?: string;
};

export type UsersResponse = {
  users: User[];
  total_users: number;
  page: number;
  limit: number;
  offset: number;
};

export type UserMutationPayload = {
  display_name: string;
  email: string;
  phone_number: string;
  role_id: string;
  is_active: boolean;
};
