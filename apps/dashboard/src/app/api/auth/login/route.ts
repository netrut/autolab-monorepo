import { NextRequest, NextResponse } from 'next/server';
import { createSessionToken, sessionCookieOptions } from '@/lib/auth';

const ADMIN_EMAIL = process.env.ADMIN_EMAIL || 'admin@autolab.com';
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD;

export async function POST(request: NextRequest) {
  if (!ADMIN_PASSWORD) {
    return NextResponse.json({ error: 'Auth not configured. Set ADMIN_PASSWORD env var.' }, { status: 500 });
  }

  const { email, password } = await request.json();

  if (email !== ADMIN_EMAIL || password !== ADMIN_PASSWORD) {
    return NextResponse.json({ error: 'Invalid credentials' }, { status: 401 });
  }

  const token = createSessionToken();
  const response = NextResponse.json({ success: true });
  response.cookies.set(sessionCookieOptions(token));
  return response;
}
