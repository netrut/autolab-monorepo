# 📐 AutoLab Website — Section-by-Section Layout Guide

Detailed layout, spacing, and implementation notes for every section.

---

## Home Page Sections

### Section 1: Hero

**Height**: Full viewport (min-h-screen) on desktop, auto on mobile

**Layout**:
```
┌─────────────────────────────────────────────────────────────────┐
│ [Navbar - fixed, transparent on hero, white on scroll]          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────┐  ┌──────────────────────────────┐    │
│  │                      │  │                              │    │
│  │  [Badge pill]        │  │    ┌─────┐    ┌─────┐      │    │
│  │                      │  │    │Phone│    │Phone│      │    │
│  │  [H1 - 2 lines]     │  │    │Mock │    │Mock │      │    │
│  │                      │  │    │ SC  │    │Cust│      │    │
│  │  [Subtitle - 2 lines]│  │    │ App │    │App │      │    │
│  │                      │  │    │     │    │     │      │    │
│  │  [CTA] [CTA]        │  │    └─────┘    └─────┘      │    │
│  │                      │  │                              │    │
│  │  [Trust badges]      │  │  (slightly overlapping,      │    │
│  │                      │  │   rotated -5° and +5°)       │    │
│  └──────────────────────┘  └──────────────────────────────┘    │
│                                                                   │
│  [Scroll indicator arrow ↓]                                      │
└─────────────────────────────────────────────────────────────────┘
```

**Background**: Dark gradient with subtle dot grid pattern
**Text color**: White on dark background
**Phone mockups**: Floating with subtle shadow, slight rotation for depth

**Tailwind structure**:
```html
<section class="relative min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-blue-900 overflow-hidden">
  <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 pt-32 pb-20">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
      <!-- Left: Content -->
      <!-- Right: Phone mockups -->
    </div>
  </div>
</section>
```

---

### Section 2: Problem Statement

**Background**: White (`bg-white`)
**Layout**: Centered heading + 3 cards in a row

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label - uppercase, small, blue]                     │
│              [H2 - centered, bold]                                │
│              [Subtitle - centered, gray]                          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  [Icon]      │  │  [Icon]      │  │  [Icon]      │          │
│  │  [Title]     │  │  [Title]     │  │  [Title]     │          │
│  │  [Desc]      │  │  [Desc]      │  │  [Desc]      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Cards**: Red/orange tinted icons (problem = negative), border-red-100 subtle border

---

### Section 3: Solution (Two Apps)

**Background**: Light gray (`bg-gray-50`)
**Layout**: 2 large cards side by side

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label]                                              │
│              [H2]                                                 │
│                                                                   │
│  ┌────────────────────────────┐  ┌────────────────────────────┐ │
│  │  [Badge: FOR SERVICE CTRS] │  │  [Badge: FOR CUSTOMERS]    │ │
│  │                            │  │                            │ │
│  │  [H3]                      │  │  [H3]                      │ │
│  │  [Body text]               │  │  [Body text]               │ │
│  │                            │  │                            │ │
│  │  [Feature bullets ✓✓✓]    │  │  [Feature bullets ✓✓✓]    │ │
│  │                            │  │                            │ │
│  │  [CTA button →]           │  │  [CTA button →]           │ │
│  │                            │  │                            │ │
│  │  ┌──────────────────┐     │  │  ┌──────────────────┐     │ │
│  │  │  [Screenshot]    │     │  │  │  [Screenshot]    │     │ │
│  │  └──────────────────┘     │  │  └──────────────────┘     │ │
│  └────────────────────────────┘  └────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Card style**: Large rounded corners (rounded-3xl), white bg, subtle shadow, hover lift
**Badge colors**: Blue for Service Centre, Green for Customer

---

### Section 4: Features Grid

**Background**: White
**Layout**: Section header + 2x3 grid

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label + H2 + Subtitle]                             │
│                                                                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                        │
│  │ [Icon]  │  │ [Icon]  │  │ [Icon]  │                        │
│  │ [Title] │  │ [Title] │  │ [Title] │                        │
│  │ [Desc]  │  │ [Desc]  │  │ [Desc]  │                        │
│  └─────────┘  └─────────┘  └─────────┘                        │
│                                                                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                        │
│  │ [Icon]  │  │ [Icon]  │  │ [Icon]  │                        │
│  │ [Title] │  │ [Title] │  │ [Title] │                        │
│  │ [Desc]  │  │ [Desc]  │  │ [Desc]  │                        │
│  └─────────┘  └─────────┘  └─────────┘                        │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Card style**: Icon in colored circle (blue-50 bg), hover border change
**Mobile**: Stack to 1 column

---

### Section 5: How It Works

**Background**: Gray-50
**Layout**: 3 steps with connecting dotted line

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label + H2]                                         │
│                                                                   │
│     ①─────────────────②─────────────────③                       │
│                                                                   │
│  ┌─────────┐      ┌─────────┐      ┌─────────┐                │
│  │  [Icon] │      │  [Icon] │      │  [Icon] │                │
│  │ Download│      │Register │      │  Start  │                │
│  │  the App│      │Your Ctr │      │Recording│                │
│  │  [desc] │      │  [desc] │      │  [desc] │                │
│  └─────────┘      └─────────┘      └─────────┘                │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Step numbers**: Large circled numbers (bg-brand-accent, text-white, rounded-full)
**Connecting line**: Dashed border between steps (hidden on mobile)

---

### Section 6: Stats Bar

**Background**: Dark (bg-gray-900)
**Layout**: 4 stats in a row, centered

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│    500+          1000+          50+           4.8★               │
│  Vehicles      Service       Service        User                │
│  Tracked       Records       Centres        Rating              │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Numbers**: text-4xl font-bold text-white
**Labels**: text-sm text-gray-400
**Animation**: Count-up animation on scroll into view

---

### Section 7: Testimonials

**Background**: White
**Layout**: 3 cards with quote marks

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label + H2]                                         │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  "Quote..."  │  │  "Quote..."  │  │  "Quote..."  │          │
│  │              │  │              │  │              │          │
│  │  [Avatar]    │  │  [Avatar]    │  │  [Avatar]    │          │
│  │  [Name]      │  │  [Name]      │  │  [Name]      │          │
│  │  [Role]      │  │  [Role]      │  │  [Role]      │          │
│  │  ★★★★★      │  │  ★★★★★      │  │  ★★★★★      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Card style**: Large quote mark (") as decorative element, subtle left border accent

---

### Section 8: Download CTA

**Background**: Gradient (same as hero but lighter)
**Layout**: Centered content with store badges

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [H2 - white]                                         │
│              [Subtitle - white/70]                                │
│                                                                   │
│              [CTA Button] [CTA Button]                           │
│                                                                   │
│         [Play Store]  [App Store]  [Web App]                    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

### Section 9: FAQ

**Background**: Gray-50
**Layout**: Centered accordion, max-w-3xl

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [Label + H2]                                         │
│                                                                   │
│         ┌─────────────────────────────────────┐                 │
│         │ ▶ Is AutoLab free?                  │                 │
│         ├─────────────────────────────────────┤                 │
│         │ ▶ Do I need internet?               │                 │
│         ├─────────────────────────────────────┤                 │
│         │ ▼ Can customers see history?        │                 │
│         │   Yes! When you complete a service..│                 │
│         ├─────────────────────────────────────┤                 │
│         │ ▶ Is my data safe?                  │                 │
│         ├─────────────────────────────────────┤                 │
│         │ ▶ Cars and bikes?                   │                 │
│         └─────────────────────────────────────┘                 │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Accordion style**: Clean borders, smooth expand animation, plus/minus icon

---

## Service Centre & Customer Pages

### Feature Sections (Alternating Layout)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│  ┌──────────────────────┐  ┌──────────────────────────────┐    │
│  │                      │  │                              │    │
│  │  [Label - small]     │  │    ┌─────────────────┐      │    │
│  │  [H3 - feature]      │  │    │                 │      │    │
│  │                      │  │    │  [Phone mockup  │      │    │
│  │  [Body - 2-3 lines]  │  │    │   with screen-  │      │    │
│  │                      │  │    │   shot]         │      │    │
│  │  [Bullet points]     │  │    │                 │      │    │
│  │  ✓ Point 1           │  │    └─────────────────┘      │    │
│  │  ✓ Point 2           │  │                              │    │
│  │  ✓ Point 3           │  │                              │    │
│  │                      │  │                              │    │
│  └──────────────────────┘  └──────────────────────────────┘    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘

(Next section: image on LEFT, text on RIGHT — alternating)
```

**Spacing**: `py-20 lg:py-28` between feature sections
**Alignment**: Items vertically centered (`items-center`)
**Mobile**: Stack (image on top, text below)

---

### Screenshots Carousel

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│              [H2 - "See It in Action"]                           │
│                                                                   │
│  ← ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ →       │
│    │    │ │    │ │    │ │    │ │    │ │    │ │    │          │
│    │ SC │ │ SC │ │ SC │ │ SC │ │ SC │ │ SC │ │ SC │          │
│    │ 1  │ │ 2  │ │ 3  │ │ 4  │ │ 5  │ │ 6  │ │ 7  │          │
│    │    │ │    │ │    │ │    │ │    │ │    │ │    │          │
│    └────┘ └────┘ └────┘ └────┘ └────┘ └────┘ └────┘          │
│                                                                   │
│              [● ○ ○ ○ ○ ○ ○] (dots indicator)                   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Implementation**: CSS scroll-snap horizontal scroll (no JS library needed)
**Phone frames**: Each screenshot wrapped in phone mockup component
**Mobile**: Show 1 at a time, swipeable

```html
<div class="flex gap-6 overflow-x-auto snap-x snap-mandatory scrollbar-hide px-4">
  <div class="snap-center shrink-0">
    <PhoneMockup src="..." alt="..." />
  </div>
  <!-- repeat -->
</div>
```

---

## Navbar Behavior

```
┌─────────────────────────────────────────────────────────────────┐
│ [Logo]    Home  Service Centre  Customer  Pricing  [Download ↓] │
└─────────────────────────────────────────────────────────────────┘
```

**States**:
1. **On hero (top)**: Transparent background, white text
2. **On scroll**: White background, dark text, subtle shadow, backdrop-blur
3. **Mobile**: Logo + hamburger menu icon

**Transition**: Smooth background change on scroll (use IntersectionObserver)

```tsx
// Navbar scroll behavior
const [scrolled, setScrolled] = useState(false);

useEffect(() => {
  const handler = () => setScrolled(window.scrollY > 50);
  window.addEventListener('scroll', handler);
  return () => window.removeEventListener('scroll', handler);
}, []);

// Classes
className={cn(
  "fixed top-0 z-50 w-full transition-all duration-300",
  scrolled ? "bg-white/90 backdrop-blur-lg shadow-sm" : "bg-transparent"
)}
```

---

## Footer Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  bg-gray-900 text-white                                          │
│                                                                   │
│  ┌────────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌──────┐│
│  │ [Logo]     │  │Product │  │Company │  │Legal   │  │Social││
│  │ AutoLab    │  │        │  │        │  │        │  │      ││
│  │            │  │SC App  │  │About   │  │Privacy │  │ 𝕏    ││
│  │ Tagline    │  │Cust App│  │Contact │  │Terms   │  │ in   ││
│  │ text here  │  │Pricing │  │Careers │  │Refund  │  │ 📷   ││
│  │            │  │Download│  │Blog    │  │Cookie  │  │ ▶️    ││
│  └────────────┘  └────────┘  └────────┘  └────────┘  └──────┘│
│                                                                   │
│  ─────────────────────────────────────────────────────────────── │
│  © 2026 AutoLab Technologies. Made with ❤️ in India 🇮🇳          │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Mobile footer**: Stack columns vertically, accordion-style collapsible groups

---

## Animation Timing

| Section | Animation | Trigger | Duration |
|---------|-----------|---------|----------|
| Hero text | Fade up | Page load | 0.6s |
| Hero phones | Fade up + scale | Page load (0.3s delay) | 0.8s |
| Problem cards | Stagger fade up | Scroll into view | 0.4s each, 0.1s stagger |
| Feature cards | Stagger fade up | Scroll into view | 0.4s each, 0.1s stagger |
| Stats numbers | Count up | Scroll into view | 1.5s |
| Testimonials | Fade in | Scroll into view | 0.5s |
| Screenshots | Already visible | Horizontal scroll | N/A |

**Library**: Framer Motion `useInView` + `motion.div`

```tsx
import { motion, useInView } from 'framer-motion';

function FadeUp({ children, delay = 0 }) {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-100px' });

  return (
    <motion.div
      ref={ref}
      initial={{ opacity: 0, y: 30 }}
      animate={inView ? { opacity: 1, y: 0 } : {}}
      transition={{ duration: 0.5, delay, ease: 'easeOut' }}
    >
      {children}
    </motion.div>
  );
}
```

---

## Responsive Behavior Summary

| Element | Mobile (< 768px) | Tablet (768-1024px) | Desktop (> 1024px) |
|---------|-------------------|---------------------|---------------------|
| Hero | Stack (text → phones) | Stack | Side by side |
| Nav | Logo + hamburger | Logo + hamburger | Full nav links |
| Feature grid | 1 column | 2 columns | 3 columns |
| Stats | 2x2 grid | 4 columns | 4 columns |
| Testimonials | 1 card (swipe) | 2 cards | 3 cards |
| Feature sections | Stack (img → text) | Stack | Alternating L/R |
| Footer | Stacked columns | 2x2 grid | 5 columns |
| Phone mockups | 240px wide | 280px wide | 320px wide |
| H1 size | text-4xl | text-5xl | text-6xl/7xl |

---

## Implementation Priority

Build in this order:

1. **Layout** — Navbar + Footer + page shells
2. **Home Hero** — First impression, most important
3. **Home Features** — Core value communication
4. **Service Centre page** — Primary conversion page
5. **Customer page** — Secondary conversion page
6. **Download page** — Conversion endpoint
7. **About + Contact** — Trust building
8. **Privacy + Terms** — Legal compliance
9. **Pricing** — Future monetization
10. **Animations** — Polish (last, not first)

---

*All documents complete. Ready to scaffold `apps/website` and start building! 🚀*
