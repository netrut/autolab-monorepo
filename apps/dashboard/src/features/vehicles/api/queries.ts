import { queryOptions } from '@tanstack/react-query';
import { getVehicles } from './service';
import type { Vehicle, VehicleFilters } from './types';

export type { Vehicle };

export const vehicleKeys = {
  all: ['vehicles'] as const,
  list: (filters: VehicleFilters) => [...vehicleKeys.all, 'list', filters] as const,
  detail: (id: string | number) => [...vehicleKeys.all, 'detail', id] as const
};

export const vehiclesQueryOptions = (filters: VehicleFilters) =>
  queryOptions({
    queryKey: vehicleKeys.list(filters),
    queryFn: () => getVehicles(filters)
  });
