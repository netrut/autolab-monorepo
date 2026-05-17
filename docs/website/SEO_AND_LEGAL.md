# 🔍 AutoLab Website — SEO & Legal

## 1. SEO Strategy

### Target Keywords

| Priority | Keyword | Monthly Searches (India) | Difficulty |
|----------|---------|--------------------------|------------|
| 🔴 High | vehicle service management app | 500-1K | Low |
| 🔴 High | garage management software free | 1K-5K | Medium |
| 🔴 High | car service record app | 500-1K | Low |
| 🟡 Medium | bike service tracker app | 200-500 | Low |
| 🟡 Medium | vehicle maintenance app India | 200-500 | Low |
| 🟡 Medium | service centre billing software | 500-1K | Medium |
| 🟡 Medium | car service reminder app | 500-1K | Medium |
| 🟢 Low | digital service record | 100-200 | Low |
| 🟢 Low | mechanic invoice app | 100-200 | Low |
| 🟢 Low | vehicle service history tracker | 100-200 | Low |

### Meta Tags Per Page

#### Home Page (`/`)

```html
<title>AutoLab — Free Vehicle Service Management App for Service Centres & Customers</title>
<meta name="description" content="Replace paper records with AutoLab. Free app for service centres to track vehicle services, generate invoices, and send reminders. Customers get complete service history." />
<meta name="keywords" content="vehicle service management, garage management app, car service record, bike service tracker, service centre software, free, India" />

<!-- Open Graph -->
<meta property="og:title" content="AutoLab — Vehicle Service Management Platform" />
<meta property="og:description" content="Digital service records, instant invoices, automatic reminders. Free for service centres and customers." />
<meta property="og:image" content="https://autolab.in/images/og/home.png" />
<meta property="og:url" content="https://autolab.in" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="AutoLab" />

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="AutoLab — Vehicle Service Management Platform" />
<meta name="twitter:description" content="Free app for service centres and vehicle owners. Track services, generate invoices, get reminders." />
<meta name="twitter:image" content="https://autolab.in/images/og/home.png" />
```

#### Service Centre Page (`/service-centre`)

```html
<title>AutoLab for Service Centres — Free Garage Management App | Digital Service Records</title>
<meta name="description" content="Free app for service centres. Search vehicles by number, log service details, generate invoices, send WhatsApp reminders. Used by 50+ garages across India." />
```

#### Customer Page (`/customer`)

```html
<title>AutoLab for Vehicle Owners — Track Your Car & Bike Service History Free</title>
<meta name="description" content="Know your vehicle's complete service history. Get reminders for upcoming services. View invoices anytime. Free app for car and bike owners." />
```

#### Pricing Page (`/pricing`)

```html
<title>AutoLab Pricing — Free Forever for Service Centres & Customers</title>
<meta name="description" content="AutoLab is completely free. Unlimited vehicles, service records, invoices, and users. No credit card required. Premium features coming soon." />
```

#### Download Page (`/download`)

```html
<title>Download AutoLab — Free Vehicle Service App for Android, iOS & Web</title>
<meta name="description" content="Download AutoLab for free. Available on Google Play, App Store, and web. Service Centre app for mechanics. Customer app for vehicle owners." />
```

---

### Structured Data (JSON-LD)

```html
<!-- Home page — Organization -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "AutoLab",
  "applicationCategory": "BusinessApplication",
  "operatingSystem": "Android, iOS, Web",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "INR"
  },
  "description": "Vehicle service management platform for service centres and customers",
  "author": {
    "@type": "Organization",
    "name": "AutoLab Technologies"
  }
}
</script>

<!-- FAQ page — FAQPage schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Is AutoLab free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! AutoLab is completely free for service centres and customers."
      }
    }
  ]
}
</script>
```

---

### Technical SEO

#### robots.txt

```
# apps/website/public/robots.txt
User-agent: *
Allow: /

Sitemap: https://autolab.in/sitemap.xml
```

#### sitemap.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://autolab.in/</loc><priority>1.0</priority><changefreq>weekly</changefreq></url>
  <url><loc>https://autolab.in/service-centre</loc><priority>0.9</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/customer</loc><priority>0.9</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/pricing</loc><priority>0.8</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/download</loc><priority>0.8</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/about</loc><priority>0.6</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/contact</loc><priority>0.6</priority><changefreq>monthly</changefreq></url>
  <url><loc>https://autolab.in/privacy</loc><priority>0.3</priority><changefreq>yearly</changefreq></url>
  <url><loc>https://autolab.in/terms</loc><priority>0.3</priority><changefreq>yearly</changefreq></url>
</urlset>
```

---

### Performance SEO

| Factor | Implementation |
|--------|---------------|
| Core Web Vitals | Static pages, optimized images, no layout shift |
| Mobile-friendly | Responsive design, touch targets 44px+ |
| HTTPS | Auto via Vercel |
| Page speed | < 2s load, < 500KB total |
| Canonical URLs | `<link rel="canonical" href="..." />` on every page |
| Hreflang | Not needed (single language) |
| Internal linking | Every page links to related pages |

---

## 2. Privacy Policy (`/privacy`)

```markdown
# Privacy Policy

**Last updated: [Date]**

AutoLab Technologies ("we", "our", "us") operates the AutoLab mobile application
and website (the "Service"). This page informs you of our policies regarding the
collection, use, and disclosure of personal data when you use our Service.

## Information We Collect

### Personal Data
When you create an account, we collect:
- Name
- Email address
- Phone number
- Vehicle registration numbers

### Usage Data
We automatically collect:
- Device type and operating system
- App usage patterns (screens visited, features used)
- IP address (for security purposes)

### Vehicle Data
When you use the Service, we store:
- Vehicle details (brand, model, registration number)
- Service records (dates, costs, parts replaced)
- Invoice data

## How We Use Your Data

We use your data to:
- Provide and maintain the Service
- Send service reminders and notifications
- Generate invoices
- Improve the app experience
- Communicate important updates

## Data Sharing

We do NOT sell your personal data. We may share data with:
- **Service centres** — only the vehicle and service data relevant to their work
- **Cloud providers** — for secure data storage (encrypted)
- **Law enforcement** — only when legally required

## Data Security

- All data is encrypted in transit (HTTPS/TLS)
- Passwords are hashed using industry-standard algorithms
- Database access is restricted and monitored
- Regular security audits

## Data Retention

- Account data: retained while your account is active
- Service records: retained indefinitely (they're your vehicle's history)
- Deleted accounts: data removed within 30 days

## Your Rights

You have the right to:
- Access your personal data
- Correct inaccurate data
- Delete your account and data
- Export your data
- Opt out of marketing communications

## Children's Privacy

Our Service is not intended for children under 13. We do not knowingly
collect data from children.

## Changes to This Policy

We may update this policy from time to time. We will notify you of changes
by posting the new policy on this page and updating the "Last updated" date.

## Contact Us

If you have questions about this Privacy Policy:
- Email: privacy@autolab.in
- WhatsApp: [number]
- Address: [Company Address]

---

© 2026 AutoLab Technologies. All rights reserved.
```

---

## 3. Terms of Service (`/terms`)

```markdown
# Terms of Service

**Last updated: [Date]**

Please read these Terms of Service ("Terms") carefully before using the AutoLab
application and website operated by AutoLab Technologies.

## 1. Acceptance of Terms

By accessing or using AutoLab, you agree to be bound by these Terms. If you
disagree with any part, you may not access the Service.

## 2. Description of Service

AutoLab provides a digital vehicle service management platform that allows:
- Service centres to record and manage vehicle service history
- Vehicle owners to view their service records and receive reminders
- Generation and sharing of service invoices

## 3. User Accounts

- You must provide accurate information when creating an account
- You are responsible for maintaining the security of your account
- You must notify us immediately of any unauthorized access
- One person may not maintain multiple accounts

## 4. Acceptable Use

You agree NOT to:
- Use the Service for any illegal purpose
- Upload false or misleading service records
- Attempt to access other users' data without authorization
- Reverse engineer or copy the application
- Use automated tools to scrape or access the Service
- Impersonate another person or service centre

## 5. Service Centre Responsibilities

Service centres using AutoLab agree to:
- Provide accurate service records
- Obtain customer consent before adding their vehicle data
- Not misuse customer contact information
- Maintain professional standards in all communications

## 6. Data Ownership

- **Your data belongs to you.** We do not claim ownership of your service records,
  vehicle data, or business information.
- You grant us a license to store and display your data as needed to provide the Service.
- You can export or delete your data at any time.

## 7. Intellectual Property

- The AutoLab name, logo, and application are our intellectual property
- You may not copy, modify, or distribute our software
- User-generated content (service records, notes) remains yours

## 8. Limitation of Liability

- AutoLab is provided "as is" without warranties of any kind
- We are not liable for any indirect, incidental, or consequential damages
- Our total liability shall not exceed the amount paid by you (if any) in the
  past 12 months
- We are not responsible for data loss due to circumstances beyond our control

## 9. Service Availability

- We strive for 99.9% uptime but do not guarantee uninterrupted service
- We may perform maintenance with reasonable notice
- We reserve the right to modify or discontinue features with notice

## 10. Termination

- You may delete your account at any time
- We may suspend or terminate accounts that violate these Terms
- Upon termination, your data will be deleted within 30 days

## 11. Changes to Terms

We may modify these Terms at any time. Continued use after changes constitutes
acceptance of the new Terms.

## 12. Governing Law

These Terms are governed by the laws of India. Any disputes shall be resolved
in the courts of [City], [State], India.

## 13. Contact

For questions about these Terms:
- Email: legal@autolab.in
- WhatsApp: [number]

---

© 2026 AutoLab Technologies. All rights reserved.
```

---

## 4. Refund Policy (if applicable)

```markdown
# Refund Policy

AutoLab is currently a **free service**. There are no charges, subscriptions,
or payments required to use the app.

When we introduce premium features in the future, this page will be updated
with our refund policy.

If you have been charged incorrectly or have billing questions, please
contact us at billing@autolab.in.
```

---

## 5. Cookie Policy (for website)

```markdown
# Cookie Policy

AutoLab website uses minimal cookies:

| Cookie | Purpose | Duration |
|--------|---------|----------|
| `_vercel_analytics` | Anonymous page view tracking | Session |
| `theme` | Remember dark/light mode preference | 1 year |

We do NOT use:
- Advertising cookies
- Third-party tracking cookies
- Social media cookies

You can disable cookies in your browser settings. The website will still
function normally without cookies.
```

---

## 6. Additional SEO Recommendations

### Google Search Console

After deploying, submit to Google Search Console:
1. Go to https://search.google.com/search-console
2. Add property: `autolab.in`
3. Verify via DNS TXT record (Vercel makes this easy)
4. Submit sitemap: `https://autolab.in/sitemap.xml`

### Google Business Profile

If you have a physical office:
1. Create Google Business Profile
2. Add website URL
3. Add app download links
4. Collect reviews

### Backlink Strategy

| Source | Action |
|--------|--------|
| Product Hunt | Launch on Product Hunt |
| IndieHackers | Share building story |
| Reddit r/India | Share in relevant threads |
| Quora | Answer "best garage management app" questions |
| Medium/Dev.to | Write technical blog posts |
| Local directories | List on JustDial, Sulekha, IndiaMART |

### Social Media Presence

Create accounts (even if not active yet):
- Twitter/X: `@autolab_in`
- Instagram: `@autolab.in`
- LinkedIn: AutoLab Technologies (company page)
- YouTube: AutoLab (for demo videos later)

---

*This completes the website documentation. Ready to build! 🚀*
