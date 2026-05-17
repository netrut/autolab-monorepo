import type { Metadata } from 'next';

export const metadata: Metadata = { title: 'About — AutoLab' };

export default function AboutPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-6">About AutoLab</h1>
        <p className="text-lg text-gray-600 leading-relaxed mb-8">
          We&apos;re building the future of vehicle service management in India.
        </p>

        <div className="prose prose-gray max-w-none space-y-6">
          <h2 className="text-2xl font-bold text-gray-900">Our Story</h2>
          <p className="text-gray-600 leading-relaxed">
            AutoLab was born from a simple observation: every service centre in India still uses paper
            registers to track vehicle services. Customers lose bills. Mechanics forget what was done.
            Service centres lose repeat business.
          </p>
          <p className="text-gray-600 leading-relaxed">
            We built AutoLab to solve this — a simple, free app that digitizes the entire service
            record workflow. For service centres AND their customers.
          </p>

          <h2 className="text-2xl font-bold text-gray-900 mt-12">Our Mission</h2>
          <p className="text-gray-600 leading-relaxed">
            Make vehicle service management digital, accessible, and free for every service centre in
            India — from the neighbourhood mechanic to the multi-brand workshop.
          </p>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
            {[
              { emoji: '🇮🇳', title: 'Made in India', desc: 'Built for Indian service centres, by an Indian team.' },
              { emoji: '💰', title: 'Free First', desc: 'Core features free forever. We grow when you grow.' },
              { emoji: '🤝', title: 'Customer Obsessed', desc: 'Every feature is built from real mechanic feedback.' },
            ].map((v) => (
              <div key={v.title} className="rounded-xl border border-gray-200 p-6 text-center">
                <div className="text-3xl mb-3">{v.emoji}</div>
                <h3 className="font-bold text-gray-900 mb-1">{v.title}</h3>
                <p className="text-sm text-gray-600">{v.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
