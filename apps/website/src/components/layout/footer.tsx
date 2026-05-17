import Link from 'next/link';

const footerLinks = {
  Product: [
    { href: '/service-centre', label: 'Service Centre App' },
    { href: '/customer', label: 'Customer App' },
    { href: '/pricing', label: 'Pricing' },
    { href: '/download', label: 'Download' },
  ],
  Company: [
    { href: '/about', label: 'About' },
    { href: '/contact', label: 'Contact' },
  ],
  Legal: [
    { href: '/privacy', label: 'Privacy Policy' },
    { href: '/terms', label: 'Terms of Service' },
  ],
};

export function Footer() {
  return (
    <footer className="bg-gray-900 text-white">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          {/* Brand */}
          <div className="col-span-2 md:col-span-1">
            <div className="flex items-center gap-2 mb-4">
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-accent">
                <span className="text-sm font-bold text-white">A</span>
              </div>
              <span className="text-xl font-bold">AutoLab</span>
            </div>
            <p className="text-sm text-gray-400 leading-relaxed">
              Your complete vehicle service management platform. Free forever.
            </p>
          </div>

          {/* Links */}
          {Object.entries(footerLinks).map(([title, links]) => (
            <div key={title}>
              <h4 className="text-sm font-semibold uppercase tracking-wider text-gray-400 mb-4">
                {title}
              </h4>
              <ul className="space-y-2">
                {links.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="text-sm text-gray-300 hover:text-white transition-colors"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-12 pt-8 border-t border-gray-800 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-sm text-gray-400">
            © {new Date().getFullYear()} AutoLab Technologies. All rights reserved.
          </p>
          <p className="text-sm text-gray-400">
            Made with ❤️ in India 🇮🇳
          </p>
        </div>
      </div>
    </footer>
  );
}
