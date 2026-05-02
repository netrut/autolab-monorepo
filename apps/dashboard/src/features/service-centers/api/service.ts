import type { ServiceCenterFilters, ServiceCentersResponse, ServiceCenterMutationPayload } from './types';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3002';
const SERVICE_TOKEN = process.env.BACKEND_SERVICE_TOKEN;

async function fetchBackend<T>(path: string, options?: RequestInit): Promise<T> {
  const headers: HeadersInit = { 'Content-Type': 'application/json' };
  if (SERVICE_TOKEN) headers['Authorization'] = `Bearer ${SERVICE_TOKEN}`;
  const res = await fetch(`${BACKEND_URL}${path}`, { ...options, headers: { ...headers, ...(options?.headers ?? {}) } });
  if (!res.ok) throw new Error(`API error: ${res.status} ${res.statusText}`);
  return res.json() as Promise<T>;
}

async function fetchProxy<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(path, { headers: { 'Content-Type': 'application/json' }, ...options });
  if (!res.ok) throw new Error(`API error: ${res.status} ${res.statusText}`);
  return res.json() as Promise<T>;
}

export async function getServiceCenters(filters: ServiceCenterFilters): Promise<ServiceCentersResponse> {
  const params = new URLSearchParams();
  if (filters.page) params.set('page', String(filters.page));
  if (filters.limit) params.set('limit', String(filters.limit));
  if (filters.search) params.set('search', filters.search);
  if (filters.city) params.set('city', filters.city);
  if (filters.is_verified !== undefined && filters.is_verified !== '') params.set('is_verified', filters.is_verified);
  if (filters.sort) params.set('sort', filters.sort);
  const qs = params.toString();
  if (typeof window === 'undefined') {
    return fetchBackend<ServiceCentersResponse>(`/api/service-centers?${qs}`);
  }
  return fetchProxy<ServiceCentersResponse>(`/api/service-centers?${qs}`);
}

export async function createServiceCenter(data: ServiceCenterMutationPayload) {
  return fetchProxy('/api/service-centers', { method: 'POST', body: JSON.stringify(data) });
}

export async function updateServiceCenter(id: string, data: Partial<ServiceCenterMutationPayload>) {
  return fetchProxy(`/api/service-centers?id=${id}`, { method: 'PUT', body: JSON.stringify(data) });
}

export async function deactivateServiceCenter(id: string) {
  return fetchProxy(`/api/service-centers?id=${id}`, { method: 'DELETE' });
}
