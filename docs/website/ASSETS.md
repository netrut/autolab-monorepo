# 🖼️ AutoLab Website — Assets & Resources

## 1. App Screenshots (Already Available)

### Service Centre App Screenshots

Located at: `/workspaces/autolab-monorepo/docs/website/images/service_centre/`

| File | Suggested Usage | Rename To |
|------|----------------|-----------|
| Screenshot 2026-05-10 at 5.58.58PM.png | Home/Dashboard | `sc-home.png` |
| Screenshot 2026-05-17 at 9.21.12PM.png | Feature section | `sc-feature-1.png` |
| Screenshot 2026-05-17 at 9.22.02PM.png | Feature section | `sc-feature-2.png` |
| Screenshot 2026-05-17 at 9.22.18PM.png | Feature section | `sc-feature-3.png` |
| Screenshot 2026-05-17 at 9.22.31PM.png | Feature section | `sc-feature-4.png` |
| Screenshot 2026-05-17 at 9.22.56PM.png | Feature section | `sc-feature-5.png` |
| Screenshot 2026-05-17 at 9.23.18PM.png | Feature section | `sc-feature-6.png` |

### Customer App Screenshots

Located at: `/workspaces/autolab-monorepo/docs/website/images/customer_app/`

| File | Suggested Usage | Rename To |
|------|----------------|-----------|
| Screenshot 2026-05-17 at 9.27.02PM.png | Home/Dashboard | `ca-home.png` |
| Screenshot 2026-05-17 at 9.27.38PM.png | Feature section | `ca-feature-1.png` |
| Screenshot 2026-05-17 at 9.27.55PM.png | Feature section | `ca-feature-2.png` |
| Screenshot 2026-05-17 at 9.28.11PM.png | Feature section | `ca-feature-3.png` |
| Screenshot 2026-05-17 at 9.28.25PM.png | Feature section | `ca-feature-4.png` |

### Screenshot Optimization

Before using in website:
1. Resize to max 750px width (phone screenshots don't need to be huge)
2. Convert to WebP format (50-70% smaller than PNG)
3. Create 2x versions for retina displays
4. Use Next.js `<Image>` component for automatic optimization

```bash
# Batch convert with sharp-cli (or use squoosh.app online)
npx sharp-cli resize 750 --input "*.png" --output "./optimized/" --format webp --quality 85
```

---

## 2. Free Image Resources

### Hero Section Images

| Source | URL | What to Get |
|--------|-----|-------------|
| **Unsplash** | https://unsplash.com/s/photos/car-mechanic | Mechanic working on car (hero background) |
| **Unsplash** | https://unsplash.com/s/photos/auto-repair | Auto repair shop interior |
| **Unsplash** | https://unsplash.com/s/photos/car-service | Car being serviced |
| **Pexels** | https://www.pexels.com/search/mechanic/ | Indian mechanic photos |
| **Pexels** | https://www.pexels.com/search/car-workshop/ | Workshop environment |

**Recommended hero images** (search terms):
- "mechanic tablet" — shows digital transformation
- "car service centre India" — relatable to target audience
- "auto repair modern" — professional workshop

### Illustrations (Free)

| Source | URL | Style | Usage |
|--------|-----|-------|-------|
| **unDraw** | https://undraw.co/illustrations | Flat, customizable color | How it works, empty states |
| **Storyset** | https://storyset.com | Animated, detailed | Feature sections |
| **Humaaans** | https://humaaans.com | Mix-and-match people | About page, testimonials |
| **Blush** | https://blush.design | Various styles | Hero, features |
| **DrawKit** | https://drawkit.com | Clean, professional | Problem/solution sections |

**Recommended illustrations** (search on unDraw/Storyset):
- "Mobile app" — for download sections
- "Data report" — for service history feature
- "Notification" — for reminders feature
- "Invoice" — for billing feature
- "Team work" — for multi-user feature
- "Car repair" / "Mechanic" — for hero/about

### Icons

| Source | URL | Format | Usage |
|--------|-----|--------|-------|
| **Lucide** | https://lucide.dev | React components | Primary icon set (already in stack) |
| **Heroicons** | https://heroicons.com | SVG | Alternative icons |
| **Phosphor** | https://phosphoricons.com | React/SVG | Feature icons |
| **Tabler Icons** | https://tabler.io/icons | SVG | Additional icons |

**Key icons needed**:
- Search, FileText, Calendar, Bell, Receipt, Users, Car, Wrench
- Shield, Clock, Download, Phone, Mail, MapPin
- CheckCircle, ArrowRight, Star, Heart

### Patterns & Backgrounds

| Source | URL | Usage |
|--------|-----|-------|
| **Hero Patterns** | https://heropatterns.com | Subtle SVG backgrounds |
| **SVG Backgrounds** | https://svgbackgrounds.com | Section backgrounds |
| **Haikei** | https://haikei.app | Blob shapes, waves |
| **Mesh Gradient** | https://meshgradient.in | Gradient backgrounds |

---

## 3. Logo & Branding

### Logo Requirements

Create/use AutoLab logo in these formats:

| Format | Size | Usage |
|--------|------|-------|
| `logo.svg` | Scalable | Navbar, footer |
| `logo-dark.svg` | Scalable | On dark backgrounds |
| `logo-icon.svg` | 32x32 | Favicon, small spaces |
| `logo-full.png` | 200x50 | Email, social |
| `og-image.png` | 1200x630 | Social media sharing |

### Logo Design Direction

If logo doesn't exist yet, here's the brief:
- **Symbol**: Stylized wrench + digital/circuit element (or speedometer + checkmark)
- **Wordmark**: "AUTOLAB" in Inter Bold or Poppins Bold
- **Colors**: Primary blue-black (#1B1F26) with accent blue (#3B82F6)
- **Style**: Modern, minimal, tech-forward

### Free Logo Tools

| Tool | URL |
|------|-----|
| Canva | https://canva.com (free tier) |
| Figma | https://figma.com (free) |
| Looka | https://looka.com (AI logo, paid for high-res) |
| Hatchful | https://hatchful.shopify.com (free) |

---

## 4. App Store Assets

### Google Play Store

| Asset | Size | Format |
|-------|------|--------|
| App Icon | 512x512 | PNG (32-bit) |
| Feature Graphic | 1024x500 | PNG/JPEG |
| Screenshots | 320-3840px wide | PNG/JPEG (min 2, max 8) |
| Short Description | 80 chars max | Text |
| Full Description | 4000 chars max | Text |

### Apple App Store

| Asset | Size | Format |
|-------|------|--------|
| App Icon | 1024x1024 | PNG (no alpha) |
| Screenshots (6.7") | 1290x2796 | PNG |
| Screenshots (6.5") | 1284x2778 | PNG |
| Screenshots (5.5") | 1242x2208 | PNG |
| Preview Video | 15-30 seconds | MP4 |

### Store Badge Images

Use official badges (free to use):

```html
<!-- Google Play Badge -->
<a href="#">
  <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
       alt="Get it on Google Play" height="60" />
</a>

<!-- App Store Badge -->
<a href="#">
  <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"
       alt="Download on the App Store" height="60" />
</a>
```

Or use local copies in `public/images/badges/`:
- `google-play-badge.png`
- `app-store-badge.svg`

---

## 5. Phone Mockup Frames

### Free Mockup Resources

| Source | URL | Type |
|--------|-----|------|
| **Mockup World** | https://mockupworld.co | PSD/Figma mockups |
| **Smartmockups** | https://smartmockups.com | Online tool (free tier) |
| **Shots.so** | https://shots.so | Browser-based, beautiful |
| **Device Frames** | https://deviceframes.com | Simple device frames |
| **MockuPhone** | https://mockuphone.com | Free phone mockups |

### CSS Phone Mockup (No external tool needed)

Build a phone frame in CSS/Tailwind (recommended for performance):

```tsx
// components/ui/phone-mockup.tsx
export function PhoneMockup({ src, alt }: { src: string; alt: string }) {
  return (
    <div className="relative mx-auto w-[280px]">
      {/* Phone body */}
      <div className="rounded-[2.5rem] border-[6px] border-gray-900 bg-gray-900 shadow-2xl">
        {/* Notch */}
        <div className="mx-auto mt-2 h-5 w-24 rounded-full bg-gray-800" />
        {/* Screen */}
        <div className="mx-1 mt-2 mb-2 overflow-hidden rounded-[2rem]">
          <img src={src} alt={alt} className="w-full" />
        </div>
      </div>
      {/* Home indicator */}
      <div className="mx-auto mt-1 h-1 w-16 rounded-full bg-gray-300" />
    </div>
  );
}
```

---

## 6. Social Media / OG Images

### Open Graph Image Template

Create a 1200x630px image for each page:

| Page | OG Image Content |
|------|-----------------|
| Home | AutoLab logo + tagline + both phone mockups |
| Service Centre | "For Service Centres" + app screenshot |
| Customer | "For Vehicle Owners" + app screenshot |
| Download | "Download AutoLab" + store badges |

### Tools to Create OG Images

| Tool | URL | Notes |
|------|-----|-------|
| Figma | https://figma.com | Best for custom designs |
| Canva | https://canva.com | Quick templates |
| OG Image Generator | https://og-image.vercel.app | Code-based (Vercel) |

---

## 7. Favicon & PWA Icons

Generate from logo using https://realfavicongenerator.net/

Required files:
```
public/
├── favicon.ico              (16x16, 32x32)
├── favicon-16x16.png
├── favicon-32x32.png
├── apple-touch-icon.png     (180x180)
├── android-chrome-192x192.png
├── android-chrome-512x512.png
├── site.webmanifest
└── browserconfig.xml
```

---

## 8. Video Assets (Optional — Phase 2)

### Demo Video Ideas

| Video | Duration | Content |
|-------|----------|---------|
| Product Overview | 60-90s | Quick walkthrough of both apps |
| Service Centre Demo | 2-3 min | Full flow: search → service → invoice |
| Customer Demo | 1-2 min | View history, reminders, invoices |

### Free Video Tools

| Tool | URL | Usage |
|------|-----|-------|
| Loom | https://loom.com | Screen recording |
| OBS Studio | https://obsproject.com | Professional recording |
| DaVinci Resolve | https://blackmagicdesign.com | Free video editing |
| Canva Video | https://canva.com | Quick promo videos |

---

## 9. Image Optimization Checklist

Before deploying any image:

- [ ] Resize to maximum needed display size (don't serve 4000px images)
- [ ] Convert to WebP format (use PNG fallback for older browsers)
- [ ] Compress: quality 80-85% for photos, lossless for screenshots
- [ ] Add proper `alt` text for accessibility
- [ ] Use Next.js `<Image>` component (auto lazy-load, responsive)
- [ ] Set explicit `width` and `height` to prevent CLS
- [ ] Use `priority` prop for above-the-fold images (hero)
- [ ] Create `srcSet` for responsive images (Next.js handles this)

### Recommended Image Sizes

| Usage | Max Width | Format |
|-------|-----------|--------|
| Hero background | 1920px | WebP (quality 80) |
| Phone screenshots | 750px | WebP (quality 85) |
| Feature icons | 64px | SVG (preferred) or WebP |
| Testimonial avatars | 80px | WebP (quality 80) |
| Logo | 200px | SVG |
| OG images | 1200px | PNG (for social compatibility) |

---

## 10. Content Images to Create/Source

### Must-Have Images

| # | Image | Source | Notes |
|---|-------|--------|-------|
| 1 | Hero background (mechanic/workshop) | Unsplash/Pexels | Dark, professional |
| 2 | AutoLab logo (SVG) | Create in Figma | Primary brand asset |
| 3 | Phone mockups with screenshots | CSS component | Built in code |
| 4 | Feature icons (6-8) | Lucide React | Consistent style |
| 5 | How-it-works illustrations | unDraw/Storyset | 3 step illustrations |
| 6 | Testimonial avatars | Generated/stock | 3 people |
| 7 | About page team photo | Real or illustration | Builds trust |
| 8 | OG image (social sharing) | Figma/Canva | 1200x630 |
| 9 | Favicon set | From logo | All sizes |
| 10 | Store badges | Official Google/Apple | Standard badges |

### Nice-to-Have (Phase 2)

| # | Image | Source |
|---|-------|--------|
| 1 | Product demo video thumbnail | Screenshot + play button |
| 2 | Blog post featured images | Unsplash |
| 3 | Partner logos (if any) | From partners |
| 4 | Map showing service centres | Google Maps embed |
| 5 | Before/after comparison | Custom design |

---

*Next: Read `SEO_AND_LEGAL.md` for SEO strategy and legal pages →*
