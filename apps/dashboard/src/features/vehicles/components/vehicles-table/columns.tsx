'use client';
import { Badge } from '@/components/ui/badge';
import { DataTableColumnHeader } from '@/components/ui/table/data-table-column-header';
import type { Vehicle } from '../../api/types';
import { ColumnDef } from '@tanstack/react-table';
import { Icons } from '@/components/icons';
import { CellAction } from './cell-action';
import { VEHICLE_STATUS_OPTIONS } from './options';

export const columns: ColumnDef<Vehicle>[] = [
  {
    id: 'vehicle',
    accessorFn: (row) => `${row.brand} ${row.model}`,
    header: ({ column }) => <DataTableColumnHeader column={column} title='Vehicle' />,
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>{row.original.brand} {row.original.model}</span>
        <span className='text-muted-foreground text-xs capitalize'>{row.original.vehicle_type}</span>
      </div>
    ),
    meta: { label: 'Vehicle', placeholder: 'Search vehicles...', variant: 'text' as const, icon: Icons.text },
    enableColumnFilter: true
  },
  {
    accessorKey: 'registration_number',
    header: 'REG. NUMBER',
    cell: ({ cell }) => <span className='font-mono text-sm'>{cell.getValue<string | null>() ?? '—'}</span>
  },
  {
    accessorKey: 'year',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Year' />,
    cell: ({ cell }) => cell.getValue<number | null>() ?? '—'
  },
  {
    id: 'vehicle_color',
    accessorKey: 'vehicle_color',
    header: 'COLOR',
    cell: ({ cell }) => {
      const color = cell.getValue<string | null>();
      return (
        <div className='flex items-center gap-2'>
          {color && (
            <div className='h-3 w-3 rounded-full border' style={{ backgroundColor: color.toLowerCase() }} />
          )}
          <span className='capitalize'>{color ?? '—'}</span>
        </div>
      );
    }
  },
  {
    accessorKey: 'fuel_type',
    header: 'FUEL',
    cell: ({ cell }) => <span className='capitalize'>{cell.getValue<string | null>() ?? '—'}</span>
  },
  {
    id: 'owner',
    accessorFn: (row) => row.users?.display_name ?? row.users?.email ?? row.user_id,
    header: 'OWNER',
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='text-sm'>{row.original.users?.display_name ?? '—'}</span>
        <span className='text-muted-foreground text-xs'>{row.original.users?.email}</span>
      </div>
    )
  },
  {
    id: 'is_active',
    accessorKey: 'is_active',
    header: ({ column }) => <DataTableColumnHeader column={column} title='Status' />,
    cell: ({ cell }) => {
      const active = cell.getValue<boolean | null>();
      return <Badge variant={active ? 'default' : 'secondary'}>{active ? 'Active' : 'Inactive'}</Badge>;
    },
    enableColumnFilter: true,
    meta: { label: 'Status', variant: 'multiSelect' as const, options: VEHICLE_STATUS_OPTIONS }
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
