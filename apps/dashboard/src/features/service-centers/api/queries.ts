import { queryOptions } from '@tanstack/react-query';
import { getServiceCenters } from './service';
import type { ServiceCenter, ServiceCenterFilters } from './types';

export type { ServiceCenter };

export const serviceCenterKeys = {
  all: ['service-centers'] as const,
  list: (filters: ServiceCenterFilters) => [...serviceCenterKeys.all, 'list', filters] as const,
  detail: (id: string) => [...serviceCenterKeys.all, 'detail', id] as const
};

export const serviceCentersQueryOptions = (filters: ServiceCenterFilters) =>
  queryOptions({
    queryKey: serviceCenterKeys.list(filters),
    queryFn: () => getServiceCenters(filters)
  });
