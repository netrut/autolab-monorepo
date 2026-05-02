import type { UserFilters, UsersResponse, UserMutationPayload } from './types';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3002';
const SERVICE_TOKEN = process.env.BACKEND_SERVICE_TOKEN;

// Server-side: call backend directly with service token
async function fetchBackend<T>(path: string, options?: RequestInit): Promise<T> {
  const headers: HeadersInit = { 'Content-Type': 'application/json' };
  if (SERVICE_TOKEN) headers['Authorization'] = `Bearer ${SERVICE_TOKEN}`;
  const res = await fetch(`${BACKEND_URL}${path}`, { ...options, headers: { ...headers, ...(options?.headers ?? {}) } });
  if (!res.ok) throw new Error(`API error: ${res.status} ${res.statusText}`);
  return res.json() as Promise<T>;
}

// Client-side: call Next.js BFF proxy (relative URL, no token needed)
async function fetchProxy<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(path, { headers: { 'Content-Type': 'application/json' }, ...options });
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body?.error ?? `API error: ${res.status} ${res.statusText}`);
  }
  return res.json() as Promise<T>;
}

export async function getUsers(filters: UserFilters): Promise<UsersResponse> {
  const params = new URLSearchParams();
  if (filters.page) params.set('page', String(filters.page));
  if (filters.limit) params.set('limit', String(filters.limit));
  if (filters.search) params.set('search', filters.search);
  if (filters.role) params.set('role', filters.role);
  if (filters.sort) params.set('sort', filters.sort);
  const qs = params.toString();
  if (typeof window === 'undefined') {
    return fetchBackend<UsersResponse>(`/api/users?${qs}`);
  }
  return fetchProxy<UsersResponse>(`/api/users?${qs}`);
}

export async function createUser(data: UserMutationPayload) {
  return fetchProxy('/api/users', { method: 'POST', body: JSON.stringify(data) });
}

export async function updateUser(id: string, data: UserMutationPayload) {
  return fetchProxy(`/api/users/${id}`, { method: 'PUT', body: JSON.stringify(data) });
}

export async function deleteUser(id: string) {
  return fetchProxy(`/api/users/${id}`, { method: 'DELETE' });
}
