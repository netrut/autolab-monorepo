import Link from 'next/link';
import { ArrowRight } from 'lucide-react';

export function CTA() {
  return (
    <section className="py-20 lg:py-28 bg-gradient-to-br from-gray-900 via-gray-800 to-blue-900">
      <div className="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8 text-center">
        <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight text-white mb-6">
          Ready to Go Digital?
        </h2>
        <p className="text-lg text-gray-300 mb-10 max-w-2xl mx-auto">
          Join hundreds of service centres already using AutoLab. Free forever. No credit card required.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link
            href="/download"
            className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-accent px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-500/25 transition-all hover:bg-brand-accent-dark hover:-translate-y-0.5"
          >
            Download Now
            <ArrowRight className="h-5 w-5" />
          </Link>
          <Link
            href="/contact"
            className="inline-flex items-center justify-center gap-2 rounded-xl border-2 border-white/20 px-8 py-4 text-lg font-semibold text-white transition-all hover:bg-white/10"
          >
            Contact Us
          </Link>
        </div>

        {/* Store badges placeholder */}
        <div className="mt-10 flex flex-wrap justify-center gap-4">
          <a href="#" className="inline-block rounded-lg bg-white/10 px-5 py-2.5 text-sm font-medium text-white hover:bg-white/20 transition-colors">
            ▶ Google Play
          </a>
          <a href="#" className="inline-block rounded-lg bg-white/10 px-5 py-2.5 text-sm font-medium text-white hover:bg-white/20 transition-colors">
             App Store
          </a>
          <a
            href="https://autolab-partner-app.vercel.app"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-block rounded-lg bg-white/10 px-5 py-2.5 text-sm font-medium text-white hover:bg-white/20 transition-colors"
          >
            🌐 Use Web App
          </a>
        </div>
      </div>
    </section>
  );
}
