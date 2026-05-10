# Vehicle Service — Feature Documentation

## Overview

The Vehicle Service feature is the core of AutoLab. It enables mechanics to record, track, and manage vehicle service history with dynamic line items, cost tracking, parts expiry dates, and next-service reminders.

---

## Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter App                                │
│                                                                   │
│  ServiceScreen ──→ ServiceFormScreen ──→ POST/PUT API            │
│       │                                                           │
│       ├──→ ServiceHistoryScreen ──→ ServiceDetailScreen           │
│       │                                    │                      │
│       │                                    ├── Edit → Form        │
│       │                                    └── Delete → API       │
│       │                                                           │
│  VehicleServiceProvider (state management via ChangeNotifier)     │
└───────────────────────────────┬───────────────────────────────────┘
                                │ HTTP + JWT
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Backend API                                │
│                                                                   │
│  vehicleService.routes.ts → vehicleServiceController.ts          │
│                                                                   │
│  Middleware: authMiddleware (JWT verification)                    │
└───────────────────────────────┬───────────────────────────────────┘
                                │ Prisma ORM
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     PostgreSQL (Supabase)                         │
│                                                                   │
│  Tables: vehicle_services, service_items, service_item_catalogue │
└─────────────────────────────────────────────────────────────────┘
```

---

## API Reference

Base URL: `http://localhost:3002`

All endpoints require `Authorization: Bearer <token>` header unless noted.

### GET /api/vehicle-services/vehicles

List all user's vehicles with computed service status.

**Query Params:**
- `search` (optional) — filter by registration number or brand/model
- `status` (optional) — `due` | `upcoming` | `completed` | `no_service`

**Response:**
```json
{
  "vehicles": [
    {
      "id": "uuid",
      "vehicle_type": "car",
      "brand": "Honda",
      "model": "City",
      "year": 2020,
      "registration_number": "MH-12-AB-1234",
      "fuel_type": "petrol",
      "service_status": "due",
      "last_service_date": "2025-01-15T00:00:00Z",
      "next_service_date": "2025-04-15T00:00:00Z",
      "total_services": 5
    }
  ]
}
```

---

### GET /api/vehicle-services/upcoming

Vehicles with upcoming or due service dates.

**Response:**
```json
{
  "services": [...]
}
```

---

### GET /api/vehicle-services/catalogue

Pre-loaded service item suggestions (39 items across 7 categories).

**Query Params:**
- `vehicle_type` (optional) — `car` | `bike` | `both`

**Response:**
```json
{
  "items": [
    {
      "id": "uuid",
      "name": "Engine Oil",
      "vehicle_type": "both",
      "category": "engine",
      "sort_order": 1
    }
  ]
}
```

---

### GET /api/vehicle-services/:vehicleId

Service history for a specific vehicle (latest first).

**Response:**
```json
{
  "services": [
    {
      "id": "uuid",
      "vehicle_id": "uuid",
      "service_date": "2025-03-10T00:00:00Z",
      "next_service_date": "2025-06-10T00:00:00Z",
      "odometer_km": 45000,
      "service_type": "general",
      "labour_cost": 500,
      "total_cost": 3500,
      "status": "completed",
      "items": [...]
    }
  ]
}
```

---

### GET /api/vehicle-services/record/:id

Single service record with all items and vehicle info.

**Response:**
```json
{
  "id": "uuid",
  "vehicle_id": "uuid",
  "user_id": "uuid",
  "service_date": "2025-03-10T00:00:00Z",
  "next_service_date": "2025-06-10T00:00:00Z",
  "odometer_km": 45000,
  "service_type": "general",
  "labour_cost": 500,
  "total_cost": 3500,
  "notes": "Regular maintenance",
  "status": "completed",
  "items": [
    {
      "id": "uuid",
      "service_id": "uuid",
      "item_name": "Engine Oil",
      "status": "Changed",
      "cost": 800,
      "notes": "10W40 Castrol",
      "expiry_date": "2025-09-10T00:00:00Z"
    }
  ],
  "vehicle": {
    "brand": "Honda",
    "model": "City",
    "registration_number": "MH-12-AB-1234",
    "vehicle_type": "car"
  }
}
```

---

### POST /api/vehicle-services

Create a new service record.

**Body:**
```json
{
  "vehicle_id": "uuid",
  "service_date": "2025-03-10T00:00:00Z",
  "next_service_date": "2025-06-10T00:00:00Z",
  "odometer_km": 45000,
  "service_type": "general",
  "labour_cost": 500,
  "notes": "Regular maintenance",
  "status": "completed",
  "items": [
    {
      "item_name": "Engine Oil",
      "status": "Changed",
      "cost": 800,
      "notes": "10W40 Castrol",
      "expiry_date": "2025-09-10T00:00:00Z"
    }
  ]
}
```

**Response:** Created service record (same as GET record/:id)

---

### PUT /api/vehicle-services/record/:id

Update an existing service record. Same body as POST.

---

### DELETE /api/vehicle-services/record/:id

Delete a service record and all its items.

**Response:**
```json
{ "message": "Service record deleted" }
```

---

## Service Status Calculation Logic

The status is computed server-side for each vehicle based on its latest service record:

```
latest_service = most recent vehicle_services record for this vehicle

if (no service records exist)
  → "no_service"

if (latest_service.next_service_date exists AND next_service_date > today)
  → "upcoming"

if (latest_service.next_service_date exists AND next_service_date <= today)
  → "due"

if (next_service_date is NULL AND days_since(latest_service.service_date) > 90)
  → "due"

if (next_service_date is NULL AND days_since(latest_service.service_date) <= 90)
  → "completed"
```

---

## Flutter Screen Flow

```
Bottom Nav "Services" tab
    │
    ▼
ServiceScreen (/services)
    │ Shows all vehicles with service status badges
    │ Search by reg number / name
    │ Filter by status (All / Due / Upcoming / Completed)
    │
    ├── [Service button] → ServiceFormScreen (/service/form/:vehicleId)
    │       │ Create new service record
    │       │ Dynamic items with + Add Item
    │       │ Catalogue suggestions bottom sheet
    │       │ Cost tracking (items + labour = total)
    │       │ Save as Draft / Complete
    │       │
    │       └── [Edit mode] → /service/form/:vehicleId?serviceId=xxx
    │               Pre-fills all fields from existing record
    │
    └── [History button] → ServiceHistoryScreen (/service/history/:vehicleId)
            │ Vehicle header with total services count
            │ Timeline list of all services
            │
            └── [Tap card] → ServiceDetailScreen (/service/detail/:serviceId)
                    │ Full record view
                    │ All items with status badges
                    │ Cost breakdown
                    │ Mechanic notes
                    │
                    ├── [Edit] → ServiceFormScreen (edit mode)
                    └── [Delete] → Confirmation → API delete → pop
```

---

## Catalogue Categories (39 items)

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

## Item Status Options

- Good
- Changed
- Repaired
- Replaced
- Needs Attention
- Checked
- Topped Up
- Cleaned

---

## File Structure

```
apps/flutter-app/lib/
├── core/
│   ├── models/
│   │   ├── service_item_model.dart      # ServiceItemModel, ServiceItemInput, CatalogueItem
│   │   └── vehicle_service_model.dart   # VehicleServiceModel, VehicleWithServiceStatus
│   ├── providers/
│   │   └── vehicle_service_provider.dart # All API calls + state
│   └── utils/
│       └── router.dart                  # Routes for /services, /service/form, /history, /detail
├── features/
│   └── service/
│       └── screens/
│           ├── service_screen.dart       # Main search/list screen
│           ├── service_form_screen.dart   # Create/edit service record
│           ├── service_history_screen.dart # Vehicle service timeline
│           └── service_detail_screen.dart  # Full record view
└── shared/
    └── widgets/
        └── bottom_nav_bar.dart          # Services tab (index 3)

apps/backend/
├── src/
│   ├── controllers/
│   │   └── vehicleServiceController.ts  # All CRUD logic
│   ├── routes/
│   │   └── vehicleService.routes.ts     # Route definitions
│   └── index.ts                         # Route registration
└── prisma/
    └── schema.prisma                    # vehicle_services, service_items, service_item_catalogue
```

---

## Notes

- Old `bike_services` and `car_services` tables remain untouched
- Backend runs on port 3002
- Catalogue is loaded once per session and cached in provider memory
- `total_cost` is calculated client-side as `sum(item costs) + labour_cost` before sending to API
- Edit mode passes `serviceId` as a query parameter to the form route
- Delete cascades to remove all associated service_items
