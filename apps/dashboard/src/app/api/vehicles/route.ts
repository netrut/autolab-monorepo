/**
 * Route Handler — Vehicles (proxy to backend)
 * ============================================================
 * Proxies all vehicle requests to the backend API.
 * This allows the dashboard to fetch real DB data without CORS issues.
 * 
 * NOTE: Backend /api/vehicles requires authentication (JWT token).
 * For development, the token is passed via Authorization header or cookies.
 */

import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3000';

async function getAuthToken(request: NextRequest): Promise<string | null> {
  // Try Authorization header first
  const authHeader = request.headers.get('authorization');
  if (authHeader) {
    return authHeader;
  }

  // Try getting token from cookies (common for JWT auth)
  const cookieStore = await cookies();
  const token = cookieStore.get('token')?.value || cookieStore.get('jwt')?.value;
  
  if (token) {
    return `Bearer ${token}`;
  }

  return null;
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const backendUrl = new URL(`${BACKEND_URL}/api/vehicles`);
    
    // Forward query parameters
    Array.from(searchParams.entries()).forEach(([key, value]) => {
      backendUrl.searchParams.append(key, value);
    });

    // Get authorization token
    const authToken = await getAuthToken(request);
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (authToken) {
      headers['Authorization'] = authToken;
    }

    const response = await fetch(backendUrl.toString(), {
      method: 'GET',
      headers,
    });

    const data = await response.json();

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('Error proxying vehicles request:', error);
    return NextResponse.json(
      { error: 'Failed to fetch vehicles from backend', message: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const backendUrl = `${BACKEND_URL}/api/vehicles`;

    const authToken = await getAuthToken(request);
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (authToken) {
      headers['Authorization'] = authToken;
    }

    const response = await fetch(backendUrl, {
      method: 'POST',
      headers,
      body: JSON.stringify(body),
    });

    const data = await response.json();

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('Error proxying vehicles POST:', error);
    return NextResponse.json(
      { error: 'Failed to create vehicle', message: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}

export async function PUT(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const id = searchParams.get('id');
    
    if (!id) {
      return NextResponse.json({ error: 'Vehicle ID required' }, { status: 400 });
    }

    const body = await request.json();
    const backendUrl = `${BACKEND_URL}/api/vehicles/${id}`;

    const authToken = await getAuthToken(request);
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (authToken) {
      headers['Authorization'] = authToken;
    }

    const response = await fetch(backendUrl, {
      method: 'PUT',
      headers,
      body: JSON.stringify(body),
    });

    const data = await response.json();

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('Error proxying vehicles PUT:', error);
    return NextResponse.json(
      { error: 'Failed to update vehicle', message: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const id = searchParams.get('id');
    
    if (!id) {
      return NextResponse.json({ error: 'Vehicle ID required' }, { status: 400 });
    }

    const backendUrl = `${BACKEND_URL}/api/vehicles/${id}`;

    const authToken = await getAuthToken(request);
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (authToken) {
      headers['Authorization'] = authToken;
    }

    const response = await fetch(backendUrl, {
      method: 'DELETE',
      headers,
    });

    const data = await response.json();

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('Error proxying vehicles DELETE:', error);
    return NextResponse.json(
      { error: 'Failed to delete vehicle', message: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}
