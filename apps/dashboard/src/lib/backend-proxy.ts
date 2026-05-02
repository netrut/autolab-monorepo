/**
 * Backend proxy helper for Next.js route handlers.
 * Always uses the server-side BACKEND_SERVICE_TOKEN — never exposed to the browser.
 */

// BACKEND_URL = server-side only (localhost), NEXT_PUBLIC_BACKEND_URL = public URL for browser
const BACKEND_URL = process.env.BACKEND_URL || process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3002';
const SERVICE_TOKEN = process.env.BACKEND_SERVICE_TOKEN;

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
