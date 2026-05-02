'use client';
import { Badge } from '@/components/ui/badge';
import { DataTableColumnHeader } from '@/components/ui/table/data-table-column-header';
import type { ServiceCenter } from '../../api/types';
import { ColumnDef } from '@tanstack/react-table';
import { Icons } from '@/components/icons';
import { CellAction } from './cell-action';

export const columns: ColumnDef<ServiceCenter>[] = [
  {
    id: 'name',
    accessorKey: 'name',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Name' />,
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>{row.original.name}</span>
        <span className='text-muted-foreground text-xs'>{row.original.email ?? '—'}</span>
      </div>
    ),
    meta: { label: 'Name', placeholder: 'Search centers...', variant: 'text' as const, icon: Icons.text },
    enableColumnFilter: true
  },
  {
    accessorKey: 'phone',
    header: 'PHONE'
  },
  {
    id: 'location',
    accessorFn: (row) => `${row.city ?? ''} ${row.state ?? ''}`.trim(),
    header: 'LOCATION',
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span>{row.original.city ?? '—'}</span>
        <span className='text-muted-foreground text-xs'>{row.original.state}</span>
      </div>
    )
  },
  {
    accessorKey: 'rating',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Rating' />,
    cell: ({ cell }) => {
      const r = parseFloat(cell.getValue<string>() ?? '0');
      return <span>{'★'.repeat(Math.round(r))} {r.toFixed(1)}</span>;
    }
  },
  {
    id: 'is_verified',
    accessorKey: 'is_verified',
    header: 'VERIFIED',
    cell: ({ cell }) => (
      <Badge variant={cell.getValue<boolean>() ? 'default' : 'outline'}>
        {cell.getValue<boolean>() ? 'Verified' : 'Unverified'}
      </Badge>
    ),
    enableColumnFilter: true,
    meta: {
      label: 'Verified',
      variant: 'select' as const,
      options: [
        { value: 'true', label: 'Verified' },
        { value: 'false', label: 'Unverified' }
      ]
    }
  },
  {
    id: 'is_active',
    accessorKey: 'is_active',
    header: 'STATUS',
    cell: ({ cell }) => (
      <Badge variant={cell.getValue<boolean>() ? 'default' : 'secondary'}>
        {cell.getValue<boolean>() ? 'Active' : 'Inactive'}
      </Badge>
    )
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
