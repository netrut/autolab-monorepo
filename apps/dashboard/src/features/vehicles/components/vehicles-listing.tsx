import { HydrationBoundary, dehydrate } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { searchParamsCache } from '@/lib/searchparams';
import { vehiclesQueryOptions } from '../api/queries';
import { VehiclesDataTable, VehiclesTableSkeleton } from './vehicles-table';
import { Suspense } from 'react';

export default function VehiclesListingPage() {
  const page = searchParamsCache.get('page');
  const search = searchParamsCache.get('name');
  const pageLimit = searchParamsCache.get('perPage');
  const status = searchParamsCache.get('status');
  const sort = searchParamsCache.get('sort');

  const filters = {
    page,
    limit: pageLimit,
    ...(search && { search }),
    ...(status && { status }),
    ...(sort && { sort })
  };

  const queryClient = getQueryClient();
  void queryClient.prefetchQuery(vehiclesQueryOptions(filters));

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Suspense fallback={<VehiclesTableSkeleton />}>
        <VehiclesDataTable />
      </Suspense>
    </HydrationBoundary>
  );
}
