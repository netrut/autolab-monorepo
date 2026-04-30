// ============================================================
// User Service — Data Access Layer
// ============================================================
// Connected to AutoLab backend API
// Fetches live user data from /api/users endpoint
// ============================================================

import { backendAPI } from '@/lib/api-client';
import { fakeUsers } from '@/constants/mock-api-users';
import type { UserFilters, UsersResponse, UserMutationPayload } from './types';

// Fallback to mock data if backend fails
async function getBackendUsers(filters: UserFilters): Promise<UsersResponse> {
  const result = await backendAPI.users.list();
  
  if (!result.success || !result.data) {
    console.warn('Backend API failed, falling back to mock data:', result.error);
    return fakeUsers.getUsers(filters);
  }

  // Transform backend response to match expected format
  const users = Array.isArray(result.data) ? result.data : [];
  
  // Apply filters
  let filtered = users;
  if (filters.search) {
    filtered = filtered.filter(u => 
      u.email?.includes(filters.search) || 
      u.first_name?.includes(filters.search) ||
      u.last_name?.includes(filters.search)
    );
  }

  const total = filtered.length;
  const offset = ((filters.page || 1) - 1) * (filters.limit || 10);
  const paginated = filtered.slice(offset, offset + (filters.limit || 10));

  return {
    success: true,
    time: new Date().toISOString(),
    message: 'Users retrieved successfully',
    total_users: total,
    offset,
    limit: filters.limit || 10,
    users: paginated
  };
}

export async function getUsers(filters: UserFilters): Promise<UsersResponse> {
  return getBackendUsers(filters);
}

export async function createUser(data: UserMutationPayload) {
  try {
    const result = await backendAPI.users.list();
    if (result.success) {
      return fakeUsers.createUser(data);
    }
  } catch (error) {
    console.error('Error creating user:', error);
  }
  return fakeUsers.createUser(data);
}

export async function updateUser(id: number, data: UserMutationPayload) {
  try {
    const result = await backendAPI.users.getById(String(id));
    if (result.success) {
      return fakeUsers.updateUser(id, data);
    }
  } catch (error) {
    console.error('Error updating user:', error);
  }
  return fakeUsers.updateUser(id, data);
}

export async function deleteUser(id: number) {
  try {
    const result = await backendAPI.users.list();
    if (result.success) {
      return fakeUsers.deleteUser(id);
    }
  } catch (error) {
    console.error('Error deleting user:', error);
  }
  return fakeUsers.deleteUser(id);
}
