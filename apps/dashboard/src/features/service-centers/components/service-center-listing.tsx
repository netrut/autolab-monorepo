import { HydrationBoundary, dehydrate } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { searchParamsCache } from '@/lib/searchparams';
import { serviceCentersQueryOptions } from '../api/queries';
import { ServiceCentersTable, ServiceCentersTableSkeleton } from './service-centers-table';
import { Suspense } from 'react';

export default function ServiceCenterListingPage() {
  const page = searchParamsCache.get('page');
  const search = searchParamsCache.get('name');
  const pageLimit = searchParamsCache.get('perPage');
  const sort = searchParamsCache.get('sort');

  const filters = {
    page,
    limit: pageLimit,
    ...(search && { search }),
    ...(sort && { sort })
  };

  const queryClient = getQueryClient();
  void queryClient.prefetchQuery(serviceCentersQueryOptions(filters));

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Suspense fallback={<ServiceCentersTableSkeleton />}>
        <ServiceCentersTable />
      </Suspense>
    </HydrationBoundary>
  );
}
