'use client';
import { AlertModal } from '@/components/modal/alert-modal';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { cancelBookingMutation } from '../../api/mutations';
import type { Booking } from '../../api/types';
import { Icons } from '@/components/icons';
import { useState } from 'react';
import { useMutation } from '@tanstack/react-query';
import { toast } from 'sonner';
import { BookingFormSheet } from '../booking-form-sheet';

export function CellAction({ data }: { data: Booking }) {
  const [cancelOpen, setCancelOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);

  const cancelMutation = useMutation({
    ...cancelBookingMutation,
    onSuccess: () => { toast.success('Booking cancelled'); setCancelOpen(false); },
    onError: () => toast.error('Failed to cancel booking')
  });

  const isCancellable = data.status !== 'cancelled' && data.status !== 'completed';

  return (
    <>
      <AlertModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={() => cancelMutation.mutate(data.id)}
        loading={cancelMutation.isPending}
      />
      <BookingFormSheet booking={data} open={editOpen} onOpenChange={setEditOpen} />
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
            <Icons.edit className='mr-2 h-4 w-4' /> Update Status
          </DropdownMenuItem>
          {isCancellable && (
            <DropdownMenuItem onClick={() => setCancelOpen(true)} className='text-destructive'>
              <Icons.circleX className='mr-2 h-4 w-4' /> Cancel
            </DropdownMenuItem>
          )}
        </DropdownMenuContent>
      </DropdownMenu>
    </>
  );
}
