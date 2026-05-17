import type { Metadata } from 'next';
import Link from 'next/link';
import { Check } from 'lucide-react';

export const metadata: Metadata = {
  title: 'AutoLab Pricing — Free Forever',
  description: 'AutoLab is completely free. Unlimited vehicles, service records, invoices, and users.',
};

const freePlan = [
  'Unlimited vehicles',
  'Unlimited service records',
  'Invoice generation',
  'WhatsApp sharing',
  'Multi-user access',
  'Customer notifications',
  'Service reminders',
  'PDF download',
];

const proPlan = [
  'Everything in Free',
  'Custom branding on invoices',
  'SMS reminders (bulk)',
  'Analytics dashboard',
  'Priority support',
  'API access',
  'White-label option',
  'Bulk import/export',
];

export default function PricingPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen bg-gray-50">
      <div className="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h1 className="text-4xl sm:text-5xl font-bold tracking-tight text-gray-900 mb-4">
            Simple, Transparent Pricing
          </h1>
          <p className="text-lg text-gray-600">
            AutoLab is free for everyone. Premium features coming soon.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Free */}
          <div className="rounded-2xl border-2 border-brand-accent bg-white p-8 shadow-lg relative">
            <span className="absolute -top-3 left-6 inline-flex items-center rounded-full bg-brand-accent px-3 py-1 text-xs font-bold text-white uppercase">
              Current
            </span>
            <div className="mb-6">
              <span className="text-4xl font-bold text-gray-900">₹0</span>
              <span className="text-gray-500 ml-1">/ forever</span>
            </div>
            <h3 className="text-xl font-bold text-gray-900 mb-2">Free</h3>
            <p className="text-gray-600 mb-6">Everything you need to manage vehicle services.</p>
            <ul className="space-y-3 mb-8">
              {freePlan.map((item) => (
                <li key={item} className="flex items-center gap-2 text-sm text-gray-700">
                  <Check className="h-4 w-4 text-brand-accent shrink-0" />
                  {item}
                </li>
              ))}
            </ul>
            <Link
              href="/download"
              className="block w-full text-center rounded-xl bg-brand-accent px-6 py-3 text-sm font-semibold text-white hover:bg-brand-accent-dark transition-colors"
            >
              Get Started Free
            </Link>
          </div>

          {/* Pro */}
          <div className="rounded-2xl border border-gray-200 bg-white p-8 relative opacity-80">
            <span className="absolute -top-3 left-6 inline-flex items-center rounded-full bg-gray-200 px-3 py-1 text-xs font-bold text-gray-600 uppercase">
              Coming Soon
            </span>
            <div className="mb-6">
              <span className="text-4xl font-bold text-gray-900">₹499</span>
              <span className="text-gray-500 ml-1">/ month</span>
            </div>
            <h3 className="text-xl font-bold text-gray-900 mb-2">Pro</h3>
            <p className="text-gray-600 mb-6">Advanced features for growing service centres.</p>
            <ul className="space-y-3 mb-8">
              {proPlan.map((item) => (
                <li key={item} className="flex items-center gap-2 text-sm text-gray-700">
                  <Check className="h-4 w-4 text-gray-400 shrink-0" />
                  {item}
                </li>
              ))}
            </ul>
            <button
              disabled
              className="block w-full text-center rounded-xl bg-gray-100 px-6 py-3 text-sm font-semibold text-gray-400 cursor-not-allowed"
            >
              Coming Soon
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
