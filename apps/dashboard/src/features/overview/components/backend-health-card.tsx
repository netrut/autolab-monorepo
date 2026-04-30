import { Icons } from '@/components/icons';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

type BackendHealth = {
  status: string;
  message?: string;
  timestamp?: string;
  environment?: string;
};

async function getBackendHealth(): Promise<BackendHealth> {
  const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3000';

  try {
    const response = await fetch(`${backendUrl}/health`, {
      cache: 'no-store'
    });

    if (!response.ok) {
      throw new Error(`Backend returned ${response.status}`);
    }

    return (await response.json()) as BackendHealth;
  } catch (error) {
    return {
      status: 'offline',
      message: error instanceof Error ? error.message : 'Unable to reach backend'
    };
  }
}

export default async function BackendHealthCard() {
  const health = await getBackendHealth();
  const isOnline = health.status.toLowerCase() === 'ok';

  return (
    <Card className='@container/card lg:col-span-4'>
      <CardHeader>
        <CardDescription>Backend API</CardDescription>
        <CardTitle className='flex items-center gap-2 text-2xl font-semibold tabular-nums @[250px]/card:text-3xl'>
          <Icons.dashboard className='size-5' />
          {isOnline ? 'Connected' : 'Offline'}
        </CardTitle>
        <Badge variant={isOnline ? 'outline' : 'destructive'} className='w-fit'>
          {isOnline ? 'Health check passed' : 'Health check failed'}
        </Badge>
      </CardHeader>
      <CardContent className='space-y-2 text-sm'>
        <p className='text-muted-foreground'>
          {isOnline
            ? `The dashboard is reaching ${process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3000'}/health successfully.`
            : health.message || 'Unable to contact the backend API.'}
        </p>
        {health.timestamp ? (
          <p className='text-muted-foreground text-xs'>Last check: {health.timestamp}</p>
        ) : null}
      </CardContent>
    </Card>
  );
}