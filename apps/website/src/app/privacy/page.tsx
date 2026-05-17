import type { Metadata } from 'next';

export const metadata: Metadata = { title: 'Privacy Policy — AutoLab' };

export default function PrivacyPage() {
  return (
    <section className="pt-32 pb-20 min-h-screen">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 prose prose-gray">
        <h1>Privacy Policy</h1>
        <p className="text-sm text-gray-500">Last updated: May 2026</p>

        <h2>Information We Collect</h2>
        <p>When you create an account, we collect: name, email address, phone number, and vehicle registration numbers.</p>

        <h2>How We Use Your Data</h2>
        <ul>
          <li>Provide and maintain the Service</li>
          <li>Send service reminders and notifications</li>
          <li>Generate invoices</li>
          <li>Improve the app experience</li>
        </ul>

        <h2>Data Sharing</h2>
        <p>We do NOT sell your personal data. We share data only with service centres relevant to your vehicles, cloud providers for secure storage, and law enforcement when legally required.</p>

        <h2>Data Security</h2>
        <p>All data is encrypted in transit (HTTPS/TLS). Passwords are hashed. Database access is restricted and monitored.</p>

        <h2>Your Rights</h2>
        <p>You have the right to access, correct, delete, and export your personal data. You can opt out of marketing communications at any time.</p>

        <h2>Contact Us</h2>
        <p>Email: privacy@autolab.in</p>
      </div>
    </section>
  );
}
