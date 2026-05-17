'use client';

import { motion, useInView } from 'framer-motion';
import { useRef } from 'react';

const stats = [
  { value: '500+', label: 'Vehicles Tracked' },
  { value: '1000+', label: 'Service Records' },
  { value: '50+', label: 'Service Centres' },
  { value: '4.8★', label: 'User Rating' },
];

export function Stats() {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true });

  return (
    <section className="py-16 bg-gray-900" ref={ref}>
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          {stats.map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, scale: 0.8 }}
              animate={inView ? { opacity: 1, scale: 1 } : {}}
              transition={{ duration: 0.4, delay: i * 0.1 }}
              className="text-center"
            >
              <div className="text-3xl sm:text-4xl font-bold text-white">{stat.value}</div>
              <div className="mt-1 text-sm text-gray-400">{stat.label}</div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
