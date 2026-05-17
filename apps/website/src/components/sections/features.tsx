'use client';

import { Search, FileText, CalendarClock, Receipt, History, Users } from 'lucide-react';
import { motion, useInView } from 'framer-motion';
import { useRef } from 'react';

const features = [
  {
    icon: Search,
    title: 'Search by Number',
    description: 'Find any vehicle instantly by registration number.',
  },
  {
    icon: FileText,
    title: 'Digital Service Records',
    description: 'Log oil changes, parts replaced, costs — everything.',
  },
  {
    icon: CalendarClock,
    title: 'Next Service Reminders',
    description: 'Set due dates. Customers get notified automatically.',
  },
  {
    icon: Receipt,
    title: 'Invoice Generation',
    description: 'Create professional invoices. Share via WhatsApp.',
  },
  {
    icon: History,
    title: 'Service History',
    description: 'Complete timeline of every service for every vehicle.',
  },
  {
    icon: Users,
    title: 'Multi-User Access',
    description: 'Owner, mechanic, customer — everyone sees what they need.',
  },
];

export function Features() {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-100px' });

  return (
    <section className="py-20 lg:py-28 bg-white" ref={ref}>
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-accent">
            Features
          </span>
          <h2 className="mt-2 text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight text-gray-900">
            Everything You Need
          </h2>
          <p className="mt-4 text-lg text-gray-600 max-w-2xl mx-auto">
            Run a modern service centre with digital records, instant invoices, and automatic reminders.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
          {features.map((feature, i) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: i * 0.1 }}
              className="group relative rounded-2xl border border-gray-100 bg-white p-8 shadow-sm transition-all hover:shadow-lg hover:border-brand-accent/20 hover:-translate-y-1"
            >
              <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-brand-accent transition-colors group-hover:bg-brand-accent group-hover:text-white">
                <feature.icon className="h-6 w-6" />
              </div>
              <h3 className="mb-2 text-xl font-bold text-gray-900">{feature.title}</h3>
              <p className="text-gray-600 leading-relaxed">{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
