import PageContainer from '@/components/layout/page-container';
import ServicesListingPage from '@/features/services/components/services-listing';
import { searchParamsCache } from '@/lib/searchparams';
import type { SearchParams } from 'nuqs/server';

export const metadata = {
  title: 'Dashboard: Services'
};

type PageProps = {
  searchParams: Promise<SearchParams>;
};

export default async function ServicesPage(props: PageProps) {
  const searchParams = await props.searchParams;
  searchParamsCache.parse(searchParams);

  return (
    <PageContainer
      pageTitle='Services'
      pageDescription='Browse available services from the AutoLab backend.'
    >
      <ServicesListingPage />
    </PageContainer>
  );
}
