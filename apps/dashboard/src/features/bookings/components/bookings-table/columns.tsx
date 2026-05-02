'use client';
import { Badge } from '@/components/ui/badge';
import { DataTableColumnHeader } from '@/components/ui/table/data-table-column-header';
import type { Booking } from '../../api/types';
import { ColumnDef } from '@tanstack/react-table';
import { Icons } from '@/components/icons';
import { CellAction } from './cell-action';
import { BOOKING_STATUS_OPTIONS } from './options';
import { formatDate } from '@/lib/format';

const statusVariant: Record<string, 'default' | 'secondary' | 'outline' | 'destructive'> = {
  pending: 'outline',
  confirmed: 'default',
  in_progress: 'default',
  completed: 'secondary',
  cancelled: 'destructive'
};

export const columns: ColumnDef<Booking>[] = [
  {
    id: 'user',
    accessorFn: (row) => row.users?.display_name ?? row.users?.email ?? row.user_id,
    header: 'USER',
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>{row.original.users?.display_name ?? '—'}</span>
        <span className='text-muted-foreground text-xs'>{row.original.users?.email}</span>
      </div>
    ),
    meta: { label: 'User', placeholder: 'Search...', variant: 'text' as const, icon: Icons.text },
    enableColumnFilter: true
  },
  {
    id: 'vehicle',
    accessorFn: (row) => `${row.vehicles?.brand ?? ''} ${row.vehicles?.model ?? ''}`.trim(),
    header: 'VEHICLE',
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>
          {row.original.vehicles?.brand} {row.original.vehicles?.model}
        </span>
        <span className='text-muted-foreground text-xs'>{row.original.vehicles?.license_plate ?? '—'}</span>
      </div>
    )
  },
  {
    accessorKey: 'service_type',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Service' />,
    cell: ({ cell }) => (
      <span className='capitalize'>{cell.getValue<string>().replace(/_/g, ' ')}</span>
    )
  },
  {
    id: 'service_center',
    accessorFn: (row) => row.service_centers?.name ?? row.service_center_id,
    header: 'CENTER',
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>{row.original.service_centers?.name ?? '—'}</span>
        <span className='text-muted-foreground text-xs'>{row.original.service_centers?.city}</span>
      </div>
    )
  },
  {
    accessorKey: 'booking_date',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Date' />,
    cell: ({ cell }) => formatDate(cell.getValue<string>(), { month: 'short', day: 'numeric', year: 'numeric' })
  },
  {
    id: 'status',
    accessorKey: 'status',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Status' />,
    cell: ({ cell }) => {
      const s = cell.getValue<string>() ?? 'pending';
      return (
        <Badge variant={statusVariant[s] ?? 'outline'} className='capitalize'>
          {s.replace(/_/g, ' ')}
        </Badge>
      );
    },
    enableColumnFilter: true,
    meta: { label: 'Status', variant: 'multiSelect' as const, options: BOOKING_STATUS_OPTIONS }
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
