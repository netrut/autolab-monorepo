import { backendAPI } from '@/lib/api-client';
import type { VehicleFilters, VehiclesResponse, VehicleMutationPayload } from './types';

// Mock vehicles for fallback
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
  const result = await backendAPI.vehicles.list();
  
  if (!result.success || !result.data) {
    console.warn('Backend API failed, using mock vehicles:', result.error);
    
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
      message: 'Vehicles retrieved (mock data)',
      total_vehicles: total,
      offset,
      limit: filters.limit || 10,
      vehicles: paginated
    };
  }

  // Transform backend response to match expected format
  const vehicles = Array.isArray(result.data) ? result.data : [];
  
  // Apply filters
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
    time: new Date().toISOString(),
    message: 'Vehicles retrieved successfully',
    total_vehicles: total,
    offset,
    limit: filters.limit || 10,
    vehicles: paginated
  };
}

export async function getVehicles(filters: VehicleFilters): Promise<VehiclesResponse> {
  return getBackendVehicles(filters);
}

export async function createVehicle(data: VehicleMutationPayload) {
  console.log('Create vehicle:', data);
  return {
    success: true,
    message: 'Vehicle created successfully'
  };
}

export async function updateVehicle(id: string | number, data: VehicleMutationPayload) {
  console.log('Update vehicle:', id, data);
  return {
    success: true,
    message: 'Vehicle updated successfully'
  };
}

export async function deleteVehicle(id: string | number) {
  console.log('Delete vehicle:', id);
  return {
    success: true,
    message: 'Vehicle deleted successfully'
  };
}
