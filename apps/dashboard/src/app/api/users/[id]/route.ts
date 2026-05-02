import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/backend-proxy';

type Params = { params: Promise<{ id: string }> };

export async function PUT(request: NextRequest, { params }: Params) {
  try {
    const { id } = await params;
    const response = await backendFetch(`/api/users/${id}`, {
      method: 'PUT',
      body: JSON.stringify(await request.json())
    });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to update user' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: Params) {
  try {
    const { id } = await params;
    const response = await backendFetch(`/api/users/${id}`, { method: 'DELETE' });
    return NextResponse.json(await response.json(), { status: response.status });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to delete user' }, { status: 500 });
  }
}
