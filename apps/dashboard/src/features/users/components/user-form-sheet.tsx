'use client';
import { useState } from 'react';
import { useAppForm } from '@/components/ui/tanstack-form';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Sheet, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle
} from '@/components/ui/sheet';
import { Icons } from '@/components/icons';
import { useMutation } from '@tanstack/react-query';
import { createUserMutation, updateUserMutation } from '../api/mutations';
import type { User } from '../api/types';
import { toast } from 'sonner';
import * as z from 'zod';
import { ROLE_OPTIONS } from './users-table/options';

const STATUS_OPTIONS = [
  { value: 'true', label: 'Active' },
  { value: 'false', label: 'Inactive' }
];

interface UserFormSheetProps {
  user?: User;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function UserFormSheet({ user, open, onOpenChange }: UserFormSheetProps) {
  const isEdit = !!user;
  const [showPassword, setShowPassword] = useState(false);

  const createMutation = useMutation({
    ...createUserMutation,
    onSuccess: () => { toast.success('User created successfully'); onOpenChange(false); },
    onError: (e: any) => toast.error(e?.message ?? 'Failed to create user')
  });

  const updateMutation = useMutation({
    ...updateUserMutation,
    onSuccess: () => { toast.success('User updated successfully'); onOpenChange(false); },
    onError: (e: any) => toast.error(e?.message ?? 'Failed to update user')
  });

  const form = useAppForm({
    defaultValues: {
      display_name: user?.display_name ?? '',
      email: user?.email ?? '',
      phone_number: user?.phone_number ?? '',
      role_id: String(user?.role_id ?? '2'),
      is_active: String(user?.is_active ?? 'true'),
      password: ''
    },
    onSubmit: async ({ value }) => {
      const payload: any = {
        display_name: value.display_name,
        email: value.email,
        phone_number: value.phone_number,
        role_id: parseInt(value.role_id),
        is_active: value.is_active === 'true'
      };
      if (value.password) payload.password = value.password;
      if (isEdit) {
        await updateMutation.mutateAsync({ id: user.id, values: payload });
      } else {
        await createMutation.mutateAsync(payload);
      }
    }
  });

  const isPending = createMutation.isPending || updateMutation.isPending;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className='flex flex-col'>
        <SheetHeader>
          <SheetTitle>{isEdit ? 'Edit User' : 'New User'}</SheetTitle>
          <SheetDescription>
            {isEdit ? 'Update user details below.' : 'Fill in details to create a new user.'}
          </SheetDescription>
        </SheetHeader>
        <div className='flex-1 overflow-auto px-1'>
          <form.AppForm>
            <form.Form id='user-form-sheet' className='space-y-4'>
              <form.AppField name='display_name'
                validators={{ onBlur: z.string().min(2, 'Name must be at least 2 characters') }}>
                {(field) => <field.TextField label='Display Name' required placeholder='John Doe' />}
              </form.AppField>
              <form.AppField name='email'
                validators={{ onBlur: z.string().email('Please enter a valid email') }}>
                {(field) => <field.TextField label='Email' required type='email' placeholder='john@example.com' />}
              </form.AppField>
              <form.AppField name='phone_number'>
                {(field) => <field.TextField label='Phone' type='tel' placeholder='+91 9876543210' />}
              </form.AppField>
              <form.AppField
                name='password'
                validators={!isEdit ? { onBlur: z.string().min(6, 'Password must be at least 6 characters') } : undefined}
              >
                {(field) => (
                  <field.FieldSet>
                    <field.Field>
                      <field.FieldLabel htmlFor={field.name}>
                        {isEdit ? 'New Password' : 'Password'}{!isEdit && <span className='text-destructive ml-1'>*</span>}
                      </field.FieldLabel>
                      <div className='relative'>
                        <Input
                          id={field.name}
                          name={field.name}
                          type={showPassword ? 'text' : 'password'}
                          value={field.state.value}
                          onBlur={field.handleBlur}
                          onChange={(e) => field.handleChange(e.target.value)}
                          placeholder={isEdit ? 'Leave blank to keep current' : 'Min. 6 characters'}
                          className='pr-10'
                        />
                        <button
                          type='button'
                          onClick={() => setShowPassword((v) => !v)}
                          className='text-muted-foreground hover:text-foreground absolute top-1/2 right-3 -translate-y-1/2'
                          tabIndex={-1}
                          aria-label={showPassword ? 'Hide password' : 'Show password'}
                        >
                          {showPassword ? <Icons.eye className='h-4 w-4' /> : <Icons.eyeOff className='h-4 w-4' />}
                        </button>
                      </div>
                    </field.Field>
                    <field.FieldError />
                  </field.FieldSet>
                )}
              </form.AppField>
              <form.AppField name='role_id'
                validators={{ onBlur: z.string().min(1, 'Please select a role') }}>
                {(field) => <field.SelectField label='Role' required options={ROLE_OPTIONS} placeholder='Select role' />}
              </form.AppField>
              <form.AppField name='is_active'>
                {(field) => <field.SelectField label='Status' required options={STATUS_OPTIONS} placeholder='Select status' />}
              </form.AppField>
            </form.Form>
          </form.AppForm>
        </div>
        <SheetFooter>
          <Button variant='outline' onClick={() => onOpenChange(false)}>Cancel</Button>
          <Button type='submit' form='user-form-sheet' isLoading={isPending}>
            <Icons.check /> {isEdit ? 'Update User' : 'Create User'}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

export function UserFormSheetTrigger() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <Icons.add className='mr-2 h-4 w-4' /> Add User
      </Button>
      <UserFormSheet open={open} onOpenChange={setOpen} />
    </>
  );
}
