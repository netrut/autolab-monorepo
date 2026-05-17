import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const APP_LINKS = {
  serviceCentre: {
    web: 'https://autolab-partner-app.vercel.app',
    playStore: '#',
    appStore: '#',
  },
  customer: {
    web: 'https://autolab-customer-app.vercel.app',
    playStore: '#',
    appStore: '#',
  },
  whatsapp: 'https://wa.me/919876543210',
  email: 'hello@autolab.in',
};
