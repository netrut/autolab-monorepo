import type { VehicleFilters, VehiclesResponse, VehicleMutationPayload } from './types';

// Mock vehicles for fallback (only used if local proxy fails)
const mockVehicles = [
  {
    id: 1,
    brand: 'Toyota',
    model: 'Camry',
    year: 2022,
    license_plate: 'ABC123',
    color: 'Blue',
    mileage: 15000,
    status: 'active' as const,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: 2,
    brand: 'Honda',
    model: 'Civic',
    year: 2021,
    license_plate: 'XYZ789',
    color: 'Red',
    mileage: 28000,
    status: 'active' as const,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  }
];

async function getBackendVehicles(filters: VehicleFilters): Promise<VehiclesResponse> {
  try {
    // Call the local Next.js proxy which forwards to the backend
    const queryParams = new URLSearchParams();
    if (filters.page) queryParams.append('page', String(filters.page));
    if (filters.limit) queryParams.append('limit', String(filters.limit));
    if (filters.search) queryParams.append('search', filters.search);
    if (filters.status) queryParams.append('status', filters.status);

    // Build absolute URL for both server and client
    // This is safe for server-side rendering since we're calling our own Next.js API
    let apiUrl = `/api/vehicles?${queryParams.toString()}`;
    
    // If running on server, need absolute URL
    if (typeof window === 'undefined') {
      apiUrl = `http://127.0.0.1:3000/api/vehicles?${queryParams.toString()}`;
    }

    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    });

    if (!response.ok) {
      console.warn(`Failed to fetch vehicles from backend: ${response.status} ${response.statusText}`);
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    // Handle array response (direct vehicle list)
    if (Array.isArray(data)) {
      let filtered = data;
      if (filters.search) {
        filtered = filtered.filter(v => 
          v.brand?.includes(filters.search) || 
          v.model?.includes(filters.search) ||
          v.license_plate?.includes(filters.search)
        );
      }
      if (filters.status) {
        filtered = filtered.filter(v => v.status === filters.status);
      }

      const total = filtered.length;
      const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
      const paginated = filtered.slice(offset, offset + (filters.limit || 10));

      return {
        success: true,
        time: new Date().toISOString(),
        message: 'Vehicles retrieved successfully',
        total_vehicles: total,
        offset,
        limit: filters.limit || 10,
        vehicles: paginated
      };
    }

    // Handle structured response (with success, data, etc.)
    if (data.success || data.data) {
      const vehicles = Array.isArray(data.data) ? data.data : [];
      
      let filtered = vehicles;
      if (filters.search) {
        filtered = filtered.filter(v => 
          v.brand?.includes(filters.search) || 
          v.model?.includes(filters.search) ||
          v.license_plate?.includes(filters.search)
        );
      }
      if (filters.status) {
        filtered = filtered.filter(v => v.status === filters.status);
      }

      const total = filtered.length;
      const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
      const paginated = filtered.slice(offset, offset + (filters.limit || 10));

      return {
        success: true,
        time: data.time || new Date().toISOString(),
        message: data.message || 'Vehicles retrieved successfully',
        total_vehicles: total,
        offset,
        limit: filters.limit || 10,
        vehicles: paginated
      };
    }

    throw new Error('Invalid response format');
  } catch (error) {
    console.warn('Backend API failed, using mock vehicles:', error instanceof Error ? error.message : error);
    
    let filtered = mockVehicles;
    if (filters.search) {
      filtered = filtered.filter(v => 
        v.brand.includes(filters.search!) || 
        v.model.includes(filters.search!) ||
        v.license_plate.includes(filters.search!)
      );
    }
    if (filters.status) {
      filtered = filtered.filter(v => v.status === filters.status);
    }

    const total = filtered.length;
    const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
    const paginated = filtered.slice(offset, offset + (filters.limit || 10));

    return {
      success: true,
      time: new Date().toISOString(),
      message: 'Vehicles retrieved (mock data - backend unavailable)',
      total_vehicles: total,
      offset,
      limit: filters.limit || 10,
      vehicles: paginated
    };
  }
}

export async function getVehicles(filters: VehicleFilters): Promise<VehiclesResponse> {
  return getBackendVehicles(filters);
}

export async function createVehicle(data: VehicleMutationPayload) {
  try {
    const response = await fetch('/api/vehicles', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Failed to create vehicle:', error);
    return {
      success: false,
      message: error instanceof Error ? error.message : 'Failed to create vehicle'
    };
  }
}

export async function updateVehicle(id: string | number, data: VehicleMutationPayload) {
  try {
    const response = await fetch(`/api/vehicles?id=${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Failed to update vehicle:', error);
    return {
      success: false,
      message: error instanceof Error ? error.message : 'Failed to update vehicle'
    };
  }
}

export async function deleteVehicle(id: string | number) {
  try {
    const response = await fetch(`/api/vehicles?id=${id}`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Failed to delete vehicle:', error);
    return {
      success: false,
      message: error instanceof Error ? error.message : 'Failed to delete vehicle'
    };
  }
}
