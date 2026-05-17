'use client';

import { useState } from 'react';
import { ChevronDown } from 'lucide-react';
import { cn } from '@/lib/utils';

const faqs = [
  {
    q: 'Is AutoLab free?',
    a: 'Yes! AutoLab is completely free for service centres and customers. We plan to offer premium features in the future, but the core app will always be free.',
  },
  {
    q: 'Do I need internet to use it?',
    a: 'You need internet to sync data. But once loaded, you can view cached records offline.',
  },
  {
    q: 'Can my customers see their service history?',
    a: 'Yes! When you complete a service, the customer can see it in their app immediately.',
  },
  {
    q: 'Is my data safe?',
    a: 'Your data is stored securely on cloud servers with encryption. We never share your data with third parties.',
  },
  {
    q: 'Can I use it for both cars and bikes?',
    a: 'Absolutely! AutoLab supports all vehicle types — cars, bikes, scooters, SUVs, trucks.',
  },
  {
    q: 'How do I get support?',
    a: 'WhatsApp us anytime. We typically respond within 1 hour during business hours.',
  },
];

export function FAQ() {
  const [open, setOpen] = useState<number | null>(null);

  return (
    <section className="py-20 lg:py-28 bg-gray-50">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-accent">
            FAQ
          </span>
          <h2 className="mt-2 text-3xl sm:text-4xl font-bold tracking-tight text-gray-900">
            Frequently Asked Questions
          </h2>
        </div>

        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div
              key={i}
              className="rounded-xl border border-gray-200 bg-white overflow-hidden"
            >
              <button
                onClick={() => setOpen(open === i ? null : i)}
                className="flex w-full items-center justify-between px-6 py-4 text-left"
              >
                <span className="text-base font-semibold text-gray-900">{faq.q}</span>
                <ChevronDown
                  className={cn(
                    'h-5 w-5 text-gray-400 transition-transform',
                    open === i && 'rotate-180'
                  )}
                />
              </button>
              {open === i && (
                <div className="px-6 pb-4">
                  <p className="text-gray-600 leading-relaxed">{faq.a}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
