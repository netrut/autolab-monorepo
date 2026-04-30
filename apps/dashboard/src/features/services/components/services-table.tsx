'use client';

import { useSearchParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { servicesQueryOptions } from '../api/queries';

export function ServicesTable() {
  const searchParams = useSearchParams();
  const page = parseInt(searchParams.get('page') || '1');
  const limit = parseInt(searchParams.get('perPage') || '10');
  const search = searchParams.get('name');

  const filters = {
    page,
    limit,
    ...(search && { search })
  };

  const { data, isLoading, error } = useQuery(servicesQueryOptions(filters));

  if (isLoading) {
    return (
      <Card>
        <CardContent className="pt-6">
          <div className="flex items-center justify-center h-64">
            <p className="text-muted-foreground">Loading services...</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  if (error) {
    return (
      <Card>
        <CardContent className="pt-6">
          <div className="flex items-center justify-center h-64">
            <p className="text-destructive">Error loading services: {error.message}</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  const services = data?.services || [];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Services</CardTitle>
        <CardDescription>
          Total: {data?.total_services || 0} services available
        </CardDescription>
      </CardHeader>
      <CardContent>
        {services.length === 0 ? (
          <div className="text-center py-8 text-muted-foreground">
            No services found
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-3 px-4 font-semibold">Service Name</th>
                  <th className="text-left py-3 px-4 font-semibold">Category</th>
                  <th className="text-left py-3 px-4 font-semibold">Price</th>
                  <th className="text-left py-3 px-4 font-semibold">Duration</th>
                  <th className="text-left py-3 px-4 font-semibold">Status</th>
                </tr>
              </thead>
              <tbody>
                {services.map((service) => (
                  <tr key={service.id} className="border-b hover:bg-muted/50">
                    <td className="py-3 px-4">
                      <div>
                        <p className="font-medium">{service.name}</p>
                        <p className="text-sm text-muted-foreground">{service.description}</p>
                      </div>
                    </td>
                    <td className="py-3 px-4">{service.category}</td>
                    <td className="py-3 px-4 font-semibold">${service.price.toFixed(2)}</td>
                    <td className="py-3 px-4">
                      {service.duration_minutes ? `${service.duration_minutes} min` : '—'}
                    </td>
                    <td className="py-3 px-4">
                      <Badge
                        variant={service.status === 'available' ? 'default' : 'secondary'}
                      >
                        {service.status}
                      </Badge>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
