import { HydrationBoundary, dehydrate } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { searchParamsCache } from '@/lib/searchparams';
import { vehiclesQueryOptions } from '../api/queries';
import { VehiclesTable } from './vehicles-table';

export default function VehiclesListingPage() {
  const page = searchParamsCache.get('page');
  const search = searchParamsCache.get('name');
  const pageLimit = searchParamsCache.get('perPage');

  const filters = {
    page,
    limit: pageLimit,
    ...(search && { search })
  };

  const queryClient = getQueryClient();

  void queryClient.prefetchQuery(vehiclesQueryOptions(filters));

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <VehiclesTable />
    </HydrationBoundary>
  );
}
