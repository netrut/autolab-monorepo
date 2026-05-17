import type { Metadata } from 'next';

export const metadata: Metadata = { title: 'Terms of Service — AutoLab' };

export default function TermsPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 prose prose-gray">
        <h1>Terms of Service</h1>
        <p className="text-sm text-gray-500">Last updated: May 2026</p>

        <h2>1. Acceptance of Terms</h2>
        <p>By accessing or using AutoLab, you agree to be bound by these Terms.</p>

        <h2>2. Description of Service</h2>
        <p>AutoLab provides a digital vehicle service management platform for service centres and vehicle owners.</p>

        <h2>3. User Accounts</h2>
        <p>You must provide accurate information. You are responsible for maintaining account security.</p>

        <h2>4. Acceptable Use</h2>
        <p>You agree not to use the Service for illegal purposes, upload false records, or attempt unauthorized access.</p>

        <h2>5. Data Ownership</h2>
        <p>Your data belongs to you. We do not claim ownership of your service records or business information. You can export or delete your data at any time.</p>

        <h2>6. Limitation of Liability</h2>
        <p>AutoLab is provided &quot;as is&quot; without warranties. We are not liable for indirect or consequential damages.</p>

        <h2>7. Termination</h2>
        <p>You may delete your account at any time. We may suspend accounts that violate these Terms.</p>

        <h2>8. Governing Law</h2>
        <p>These Terms are governed by the laws of India.</p>

        <h2>Contact</h2>
        <p>Email: legal@autolab.in</p>
      </div>
    </section>
  );
}
