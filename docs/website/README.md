# 🌐 AutoLab Launch Website — Complete Documentation

## Document Index

| Document | Content |
|----------|---------|
| `README.md` (this file) | Overview, tech stack, project structure, deployment |
| `PAGES.md` | All pages with complete content/copy |
| `DESIGN.md` | UI/UX design system, colors, typography, components |
| `SECTIONS.md` | Detailed section-by-section breakdown with layout |
| `ASSETS.md` | Images, icons, illustrations, free resources |
| `SEO_AND_LEGAL.md` | SEO strategy, meta tags, privacy policy, terms |

---

## 1. Project Overview

### What is this?

A modern, responsive marketing/launch website for **AutoLab** — showcasing both the Service Centre App and Customer App. This is the public-facing brand website that builds trust, explains the product, and drives downloads.

### Goals

1. **Brand presence** — establish AutoLab as a professional vehicle service management platform
2. **Drive downloads** — get service centres and customers to install the apps
3. **SEO** — rank for "vehicle service management app India", "garage management software"
4. **Trust** — show screenshots, features, testimonials to build credibility
5. **Legal compliance** — privacy policy & terms for Play Store / App Store submission

### Live App URLs (for linking)

| App | Web URL | Store Links (placeholder) |
|-----|---------|--------------------------|
| Service Centre App | https://autolab-partner-app.vercel.app | Play Store: `#` / App Store: `#` |
| Customer App | https://autolab-customer-app.vercel.app | Play Store: `#` / App Store: `#` |

---

## 2. Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Framework | Next.js 15 (App Router) | SSG/SSR, SEO, fast builds |
| Styling | Tailwind CSS v4 | Rapid UI development, consistent design |
| Animations | Framer Motion | Smooth scroll animations, micro-interactions |
| Icons | Lucide React | Clean, consistent icon set |
| Fonts | Google Fonts (Inter + Poppins) | Modern, readable |
| Deployment | Vercel (Static Export) | Free, fast CDN, auto-deploy |
| Analytics | Vercel Analytics | Free, privacy-friendly |
| Images | Next.js Image + sharp | Optimized, lazy-loaded |

### Why Static Export?

- Zero server cost (Vercel free tier)
- Fastest possible load time (CDN-served HTML)
- No database needed
- Perfect Lighthouse scores achievable
- Content changes via git push

---

## 3. Project Structure

```
apps/website/
├── public/
│   ├── images/
│   │   ├── hero/                    ← Hero section images
│   │   ├── screenshots/
│   │   │   ├── service-centre/      ← Service Centre App screenshots
│   │   │   └── customer/            ← Customer App screenshots
│   │   ├── features/                ← Feature illustration icons
│   │   ├── logos/                    ← AutoLab logo variants
│   │   └── og/                      ← Open Graph social preview images
│   ├── apk/                         ← Direct APK downloads (optional)
│   ├── favicon.ico
│   ├── robots.txt
│   └── sitemap.xml
├── src/
│   ├── app/
│   │   ├── layout.tsx               ← Root layout (nav + footer)
│   │   ├── page.tsx                 ← Home page
│   │   ├── service-centre/
│   │   │   └── page.tsx             ← Service Centre App page
│   │   ├── customer/
│   │   │   └── page.tsx             ← Customer App page
│   │   ├── pricing/
│   │   │   └── page.tsx             ← Pricing page (free/pro plans)
│   │   ├── about/
│   │   │   └── page.tsx             ← About us page
│   │   ├── contact/
│   │   │   └── page.tsx             ← Contact page
│   │   ├── privacy/
│   │   │   └── page.tsx             ← Privacy Policy
│   │   ├── terms/
│   │   │   └── page.tsx             ← Terms of Service
│   │   └── download/
│   │       └── page.tsx             ← Download hub (APK + store links)
│   ├── components/
│   │   ├── layout/
│   │   │   ├── navbar.tsx           ← Sticky navigation
│   │   │   ├── footer.tsx           ← Site footer
│   │   │   └── mobile-menu.tsx      ← Mobile hamburger menu
│   │   ├── sections/
│   │   │   ├── hero.tsx             ← Hero section
│   │   │   ├── features.tsx         ← Features grid
│   │   │   ├── how-it-works.tsx     ← Step-by-step flow
│   │   │   ├── screenshots.tsx      ← App screenshot carousel
│   │   │   ├── testimonials.tsx     ← Customer testimonials
│   │   │   ├── stats.tsx            ← Numbers/stats section
│   │   │   ├── cta.tsx              ← Call-to-action section
│   │   │   ├── faq.tsx              ← FAQ accordion
│   │   │   └── download-cta.tsx     ← Download buttons section
│   │   ├── ui/
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── badge.tsx
│   │   │   ├── accordion.tsx
│   │   │   └── phone-mockup.tsx     ← Phone frame for screenshots
│   │   └── shared/
│   │       ├── section-header.tsx
│   │       ├── app-store-buttons.tsx
│   │       └── qr-code.tsx
│   ├── lib/
│   │   └── utils.ts                 ← cn() helper
│   └── styles/
│       └── globals.css              ← Tailwind imports + custom styles
├── next.config.ts
├── tailwind.config.ts
├── tsconfig.json
├── package.json
└── vercel.json
```

---

## 4. Pages Overview

| # | Route | Page | Purpose |
|---|-------|------|---------|
| 1 | `/` | Home | Hero + value prop + both apps overview |
| 2 | `/service-centre` | Service Centre App | Full feature showcase + screenshots + download |
| 3 | `/customer` | Customer App | Full feature showcase + screenshots + download |
| 4 | `/pricing` | Pricing | Free tier + future Pro plan |
| 5 | `/about` | About Us | Story, mission, team |
| 6 | `/contact` | Contact | Contact form + WhatsApp + email |
| 7 | `/download` | Download Hub | All download links + QR codes |
| 8 | `/privacy` | Privacy Policy | Legal (required for app stores) |
| 9 | `/terms` | Terms of Service | Legal (required for app stores) |

---

## 5. Deployment

### Vercel Configuration

```json
// apps/website/vercel.json
{
  "framework": "nextjs",
  "buildCommand": "next build",
  "outputDirectory": ".next"
}
```

### Vercel Project Settings

| Setting | Value |
|---------|-------|
| Framework Preset | Next.js |
| Root Directory | `apps/website` |
| Build Command | `next build` |
| Output Directory | `.next` |
| Node.js Version | 22.x |

### Custom Domain (Recommended)

- Primary: `autolab.in` or `autolab.co.in`
- Alternative: `www.autolab.app` or `getautolab.com`
- Vercel auto-provisions SSL certificate

### Environment Variables

```env
# Analytics (optional)
NEXT_PUBLIC_VERCEL_ANALYTICS_ID=

# Contact form (optional - if using Formspree/Resend)
CONTACT_FORM_ENDPOINT=

# App URLs
NEXT_PUBLIC_SERVICE_CENTRE_URL=https://autolab-partner-app.vercel.app
NEXT_PUBLIC_CUSTOMER_APP_URL=https://autolab-customer-app.vercel.app

# Store links (update when published)
NEXT_PUBLIC_PLAY_STORE_SERVICE_CENTRE=#
NEXT_PUBLIC_PLAY_STORE_CUSTOMER=#
NEXT_PUBLIC_APP_STORE_SERVICE_CENTRE=#
NEXT_PUBLIC_APP_STORE_CUSTOMER=#
```

---

## 6. Development Commands

```bash
# Install dependencies
cd apps/website
pnpm install

# Start dev server
pnpm dev          # http://localhost:3003

# Build for production
pnpm build

# Preview production build
pnpm start

# Lint
pnpm lint
```

---

## 7. Git & Deploy Flow

```bash
# After making changes
cd /workspaces/autolab-monorepo
git add apps/website
git commit -m "Website: update landing page"
git push origin main
# → Vercel auto-deploys
```

---

## Next Steps

1. Read `DESIGN.md` for the complete design system
2. Read `PAGES.md` for all page content/copy
3. Read `SECTIONS.md` for section-by-section layout details
4. Read `ASSETS.md` for image sources and optimization
5. Read `SEO_AND_LEGAL.md` for SEO and legal pages

---

**Created**: May 2026
**Status**: Planning Complete — Ready to Build
