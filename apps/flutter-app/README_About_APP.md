# AutoLab — Vehicle Service Management App

## What is AutoLab?

AutoLab is a mobile app built for vehicle service centres and their customers. It replaces paper-based service records with a digital system where mechanics can log every service job in detail, and customers always know the full history of their vehicle.

---

## The Problem We Solve

Managing vehicle service history is painful for everyone involved:

- **Service centres** struggle to track what was done, which parts were replaced, and when each vehicle is due for its next service — especially across dozens of vehicles.
- **Customers** forget what was serviced, which parts are under warranty, and when they need to bring their vehicle back.
- **Both sides** miss service due dates, leading to vehicle damage and lost business.

AutoLab fixes this by keeping everything in one place, accessible to both the service centre and the customer.

---

## Who Uses It

- **Mechanics / Service Centre Staff** — log service records, add parts and work done, track costs, set next service dates.
- **Vehicle Owners / Customers** — view their vehicle's full service history, get reminders for upcoming and due services.

---

## Core Features

### Vehicle Management
- Add and manage cars (four-wheelers) and bikes (two-wheelers)
- Each vehicle has its own profile with registration number, make, model, and service history

### Vehicle Service Screen
- Lists all vehicles with their current service status: **Due**, **Upcoming**, or **Completed**
- Search vehicles by registration number or name
- Filter by service status (All / Due / Upcoming / Completed)
- Date-based filters: due today, last 7 days, next 30 days, etc.
- Quick action buttons — start a new service or view history — directly from the list

### Service Form (New / Edit)
- Create a new service record or edit an existing one
- Fill in service date, service type (general, major, emergency, etc.), odometer reading, and next service date
- Dynamically add service items using a searchable catalogue (oil change, brake pads, filters, etc.) or type a custom item
- For each item: set status (Changed / Replaced / Repaired / Good / Needs Attention), cost, notes, and expiry date for parts
- Labour cost entry with automatic total calculation (items subtotal + labour = total)
- Save as draft or mark as completed
- General mechanic notes / remarks field

### Service History
- Full chronological service history for each vehicle
- Each record shows date, service type, number of items, total cost, odometer reading, and next due date
- Tap any record to see the full detail view
- Latest service is visually highlighted

### Service Detail View
- Complete breakdown of a service record: vehicle info, service metadata, all items with status and expiry dates, cost breakdown, and mechanic notes
- Edit or delete a record directly from this screen

### Bookings
- Create and manage service bookings / appointments

### Service Centres
- Browse and view service centre details

### Profile & Authentication
- User registration, login, OTP verification, and forgot password
- Profile management

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Navigation | go_router |
| HTTP Client | Dio |
| Local Storage | shared_preferences |
| UI Fonts | Google Fonts (Poppins) |
| Image Caching | cached_network_image |
| Animations | Lottie |
| Date/Number Formatting | intl |

---

## App Structure

```
lib/
├── core/
│   ├── api/          # API service layer
│   ├── models/       # Data models (vehicle, service record, service item, etc.)
│   ├── providers/    # State management (VehicleServiceProvider, etc.)
│   └── utils/        # Helpers and utilities
├── features/
│   ├── auth/         # Login, register, OTP, forgot password
│   ├── bookings/     # Booking list and create booking
│   ├── home/         # Home dashboard
│   ├── profile/      # User profile
│   ├── service/      # Vehicle service (core feature)
│   │   └── screens/
│   │       ├── service_screen.dart         # Vehicle list with service status
│   │       ├── service_form_screen.dart    # Create / edit service record
│   │       ├── service_history_screen.dart # Full history for a vehicle
│   │       └── service_detail_screen.dart  # Single service record detail
│   ├── service_centers/ # Browse service centres
│   ├── services/     # Services catalogue
│   └── vehicles/     # Add and manage vehicles
└── shared/
    ├── theme/        # App theme and colours
    └── widgets/      # Shared widgets (bottom nav bar, etc.)
```

---

## Key Design Decisions

- **Dynamic service items** — mechanics are not locked into a fixed form. They search a catalogue or type any custom item, then fill in cost, status, and expiry date per item. This makes the form flexible for any type of service job.
- **Part expiry tracking** — each service item can have an expiry date, so the app can flag parts that are nearing or past their replacement date.
- **Service status logic** — vehicles are automatically tagged as Due, Upcoming, or Completed based on the next service date stored in the last service record.
- **Draft support** — mechanics can save a form as a draft mid-job and complete it later.
- **Offline-friendly UX** — data is loaded once and cached in the provider; pull-to-refresh is available on all list screens.
