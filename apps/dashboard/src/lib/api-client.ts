const DASHBOARD_API = '/api';
const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3000';

export async function apiClient<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${DASHBOARD_API}${endpoint}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options
  });

  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }

  return res.json() as Promise<T>;
}

/**
 * AutoLab Backend API Client
 * Communicates with the backend server
 */
export interface BackendApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  status?: string;
}

export async function backendApiClient<T>(
  endpoint: string,
  options?: RequestInit
): Promise<BackendApiResponse<T>> {
  try {
    const res = await fetch(`${BACKEND_URL}${endpoint}`, {
      headers: { 'Content-Type': 'application/json' },
      ...options
    });

    if (!res.ok) {
      return {
        success: false,
        error: `HTTP ${res.status}: ${res.statusText}`
      };
    }

    const data = await res.json();
    return {
      success: true,
      data: data as T
    };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
}

/**
 * Backend API Endpoints
 */
export const backendAPI = {
  // Users
  users: {
    async list() {
      return backendApiClient<any[]>('/api/users');
    },
    async getById(id: string) {
      return backendApiClient<any>(`/api/users/${id}`);
    }
  },
  
  // Vehicles
  vehicles: {
    async list() {
      return backendApiClient<any[]>('/api/vehicles');
    },
    async getById(id: string) {
      return backendApiClient<any>(`/api/vehicles/${id}`);
    }
  },
  
  // Services
  services: {
    async list() {
      return backendApiClient<any[]>('/api/services');
    },
    async getById(id: string) {
      return backendApiClient<any>(`/api/services/${id}`);
    }
  },
  
  // Bookings
  bookings: {
    async list() {
      return backendApiClient<any[]>('/api/bookings');
    },
    async getById(id: string) {
      return backendApiClient<any>(`/api/bookings/${id}`);
    }
  },
  
  // Health check
  health: {
    async check() {
      return backendApiClient<{ status: string; timestamp: string }>('/health');
    }
  }
};
