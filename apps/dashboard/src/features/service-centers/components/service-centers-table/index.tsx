'use client';
import { DataTable } from '@/components/ui/table/data-table';
import { DataTableToolbar } from '@/components/ui/table/data-table-toolbar';
import { useDataTable } from '@/hooks/use-data-table';
import { useSuspenseQuery } from '@tanstack/react-query';
import { parseAsInteger, parseAsString, useQueryStates } from 'nuqs';
import { getSortingStateParser } from '@/lib/parsers';
import { serviceCentersQueryOptions } from '../../api/queries';
import { columns } from './columns';
import { Skeleton } from '@/components/ui/skeleton';

const columnIds = columns.map((c) => c.id).filter(Boolean) as string[];

export function ServiceCentersTable() {
  const [params] = useQueryStates({
    page: parseAsInteger.withDefault(1),
    perPage: parseAsInteger.withDefault(10),
    name: parseAsString,
    is_verified: parseAsString,
    sort: getSortingStateParser(columnIds).withDefault([])
  });

  const filters = {
    page: params.page,
    limit: params.perPage,
    ...(params.name && { search: params.name }),
    ...(params.is_verified && { is_verified: params.is_verified }),
    ...(params.sort.length > 0 && { sort: JSON.stringify(params.sort) })
  };

  const { data } = useSuspenseQuery(serviceCentersQueryOptions(filters));
  const pageCount = Math.ceil(data.total_centers / params.perPage);

  const { table } = useDataTable({
    data: data.centers,
    columns,
    pageCount,
    shallow: true,
    debounceMs: 500,
    initialState: { columnPinning: { right: ['actions'] } }
  });

  return (
    <DataTable table={table}>
      <DataTableToolbar
        table={table}
        filterParams={[{ paramKey: 'is_verified', columnId: 'is_verified' }]}
      />
    </DataTable>
  );
}

export function ServiceCentersTableSkeleton() {
  return (
    <div className='flex flex-1 animate-pulse flex-col gap-4'>
      <Skeleton className='h-10 w-full' />
      <Skeleton className='h-96 w-full' />
      <Skeleton className='h-10 w-full' />
    </div>
  );
}
