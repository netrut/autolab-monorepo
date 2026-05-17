'use client';

import { Download, Store, CheckCircle } from 'lucide-react';
import { motion, useInView } from 'framer-motion';
import { useRef } from 'react';

const steps = [
  {
    icon: Download,
    title: 'Download the App',
    description: 'Install AutoLab from Play Store or use the web app directly.',
  },
  {
    icon: Store,
    title: 'Register Your Centre',
    description: 'Add your service centre details in just 2 minutes.',
  },
  {
    icon: CheckCircle,
    title: 'Start Recording',
    description: 'Search vehicles, log services, and send invoices.',
  },
];

export function HowItWorks() {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-100px' });

  return (
    <section className="py-20 lg:py-28 bg-gray-50" ref={ref}>
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-accent">
            How It Works
          </span>
          <h2 className="mt-2 text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight text-gray-900">
            Get Started in 3 Simple Steps
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 lg:gap-12">
          {steps.map((step, i) => (
            <motion.div
              key={step.title}
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: i * 0.15 }}
              className="text-center"
            >
              <div className="mx-auto mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-brand-accent text-white text-xl font-bold shadow-lg shadow-blue-500/25">
                {i + 1}
              </div>
              <div className="mb-3 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-brand-accent">
                <step.icon className="h-6 w-6" />
              </div>
              <h3 className="mb-2 text-xl font-bold text-gray-900">{step.title}</h3>
              <p className="text-gray-600 leading-relaxed">{step.description}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
