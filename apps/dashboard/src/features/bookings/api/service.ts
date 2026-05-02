import type { BookingFilters, BookingsResponse, BookingMutationPayload } from './types';

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
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body?.error ?? `API error: ${res.status} ${res.statusText}`);
  }
  return res.json() as Promise<T>;
}

export async function getBookings(filters: BookingFilters): Promise<BookingsResponse> {
  const params = new URLSearchParams();
  if (filters.page) params.set('page', String(filters.page));
  if (filters.limit) params.set('limit', String(filters.limit));
  if (filters.status) params.set('status', filters.status);
  if (filters.search) params.set('search', filters.search);
  if (filters.sort) params.set('sort', filters.sort);
  const qs = params.toString();
  if (typeof window === 'undefined') {
    return fetchBackend<BookingsResponse>(`/api/bookings?${qs}`);
  }
  return fetchProxy<BookingsResponse>(`/api/bookings?${qs}`);
}

export async function createBooking(data: BookingMutationPayload) {
  return fetchProxy('/api/bookings', { method: 'POST', body: JSON.stringify(data) });
}

export async function updateBooking(id: string, data: Partial<BookingMutationPayload> & { status?: string }) {
  return fetchProxy(`/api/bookings?id=${id}`, { method: 'PUT', body: JSON.stringify(data) });
}

export async function cancelBooking(id: string) {
  return fetchProxy(`/api/bookings?id=${id}`, {
    method: 'PUT',
    body: JSON.stringify({ status: 'cancelled' })
  });
}
