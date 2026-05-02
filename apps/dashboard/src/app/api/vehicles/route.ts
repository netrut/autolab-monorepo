import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/backend-proxy';

export async function GET(request: NextRequest) {
  try {
    const qs = request.nextUrl.searchParams.toString();
    const response = await backendFetch(`/api/vehicles${qs ? `?${qs}` : ''}`);
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch vehicles' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const response = await backendFetch('/api/vehicles', {
      method: 'POST',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to create vehicle' }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Vehicle ID required' }, { status: 400 });
    const response = await backendFetch(`/api/vehicles/${id}`, {
      method: 'PUT',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to update vehicle' }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Vehicle ID required' }, { status: 400 });
    const response = await backendFetch(`/api/vehicles/${id}`, { method: 'DELETE' });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to deactivate vehicle' }, { status: 500 });
  }
}
