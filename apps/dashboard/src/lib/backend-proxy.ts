/**
 * Backend proxy helper for Next.js route handlers.
 * Always uses the server-side BACKEND_SERVICE_TOKEN — never exposed to the browser.
 */

// BACKEND_URL = server-side only. Falls back to production URL so Vercel deployments
// work even if the env var is not explicitly set.
const BACKEND_URL =
  process.env.BACKEND_URL ||
  process.env.NEXT_PUBLIC_BACKEND_URL ||
  'https://autolab-api.vercel.app';
const SERVICE_TOKEN = process.env.BACKEND_SERVICE_TOKEN;

if (!SERVICE_TOKEN && process.env.NODE_ENV === 'production') {
  console.error(
    '[backend-proxy] BACKEND_SERVICE_TOKEN is not set. ' +
    'Requests to protected backend routes (/api/users, /api/bookings) will return 401. ' +
    'Add BACKEND_SERVICE_TOKEN to your Vercel environment variables.'
  );
}

export function backendHeaders(): HeadersInit {
  const headers: HeadersInit = { 'Content-Type': 'application/json' };
  if (SERVICE_TOKEN) headers['Authorization'] = `Bearer ${SERVICE_TOKEN}`;
  return headers;
}

export async function backendFetch(
  path: string,
  options?: RequestInit
): Promise<Response> {
  return fetch(`${BACKEND_URL}${path}`, {
    ...options,
    headers: { ...backendHeaders(), ...(options?.headers ?? {}) }
  });
}
