'use client';
import { AlertModal } from '@/components/modal/alert-modal';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem,
  DropdownMenuLabel, DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { deactivateVehicleMutation } from '../../api/mutations';
import type { Vehicle } from '../../api/types';
import { Icons } from '@/components/icons';
import { useState } from 'react';
import { useMutation } from '@tanstack/react-query';
import { toast } from 'sonner';
import { VehicleFormSheet } from '../vehicle-form-sheet';

export function CellAction({ data }: { data: Vehicle }) {
  const [deactivateOpen, setDeactivateOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);

  const deactivateMutation = useMutation({
    ...deactivateVehicleMutation,
    onSuccess: () => { toast.success('Vehicle deactivated'); setDeactivateOpen(false); },
    onError: () => toast.error('Failed to deactivate vehicle')
  });

  return (
    <>
      <AlertModal
        isOpen={deactivateOpen}
        onClose={() => setDeactivateOpen(false)}
        onConfirm={() => deactivateMutation.mutate(data.id as string)}
        loading={deactivateMutation.isPending}
      />
      <VehicleFormSheet vehicle={data} open={editOpen} onOpenChange={setEditOpen} />
      <DropdownMenu modal={false}>
        <DropdownMenuTrigger asChild>
          <Button variant='ghost' className='h-8 w-8 p-0'>
            <span className='sr-only'>Open menu</span>
            <Icons.ellipsis className='h-4 w-4' />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align='end'>
          <DropdownMenuLabel>Actions</DropdownMenuLabel>
          <DropdownMenuItem onClick={() => setEditOpen(true)}>
            <Icons.edit className='mr-2 h-4 w-4' /> Edit
          </DropdownMenuItem>
          {data.is_active && (
            <DropdownMenuItem onClick={() => setDeactivateOpen(true)} className='text-destructive'>
              <Icons.eyeOff className='mr-2 h-4 w-4' /> Deactivate
            </DropdownMenuItem>
          )}
        </DropdownMenuContent>
      </DropdownMenu>
    </>
  );
}
