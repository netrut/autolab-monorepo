# 🎨 AutoLab Website — Design System & UI/UX Guide

## Design Philosophy

> **"Professional, Trustworthy, Modern"**

The website must feel like a **premium SaaS product** — not a generic template. Since AutoLab targets Indian service centres and vehicle owners, the design should be:

- **Clean & minimal** — no clutter, generous whitespace
- **Trust-building** — professional imagery, consistent branding
- **Mobile-first** — 70%+ traffic will be mobile (India market)
- **Fast** — under 2s load time, no heavy animations
- **Accessible** — readable fonts, high contrast, WCAG AA compliant

---

## 1. Color Palette

### Primary Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Primary** (Deep Blue-Black) | `#1B1F26` | Headers, primary buttons, nav |
| **Primary Light** | `#2D3748` | Hover states, secondary text |
| **Accent** (Electric Blue) | `#3B82F6` | CTAs, links, highlights |
| **Accent Dark** | `#2563EB` | Button hover, active states |

### Secondary Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Success** (Green) | `#10B981` | Checkmarks, positive states |
| **Warning** (Amber) | `#F59E0B` | Alerts, badges |
| **Error** (Red) | `#EF4444` | Error states |
| **Purple** | `#8B5CF6` | Premium/Pro badges |

### Neutral Colors

| Name | Hex | Usage |
|------|-----|-------|
| **White** | `#FFFFFF` | Backgrounds, cards |
| **Gray 50** | `#F9FAFB` | Page background, alternating sections |
| **Gray 100** | `#F3F4F6` | Card backgrounds, borders |
| **Gray 200** | `#E5E7EB` | Dividers, borders |
| **Gray 400** | `#9CA3AF` | Placeholder text |
| **Gray 600** | `#4B5563` | Body text |
| **Gray 900** | `#111827` | Headings |

### Gradient

```css
/* Hero gradient background */
background: linear-gradient(135deg, #1B1F26 0%, #2D3748 50%, #1a365d 100%);

/* Accent gradient for CTAs */
background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%);

/* Light section gradient */
background: linear-gradient(180deg, #F9FAFB 0%, #FFFFFF 100%);
```

### Tailwind Config

```js
// tailwind.config.ts
colors: {
  brand: {
    primary: '#1B1F26',
    'primary-light': '#2D3748',
    accent: '#3B82F6',
    'accent-dark': '#2563EB',
    success: '#10B981',
    warning: '#F59E0B',
  }
}
```

---

## 2. Typography

### Font Stack

| Usage | Font | Weight | Fallback |
|-------|------|--------|----------|
| Headings | **Inter** | 700 (Bold), 800 (Extra Bold) | system-ui, sans-serif |
| Body | **Inter** | 400 (Regular), 500 (Medium) | system-ui, sans-serif |
| Accent/Brand | **Poppins** | 600 (SemiBold), 700 (Bold) | sans-serif |
| Code/Numbers | **JetBrains Mono** | 400 | monospace |

### Type Scale

| Element | Size (Mobile) | Size (Desktop) | Weight | Line Height |
|---------|--------------|----------------|--------|-------------|
| H1 (Hero) | 36px / 2.25rem | 64px / 4rem | 800 | 1.1 |
| H2 (Section) | 28px / 1.75rem | 48px / 3rem | 700 | 1.2 |
| H3 (Card title) | 22px / 1.375rem | 28px / 1.75rem | 700 | 1.3 |
| H4 (Subtitle) | 18px / 1.125rem | 22px / 1.375rem | 600 | 1.4 |
| Body Large | 18px / 1.125rem | 20px / 1.25rem | 400 | 1.6 |
| Body | 16px / 1rem | 16px / 1rem | 400 | 1.6 |
| Body Small | 14px / 0.875rem | 14px / 0.875rem | 400 | 1.5 |
| Caption | 12px / 0.75rem | 12px / 0.75rem | 500 | 1.4 |

### Tailwind Classes

```html
<!-- Hero heading -->
<h1 class="text-4xl md:text-6xl lg:text-7xl font-extrabold tracking-tight">

<!-- Section heading -->
<h2 class="text-3xl md:text-5xl font-bold tracking-tight">

<!-- Body text -->
<p class="text-base md:text-lg text-gray-600 leading-relaxed">

<!-- Small label -->
<span class="text-xs font-medium uppercase tracking-wider text-gray-500">
```

---

## 3. Spacing & Layout

### Container

```html
<!-- Max width: 1280px, centered, responsive padding -->
<div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
```

### Section Spacing

| Element | Mobile | Desktop |
|---------|--------|---------|
| Section padding (vertical) | `py-16` (64px) | `py-24` (96px) |
| Between sections | `space-y-0` (sections alternate bg) | Same |
| Card gap | `gap-6` (24px) | `gap-8` (32px) |
| Content gap | `space-y-4` (16px) | `space-y-6` (24px) |

### Grid System

```html
<!-- 2-column (features, about) -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-12">

<!-- 3-column (feature cards) -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">

<!-- 4-column (stats) -->
<div class="grid grid-cols-2 md:grid-cols-4 gap-6">
```

---

## 4. Component Design

### Buttons

```html
<!-- Primary CTA (large) -->
<button class="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-accent px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-500/25 transition-all hover:bg-brand-accent-dark hover:shadow-xl hover:-translate-y-0.5">
  Download App
  <ArrowRight class="h-5 w-5" />
</button>

<!-- Secondary button -->
<button class="inline-flex items-center justify-center gap-2 rounded-xl border-2 border-gray-200 bg-white px-8 py-4 text-lg font-semibold text-gray-900 transition-all hover:border-brand-accent hover:text-brand-accent">
  Learn More
</button>

<!-- Ghost button -->
<button class="inline-flex items-center gap-2 text-brand-accent font-medium hover:underline">
  View Features →
</button>
```

### Cards

```html
<!-- Feature card -->
<div class="group relative rounded-2xl border border-gray-100 bg-white p-8 shadow-sm transition-all hover:shadow-lg hover:border-brand-accent/20 hover:-translate-y-1">
  <div class="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-brand-accent">
    <Icon class="h-6 w-6" />
  </div>
  <h3 class="mb-2 text-xl font-bold text-gray-900">Feature Title</h3>
  <p class="text-gray-600 leading-relaxed">Description text here.</p>
</div>
```

### Phone Mockup (for screenshots)

```html
<!-- Phone frame wrapper -->
<div class="relative mx-auto w-[280px] md:w-[320px]">
  <!-- Phone bezel -->
  <div class="rounded-[3rem] border-[8px] border-gray-900 bg-gray-900 p-2 shadow-2xl">
    <!-- Notch -->
    <div class="absolute top-0 left-1/2 -translate-x-1/2 h-6 w-32 rounded-b-2xl bg-gray-900 z-10"></div>
    <!-- Screen -->
    <div class="overflow-hidden rounded-[2.2rem] bg-white">
      <img src="/images/screenshots/..." alt="..." class="w-full" />
    </div>
  </div>
</div>
```

### Badge / Pill

```html
<!-- Status badge -->
<span class="inline-flex items-center gap-1.5 rounded-full bg-green-50 px-3 py-1 text-sm font-medium text-green-700">
  <span class="h-1.5 w-1.5 rounded-full bg-green-500"></span>
  Live
</span>

<!-- Feature badge -->
<span class="inline-flex items-center rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-700 uppercase tracking-wider">
  New
</span>
```

### Navigation

```html
<!-- Sticky navbar -->
<nav class="fixed top-0 z-50 w-full border-b border-gray-100 bg-white/80 backdrop-blur-lg">
  <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
    <!-- Logo -->
    <!-- Nav links (hidden on mobile) -->
    <!-- CTA button -->
    <!-- Mobile menu toggle -->
  </div>
</nav>
```

---

## 5. Animations & Micro-interactions

### Scroll Reveal (Framer Motion)

```tsx
// Fade up on scroll
const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } }
};

// Stagger children
const stagger = {
  visible: { transition: { staggerChildren: 0.1 } }
};
```

### Hover Effects

- Cards: `hover:-translate-y-1 hover:shadow-lg` (subtle lift)
- Buttons: `hover:-translate-y-0.5 hover:shadow-xl` (micro lift)
- Links: `hover:text-brand-accent` (color change)
- Images: `hover:scale-105` (subtle zoom)

### Transitions

```css
/* Default transition for all interactive elements */
transition: all 0.2s ease-out;

/* Tailwind class */
class="transition-all duration-200 ease-out"
```

### Rules

- ❌ No heavy parallax (hurts mobile performance)
- ❌ No auto-playing videos (data-expensive for Indian users)
- ✅ Subtle fade-in on scroll (intersection observer)
- ✅ Smooth hover states on cards and buttons
- ✅ Loading skeleton for images

---

## 6. Responsive Breakpoints

| Breakpoint | Width | Target |
|-----------|-------|--------|
| `sm` | 640px | Large phones (landscape) |
| `md` | 768px | Tablets |
| `lg` | 1024px | Small laptops |
| `xl` | 1280px | Desktops |
| `2xl` | 1536px | Large screens |

### Mobile-First Approach

```html
<!-- Example: 1 col on mobile, 2 on tablet, 3 on desktop -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
```

---

## 7. Dark Mode (Optional — Phase 2)

For launch, ship **light mode only**. Dark mode can be added later using:

```css
/* CSS variables approach */
:root {
  --bg-primary: #ffffff;
  --text-primary: #111827;
}

.dark {
  --bg-primary: #0f172a;
  --text-primary: #f1f5f9;
}
```

---

## 8. Accessibility (WCAG AA)

| Requirement | Implementation |
|-------------|---------------|
| Color contrast | All text meets 4.5:1 ratio minimum |
| Focus states | Visible focus ring on all interactive elements |
| Alt text | All images have descriptive alt text |
| Keyboard nav | Full keyboard navigation support |
| Semantic HTML | Proper heading hierarchy, landmarks |
| Skip link | "Skip to content" link for screen readers |
| Touch targets | Minimum 44x44px for mobile buttons |

```html
<!-- Focus ring -->
class="focus:outline-none focus-visible:ring-2 focus-visible:ring-brand-accent focus-visible:ring-offset-2"
```

---

## 9. Performance Targets

| Metric | Target | How |
|--------|--------|-----|
| LCP (Largest Contentful Paint) | < 2.5s | Optimized images, preload hero |
| FID (First Input Delay) | < 100ms | Minimal JS, static pages |
| CLS (Cumulative Layout Shift) | < 0.1 | Fixed image dimensions, font-display: swap |
| Lighthouse Score | 95+ | All optimizations below |
| Page Size | < 500KB | Compressed images, tree-shaking |

### Optimization Checklist

- [ ] Next.js Image component for all images (WebP, lazy load)
- [ ] Font preload with `font-display: swap`
- [ ] Critical CSS inlined
- [ ] No unused JavaScript
- [ ] Gzip/Brotli compression (Vercel handles this)
- [ ] Static generation (no server-side rendering needed)

---

## 10. Design Inspiration & References

| Reference | What to Take |
|-----------|-------------|
| [Linear.app](https://linear.app) | Clean hero, smooth animations, dark aesthetic |
| [Vercel.com](https://vercel.com) | Typography, whitespace, gradient usage |
| [Stripe.com](https://stripe.com) | Feature sections, card design, trust signals |
| [Notion.so](https://notion.so) | Simple messaging, clear CTAs |
| [Razorpay.com](https://razorpay.com) | Indian SaaS, trust badges, pricing |
| [Cred.club](https://cred.club) | Premium feel, dark theme, Indian audience |

### Key Takeaways for AutoLab

1. **Hero**: Large heading + subtext + 2 CTAs + phone mockup with screenshot
2. **Social proof**: "Trusted by X service centres" (even if small number initially)
3. **Feature sections**: Icon + title + description in grid
4. **Screenshots**: Phone mockup frames, not raw screenshots
5. **CTA repetition**: Download CTA appears 3-4 times on page (hero, mid, bottom)
6. **Trust signals**: "Free forever", "No credit card", "Made in India 🇮🇳"

---

## 11. Brand Voice & Copy Guidelines

### Tone

- **Friendly** but professional
- **Simple** — avoid jargon, write for non-technical users
- **Action-oriented** — every section has a clear next step
- **Empathetic** — acknowledge the pain points of paper records

### Do's

- ✅ "Track every service in one place"
- ✅ "Never miss a service date again"
- ✅ "Free for service centres"
- ✅ "Get started in 2 minutes"

### Don'ts

- ❌ "Leverage our cutting-edge AI-powered platform"
- ❌ "Synergize your workflow optimization"
- ❌ Technical jargon (API, database, backend)
- ❌ Long paragraphs (max 2-3 lines per paragraph)

### Language

- Primary: **English** (Indian English)
- Consider: Hindi taglines for emotional connection
  - "अब सर्विस भूलना नामुमकिन" (Now forgetting service is impossible)
  - "आपकी गाड़ी, आपका रिकॉर्ड" (Your vehicle, your record)

---

*Next: Read `PAGES.md` for complete page content →*
