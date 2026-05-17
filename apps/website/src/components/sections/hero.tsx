'use client';

import Link from 'next/link';
import { ArrowRight, CheckCircle } from 'lucide-react';
import { motion } from 'framer-motion';

export function Hero() {
  return (
    <section className="relative min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-blue-900 overflow-hidden">
      {/* Subtle grid pattern */}
      <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMSIgY3k9IjEiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wNSkiLz48L3N2Zz4=')] opacity-50" />

      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 pt-32 pb-20 lg:pt-40 lg:pb-32">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Left content */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <span className="inline-flex items-center gap-2 rounded-full bg-white/10 px-4 py-1.5 text-sm font-medium text-blue-300 backdrop-blur-sm border border-white/10 mb-6">
              🚀 Now Available for Service Centres & Customers
            </span>

            <h1 className="text-4xl sm:text-5xl lg:text-6xl xl:text-7xl font-extrabold tracking-tight text-white leading-[1.1] mb-6">
              Your Complete Vehicle{' '}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-cyan-300">
                Service Management
              </span>{' '}
              Platform
            </h1>

            <p className="text-lg sm:text-xl text-gray-300 leading-relaxed mb-8 max-w-xl">
              Replace paper records with a digital system. Track every service, remind
              customers, and grow your business — all from one app.
            </p>

            <div className="flex flex-col sm:flex-row gap-4 mb-8">
              <Link
                href="/service-centre"
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-accent px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-500/25 transition-all hover:bg-brand-accent-dark hover:-translate-y-0.5"
              >
                For Service Centres
                <ArrowRight className="h-5 w-5" />
              </Link>
              <Link
                href="/customer"
                className="inline-flex items-center justify-center gap-2 rounded-xl border-2 border-white/20 px-8 py-4 text-lg font-semibold text-white transition-all hover:bg-white/10 hover:border-white/40"
              >
                For Customers
              </Link>
            </div>

            <div className="flex flex-wrap gap-4 text-sm text-gray-400">
              {['Free forever', 'No credit card', 'Made in India 🇮🇳'].map((item) => (
                <span key={item} className="inline-flex items-center gap-1.5">
                  <CheckCircle className="h-4 w-4 text-green-400" />
                  {item}
                </span>
              ))}
            </div>
          </motion.div>

          {/* Right - Phone mockups */}
          <motion.div
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="relative hidden lg:flex justify-center items-center"
          >
            {/* Phone 1 - Service Centre */}
            <div className="relative -rotate-6 z-10">
              <div className="w-[260px] rounded-[2.5rem] border-[6px] border-gray-700 bg-gray-900 p-1.5 shadow-2xl">
                <div className="overflow-hidden rounded-[2rem] bg-white aspect-[9/19.5]">
                  <img
                    src="/images/screenshots/service-centre/sc-home.png"
                    alt="AutoLab Service Centre App"
                    className="w-full h-full object-cover object-top"
                  />
                </div>
              </div>
            </div>
            {/* Phone 2 - Customer */}
            <div className="relative rotate-6 -ml-16 mt-12">
              <div className="w-[260px] rounded-[2.5rem] border-[6px] border-gray-700 bg-gray-900 p-1.5 shadow-2xl">
                <div className="overflow-hidden rounded-[2rem] bg-white aspect-[9/19.5]">
                  <img
                    src="/images/screenshots/customer/ca-home.png"
                    alt="AutoLab Customer App"
                    className="w-full h-full object-cover object-top"
                  />
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
