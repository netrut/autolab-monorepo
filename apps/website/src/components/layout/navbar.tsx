'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import { Menu, X, Download } from 'lucide-react';
import { cn } from '@/lib/utils';

const navLinks = [
  { href: '/', label: 'Home' },
  { href: '/service-centre', label: 'Service Centre' },
  { href: '/customer', label: 'Customer App' },
  { href: '/pricing', label: 'Pricing' },
  { href: '/about', label: 'About' },
];

export function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 50);
    window.addEventListener('scroll', handler);
    return () => window.removeEventListener('scroll', handler);
  }, []);

  return (
    <nav
      className={cn(
        'fixed top-0 z-50 w-full transition-all duration-300',
        scrolled
          ? 'bg-white/90 backdrop-blur-lg shadow-sm border-b border-gray-100'
          : 'bg-transparent'
      )}
    >
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <Link href="/" className="flex items-center gap-2">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-accent">
            <span className="text-sm font-bold text-white">A</span>
          </div>
          <span
            className={cn(
              'text-xl font-bold transition-colors',
              scrolled ? 'text-gray-900' : 'text-white'
            )}
          >
            AutoLab
          </span>
        </Link>

        {/* Desktop nav */}
        <div className="hidden md:flex items-center gap-8">
          {navLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={cn(
                'text-sm font-medium transition-colors hover:text-brand-accent',
                scrolled ? 'text-gray-600' : 'text-white/80 hover:text-white'
              )}
            >
              {link.label}
            </Link>
          ))}
          <Link
            href="/download"
            className="inline-flex items-center gap-2 rounded-lg bg-brand-accent px-4 py-2 text-sm font-semibold text-white transition-all hover:bg-brand-accent-dark hover:-translate-y-0.5"
          >
            <Download className="h-4 w-4" />
            Download
          </Link>
        </div>

        {/* Mobile toggle */}
        <button
          onClick={() => setMobileOpen(!mobileOpen)}
          className={cn('md:hidden p-2', scrolled ? 'text-gray-900' : 'text-white')}
        >
          {mobileOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </button>
      </div>

      {/* Mobile menu */}
      {mobileOpen && (
        <div className="md:hidden bg-white border-t border-gray-100 shadow-lg">
          <div className="px-4 py-4 space-y-3">
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                onClick={() => setMobileOpen(false)}
                className="block text-base font-medium text-gray-700 hover:text-brand-accent"
              >
                {link.label}
              </Link>
            ))}
            <Link
              href="/download"
              onClick={() => setMobileOpen(false)}
              className="block w-full text-center rounded-lg bg-brand-accent px-4 py-3 text-sm font-semibold text-white"
            >
              Download App
            </Link>
          </div>
        </div>
      )}
    </nav>
  );
}
