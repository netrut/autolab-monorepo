import { cookies } from 'next/headers';

const SESSION_COOKIE = 'admin_session';
const SESSION_SECRET = process.env.ADMIN_SESSION_SECRET || 'autolab-dashboard-secret';

export function createSessionToken(): string {
  // Simple HMAC-like token: base64(timestamp + secret hash)
  const payload = `${Date.now()}:${SESSION_SECRET}`;
  return Buffer.from(payload).toString('base64');
}

export function verifySessionToken(token: string): boolean {
  try {
    const decoded = Buffer.from(token, 'base64').toString('utf-8');
    const [ts, ...rest] = decoded.split(':');
    const secret = rest.join(':');
    if (secret !== SESSION_SECRET) return false;
    // 7-day expiry
    const age = Date.now() - parseInt(ts, 10);
    return age < 7 * 24 * 60 * 60 * 1000;
  } catch {
    return false;
  }
}

export async function getSession(): Promise<boolean> {
  const cookieStore = await cookies();
  const token = cookieStore.get(SESSION_COOKIE)?.value;
  return !!token && verifySessionToken(token);
}

export function sessionCookieOptions(token: string) {
  return {
    name: SESSION_COOKIE,
    value: token,
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax' as const,
    path: '/',
    maxAge: 7 * 24 * 60 * 60
  };
}
