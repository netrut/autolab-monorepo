import PageContainer from '@/components/layout/page-container';
import ServiceCenterListingPage from '@/features/service-centers/components/service-center-listing';
import { searchParamsCache } from '@/lib/searchparams';
import type { SearchParams } from 'nuqs/server';
import { ServiceCenterFormSheetTrigger } from '@/features/service-centers/components/service-center-form-sheet';

export const metadata = { title: 'Dashboard: Service Centers' };

type PageProps = { searchParams: Promise<SearchParams> };

export default async function ServiceCentersPage(props: PageProps) {
  const searchParams = await props.searchParams;
  searchParamsCache.parse(searchParams);

  return (
    <PageContainer
      pageTitle='Service Centers'
      pageDescription='Manage service centers and their details.'
      pageHeaderAction={<ServiceCenterFormSheetTrigger />}
    >
      <ServiceCenterListingPage />
    </PageContainer>
  );
}
