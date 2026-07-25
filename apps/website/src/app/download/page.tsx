import type { Metadata } from 'next';
import { Wrench, Car } from 'lucide-react';

export const metadata: Metadata = {
  title: 'Download AutoLab — Free Vehicle Service App',
  description: 'Download AutoLab for free. Available on Google Play, App Store, and web.',
};

export default function DownloadPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h1 className="text-4xl sm:text-5xl font-bold tracking-tight text-gray-900 mb-4">
            Download AutoLab
          </h1>
          <p className="text-lg text-gray-600">Choose your app and platform.</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          {/* Service Centre App */}
          <div className="rounded-2xl border border-gray-200 bg-white p-8 text-center shadow-sm">
            <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-blue-50 text-brand-accent">
              <Wrench className="h-7 w-7" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Service Centre App</h2>
            <p className="text-gray-600 mb-8">For mechanics & service centres. Manage vehicles, log services, generate invoices.</p>

            <div className="space-y-3">
              <a href="/downloads/autolab-service-centre.apk" download className="block w-full rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
                ▶ Download APK (Android)
                {/* Google Play Store*/}
              </a>
              <a href="#" className="block w-full rounded-lg bg-gray-500 px-6 py-3 text-sm font-medium text-white cursor-not-allowed">
                 Apple App Store (Coming Soon)
                 {/* Apple App Store */}
              </a>
              <a
                href="https://autolab-partner-app.vercel.app"
                target="_blank"
                rel="noopener noreferrer"
                className="block w-full rounded-lg bg-brand-accent px-6 py-3 text-sm font-medium text-white hover:bg-brand-accent-dark transition-colors"
              >
                🌐 Use Web App
              </a>
            </div>
          </div>

          {/* Customer App */}
          <div className="rounded-2xl border border-gray-200 bg-white p-8 text-center shadow-sm">
            <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-green-50 text-brand-success">
              <Car className="h-7 w-7" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Customer App</h2>
            <p className="text-gray-600 mb-8">For vehicle owners. Track service history, get reminders, view invoices.</p>

            <div className="space-y-3">
              <a href="/downloads/autolab-customer-app.apk" download className="block w-full rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors">
                ▶ Download APK (Android)
                {/* Apple App Store */}
              </a>
              <a href="#" className="block w-full rounded-lg bg-gray-500 px-6 py-3 text-sm font-medium text-white cursor-not-allowed">
                 Apple App Store (Coming Soon)
                 {/* Apple App Store */}
              </a>
              <a
                href="https://autolab-customer-app.vercel.app"
                target="_blank"
                rel="noopener noreferrer"
                className="block w-full rounded-lg bg-brand-success px-6 py-3 text-sm font-medium text-white hover:brightness-110 transition-colors"
              >
                🌐 Use Web App
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
