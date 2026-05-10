# Vehicle Service Feature — Implementation Tracker

**Project:** AutoLab Monorepo  
**Feature:** Core Vehicle Service Management  
**Started:** May 2026  
**Status:** ✅ Complete

---

## Overview

The vehicle service feature is the core of AutoLab. It allows mechanics to:
- Search vehicles and see service status (Due / Upcoming / Completed)
- Create service records with dynamic line items after each service
- Track parts cost, labour cost, expiry dates
- Set next service date (drives reminder logic)
- View complete service history per vehicle
- Edit previously saved service records

---

## Architecture

```
Flutter App (apps/flutter-app/)
    ↓ HTTP + JWT
Backend API (apps/backend/)
    ↓ Prisma ORM
PostgreSQL (Supabase)
```

---

## Database (Prisma Schema)

### ✅ COMPLETED

| Table | Status | Notes |
|-------|--------|-------|
| `vehicle_services` | ✅ Created & migrated | One record per service visit |
| `service_items` | ✅ Created & migrated | Dynamic line items per service |
| `service_item_catalogue` | ✅ Created & migrated | Pre-loaded suggestions (39 items) |
| `User.vehicle_services` relation | ✅ Added | Prisma virtual relation only |
| `Vehicle.vehicle_services` relation | ✅ Added | Prisma virtual relation only |

### Key Fields — `vehicle_services`
- `service_date` — when service happened
- `next_service_date` — drives Due/Upcoming status badges
- `odometer_km` — km reading at service time
- `service_type` — general / major / emergency
- `labour_cost` — mechanic labour charge
- `total_cost` — auto = sum(items) + labour
- `notes` — mechanic general remarks
- `status` — completed / draft

### Key Fields — `service_items`
- `item_name` — e.g. "Engine Oil", custom item
- `status` — Good / Changed / Repaired / Replaced / Needs Attention
- `cost` — cost of this specific item
- `notes` — e.g. "10W40 Castrol"
- `expiry_date` — parts warranty/expiry date

---

## Backend API (apps/backend/)

### ✅ COMPLETED

| File | Status |
|------|--------|
| `src/controllers/vehicleServiceController.ts` | ✅ Created |
| `src/routes/vehicleService.routes.ts` | ✅ Created |
| Registered in `src/index.ts` | ✅ Done |

### API Endpoints

| Method | Endpoint | Auth | Status | Description |
|--------|----------|------|--------|-------------|
| GET | `/api/vehicle-services/vehicles` | Required | ✅ | List vehicles with service status |
| GET | `/api/vehicle-services/upcoming` | Required | ✅ | Vehicles with upcoming/due service |
| GET | `/api/vehicle-services/catalogue` | Optional | ✅ | Pre-loaded item suggestions |
| GET | `/api/vehicle-services/:vehicleId` | Required | ✅ | Service history for a vehicle |
| GET | `/api/vehicle-services/record/:id` | Required | ✅ | Single service record with items |
| POST | `/api/vehicle-services` | Required | ✅ | Create new service record |
| PUT | `/api/vehicle-services/record/:id` | Required | ✅ | Update service record (edit) |
| DELETE | `/api/vehicle-services/record/:id` | Required | ✅ | Delete service record |

---

## Flutter App (apps/flutter-app/)

### Models

| File | Status |
|------|--------|
| `lib/core/models/service_item_model.dart` | ✅ Created |
| `lib/core/models/vehicle_service_model.dart` | ✅ Created |

### Providers

| File | Status |
|------|--------|
| `lib/core/providers/vehicle_service_provider.dart` | ✅ Created |
| Registered in `lib/main.dart` | ✅ Done |

### Screens

| Screen | File | Route | Status |
|--------|------|-------|--------|
| Service (Search) | `lib/features/service/screens/service_screen.dart` | `/services` | ✅ Created |
| Service Form | `lib/features/service/screens/service_form_screen.dart` | `/service/form/:vehicleId` | ✅ Created |
| Service History | `lib/features/service/screens/service_history_screen.dart` | `/service/history/:vehicleId` | ✅ Created |
| Service Detail | `lib/features/service/screens/service_detail_screen.dart` | `/service/detail/:serviceId` | ✅ Created |

### Router

| Task | Status |
|------|--------|
| Add `/service/form/:vehicleId` route | ✅ Done |
| Add `/service/history/:vehicleId` route | ✅ Done |
| Add `/service/detail/:serviceId` route | ✅ Done |
| Update bottom nav `Services` tab to use new `ServiceScreen` | ✅ Done |

---

## Remaining Tasks (In Order)

### 1. ✅ Service Form Screen
**File:** `lib/features/service/screens/service_form_screen.dart`  
**Features:**
- Vehicle info header (auto-filled from vehicleId)
- Service date picker (default today)
- Next service date picker
- Odometer reading input
- Service type selector (General / Major / Emergency)
- Dynamic line items list with + Add Item button
- Item bottom sheet: type name OR pick from catalogue suggestions
- Each item: name, status dropdown, cost, notes, expiry date
- Labour charge field
- Total cost (auto-calculated: items + labour)
- General notes/remarks
- Save as Draft / Save as Completed buttons
- Edit mode: pre-fills all fields when serviceId passed

### 2. ✅ Service History Screen
**File:** `lib/features/service/screens/service_history_screen.dart`  
**Features:**
- Vehicle header card (brand, model, reg number, type)
- Timeline list of all services (latest first)
- Each card: date, service type badge, items count, total cost, next due date
- Tap card → navigate to Service Detail
- Pull to refresh
- Empty state

### 3. ✅ Service Detail Screen
**File:** `lib/features/service/screens/service_detail_screen.dart`  
**Features:**
- Full service record view
- Vehicle info header
- Service meta: date, type, odometer
- All items with status colour badges
- Cost breakdown: items subtotal + labour + total
- Mechanic notes
- Next service date
- Edit button → navigates to Service Form in edit mode
- Delete with confirmation dialog

### 4. ✅ Router Updates
**File:** `lib/core/utils/router.dart`  
- Add 3 new routes
- Update `/services` to use new `ServiceScreen`

### 5. ✅ Bottom Nav Update
**File:** `lib/shared/widgets/bottom_nav_bar.dart`  
- Change Services tab icon to `Icons.build_outlined`

### 6. ✅ Documentation
**File:** `docs/VEHICLE_SERVICE.md`  
- Complete API reference
- Data flow diagrams
- Status calculation logic

---

## Service Status Logic

```
For each vehicle, look at its latest service record:

if (next_service_date exists AND next_service_date > today)  → "upcoming"
if (next_service_date exists AND next_service_date <= today) → "due"
if (no next_service_date AND days_since_last_service > 90)  → "due"
if (no next_service_date AND days_since_last_service <= 90) → "completed"
if (no service records at all)                              → "no_service"
```

---

## Catalogue Items Seeded (39 items)

| Category | Items |
|----------|-------|
| engine | Engine Oil, Oil Filter, Air Filter, Spark Plug/s, Fuel Filter, Timing Belt, Drive Chain |
| fluids | Coolant, Brake Fluid, Gear Oil, Power Steering Fluid, Transmission Fluid |
| brakes | Brake Pads, Brake Disc, Brake Shoes, Brake Caliper |
| electrical | Battery, Lights & Signals, Horn, Self Start Motor, Alternator, AC Filter, AC Gas Refill |
| tyres | Front Tyre, Rear Tyre, Tyre Rotation, Wheel Alignment, Wheel Balancing, Tyre Pressure Check |
| body | Wiper Blades, Clutch Wire, Clutch Plate, Accelerator Cable, Suspension Check, Shock Absorbers |
| other | Wash & Clean, General Inspection, Lubrication |

---

## Notes

- Old `bike_services` and `car_services` tables are kept untouched — zero impact on dashboard
- New tables are completely separate — only used by new service feature
- `VehicleServiceProvider` is registered in `main.dart`
- Backend server must be running on port 3002 for API calls to work
- Catalogue is loaded once and cached in provider memory

---

*Last updated: May 2026*
