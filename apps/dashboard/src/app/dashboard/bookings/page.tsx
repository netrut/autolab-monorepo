import PageContainer from '@/components/layout/page-container';
import BookingListingPage from '@/features/bookings/components/booking-listing';
import { searchParamsCache } from '@/lib/searchparams';
import type { SearchParams } from 'nuqs/server';
import { BookingFormSheetTrigger } from '@/features/bookings/components/booking-form-sheet';

export const metadata = { title: 'Dashboard: Bookings' };

type PageProps = { searchParams: Promise<SearchParams> };

export default async function BookingsPage(props: PageProps) {
  const searchParams = await props.searchParams;
  searchParamsCache.parse(searchParams);

  return (
    <PageContainer
      pageTitle='Bookings'
      pageDescription='Manage all service bookings.'
      pageHeaderAction={<BookingFormSheetTrigger />}
    >
      <BookingListingPage />
    </PageContainer>
  );
}
