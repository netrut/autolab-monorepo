import { HydrationBoundary, dehydrate } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { searchParamsCache } from '@/lib/searchparams';
import { servicesQueryOptions } from '../api/queries';
import { ServicesTable } from './services-table';

export default function ServicesListingPage() {
  const page = searchParamsCache.get('page');
  const name = searchParamsCache.get('name');
  const pageLimit = searchParamsCache.get('perPage');

  const filters = {
    page,
    limit: pageLimit,
    ...(name && { search: name })
  };

  const queryClient = getQueryClient();

  void queryClient.prefetchQuery(servicesQueryOptions(filters));

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <ServicesTable />
    </HydrationBoundary>
  );
}
