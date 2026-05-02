'use client';
import { useState, useEffect } from 'react';
import { useAppForm } from '@/components/ui/tanstack-form';
import { Button } from '@/components/ui/button';
import {
  Sheet, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle
} from '@/components/ui/sheet';
import { Icons } from '@/components/icons';
import { useMutation, useQuery } from '@tanstack/react-query';
import { createBookingMutation, updateBookingMutation } from '../api/mutations';
import type { Booking } from '../api/types';
import { toast } from 'sonner';
import { createBookingSchema, updateBookingSchema } from '../schemas/booking';
import { BOOKING_STATUS_OPTIONS, SERVICE_TYPE_OPTIONS } from './bookings-table/options';
import * as z from 'zod';

// Fetch helpers for searchable selects
async function fetchUsers() {
  const res = await fetch('/api/users?limit=100');
  const data = await res.json();
  return (data.users ?? []).map((u: any) => ({
    value: u.id,
    label: u.display_name ? `${u.display_name} (${u.email})` : u.email
  }));
}

async function fetchVehicles() {
  const res = await fetch('/api/vehicles?limit=100');
  const data = await res.json();
  return (data.vehicles ?? []).map((v: any) => ({
    value: v.id,
    label: `${v.brand} ${v.model}${v.registration_number ? ` — ${v.registration_number}` : ''}`
  }));
}

async function fetchServiceCenters() {
  const res = await fetch('/api/service-centers?limit=100');
  const data = await res.json();
  return (data.centers ?? []).map((c: any) => ({
    value: c.id,
    label: `${c.name}${c.city ? ` (${c.city})` : ''}`
  }));
}

interface BookingFormSheetProps {
  booking?: Booking;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function BookingFormSheet({ booking, open, onOpenChange }: BookingFormSheetProps) {
  const isEdit = !!booking;

  const { data: users = [] } = useQuery({ queryKey: ['users-select'], queryFn: fetchUsers, enabled: open && !isEdit });
  const { data: vehicles = [] } = useQuery({ queryKey: ['vehicles-select'], queryFn: fetchVehicles, enabled: open && !isEdit });
  const { data: centers = [] } = useQuery({ queryKey: ['centers-select'], queryFn: fetchServiceCenters, enabled: open && !isEdit });

  const createMutation = useMutation({
    ...createBookingMutation,
    onSuccess: () => { toast.success('Booking created'); onOpenChange(false); },
    onError: () => toast.error('Failed to create booking')
  });

  const updateMutation = useMutation({
    ...updateBookingMutation,
    onSuccess: () => { toast.success('Booking updated'); onOpenChange(false); },
    onError: () => toast.error('Failed to update booking')
  });

  const createForm = useAppForm({
    defaultValues: {
      user_id: '', vehicle_id: '', service_center_id: '',
      service_type: '', booking_date: '', notes: ''
    },
    onSubmit: async ({ value }) => {
      await createMutation.mutateAsync({ ...value, notes: value.notes || undefined });
    }
  });

  const updateForm = useAppForm({
    defaultValues: {
      status: booking?.status ?? 'pending',
      service_type: booking?.service_type ?? '',
      booking_date: booking?.booking_date ? booking.booking_date.slice(0, 10) : '',
      notes: booking?.notes ?? ''
    },
    onSubmit: async ({ value }) => {
      await updateMutation.mutateAsync({ id: booking!.id, values: { ...value, notes: value.notes || undefined } });
    }
  });

  const isPending = createMutation.isPending || updateMutation.isPending;

  if (isEdit) {
    return (
      <Sheet open={open} onOpenChange={onOpenChange}>
        <SheetContent className='flex flex-col'>
          <SheetHeader>
            <SheetTitle>Update Booking</SheetTitle>
            <SheetDescription>Update booking status and details.</SheetDescription>
          </SheetHeader>
          <div className='flex-1 overflow-auto px-1'>
            <updateForm.AppForm>
              <updateForm.Form id='booking-update-form' className='space-y-4'>
                <updateForm.AppField name='status'
                  validators={{ onBlur: z.string().min(1, 'Required') }}>
                  {(field) => <field.SelectField label='Status' required options={BOOKING_STATUS_OPTIONS} placeholder='Select status' />}
                </updateForm.AppField>
                <updateForm.AppField name='service_type'
                  validators={{ onBlur: z.string().min(1, 'Required') }}>
                  {(field) => <field.SelectField label='Service Type' required options={SERVICE_TYPE_OPTIONS} placeholder='Select service' />}
                </updateForm.AppField>
                <updateForm.AppField name='booking_date'
                  validators={{ onBlur: z.string().min(1, 'Required') }}>
                  {(field) => <field.TextField label='Booking Date' required placeholder='YYYY-MM-DD' />}
                </updateForm.AppField>
                <updateForm.AppField name='notes'>
                  {(field) => <field.TextareaField label='Notes' placeholder='Optional notes...' />}
                </updateForm.AppField>
              </updateForm.Form>
            </updateForm.AppForm>
          </div>
          <SheetFooter>
            <Button variant='outline' onClick={() => onOpenChange(false)}>Cancel</Button>
            <Button type='submit' form='booking-update-form' isLoading={isPending}>
              <Icons.check /> Update
            </Button>
          </SheetFooter>
        </SheetContent>
      </Sheet>
    );
  }

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className='flex flex-col'>
        <SheetHeader>
          <SheetTitle>New Booking</SheetTitle>
          <SheetDescription>Fill in details to create a new booking.</SheetDescription>
        </SheetHeader>
        <div className='flex-1 overflow-auto px-1'>
          <createForm.AppForm>
            <createForm.Form id='booking-create-form' className='space-y-4'>
              <createForm.AppField name='user_id'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.SelectField label='User' required options={users} placeholder={users.length ? 'Select user' : 'Loading...'} />}
              </createForm.AppField>
              <createForm.AppField name='vehicle_id'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.SelectField label='Vehicle' required options={vehicles} placeholder={vehicles.length ? 'Select vehicle' : 'Loading...'} />}
              </createForm.AppField>
              <createForm.AppField name='service_center_id'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.SelectField label='Service Center' required options={centers} placeholder={centers.length ? 'Select center' : 'Loading...'} />}
              </createForm.AppField>
              <createForm.AppField name='service_type'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.SelectField label='Service Type' required options={SERVICE_TYPE_OPTIONS} placeholder='Select service' />}
              </createForm.AppField>
              <createForm.AppField name='booking_date'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.TextField label='Booking Date' required placeholder='YYYY-MM-DD' />}
              </createForm.AppField>
              <createForm.AppField name='notes'>
                {(field) => <field.TextareaField label='Notes' placeholder='Optional notes...' />}
              </createForm.AppField>
            </createForm.Form>
          </createForm.AppForm>
        </div>
        <SheetFooter>
          <Button variant='outline' onClick={() => onOpenChange(false)}>Cancel</Button>
          <Button type='submit' form='booking-create-form' isLoading={isPending}>
            <Icons.check /> Create
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

export function BookingFormSheetTrigger() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <Icons.add className='mr-2 h-4 w-4' /> Add Booking
      </Button>
      <BookingFormSheet open={open} onOpenChange={setOpen} />
    </>
  );
}
