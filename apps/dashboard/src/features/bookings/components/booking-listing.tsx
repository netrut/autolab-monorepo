import { HydrationBoundary, dehydrate } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { searchParamsCache } from '@/lib/searchparams';
import { bookingsQueryOptions } from '../api/queries';
import { BookingsTable, BookingsTableSkeleton } from './bookings-table';
import { Suspense } from 'react';

export default function BookingListingPage() {
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
  void queryClient.prefetchQuery(bookingsQueryOptions(filters));

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Suspense fallback={<BookingsTableSkeleton />}>
        <BookingsTable />
      </Suspense>
    </HydrationBoundary>
  );
}
