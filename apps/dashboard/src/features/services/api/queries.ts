import { queryOptions } from '@tanstack/react-query';
import { getServices } from './service';
import type { Service, ServiceFilters } from './types';

export type { Service };

export const serviceKeys = {
  all: ['services'] as const,
  list: (filters: ServiceFilters) => [...serviceKeys.all, 'list', filters] as const,
  detail: (id: string | number) => [...serviceKeys.all, 'detail', id] as const
};

export const servicesQueryOptions = (filters: ServiceFilters) =>
  queryOptions({
    queryKey: serviceKeys.list(filters),
    queryFn: () => getServices(filters)
  });
