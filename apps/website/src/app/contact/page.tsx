import type { Metadata } from 'next';
import { MessageCircle, Mail, Phone } from 'lucide-react';

export const metadata: Metadata = { title: 'Contact — AutoLab' };

export default function ContactPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Get in Touch</h1>
        <p className="text-lg text-gray-600 mb-12">Have questions? We&apos;d love to hear from you.</p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {[
            { icon: MessageCircle, title: 'WhatsApp', detail: 'Chat with us instantly', href: 'https://wa.me/919876543210' },
            { icon: Mail, title: 'Email', detail: 'hello@autolab.in', href: 'mailto:hello@autolab.in' },
            { icon: Phone, title: 'Phone', detail: 'Mon-Sat, 10am-7pm', href: 'tel:+919876543210' },
          ].map((item) => (
            <a
              key={item.title}
              href={item.href}
              target="_blank"
              rel="noopener noreferrer"
              className="rounded-xl border border-gray-200 p-6 text-center hover:border-brand-accent hover:shadow-md transition-all"
            >
              <div className="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-brand-accent">
                <item.icon className="h-6 w-6" />
              </div>
              <h3 className="font-bold text-gray-900 mb-1">{item.title}</h3>
              <p className="text-sm text-gray-600">{item.detail}</p>
            </a>
          ))}
        </div>
      </div>
    </section>
  );
}
