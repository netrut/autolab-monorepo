import PageContainer from '@/components/layout/page-container';
import VehiclesListingPage from '@/features/vehicles/components/vehicles-listing';
import { searchParamsCache } from '@/lib/searchparams';
import type { SearchParams } from 'nuqs/server';

export const metadata = {
  title: 'Dashboard: Vehicles'
};

type PageProps = {
  searchParams: Promise<SearchParams>;
};

export default async function VehiclesPage(props: PageProps) {
  const searchParams = await props.searchParams;
  searchParamsCache.parse(searchParams);

  return (
    <PageContainer
      pageTitle='Vehicles'
      pageDescription='View and manage registered vehicles from the AutoLab backend.'
    >
      <VehiclesListingPage />
    </PageContainer>
  );
}
