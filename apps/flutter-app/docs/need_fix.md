# AutoLab — Fixes, Improvements & Missing Features

> Status legend: `[ ]` = pending · `[x]` = done · `[~]` = partially done

---

## 1. Database / Backend Schema

- [ ] **User Roles** — Add role system: 1=Admin, 2=Partner, 3=Customer, 4=Mechanic, 5=Driver
  - `UserModel` currently only has `roleId` field but no role-based logic in the app
- [ ] **ServiceCenterUserMap table** — `service_center_id`, `user_id`, `role` (owner/user)
- [ ] **VehicleUserMap table** — `vehicle_id`, `user_id`, `role` (owner/user)
  - Vehicle and ServiceCenter tables should keep the primary `user_id` of who registered them
- [ ] **Request / Invite table** — for access requests between users and vehicles/service centres
- [ ] **Notification table** — `user_id`, `type`, `message`, `status` (sent/received/read), `channel` (app/whatsapp)
- [ ] **Brand & Model table** — separate DB tables for vehicle brands and models and image with admin dashboard to add new entries
- [ ] **Add `chassis_number` column** to Vehicle table
- [ ] **Invoice table** — store generated invoices linked to service records
- [ ] **Options table (DB)** — create a key-value `options` table to store app-wide
      configurable settings that can be managed from the admin dashboard without a code deploy:

  Schema: `key` (varchar, unique), `value` (text), `label` (varchar),
  `group` (varchar), `updated_at` (timestamp)

  Initial entries:
  - `helpline_number` → WhatsApp/call number (currently hardcoded in HomeScreen)
  - `helpline_whatsapp` → WhatsApp link
  - `app_version` → minimum supported app version
  - `booking_advance_days`→ how many days ahead a booking can be made (currently hardcoded as 90)
  - `service_due_alert_days` → how many days before due date to send reminder notification
  - `invoice_footer_text` → custom footer text on invoices
  - `service_centre_name` → fallback display name if not in ServiceCenterUserMap

  Flutter side: fetch once on app start, cache in shared_preferences,
  expose via a simple `OptionsProvider`. Any screen needing a config value
  reads from provider instead of hardcoding.

  Dashboard: simple table UI — list all keys with editable value field + save button.

---

## 2. Auth & User Session

- [ ] **Save `user_id` and `service_center_id` in local storage** (shared_preferences) on login
  - `service_center_id` should be looked up from `ServiceCenterUserMap` after login
  - Currently only auth token is stored; service centre context is missing
- [ ] **Role-based UI** — show/hide features based on user role (e.g. mechanic sees service form, customer sees history/bookings)
- [ ] **Profile screen — edit profile** — currently profile is read-only, no edit option
- [ ] **Profile screen — show role label** — currently shows "Admin" or "Customer" only; should reflect all 5 roles

---

## 3. Add Vehicle Flow

- [~] **Registration number lookup on add** — when user types a registration number:
  - Check if vehicle already exists in DB
  - If yes → show "Vehicle already registered" message + "Send Request to Owner" button
  - After owner accepts → insert into `VehicleUserMap` with `role = user`
  - If no → show remaining fields (brand, model, year, color, fuel type, transmission, chassis number is optional)
- [ ] **Brand & Model searchable dropdown** — auto-populate from Brand/Model DB table
  - If not found in list → allow free-text entry
  - Currently `AddVehicleScreen` uses plain text fields for brand and model
- [ ] **Chassis number field** — add as optional field in `AddVehicleScreen` and `VehicleModel`
- [ ] **Edit vehicle** — `VehiclesScreen` options menu has no Edit option currently
  - Add Edit that opens same form as Add Vehicle pre-filled with existing data
- [ ] **Vehicle type pre-selection** — when navigating from "Add Four-Wheeler" or "Add Two-Wheeler" on home screen, the vehicle type should be pre-selected (currently both buttons go to `/vehicles/add` with no pre-selection)

---

## 4. My Vehicles Screen

- [x] **Service update option** — "New Service Record" in vehicle options menu routes to service form ✓
- [x] **Service history option** — routes to service history screen ✓
- [ ] **Edit vehicle option** — missing from the 3-dot options menu
- [ ] **Book Service from vehicle** — currently "Book Service" in options goes to `/bookings/create` but does NOT pass the selected vehicle — the booking form then asks the user to select a vehicle again
  - Fix: pass `vehicleId` as query param to `/bookings/create?vehicleId=xxx` and pre-select it

---

## 5. Booking Flow

- [ ] **Book Service form — pre-fill vehicle** — when arriving from "Book Service" on a vehicle card, the vehicle dropdown should be pre-selected, not empty
- [ ] **Book Service form — auto-fill service centre** — should auto-populate the logged-in user's service centre name
  - Look up `service_center_id` from local storage → fetch name from `ServiceCenter` table
  - Currently user has to manually select from a dropdown of all centres
- [ ] **Booking date — show time** — `BookingsScreen` card shows date but the `BookingModel` stores full datetime; format should be `dd MMM yyyy, hh:mm a` (already done in card but verify booking form saves time correctly)
<!-- - [ ] **My Bookings — show service centre name** — booking card currently shows service type and date but not which service centre -->
- [ ] **My Bookings — update booking** — add update option on each booking card:
  - Update status: Pending → Confirmed → In Progress → Completed → Cancelled
  - Update service type, date/time, notes
  - Default status on creation should be `pending`
- [ ] **My Bookings — "Go to Service Form" button** — from a booking card, allow mechanic to jump directly to the service form for that vehicle to fill in service details
- [ ] **My Bookings — scope by service centre** — currently fetches all bookings for the user; should fetch all bookings for the user's service centre (via `ServiceCenterUserMap`)

---

## 6. Service Form

- [~] **Service types consistency** — `VehicleServiceModel.serviceTypes` has `['general', 'major', 'emergency']` but `CreateBookingScreen` has a different list (`Oil Change`, `Tire Rotation`, etc.)
  - Unify service type options across booking form and service form
- [ ] **Generate Invoice button** — add at the bottom of the service form after cost summary
  - On tap → generate invoice and navigate to Invoice screen
- [ ] **Service form — show service centre name** — display which service centre this record belongs to
- [ ] **Service form — show user name** — display which user this record fill and submited
- [ ] **Service form — show user name** — display which user this record fill and submited

---

## 7. Invoice Feature (Missing — New)

- [ ] **Invoice screen** — design a printable/shareable invoice page based on a completed service record
  - Show: vehicle details, service date, service centre name, itemised list with costs, labour, total
  - Actions: Download PDF, Share/Send to customer (WhatsApp / email)
- [ ] **Invoice model** — create `InvoiceModel` and link to `VehicleServiceModel`
- [ ] **Invoice route** — add `/invoice/:serviceId` route in router

---

## 8. Request / Invite System (Missing — New)

- [ ] **Send request to vehicle owner** — when a vehicle is already registered, show "Send Request" button
- [ ] **Send request to service centre** — mechanic can request to join a service centre
- [ ] **Partner/Customer invite** — partner can invite customer and vice versa
- [ ] **Accept / Reject flow** — notification + in-app action to accept or reject a request
- [ ] **Requests screen** — a dedicated screen to view pending/accepted/rejected requests
- [ ] **Update `VehicleUserMap` or `ServiceCenterUserMap`** on acceptance

---

## 9. Notifications (Missing — New)

- [ ] **In-app notifications screen** — list of notifications with read/unread status
- [ ] **Notification bell badge** — home screen already has a bell icon but it's not functional; wire it up
- [ ] **Service due reminders** — push notification when a vehicle's next service date is approaching
- [ ] **Booking status change notification** — notify customer when booking status changes
- [ ] **WhatsApp notification** — send service summary / invoice to customer via WhatsApp after service completion
- [ ] **Part expiry alerts** — notify when a part's expiry date is near (tracked in `ServiceItemModel.expiryDate`)

---

## 10. Home Screen

- [ ] **Due Services count** — "3 Services Pending" is hardcoded; wire it to real data from `VehicleServiceProvider`
- [ ] **Next Service date** — "14 Mar 2026" is hardcoded; show actual next service date from the user's vehicles
- [ ] **Service Update section** — bullet points are static; should show latest service record summary for the most recently serviced vehicle
- [ ] **"Update Service" button** — currently routes to `/bookings`; should route to the service form for the vehicle with the most recent booking

---

## 11. Navigation & Routing

- [ ] **Service screen route mismatch** — bottom nav bar item 3 routes to `/services` but the service screen is registered at `/services` in router; verify `AppBottomNavBar` index 3 maps correctly
- [ ] **Missing routes** — no routes for:
  - `/service-centers` (referenced in drawer and home but not in router)
  - `/services` (services_screen.dart exists but not in router)
  - `/invoice/:serviceId`
  - `/requests`
  - `/notifications`
- [ ] **Edit vehicle route** — add `/vehicles/edit/:vehicleId`

---

## 12. UI / UX Improvements

- [ ] **Vehicle card image** — `VehiclesScreen` uses an icon; `ServiceScreen` uses asset images — make consistent across both screens
- [ ] **Empty state illustrations** — replace generic icons with proper illustrations for empty states (no vehicles, no bookings, no history)
- [ ] **Pull-to-refresh** — add `RefreshIndicator` to `VehiclesScreen` and `BookingsScreen` (already done on service screens)
- [ ] **Error handling UI** — show retry button on API errors in `VehiclesScreen` and `BookingsScreen` (already done in `ServiceScreen`)
- [ ] **Loading skeletons** — replace `CircularProgressIndicator` with shimmer/skeleton loaders for a better perceived performance
- [ ] **Booking card — missing vehicle name** — `BookingCard` shows service type but not which vehicle the booking is for
- [ ] **Profile — edit button** — add edit icon/button to profile screen to update name, phone, avatar
- [ ] **Drawer consistency** — both `HomeScreen` and `VehiclesScreen` have identical drawers; extract to a shared `AppDrawer` widget to avoid duplication
- [ ] **Bottom nav — Service tab** — currently index 3 is mapped to profile in some places and service in others; audit and fix `AppBottomNavBar` index mapping across all screens

---

## 13. Testing Checklist (End-to-End Flow)

### Partner / Mechanic Flow

- [ ] Register → Login → OTP → Home
- [ ] Add new vehicle (fresh) → fill all details → saved
- [ ] Add vehicle (already registered) → send request → owner accepts → vehicle appears in list
- [ ] My Vehicles → 3-dot menu → Book Service → booking form pre-fills vehicle + service centre → submit → redirects to My Bookings
- [ ] My Bookings → update status (Pending → Confirmed → In Progress → Completed)
- [ ] My Bookings → "Go to Service Form" → fill service items → add costs → save draft → complete → generate invoice
- [ ] Invoice → download / send to customer via WhatsApp

### Customer Flow

- [ ] Register → Login → view My Vehicles
- [ ] View service history for a vehicle
- [ ] Receive notification for upcoming service
- [ ] View and download invoice

---

## 14. Code Quality / Technical Debt

- [ ] **Duplicate drawer widget** — `HomeScreen` and `VehiclesScreen` both define `_buildDrawer` identically; move to `shared/widgets/app_drawer.dart`
- [ ] **`service_centers_screen.dart` and `services_screen.dart`** — these files exist but have no routes registered in `router.dart`; so add routes
- [ ] **`ApiClient` instantiated inside widget** — `CreateBookingScreen` creates `ApiClient()` directly inside state; should use a provider or repository pattern
- [ ] **Hardcoded WhatsApp number** — `HomeScreen` contact button has a hardcoded number; move to config/env
- [ ] **`BookingModel` missing vehicle name** — model only stores `vehicleId`; join vehicle data on fetch or add `vehicleDisplayName` field for display

- [ ] **Unify vehicle card** — replace the two separate card implementations with one
      shared `VehicleCard` widget in `shared/widgets/`:
  - Base layout: vehicle asset image (car/bike) + registration number + brand/model + fuel type
  - Add **service status badge** (Due / Upcoming / Completed / No Service) — currently missing on `VehiclesScreen` card
  - Replace `VehiclesScreen` card icon with the same asset image already used in `ServiceScreen` card
  - Replace `ServiceScreen` inline "Service" + "History" buttons with a **3-dot options menu** (same as `VehiclesScreen`): New Service Record, Service History, Book Service, Edit Vehicle, Delete Vehicle
  - The shared widget needs both `VehicleModel` and `VehicleWithServiceStatus` — either merge the two models or pass service status as an optional param

- [ ] **Service screen — Amazon-style filter panel** — replace the current date filter
      dialog (opened via tune icon) with a full bottom sheet filter screen using a
      two-column layout: left sidebar for filter categories, right panel for options.

  Layout:
  - Left sidebar: vertical list of category labels (highlighted when selected)
    e.g. Service Status, Vehicle Type, Brand, Fuel Type, Date Range, Sort By
  - Right panel: scrollable chips/options for the selected category
  - Sticky bottom bar: "Clear All" (outlined) + "Apply Filters" (filled) buttons
  - Show active filter count badge on the filter icon in search bar

  Filter categories & options:
  - **Service Status** → All, Due, Upcoming, Completed, No Service Yet
  - **Vehicle Type** → All, Car / SUV, Bike / Scooter
  - **Brand** → dynamic list from vehicles in DB (Maruti, Honda, etc.)
  - **Fuel Type** → Petrol, Diesel, CNG, Electric, Hybrid
  - **Date Range** → Due Today, Due Last 7 Days, Due Last 30 Days,
    Upcoming Next 7 Days, Upcoming Next 30 Days,
    Completed Yesterday, Completed Last 7 Days,
    Completed Last 30 Days
  - **Sort By** → Last Serviced (newest), Last Serviced (oldest),
    Next Service (soonest), Registration Number (A-Z),
    Total Services (most)

  UI details:
  - Selected chips use filled/highlighted pill style (like Amazon)
  - Selected category in left sidebar has accent left border + bold text
  - Active filter count badge on tune icon (e.g. shows "3" if 3 filters active)
  - "Clear All" resets all selections, "Apply" closes sheet and applies filters
  - Smooth slide-up animation on open
    Key difference from current setup: Current setup has two separate filter mechanisms — status chips (always visible) + a date dialog (tune icon). The new approach consolidates everything into one filter panel so the search bar stays clean and the filter icon badge tells the user at a glance how many filters are active. The status chips row above the list can be removed since status is now inside the filter panel.

---

- [ ] **Request / Invite & Notification system** — 2 separate DB tables (`requests` +
      `notifications`), 2 separate Flutter screens (bell inbox + requests manager).

  ── DB Schema ──────────────────────────────────────────────────────────────────

  requests
  ┌─────────────────┬──────────┬────────────────────────────────────────────────┐
  │ column │ type │ notes │
  ├─────────────────┼──────────┼────────────────────────────────────────────────┤
  │ id │ uuid PK │ │
  │ type │ varchar │ vehicle_access | service_center_join | │
  │ │ │ customer_invite | partner_invite │
  │ from_user_id │ uuid FK │ → users │
  │ to_user_id │ uuid FK │ → users │
  │ entity_type │ varchar │ vehicle | service_center │
  │ entity_id │ uuid │ vehicle_id or service_center_id │
  │ role │ varchar │ owner | user | mechanic | driver │
  │ status │ varchar │ pending | accepted | rejected | cancelled │
  │ message │ text │ optional note from sender │
  │ created_at │ timestamp│ │
  │ updated_at │ timestamp│ │
  └─────────────────┴──────────┴────────────────────────────────────────────────┘

  notifications
  ┌─────────────────┬──────────┬────────────────────────────────────────────────┐
  │ column │ type │ notes │
  ├─────────────────┼──────────┼────────────────────────────────────────────────┤
  │ id │ uuid PK │ │
  │ user_id │ uuid FK │ → users (recipient) │
  │ type │ varchar │ request | service_due | booking_update | │
  │ │ │ service_complete | invoice | system │
  │ title │ varchar │ │
  │ body │ text │ │
  │ request_id │ uuid FK │ → requests (nullable, request-type only) │
  │ entity_type │ varchar │ vehicle | booking | service_record | invoice │
  │ entity_id │ uuid │ for deep-link navigation on tap │
  │ is_read │ boolean │ default false │
  │ channel │ varchar │ app | whatsapp | both │
  │ sent_at │ timestamp│ │
  │ read_at │ timestamp│ │
  └─────────────────┴──────────┴────────────────────────────────────────────────┘

  ── Flow ───────────────────────────────────────────────────────────────────────

  User sends request
  → INSERT requests row (status=pending)
  → INSERT notification for recipient (type=request, request_id=FK)
  → Recipient sees bell badge → taps notification → deep-links to Requests screen
  → Recipient accepts/rejects on Requests screen
  → UPDATE requests.status + UPDATE VehicleUserMap or ServiceCenterUserMap
  → INSERT follow-up notification to sender (accepted/rejected)

  ── Flutter — Models ───────────────────────────────────────────────────────────

  core/models/
  request_model.dart ← RequestModel + RequestType + RequestStatus enums
  notification_model.dart ← NotificationModel + NotificationType enum

  ── Flutter — Providers ────────────────────────────────────────────────────────

  core/providers/
  notification_provider.dart ← fetch notifications, mark read, mark all read,
  unread count (for bell badge)
  request_provider.dart ← fetch received/sent requests, send request,
  accept/reject/cancel, pending count (for drawer badge)

  ── Flutter — Screens ──────────────────────────────────────────────────────────

  features/notifications/
  screens/
  notifications_screen.dart ← bell inbox, all notification types listed,
  tap → deep-link to relevant screen,
  request-type notification taps through to
  Requests screen (NOT inline accept/reject),
  mark all read button, pull-to-refresh

  features/requests/
  screens/
  requests_screen.dart ← two tabs: Received | Sent
  widgets/
  request_card.dart ← shows: who sent it, entity name, role requested,
  when sent, status badge
  Received pending → Accept / Reject buttons
  Sent pending → Cancel button
  Accepted/Rejected → status badge only

  ── Navigation ─────────────────────────────────────────────────────────────────

  HomeScreen AppBar bell icon (unread count badge)
  → NotificationsScreen
  → request notification tapped → RequestsScreen
  → booking notification tapped → BookingsScreen
  → service due tapped → ServiceScreen
  → invoice notification tapped → InvoiceScreen

  Drawer / Profile
  → "Requests" menu item (pending count badge on drawer item)
  → RequestsScreen (Received | Sent tabs)

  ── Routes to add in router.dart ───────────────────────────────────────────────

  /notifications
  /requests

  ── Why 2 screens, not 1 ───────────────────────────────────────────────────────

  Notifications → ephemeral alerts, read/unread, no persistent state needed
  Requests → stateful lifecycle (pending→accepted/rejected), need context
  (who, what role, which entity, history), filterable by type/status,
  must persist until actioned — wrong fit for a notification list
