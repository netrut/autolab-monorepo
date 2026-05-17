# 🏠 Customer App — Home Screen UI/UX Design

---

## Design Philosophy

- **Modern & Clean** — Minimal, card-based layout with generous whitespace
- **Action-Oriented** — Quick access to most-used features within 1 tap
- **Informative** — Show vehicle health status at a glance
- **Personal** — Greeting, vehicle-centric, tailored notifications

---

## Home Screen Layout (Top to Bottom)

```
┌─────────────────────────────────────────┐
│  [☰]        AUTOLAB         [🔔 badge]  │  ← AppBar
├─────────────────────────────────────────┤
│                                         │
│  Hello, Rahul 👋                        │  ← Greeting
│  Keep your ride in top shape            │  ← Subtitle
│                                         │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐    │
│  │  🚗 My Active Vehicle           │    │  ← Vehicle Summary Card
│  │  Honda City • MH 12 AB 1234     │    │
│  │  ─────────────────────────────   │    │
│  │  Next Service: 15 Jul 2025      │    │
│  │  Odometer: 45,230 km            │    │
│  │  Status: ✅ All Good             │    │
│  │                    [View All →]  │    │
│  └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│  QUICK ACTIONS                          │  ← Section Header
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │ 🚗 │ │ 📅 │ │ 🔧 │ │ 🧾 │          │  ← 4 Icon Grid
│  │Vehi-│ │Book│ │Hist-│ │Invo-│          │
│  │cles │ │ ing│ │ory  │ │ices │          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
├─────────────────────────────────────────┤
│  UPCOMING SERVICES                      │  ← Section Header
│  ┌─────────────────────────────────┐    │
│  │ ⚠️  Oil Change Due              │    │  ← Alert Card
│  │  Honda City • Due in 3 days     │    │
│  │                  [Book Now →]   │    │
│  └─────────────────────────────────┘    │
│  ┌─────────────────────────────────┐    │
│  │ 🔧 General Service              │    │
│  │  Activa 6G • Due in 12 days     │    │
│  │                  [Book Now →]   │    │
│  └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│  RECENT SERVICES                        │  ← Section Header
│  ┌─────────────────────────────────┐    │
│  │ 12 Jun 2025 • AutoCare Hub      │    │
│  │ Honda City • ₹2,450             │    │
│  │ Oil Change, Filter Replaced     │    │
│  └─────────────────────────────────┘    │
│  ┌─────────────────────────────────┐    │
│  │ 28 May 2025 • SpeedFix Garage   │    │
│  │ Activa 6G • ₹850               │    │
│  │ Brake Pad Replaced              │    │
│  └─────────────────────────────────┘    │
│                    [View All History →]  │
│                                         │
├─────────────────────────────────────────┤
│  NEARBY SERVICE CENTRES                 │  ← Section Header
│  ┌──────┐ ┌──────┐ ┌──────┐           │  ← Horizontal Scroll
│  │ Logo │ │ Logo │ │ Logo │           │
│  │AutoCa│ │Speed │ │Royal │           │
│  │⭐ 4.5│ │⭐ 4.2│ │⭐ 4.8│           │
│  │ 1.2km│ │ 2.5km│ │ 3.1km│           │
│  └──────┘ └──────┘ └──────┘           │
│                    [Search More →]      │
│                                         │
├─────────────────────────────────────────┤
│  CONTACT & SUPPORT                      │
│  ┌─────────────────────────────────┐    │
│  │  Need help? We're here for you  │    │
│  │           [WhatsApp Us]          │    │
│  └─────────────────────────────────┘    │
│                                         │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  🏠 Home  │  🚗 Vehicles  │  📅 Book  │  🔔 Alerts  │  ← Bottom Nav
└─────────────────────────────────────────┘
```

---

## Section Details

### 1. AppBar
- Hamburger menu (drawer) on left
- "AUTOLAB" centered title (InterTight font, bold)
- Notification bell with unread badge on right

### 2. Greeting Section
- "Hello, {firstName}" — Poppins 24px bold italic
- Subtitle — Poppins 14px medium, grey
- Feels personal and welcoming

### 3. Vehicle Summary Card (Hero)
- Shows the **primary/active vehicle**
- Vehicle icon (car/bike) + brand + model + reg number
- Key stats: next service date, odometer, health status
- Status indicator: ✅ All Good / ⚠️ Service Due / 🔴 Overdue
- "View All" link to vehicles screen
- If no vehicle → "Add Your First Vehicle" CTA

### 4. Quick Actions Grid (2x2)
- **My Vehicles** → `/vehicles`
- **Book Service** → `/bookings/create`
- **Service History** → `/service-history`
- **Invoices** → `/invoices`
- Each: icon + label, rounded card, subtle shadow
- Tap feedback with ripple

### 5. Upcoming Services (Alerts)
- Shows services due within `reminder_days_before` setting
- Sorted by urgency (closest due date first)
- Each card: warning icon, service type, vehicle name, days remaining
- "Book Now" CTA → pre-fills booking with vehicle + service type
- Empty state: "All services up to date! 🎉"

### 6. Recent Services
- Last 2-3 service records
- Each: date, service centre name, vehicle, cost, key items
- Tap → service detail screen
- "View All History" link at bottom

### 7. Nearby Service Centres
- Horizontal scrollable cards
- Each: logo/icon, name, rating stars, distance
- Tap → centre detail screen
- "Search More" link → search screen
- If location not available → show "Enable Location" prompt

### 8. Contact & Support
- Simple card with WhatsApp/call CTA
- Uses helpline from Options API

---

## Bottom Navigation Bar

| Index | Icon | Label | Route |
|-------|------|-------|-------|
| 0 | 🏠 | Home | `/home` |
| 1 | 🚗 | Vehicles | `/vehicles` |
| 2 | 📅 | Book | `/bookings` |
| 3 | 🔔 | Alerts | `/notifications` |

---

## Color Scheme (Same as partner app)

| Token | Color | Usage |
|-------|-------|-------|
| Primary | `#1B1F26` | Buttons, active states |
| Background | `#F3F3F3` | Page background |
| Surface | `#FFFFFF` | Cards |
| Border | `#EAEAEA` | Card borders |
| Text Primary | `#14181B` | Headings |
| Text Secondary | `#57636C` | Subtitles |
| Success | `#249689` | "All Good" status |
| Warning | `#F5A623` | "Due Soon" status |
| Error | `#FF5963` | "Overdue" status |

---

## Drawer Menu Items

| Item | Icon | Route |
|------|------|-------|
| Home | home | `/home` |
| My Vehicles | directions_car | `/vehicles` |
| Bookings | calendar_today | `/bookings` |
| Service History | history | `/service-history` |
| Invoices | receipt_long | `/invoices` |
| Find Service Centre | search | `/search` |
| Requests | people | `/requests` |
| Notifications | notifications | `/notifications` |
| Profile | person | `/profile` |
| Settings | settings | `/settings` |
| Logout | logout | — |

---

## Responsive Considerations

- Cards use `Expanded` / `Flexible` for width adaptation
- Horizontal scroll for service centres (no overflow)
- Text overflow with ellipsis
- Min touch target: 48x48
- Works on both mobile and web (same as partner app)
