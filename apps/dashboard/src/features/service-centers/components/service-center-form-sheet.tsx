'use client';
import { useState } from 'react';
import { useAppForm, useFormFields } from '@/components/ui/tanstack-form';
import { Button } from '@/components/ui/button';
import {
  Sheet, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle
} from '@/components/ui/sheet';
import { Icons } from '@/components/icons';
import { useMutation } from '@tanstack/react-query';
import { createServiceCenterMutation, updateServiceCenterMutation } from '../api/mutations';
import type { ServiceCenter } from '../api/types';
import { toast } from 'sonner';
import { serviceCenterSchema, type ServiceCenterFormValues } from '../schemas/service-center';
import * as z from 'zod';

interface ServiceCenterFormSheetProps {
  center?: ServiceCenter;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ServiceCenterFormSheet({ center, open, onOpenChange }: ServiceCenterFormSheetProps) {
  const isEdit = !!center;

  const createMutation = useMutation({
    ...createServiceCenterMutation,
    onSuccess: () => { toast.success('Service center created'); onOpenChange(false); form.reset(); },
    onError: () => toast.error('Failed to create service center')
  });

  const updateMutation = useMutation({
    ...updateServiceCenterMutation,
    onSuccess: () => { toast.success('Service center updated'); onOpenChange(false); },
    onError: () => toast.error('Failed to update service center')
  });

  const form = useAppForm({
    defaultValues: {
      name: center?.name ?? '',
      phone: center?.phone ?? '',
      email: center?.email ?? '',
      description: center?.description ?? '',
      address: center?.address ?? '',
      city: center?.city ?? '',
      state: center?.state ?? '',
      pincode: center?.pincode ?? '',
      is_verified: center?.is_verified ?? false,
      is_active: center?.is_active ?? true
    } as ServiceCenterFormValues,
    validators: { onSubmit: serviceCenterSchema },
    onSubmit: async ({ value }) => {
      if (isEdit) {
        await updateMutation.mutateAsync({ id: center.id, values: value });
      } else {
        await createMutation.mutateAsync(value);
      }
    }
  });

  const { FormTextField, FormTextareaField, FormSwitchField } = useFormFields<ServiceCenterFormValues>();
  const isPending = createMutation.isPending || updateMutation.isPending;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className='flex flex-col'>
        <SheetHeader>
          <SheetTitle>{isEdit ? 'Edit Service Center' : 'New Service Center'}</SheetTitle>
          <SheetDescription>
            {isEdit ? 'Update service center details.' : 'Fill in details to add a new service center.'}
          </SheetDescription>
        </SheetHeader>
        <div className='flex-1 overflow-auto px-1'>
          <form.AppForm>
            <form.Form id='sc-form-sheet' className='space-y-4'>
              <FormTextField name='name' label='Name' required
                validators={{ onBlur: z.string().min(2, 'Required') }} />
              <FormTextField name='phone' label='Phone' required type='tel'
                validators={{ onBlur: z.string().min(1, 'Required') }} />
              <FormTextField name='email' label='Email' type='email' />
              <FormTextareaField name='description' label='Description' />
              <FormTextField name='address' label='Address' />
              <div className='grid grid-cols-2 gap-4'>
                <FormTextField name='city' label='City' />
                <FormTextField name='state' label='State' />
              </div>
              <FormTextField name='pincode' label='Pincode' />
              <FormSwitchField name='is_verified' label='Verified' description='Mark as a verified service center' />
              <FormSwitchField name='is_active' label='Active' description='Show this center to users' />
            </form.Form>
          </form.AppForm>
        </div>
        <SheetFooter>
          <Button variant='outline' onClick={() => onOpenChange(false)}>Cancel</Button>
          <Button type='submit' form='sc-form-sheet' isLoading={isPending}>
            <Icons.check /> {isEdit ? 'Update' : 'Create'}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

export function ServiceCenterFormSheetTrigger() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <Icons.add className='mr-2 h-4 w-4' /> Add Center
      </Button>
      <ServiceCenterFormSheet open={open} onOpenChange={setOpen} />
    </>
  );
}
