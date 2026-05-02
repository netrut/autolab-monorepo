'use client';
import { useState } from 'react';
import { useAppForm } from '@/components/ui/tanstack-form';
import { Button } from '@/components/ui/button';
import {
  Sheet, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle
} from '@/components/ui/sheet';
import { Icons } from '@/components/icons';
import { useMutation, useQuery } from '@tanstack/react-query';
import { createVehicleMutation, updateVehicleMutation } from '../api/mutations';
import type { Vehicle } from '../api/types';
import { toast } from 'sonner';
import { vehicleSchema, type VehicleFormValues } from '../schemas/vehicle';
import { VEHICLE_TYPE_OPTIONS, FUEL_TYPE_OPTIONS, TRANSMISSION_OPTIONS } from './vehicles-table/options';
import * as z from 'zod';

async function fetchUsersForSelect() {
  const res = await fetch('/api/users?limit=100');
  const data = await res.json();
  return (data.users ?? []).map((u: any) => ({
    value: u.id,
    label: u.display_name ? `${u.display_name} (${u.email})` : u.email
  }));
}

interface VehicleFormSheetProps {
  vehicle?: Vehicle;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function VehicleFormSheet({ vehicle, open, onOpenChange }: VehicleFormSheetProps) {
  const isEdit = !!vehicle;

  const { data: userOptions = [] } = useQuery({
    queryKey: ['users-select'],
    queryFn: fetchUsersForSelect,
    enabled: open && !isEdit
  });

  const createMutation = useMutation({
    ...createVehicleMutation,
    onSuccess: () => { toast.success('Vehicle created'); onOpenChange(false); form.reset(); },
    onError: (e: any) => toast.error(e?.message ?? 'Failed to create vehicle')
  });

  const updateMutation = useMutation({
    ...updateVehicleMutation,
    onSuccess: () => { toast.success('Vehicle updated'); onOpenChange(false); },
    onError: (e: any) => toast.error(e?.message ?? 'Failed to update vehicle')
  });

  const form = useAppForm({
    defaultValues: {
      user_id: vehicle?.user_id ?? '',
      vehicle_type: vehicle?.vehicle_type ?? '',
      brand: vehicle?.brand ?? '',
      model: vehicle?.model ?? '',
      year: vehicle?.year ?? new Date().getFullYear(),
      registration_number: vehicle?.registration_number ?? '',
      vehicle_color: vehicle?.vehicle_color ?? '',
      fuel_type: vehicle?.fuel_type ?? '',
      transmission: vehicle?.transmission ?? '',
      notes: vehicle?.notes ?? '',
      is_active: vehicle?.is_active ?? true
    } as VehicleFormValues,
    validators: { onSubmit: vehicleSchema },
    onSubmit: async ({ value }) => {
      if (isEdit) {
        await updateMutation.mutateAsync({ id: vehicle.id as string, values: value });
      } else {
        await createMutation.mutateAsync(value);
      }
    }
  });

  const isPending = createMutation.isPending || updateMutation.isPending;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className='flex flex-col'>
        <SheetHeader>
          <SheetTitle>{isEdit ? 'Edit Vehicle' : 'New Vehicle'}</SheetTitle>
          <SheetDescription>
            {isEdit ? 'Update vehicle details.' : 'Fill in details to register a new vehicle.'}
          </SheetDescription>
        </SheetHeader>
        <div className='flex-1 overflow-auto px-1'>
          <form.AppForm>
            <form.Form id='vehicle-form-sheet' className='space-y-4'>
              {!isEdit && (
                <form.AppField name='user_id'
                  validators={{ onBlur: z.string().min(1, 'Please select a user') }}>
                  {(field) => (
                    <field.SelectField
                      label='Owner (User)'
                      required
                      options={userOptions}
                      placeholder={userOptions.length ? 'Search and select user...' : 'Loading users...'}
                    />
                  )}
                </form.AppField>
              )}
              <form.AppField name='vehicle_type'
                validators={{ onBlur: z.string().min(1, 'Required') }}>
                {(field) => <field.SelectField label='Vehicle Type' required options={VEHICLE_TYPE_OPTIONS} placeholder='Select type' />}
              </form.AppField>
              <div className='grid grid-cols-2 gap-4'>
                <form.AppField name='brand'
                  validators={{ onBlur: z.string().min(1, 'Required') }}>
                  {(field) => <field.TextField label='Brand' required placeholder='Toyota' />}
                </form.AppField>
                <form.AppField name='model'
                  validators={{ onBlur: z.string().min(1, 'Required') }}>
                  {(field) => <field.TextField label='Model' required placeholder='Fortuner' />}
                </form.AppField>
              </div>
              <div className='grid grid-cols-2 gap-4'>
                <form.AppField name='year'
                  validators={{ onBlur: z.number().min(1900, 'Invalid year') }}>
                  {(field) => <field.TextField label='Year' required type='number' placeholder='2023' />}
                </form.AppField>
                <form.AppField name='registration_number'>
                  {(field) => <field.TextField label='Reg. Number' placeholder='DL01AB1234' />}
                </form.AppField>
              </div>
              <div className='grid grid-cols-2 gap-4'>
                <form.AppField name='vehicle_color'>
                  {(field) => <field.TextField label='Color' placeholder='Silver' />}
                </form.AppField>
                <form.AppField name='fuel_type'>
                  {(field) => <field.SelectField label='Fuel Type' options={FUEL_TYPE_OPTIONS} placeholder='Select fuel' />}
                </form.AppField>
              </div>
              <form.AppField name='transmission'>
                {(field) => <field.SelectField label='Transmission' options={TRANSMISSION_OPTIONS} placeholder='Select transmission' />}
              </form.AppField>
              <form.AppField name='notes'>
                {(field) => <field.TextareaField label='Notes' placeholder='Optional notes...' />}
              </form.AppField>
              {isEdit && (
                <form.AppField name='is_active'>
                  {(field) => <field.SwitchField label='Active' description='Mark vehicle as active' />}
                </form.AppField>
              )}
            </form.Form>
          </form.AppForm>
        </div>
        <SheetFooter>
          <Button variant='outline' onClick={() => onOpenChange(false)}>Cancel</Button>
          <Button type='submit' form='vehicle-form-sheet' isLoading={isPending}>
            <Icons.check /> {isEdit ? 'Update' : 'Create'}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

export function VehicleFormSheetTrigger() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <Icons.add className='mr-2 h-4 w-4' /> Add Vehicle
      </Button>
      <VehicleFormSheet open={open} onOpenChange={setOpen} />
    </>
  );
}
