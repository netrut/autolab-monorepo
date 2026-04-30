'use client';

import { useSearchParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { vehiclesQueryOptions } from '../api/queries';

export function VehiclesTable() {
  const searchParams = useSearchParams();
  const page = parseInt(searchParams.get('page') || '1');
  const limit = parseInt(searchParams.get('perPage') || '10');
  const search = searchParams.get('name');

  const filters = {
    page,
    limit,
    ...(search && { search })
  };

  const { data, isLoading, error } = useQuery(vehiclesQueryOptions(filters));

  if (isLoading) {
    return (
      <Card>
        <CardContent className="pt-6">
          <div className="flex items-center justify-center h-64">
            <p className="text-muted-foreground">Loading vehicles...</p>
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
            <p className="text-destructive">Error loading vehicles: {error.message}</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  const vehicles = data?.vehicles || [];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Vehicles</CardTitle>
        <CardDescription>
          Total: {data?.total_vehicles || 0} vehicles
        </CardDescription>
      </CardHeader>
      <CardContent>
        {vehicles.length === 0 ? (
          <div className="text-center py-8 text-muted-foreground">
            No vehicles found
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-3 px-4 font-semibold">Brand & Model</th>
                  <th className="text-left py-3 px-4 font-semibold">License Plate</th>
                  <th className="text-left py-3 px-4 font-semibold">Year</th>
                  <th className="text-left py-3 px-4 font-semibold">Color</th>
                  <th className="text-left py-3 px-4 font-semibold">Status</th>
                </tr>
              </thead>
              <tbody>
                {vehicles.map((vehicle) => (
                  <tr key={vehicle.id} className="border-b hover:bg-muted/50">
                    <td className="py-3 px-4">
                      {vehicle.brand} {vehicle.model}
                    </td>
                    <td className="py-3 px-4 font-mono text-sm">{vehicle.license_plate}</td>
                    <td className="py-3 px-4">{vehicle.year}</td>
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-2">
                        <div
                          className="w-4 h-4 rounded border"
                          style={{ backgroundColor: vehicle.color.toLowerCase() }}
                        />
                        {vehicle.color}
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <Badge
                        variant={
                          vehicle.status === 'active'
                            ? 'default'
                            : vehicle.status === 'maintenance'
                              ? 'secondary'
                              : 'outline'
                        }
                      >
                        {vehicle.status}
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
