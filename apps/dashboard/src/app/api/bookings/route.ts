import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/backend-proxy';

export async function GET(request: NextRequest) {
  try {
    const qs = request.nextUrl.searchParams.toString();
    const response = await backendFetch(`/api/bookings${qs ? `?${qs}` : ''}`);
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch bookings' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const response = await backendFetch('/api/bookings', {
      method: 'POST',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to create booking' }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Booking ID required' }, { status: 400 });
    const response = await backendFetch(`/api/bookings/${id}`, {
      method: 'PUT',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to update booking' }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Booking ID required' }, { status: 400 });
    const response = await backendFetch(`/api/bookings/${id}`, { method: 'DELETE' });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to cancel booking' }, { status: 500 });
  }
}
