import type { Metadata } from 'next';
import Link from 'next/link';
import { History, Bell, Car, Receipt, ArrowRight } from 'lucide-react';

export const metadata: Metadata = {
  title: 'AutoLab for Vehicle Owners — Track Your Car & Bike Service History Free',
  description:
    'Know your vehicle\'s complete service history. Get reminders for upcoming services. View invoices anytime. Free app for car and bike owners.',
};

const features = [
  {
    icon: History,
    title: "Your Vehicle's Complete Service Diary",
    description: 'Every oil change, every part replaced, every cost — all in one timeline. No more keeping paper bills.',
    image: '/images/screenshots/customer/ca-feature-1.png',
  },
  {
    icon: Bell,
    title: 'Never Miss a Service Date',
    description: "See what's due today, this week, this month. Get reminded before your service date.",
    image: '/images/screenshots/customer/ca-feature-2.png',
  },
  {
    icon: Car,
    title: 'All Your Vehicles in One Place',
    description: 'Car, bike, scooter — add all your vehicles. Each one has its own service history.',
    image: '/images/screenshots/customer/ca-feature-3.png',
  },
  {
    icon: Receipt,
    title: 'All Your Invoices, Always Available',
    description: 'No more lost bills. Every invoice is saved digitally. Download PDF anytime for insurance or resale.',
    image: '/images/screenshots/customer/ca-feature-4.png',
  },
];

export default function CustomerPage() {
  return (
    <>
      {/* Hero */}
      <section className="pt-32 pb-20 bg-gradient-to-br from-gray-900 via-gray-800 to-emerald-900">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="max-w-3xl">
            <span className="inline-flex items-center rounded-full bg-green-500/10 px-4 py-1.5 text-sm font-medium text-green-300 border border-green-500/20 mb-6">
              For Vehicle Owners
            </span>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white leading-[1.1] mb-6">
              Know Everything About Your Vehicle&apos;s Health
            </h1>
            <p className="text-lg sm:text-xl text-gray-300 leading-relaxed mb-8">
              Complete service history. Upcoming reminders. Oil change details. All in one app — for your car and bike.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Link
                href="/download"
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-success px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-green-500/25 hover:brightness-110 transition-all hover:-translate-y-0.5"
              >
                Download Free
                <ArrowRight className="h-5 w-5" />
              </Link>
              <a
                href="https://autolab-customer-app.vercel.app"
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
              className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center"
            >
              <div className={i % 2 === 1 ? 'lg:order-2' : ''}>
                <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-green-50 text-brand-success">
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
                    <img src={feature.image} alt={feature.title} className="w-full h-full object-cover object-top" />
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
            Track Your Vehicle&apos;s Health
          </h2>
          <p className="text-lg text-gray-600 mb-8">Free for all vehicle owners. Download now.</p>
          <div className="flex flex-wrap justify-center gap-4">
            <a href="#" className="inline-block rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
              ▶ Google Play
            </a>
            <a href="#" className="inline-block rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
               App Store
            </a>
            <a
              href="https://autolab-customer-app.vercel.app"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block rounded-lg bg-brand-success px-6 py-3 text-sm font-medium text-white hover:brightness-110 transition-colors"
            >
              🌐 Use Web App
            </a>
          </div>
        </div>
      </section>
    </>
  );
}
