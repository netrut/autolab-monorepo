import type { Metadata } from 'next';
import Link from 'next/link';
import { Search, FileText, Receipt, History, Bell, Users, ArrowRight } from 'lucide-react';

export const metadata: Metadata = {
  title: 'AutoLab for Service Centres — Free Garage Management App',
  description:
    'Free app for service centres. Search vehicles by number, log service details, generate invoices, send WhatsApp reminders.',
};

const features = [
  {
    icon: Search,
    title: 'Find Any Vehicle in Seconds',
    description:
      'Type the registration number. Instantly see the vehicle\'s complete service history, owner details, and upcoming due dates.',
    image: '/images/screenshots/service-centre/sc-feature-1.png',
  },
  {
    icon: FileText,
    title: 'Log Every Detail of Every Service',
    description:
      'Oil type, parts replaced, labour cost, next service date — capture everything in a structured digital form.',
    image: '/images/screenshots/service-centre/sc-feature-2.png',
  },
  {
    icon: Receipt,
    title: 'Professional Invoices in One Tap',
    description:
      'Generate itemised invoices automatically from service records. Download as PDF or share directly via WhatsApp.',
    image: '/images/screenshots/service-centre/sc-feature-3.png',
  },
  {
    icon: History,
    title: 'Complete History for Every Vehicle',
    description:
      'See every service ever done — dates, costs, parts, mechanic notes. Answer customer questions instantly.',
    image: '/images/screenshots/service-centre/sc-feature-4.png',
  },
  {
    icon: Bell,
    title: 'Never Lose a Customer to Forgetfulness',
    description:
      'Set the next service date. The customer gets reminded automatically. They come back to YOU.',
    image: '/images/screenshots/service-centre/sc-feature-5.png',
  },
  {
    icon: Users,
    title: 'Your Whole Team on One Platform',
    description:
      'Owner, mechanics, drivers — everyone has their own login. Control who can view, edit, or manage records.',
    image: '/images/screenshots/service-centre/sc-feature-6.png',
  },
];

export default function ServiceCentrePage() {
  return (
    <>
      {/* Hero */}
      <section className="pt-32 pb-20 bg-gradient-to-br from-gray-900 via-gray-800 to-blue-900">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="max-w-3xl">
            <span className="inline-flex items-center rounded-full bg-blue-500/10 px-4 py-1.5 text-sm font-medium text-blue-300 border border-blue-500/20 mb-6">
              For Service Centres
            </span>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white leading-[1.1] mb-6">
              Run Your Garage Like a Pro
            </h1>
            <p className="text-lg sm:text-xl text-gray-300 leading-relaxed mb-8">
              Digital service records. Instant invoices. Automatic reminders. Everything a modern
              service centre needs — in one free app.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Link
                href="/download"
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-accent px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-500/25 hover:bg-brand-accent-dark transition-all hover:-translate-y-0.5"
              >
                Download Now — It&apos;s Free
                <ArrowRight className="h-5 w-5" />
              </Link>
              <a
                href="https://autolab-partner-app.vercel.app"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 rounded-xl border-2 border-white/20 px-8 py-4 text-lg font-semibold text-white hover:bg-white/10 transition-all"
              >
                Try Web App →
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-20 lg:py-28">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 space-y-24">
          {features.map((feature, i) => (
            <div
              key={feature.title}
              className={`grid grid-cols-1 lg:grid-cols-2 gap-12 items-center ${
                i % 2 === 1 ? 'lg:direction-rtl' : ''
              }`}
            >
              <div className={i % 2 === 1 ? 'lg:order-2' : ''}>
                <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-brand-accent">
                  <feature.icon className="h-6 w-6" />
                </div>
                <h3 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-4">
                  {feature.title}
                </h3>
                <p className="text-lg text-gray-600 leading-relaxed">{feature.description}</p>
              </div>
              <div className={`flex justify-center ${i % 2 === 1 ? 'lg:order-1' : ''}`}>
                <div className="w-[260px] rounded-[2.5rem] border-[6px] border-gray-800 bg-gray-900 p-1.5 shadow-2xl">
                  <div className="overflow-hidden rounded-[2rem] bg-white aspect-[9/19.5]">
                    <img
                      src={feature.image}
                      alt={feature.title}
                      className="w-full h-full object-cover object-top"
                    />
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Download CTA */}
      <section className="py-20 bg-gray-50">
        <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
            Start Using AutoLab Today
          </h2>
          <p className="text-lg text-gray-600 mb-8">Free. No credit card. Set up in 2 minutes.</p>
          <div className="flex flex-wrap justify-center gap-4">
            <a href="#" className="inline-block rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
              ▶ Google Play
            </a>
            <a href="#" className="inline-block rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
               App Store
            </a>
            <a
              href="https://autolab-partner-app.vercel.app"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block rounded-lg bg-brand-accent px-6 py-3 text-sm font-medium text-white hover:bg-brand-accent-dark transition-colors"
            >
              🌐 Use Web App
            </a>
          </div>
        </div>
      </section>
    </>
  );
}
