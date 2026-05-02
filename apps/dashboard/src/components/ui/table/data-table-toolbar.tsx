'use client';

import type { Column, Table } from '@tanstack/react-table';
import * as React from 'react';

import { DataTableDateFilter } from '@/components/ui/table/data-table-date-filter';
import { DataTableFacetedFilter } from '@/components/ui/table/data-table-faceted-filter';
import { DataTableSliderFilter } from '@/components/ui/table/data-table-slider-filter';
import { DataTableViewOptions } from '@/components/ui/table/data-table-view-options';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { cn } from '@/lib/utils';
import { Cross2Icon } from '@radix-ui/react-icons';
import { parseAsInteger, parseAsString, useQueryStates } from 'nuqs';
import { useDebounce } from '@/hooks/use-debounce';

export type FilterParam = {
  /** URL query param key */
  paramKey: string;
  /** column id this filter maps to */
  columnId: string;
};

interface DataTableToolbarProps<TData> extends React.ComponentProps<'div'> {
  table: Table<TData>;
  /** Map select/multiSelect column filters to URL params */
  filterParams?: FilterParam[];
}

export function DataTableToolbar<TData>({
  table,
  children,
  className,
  filterParams = [],
  ...props
}: DataTableToolbarProps<TData>) {
  const isFiltered = table.getState().columnFilters.length > 0;

  const filterableColumns = React.useMemo(
    () => table.getAllColumns().filter((column) => column.getCanFilter()),
    [table]
  );

  // Build nuqs param shape: name (text search) + any extra select params
  const paramShape = React.useMemo(() => {
    const shape: Record<string, any> = {
      name: parseAsString,
      page: parseAsInteger.withDefault(1)
    };
    for (const fp of filterParams) {
      shape[fp.paramKey] = parseAsString;
    }
    return shape;
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const [urlParams, setUrlParams] = useQueryStates(paramShape as any);

  // Local state for the text input so typing feels instant
  const [localSearch, setLocalSearch] = React.useState<string>(
    (urlParams.name as string) ?? ''
  );
  const debouncedSearch = useDebounce(localSearch, 500);

  // Sync debounced value → URL
  React.useEffect(() => {
    const current = (urlParams.name as string) ?? '';
    if (debouncedSearch !== current) {
      setUrlParams({ name: debouncedSearch || null, page: 1 } as any);
    }
  }, [debouncedSearch]); // eslint-disable-line react-hooks/exhaustive-deps

  // Keep local state in sync if URL changes externally (e.g. reset)
  React.useEffect(() => {
    setLocalSearch((urlParams.name as string) ?? '');
  }, [urlParams.name]);

  const onReset = React.useCallback(() => {
    table.resetColumnFilters();
    setLocalSearch('');
    const reset: Record<string, any> = { name: null, page: 1 };
    for (const fp of filterParams) reset[fp.paramKey] = null;
    setUrlParams(reset as any);
  }, [table, filterParams, setUrlParams]);

  const hasActiveFilters =
    isFiltered || !!localSearch || filterParams.some((fp) => !!(urlParams as any)[fp.paramKey]);

  return (
    <div
      role='toolbar'
      aria-orientation='horizontal'
      className={cn('flex w-full items-start justify-between gap-2 p-1', className)}
      {...props}
    >
      <div className='flex flex-1 flex-wrap items-center gap-2'>
        {filterableColumns.map((column) => {
          const fp = filterParams.find((f) => f.columnId === column.id);
          return (
            <DataTableToolbarFilter
              key={column.id}
              column={column}
              searchValue={column.columnDef.meta?.variant === 'text' ? localSearch : undefined}
              onSearchChange={
                column.columnDef.meta?.variant === 'text'
                  ? (val) => setLocalSearch(val)
                  : undefined
              }
              urlFilterValue={
                fp && (column.columnDef.meta?.variant === 'select' || column.columnDef.meta?.variant === 'multiSelect')
                  ? ((urlParams as any)[fp.paramKey] ?? undefined)
                  : undefined
              }
              onUrlFilterChange={
                fp && (column.columnDef.meta?.variant === 'select' || column.columnDef.meta?.variant === 'multiSelect')
                  ? (val) => setUrlParams({ [fp.paramKey]: val || null, page: 1 } as any)
                  : undefined
              }
            />
          );
        })}
        {hasActiveFilters && (
          <Button
            aria-label='Reset filters'
            variant='outline'
            size='sm'
            className='border-dashed'
            onClick={onReset}
          >
            <Cross2Icon />
            Reset
          </Button>
        )}
      </div>
      <div className='flex items-center gap-2'>
        {children}
        <DataTableViewOptions table={table} />
      </div>
    </div>
  );
}

interface DataTableToolbarFilterProps<TData> {
  column: Column<TData>;
  searchValue?: string;
  onSearchChange?: (value: string) => void;
  urlFilterValue?: string;
  onUrlFilterChange?: (value: string) => void;
}

function DataTableToolbarFilter<TData>({
  column,
  searchValue,
  onSearchChange,
  urlFilterValue,
  onUrlFilterChange
}: DataTableToolbarFilterProps<TData>) {
  const columnMeta = column.columnDef.meta;

  const onFilterRender = React.useCallback(() => {
    if (!columnMeta?.variant) return null;

    switch (columnMeta.variant) {
      case 'text':
        return (
          <Input
            placeholder={columnMeta.placeholder ?? columnMeta.label}
            value={searchValue ?? ''}
            onChange={(e) => onSearchChange?.(e.target.value)}
            className='h-8 w-40 lg:w-56'
          />
        );

      case 'number':
        return (
          <div className='relative'>
            <Input
              type='number'
              inputMode='numeric'
              placeholder={columnMeta.placeholder ?? columnMeta.label}
              value={(column.getFilterValue() as string) ?? ''}
              onChange={(event) => column.setFilterValue(event.target.value)}
              className={cn('h-8 w-[120px]', columnMeta.unit && 'pr-8')}
            />
            {columnMeta.unit && (
              <span className='bg-accent text-muted-foreground absolute top-0 right-0 bottom-0 flex items-center rounded-r-md px-2 text-sm'>
                {columnMeta.unit}
              </span>
            )}
          </div>
        );

      case 'range':
        return <DataTableSliderFilter column={column} title={columnMeta.label ?? column.id} />;

      case 'date':
      case 'dateRange':
        return (
          <DataTableDateFilter
            column={column}
            title={columnMeta.label ?? column.id}
            multiple={columnMeta.variant === 'dateRange'}
          />
        );

      case 'select':
      case 'multiSelect':
        if (onUrlFilterChange !== undefined) {
          // URL-driven: pass value/onChange directly to faceted filter
          return (
            <DataTableFacetedFilter
              column={column}
              title={columnMeta.label ?? column.id}
              options={columnMeta.options ?? []}
              multiple={columnMeta.variant === 'multiSelect'}
              urlValue={urlFilterValue}
              onUrlChange={onUrlFilterChange}
            />
          );
        }
        return (
          <DataTableFacetedFilter
            column={column}
            title={columnMeta.label ?? column.id}
            options={columnMeta.options ?? []}
            multiple={columnMeta.variant === 'multiSelect'}
          />
        );

      default:
        return null;
    }
  }, [column, columnMeta, searchValue, onSearchChange, urlFilterValue, onUrlFilterChange]);

  return onFilterRender();
}
