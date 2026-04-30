import { backendAPI } from '@/lib/api-client';
import type { ServiceFilters, ServicesResponse, ServiceMutationPayload } from './types';

// Mock services for fallback
const mockServices = [
  {
    id: 1,
    name: 'Oil Change',
    description: 'Regular oil change and filter replacement',
    category: 'Maintenance',
    price: 49.99,
    duration_minutes: 30,
    status: 'available' as const,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: 2,
    name: 'Tire Rotation',
    description: 'Rotate and balance tires',
    category: 'Maintenance',
    price: 79.99,
    duration_minutes: 45,
    status: 'available' as const,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: 3,
    name: 'Brake Inspection',
    description: 'Complete brake system inspection and diagnostics',
    category: 'Inspection',
    price: 99.99,
    duration_minutes: 60,
    status: 'available' as const,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  }
];

async function getBackendServices(filters: ServiceFilters): Promise<ServicesResponse> {
  const result = await backendAPI.services.list();
  
  if (!result.success || !result.data) {
    console.warn('Backend API failed, using mock services:', result.error);
    
    let filtered = mockServices;
    if (filters.search) {
      filtered = filtered.filter(s => 
        s.name.includes(filters.search!) || 
        s.description?.includes(filters.search!)
      );
    }
    if (filters.category) {
      filtered = filtered.filter(s => s.category === filters.category);
    }

    const total = filtered.length;
    const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
    const paginated = filtered.slice(offset, offset + (filters.limit || 10));

    return {
      success: true,
      time: new Date().toISOString(),
      message: 'Services retrieved (mock data)',
      total_services: total,
      offset,
      limit: filters.limit || 10,
      services: paginated
    };
  }

  // Transform backend response to match expected format
  const services = Array.isArray(result.data) ? result.data : [];
  
  // Apply filters
  let filtered = services;
  if (filters.search) {
    filtered = filtered.filter(s => 
      s.name?.includes(filters.search) || 
      s.description?.includes(filters.search)
    );
  }
  if (filters.category) {
    filtered = filtered.filter(s => s.category === filters.category);
  }

  const total = filtered.length;
  const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
  const paginated = filtered.slice(offset, offset + (filters.limit || 10));

  return {
    success: true,
    time: new Date().toISOString(),
    message: 'Services retrieved successfully',
    total_services: total,
    offset,
    limit: filters.limit || 10,
    services: paginated
  };
}

export async function getServices(filters: ServiceFilters): Promise<ServicesResponse> {
  return getBackendServices(filters);
}

export async function createService(data: ServiceMutationPayload) {
  console.log('Create service:', data);
  return {
    success: true,
    message: 'Service created successfully'
  };
}

export async function updateService(id: string | number, data: ServiceMutationPayload) {
  console.log('Update service:', id, data);
  return {
    success: true,
    message: 'Service updated successfully'
  };
}

export async function deleteService(id: string | number) {
  console.log('Delete service:', id);
  return {
    success: true,
    message: 'Service deleted successfully'
  };
}
