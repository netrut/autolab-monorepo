import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/backend-proxy';

export async function GET(request: NextRequest) {
  try {
    const qs = request.nextUrl.searchParams.toString();
    const response = await backendFetch(`/api/service-centers${qs ? `?${qs}` : ''}`);
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch service centers' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const response = await backendFetch('/api/service-centers', {
      method: 'POST',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to create service center' }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Service center ID required' }, { status: 400 });
    const response = await backendFetch(`/api/service-centers/${id}`, {
      method: 'PUT',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to update service center' }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const id = request.nextUrl.searchParams.get('id');
    if (!id) return NextResponse.json({ error: 'Service center ID required' }, { status: 400 });
    const response = await backendFetch(`/api/service-centers/${id}`, { method: 'DELETE' });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to deactivate service center' }, { status: 500 });
  }
}
