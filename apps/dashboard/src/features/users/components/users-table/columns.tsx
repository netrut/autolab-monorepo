'use client';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { DataTableColumnHeader } from '@/components/ui/table/data-table-column-header';
import type { User } from '../../api/types';
import { ColumnDef } from '@tanstack/react-table';
import { Icons } from '@/components/icons';
import { CellAction } from './cell-action';
import { ROLE_OPTIONS } from './options';
import { toast } from 'sonner';

export const columns: ColumnDef<User>[] = [
  {
    id: 'display_name',
    accessorFn: (row) => row.display_name ?? row.email,
    header: ({ column }) => <DataTableColumnHeader column={column} title='Name' />,
    cell: ({ row }) => (
      <div className='flex flex-col'>
        <span className='font-medium'>{row.original.display_name ?? '—'}</span>
        <span className='text-muted-foreground text-xs'>{row.original.email}</span>
      </div>
    ),
    meta: { label: 'Name', placeholder: 'Search users...', variant: 'text' as const, icon: Icons.text },
    enableColumnFilter: true
  },
  {
    id: 'id',
    accessorKey: 'id',
    header: 'USER ID',
    cell: ({ cell }) => {
      const id = cell.getValue<string>();
      const short = id.slice(0, 8) + '…';
      return (
        <div className='flex items-center gap-1'>
          <span className='font-mono text-xs text-muted-foreground'>{short}</span>
          <Button
            variant='ghost'
            size='icon'
            className='h-5 w-5'
            onClick={() => {
              navigator.clipboard.writeText(id);
              toast.success('User ID copied');
            }}
          >
            <Icons.page className='h-3 w-3' />
          </Button>
        </div>
      );
    }
  },
  {
    accessorKey: 'phone_number',
    header: 'PHONE',
    cell: ({ cell }) => cell.getValue<string | null>() ?? '—'
  },
  {
    id: 'role_id',
    accessorKey: 'role_id',
    enableSorting: false,
    header: ({ column }) => <DataTableColumnHeader column={column} title='Role' />,
    cell: ({ cell }) => {
      const roleId = cell.getValue<number | null>();
      const label = ROLE_OPTIONS.find((r) => r.value === String(roleId))?.label ?? `Role ${roleId}`;
      return <Badge variant='outline'>{label}</Badge>;
    },
    enableColumnFilter: true,
    meta: { label: 'Role', variant: 'multiSelect' as const, options: ROLE_OPTIONS }
  },
  {
    id: 'is_active',
    accessorKey: 'is_active',
    header: 'STATUS',
    cell: ({ cell }) => {
      const active = cell.getValue<boolean>();
      return <Badge variant={active ? 'default' : 'secondary'}>{active ? 'Active' : 'Inactive'}</Badge>;
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
