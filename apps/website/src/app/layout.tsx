import type { Metadata } from 'next';
import { Inter, Poppins } from 'next/font/google';
import { Navbar } from '@/components/layout/navbar';
import { Footer } from '@/components/layout/footer';
import '@/styles/globals.css';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });
const poppins = Poppins({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-poppins',
});

export const metadata: Metadata = {
  title: 'AutoLab — Free Vehicle Service Management App',
  description:
    'Replace paper records with AutoLab. Free app for service centres to track vehicle services, generate invoices, and send reminders. Customers get complete service history.',
  keywords:
    'vehicle service management, garage management app, car service record, bike service tracker, India',
  openGraph: {
    title: 'AutoLab — Vehicle Service Management Platform',
    description:
      'Digital service records, instant invoices, automatic reminders. Free for service centres and customers.',
    type: 'website',
    siteName: 'AutoLab',
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${inter.variable} ${poppins.variable}`}>
      <body className="font-sans">
        <Navbar />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}
