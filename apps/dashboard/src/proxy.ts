import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { verifySessionToken } from '@/lib/auth';

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Protect dashboard routes
  if (pathname.startsWith('/dashboard')) {
    const token = request.cookies.get('admin_session')?.value;
    if (!token || !verifySessionToken(token)) {
      const loginUrl = new URL('/login', request.url);
      loginUrl.searchParams.set('from', pathname);
      return NextResponse.redirect(loginUrl);
    }
  }

  // Redirect logged-in users away from login page
  if (pathname === '/login') {
    const token = request.cookies.get('admin_session')?.value;
    if (token && verifySessionToken(token)) {
      return NextResponse.redirect(new URL('/dashboard/overview', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/login']
};
