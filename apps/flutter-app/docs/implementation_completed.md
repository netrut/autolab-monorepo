Phase 0 is complete. Here's a summary of every file changed:

Phase 0 — Done ✅
DB (0.1–0.4)
prisma/migrations/20260430000000_phase0_foundation/migration.sql — new migration with:

ALTER TABLE vehicles ADD COLUMN chassis_number

CREATE TABLE service_center_user_map (with FK + unique constraint)

CREATE TABLE vehicle_user_map (with FK + unique constraint)

CREATE TABLE options + 7 seeded rows (helpline_number, helpline_whatsapp, booking_advance_days, service_due_alert_days, invoice_footer_text, service_centre_name, app_version)

prisma/schema.prisma — added chassis_number to Vehicle, ServiceCenterUserMap, VehicleUserMap, Option models + back-relations on User/Vehicle/ServiceCenter

Backend (supporting 0.5 + 0.6)
src/routes/options.routes.ts — GET /api/options (public, returns key→value map), PUT /api/options/:key (authenticated)

src/routes/users.routes.ts — added GET /api/users/service-center

src/controllers/userController.ts — added getServiceCenter method

src/index.ts — registered /api/options route

Flutter (0.5)
lib/core/providers/auth_provider.dart — \_saveSession() called after loginWithEmail, verifyOtp, and init; saves user_id + fetches/saves service_center_id; logout() clears both; static helpers getSavedUserId() / getSavedServiceCenterId() for other screens to read

Flutter (0.6)
lib/core/providers/options*provider.dart — new provider, fetches /api/options on init, caches in shared_preferences with opt* prefix, falls back to defaults if offline

lib/main.dart — OptionsProvider()..init() added to MultiProvider

lib/features/home/screens/home_screen.dart — contact button uses options.helplineWhatsapp instead of hardcoded URL

lib/features/bookings/screens/create_booking_screen.dart — date picker uses options.bookingAdvanceDays instead of hardcoded 90

Test checklist
Run the migration SQL against your DB (or prisma migrate deploy)

Login → check SharedPreferences has keys user_id and service_center_id

HomeScreen "Call Now" button → opens WhatsApp number from options table

Create Booking date picker → advance limit comes from booking_advance_days option (change it in DB to verify)

---

All clean. Phase 1 is complete. Here's the full summary:

Phase 1 — Done ✅
1.1 — Shared AppDrawer (shared/widgets/app_drawer.dart)
Created AppDrawer widget with all 6 nav items: Home, My Vehicles, Bookings, Services, Service Centers, Profile + Logout

Replaced \_buildDrawer + \_drawerItem in HomeScreen — zero duplicate code

Replaced \_buildDrawer + \_drawerItem in VehiclesScreen — zero duplicate code

Removed unused AuthProvider import from VehiclesScreen

1.2 — Router fixes (core/utils/router.dart)
Added /service-centers → ServiceCentersScreen (was referenced in drawer but had no route)

Added /vehicles/edit/:vehicleId → AddVehicleScreen(vehicleId: ...) (nested under /vehicles)

Added vehicleId optional param to AddVehicleScreen (edit mode scaffold — full logic in Phase 2)

1.3 — Bottom nav audit
Confirmed correct mapping: 0=Home, 1=Vehicles, 2=Bookings, 3=Services

Fixed ProfileScreen which incorrectly had currentIndex: 3 — removed bottom nav entirely (profile is not a nav tab)

1.4 — Shared VehicleCard (shared/widgets/vehicle_card.dart)
Single widget handles both modes: with serviceStatus (badge shown) and without (no badge)

Asset image (four-wheeler/two-wheeler) consistent across both screens

3-dot options menu: New Service Record, Service History, Book Service, Edit Vehicle, Remove Vehicle

Replaced inline \_VehicleCard in VehiclesScreen

Replaced \_buildVehicleCard + \_actionBtn in ServiceScreen (features/service/)

Replaced \_buildVehicleCard + \_actionButton + \_statusStyle in ServicesScreen (features/services/)

---

## Phase 2 — Done ✅

### 2.1 — Registration number lookup on blur

**Backend**
- `src/controllers/vehicleController.ts` — added `lookupByReg` method: `GET /api/vehicles/lookup?reg=` returns `{ exists: bool, vehicle?: {...} }`
- `src/routes/vehicles.routes.ts` — registered `/lookup` route **before** `/:id` to avoid param collision

**Flutter**
- `lib/core/providers/vehicle_provider.dart` — added `lookupByReg(reg)` → calls API, returns `{exists, vehicle?}`; added `fetchById(id)` → checks local cache first, falls back to API
- `lib/features/vehicles/screens/add_vehicle_screen.dart` — reg field wrapped in `Focus` widget; on blur triggers `_onRegBlur()`:
  - If reg exists → shows amber warning banner "Vehicle Already Registered" + "Send Request to Owner" button (wired to Phase 6 placeholder)
  - If reg is free → `_showFields = true` reveals the rest of the form
  - While checking → spinner shown in reg field suffix

### 2.2 — Chassis number optional field

- `lib/core/models/vehicle_model.dart` — added `chassisNumber` field, `fromJson` reads `chassis_number`, `toJson` writes it
- `lib/features/vehicles/screens/add_vehicle_screen.dart` — `_chassisCtrl` added; "Chassis Number (optional)" field shown in the form with `TextCapitalization.characters`
- `lib/shared/widgets/app_text_field.dart` — added `textCapitalization` param (defaults to `TextCapitalization.none`)

### 2.3 — Vehicle type pre-selection via query param

- `lib/core/utils/router.dart` — `/vehicles/add` route now reads `?type=` query param and passes it as `initialType` to `AddVehicleScreen`
- `lib/features/vehicles/screens/add_vehicle_screen.dart` — `initialType` param sets `_vehicleType` in `initState`
- `lib/features/home/screens/home_screen.dart` — "Add Four-Wheeler" button pushes `/vehicles/add?type=car`; "Add Two-Wheeler" pushes `/vehicles/add?type=bike`

### 2.4 — Edit vehicle — pre-filled form

- `lib/features/vehicles/screens/add_vehicle_screen.dart` — `vehicleId` param triggers edit mode:
  - `_isEditMode` getter drives title ("Edit Vehicle" vs "Add Vehicle") and submit label ("Save Changes" vs "Add Vehicle")
  - `_loadExistingVehicle()` called in `initState` — fetches vehicle via `VehicleProvider.fetchById()` and pre-fills all controllers + dropdowns
  - On submit calls `provider.updateVehicle()` instead of `addVehicle()`
  - Reg lookup is skipped in edit mode (`_showFields` starts `true`)
- `lib/shared/widgets/vehicle_card.dart` — "Edit Vehicle" option already added in Phase 1; routes to `/vehicles/edit/$vehicleId`

### 2.5 — Book Service passes vehicleId

- `lib/shared/widgets/vehicle_card.dart` — "Book Service" option already pushes `/bookings/create?vehicleId=$vehicleId` (Phase 1)
- `lib/features/bookings/screens/create_booking_screen.dart` — added `initialVehicleId` param; `initState` post-frame callback finds matching vehicle in provider list and pre-selects it in the dropdown
- `lib/core/utils/router.dart` — `/bookings/create` route reads `?vehicleId=` and passes as `initialVehicleId`

### Test checklist
1. Home → "Add Four-Wheeler" → form opens with Car pre-selected
2. Home → "Add Two-Wheeler" → form opens with Bike pre-selected
3. Add vehicle → enter new reg number → blur → form fields appear → fill + submit → vehicle saved
4. Add vehicle → enter existing reg number → blur → warning banner shown, form fields hidden, "Send Request" button visible
5. My Vehicles → 3-dot → Edit Vehicle → form opens pre-filled with all existing data → save → updated
6. My Vehicles → 3-dot → Book Service → booking form opens with vehicle pre-selected in dropdown

---

## Phase 3 — Done ✅

### 3.1 — CreateBookingScreen: vehicleId pre-select
Already implemented in Phase 2. `CreateBookingScreen` accepts `initialVehicleId` param; post-frame callback finds matching vehicle in provider list and pre-selects the dropdown. Router passes `?vehicleId=` query param.

### 3.2 — CreateBookingScreen: auto-fill service centre
- `lib/features/bookings/screens/create_booking_screen.dart` — `_loadServiceCenter()` called in `initState`: reads `service_center_id` from `SharedPreferences`, fetches `GET /api/service-centers/:id`, stores as `_autoCenter`
- If centre found → shows a read-only info tile (name + city + check icon); `_autoCenter.id` used in submit payload
- If not found → shows amber warning banner "No service centre assigned"
- Manual dropdown removed entirely — centre is always auto-filled from session

### 3.3 — Unified service types
- `lib/features/bookings/screens/create_booking_screen.dart` — replaced old `_serviceTypes` list with `VehicleServiceModel.serviceTypes` (`['general', 'major', 'emergency']`) + `_serviceTypeLabels` map for display (`General Service`, `Major Service`, `Emergency Repair`)
- Same labels used in `_UpdateBookingSheet` in `BookingsScreen`

### 3.4 — BookingsScreen: scoped fetch by service_center_id
- `lib/core/providers/booking_provider.dart` — `fetchBookings()` reads `service_center_id` from `SharedPreferences`; if present, passes it as `?service_center_id=` query param to `GET /api/bookings`
- `apps/backend/src/controllers/bookingController.ts` — `list()` now accepts `service_center_id` query param and adds it to the Prisma `where` clause

### 3.5 — BookingsScreen: update booking option
- `lib/core/providers/booking_provider.dart` — added `updateBooking(id, data)` → `PUT /api/bookings/:id`
- `lib/features/bookings/screens/bookings_screen.dart` — each card has an "Update" button that opens `_UpdateBookingSheet` bottom sheet with:
  - Status chips: Pending → Confirmed → In Progress → Completed → Cancelled
  - Service type dropdown (unified with `VehicleServiceModel.serviceTypes`)
  - Date & time picker (respects `bookingAdvanceDays` from OptionsProvider)
  - Notes text field
  - "Save Changes" button calls `provider.updateBooking()`

### 3.6 — BookingsScreen: Go to Service Form button
- Each booking card has a "Service Form" outlined button → `context.push('/service/form/${booking.vehicleId}')`

### 3.7 — BookingCard: show vehicle name
- `lib/core/models/booking_model.dart` — added `vehicleBrand`, `vehicleModel`, `vehicleRegNumber`, `vehicleType` fields parsed from the `vehicles` join already included in the backend response
- Added `vehicleDisplayName` getter: returns reg number if available, else `brand model`
- `BookingsScreen` card header shows `vehicleDisplayName` as primary title with service type as subtitle

### Test checklist
1. Book Service from vehicle card → booking form opens with vehicle pre-selected
2. Booking form → service centre auto-filled from session (no manual dropdown)
3. Service type dropdown shows General / Major / Emergency (not old Oil Change list)
4. Submit booking → appears in bookings list scoped to your service centre
5. Booking card shows vehicle reg number / name
6. Tap "Update" on a booking → sheet opens → change status to Confirmed → Save → card updates
7. Tap "Service Form" on a booking → navigates to service form for that vehicle

---

## Phase 4 — Done ✅

### 4.1 — ServiceFormScreen: service centre name + submitted-by user in header

- `lib/features/service/screens/service_form_screen.dart` — added imports for `AuthProvider`, `OptionsProvider`, `ApiClient`, `ServiceCenterModel`, `SharedPreferences`
- Added `_centreName` and `_submittedBy` state fields
- `_loadData()` now: reads `service_center_id` from SharedPreferences → fetches `GET /api/service-centers/:id` → sets `_centreName`; falls back to `OptionsProvider.serviceCentreName` if no centre assigned
- `_submittedBy` set from `auth.user?.displayName ?? auth.user?.email`
- `_buildVehicleHeader()` updated: shows store icon + centre name + person icon + user name below the vehicle row, separated by a divider

### 4.2 — ServiceFormScreen: service types already unified

Confirmed — `_buildServiceTypeDropdown()` already uses `VehicleServiceModel.serviceTypes` (done in Phase 3.3). No changes needed.

### 4.3 — ServiceFormScreen: Generate Invoice button

- Added `OutlinedButton.icon` with `Icons.receipt_long_outlined` after the cost summary section
- Shows a SnackBar placeholder "Invoice feature coming in Phase 5" until Phase 5 wires the real invoice route

### 4.4 — HomeScreen: Due Services count from real data

- `lib/features/home/screens/home_screen.dart` — "Due Services" card subtitle now shows `svc.dueCount` from `VehicleServiceProvider` (e.g. "2 Services Pending" or "All up to date")
- Card taps to `/services` (service screen) instead of `/bookings`

### 4.5 — HomeScreen: Next Service date from real data

- "Next Service" card subtitle shows `svc.nextServiceDate` formatted as `dd MMM yyyy` via `_formatDate()` helper, or "Not scheduled" if none

### 4.6 — HomeScreen: Service Update section shows latest service summary

- Service Update card title shows `svc.latestService.vehicleDisplayName` (reg number or brand+model)
- Bullet list shows up to 4 actual service items from `svc.latestService.items`; falls back to static text if no service records exist yet

### 4.7 — HomeScreen: "Update Service" button routes to most recent vehicle

- "Update Service" button now pushes `/service/form/$vehicleId` using `svc.latestServiceVehicleId`; falls back to `/services` if no service records exist

### Backend (supporting 4.4–4.7)

- `apps/backend/src/controllers/vehicleServiceController.ts` — added `getLatest` method: `GET /api/vehicle-services/latest` returns the most recent completed service record for the authenticated user, including up to 4 items and vehicle join
- `apps/backend/src/routes/vehicleService.routes.ts` — registered `/latest` route before `/:vehicleId` to avoid param collision

### Provider changes

- `lib/core/providers/vehicle_service_provider.dart` — added `_dueCount`, `_nextServiceDate`, `_latestService`, `_latestServiceVehicleId`, `_summaryLoading` state + getters
- Added `fetchHomeSummary()`: reuses `fetchVehiclesWithStatus()` for due count + next date, then calls `/api/vehicle-services/latest` for the latest record

### Test checklist
1. Open HomeScreen → "Due Services" shows real count from DB
2. "Next Service" shows actual next service date (or "Not scheduled")
3. Service Update section shows vehicle name + actual service items from latest record
4. "Update Service" button → navigates to service form for the most recently serviced vehicle
5. Open Service Form → header shows service centre name + mechanic name below vehicle info
6. Service type dropdown shows General / Major / Emergency (unified)
7. After filling cost summary → "Generate Invoice" button visible → taps shows placeholder snackbar

---

## Phase 5 — Done ✅

### 5.1 — DB: Invoice table

- `apps/backend/prisma/migrations/20260501000000_phase5_invoices/migration.sql` — creates `invoices` table with: `id`, `service_id` (unique FK → vehicle_services), `vehicle_id`, `user_id`, `service_center_id`, `invoice_number`, `service_date`, `total_cost`, `labour_cost`, `items_cost`, `footer_text`, `notes`, `created_at`; also creates `invoice_number_seq` sequence
- `apps/backend/prisma/schema.prisma` — added `Invoice` model with all fields + back-relations on `VehicleService` (`invoice Invoice?`), `Vehicle` (`invoices Invoice[]`), `User` (`invoices Invoice[]`)
- Ran `npx prisma generate` — Prisma client regenerated with Invoice model

### 5.2 — Flutter: InvoiceModel

- `lib/core/models/invoice_model.dart` — `InvoiceModel` with all fields; `fromJson` parses nested `service` object as `VehicleServiceModel` (includes items + vehicle join from backend)

### 5.3 — Route: /invoice/:serviceId

- `lib/core/utils/router.dart` — added `GoRoute(path: '/invoice/:serviceId', builder: InvoiceScreen(serviceId: ...))`

### 5.4 — InvoiceScreen

- `lib/features/invoice/screens/invoice_screen.dart` — full invoice UI:
  - Loads invoice via `GET /api/invoices/service/:serviceId`
  - Header card: AUTOLAB name, service centre name (from OptionsProvider), invoice number, date, INVOICE badge
  - Vehicle details section: brand/model, reg number, service type, date, odometer
  - Service items table: item name, status badge (colour-coded), cost per item
  - Cost summary: items subtotal, labour, total
  - Footer: `invoice_footer_text` from OptionsProvider (or invoice record)
  - AppBar actions: Download PDF icon + Share icon
  - Bottom action buttons: "Download PDF" + "Share WhatsApp" (green)

### 5.5 — Download PDF

- Added `pdf: ^3.11.1` and `printing: ^5.13.1` to `pubspec.yaml`; ran `flutter pub get`
- `_downloadPdf()` in InvoiceScreen: builds a full A4 PDF document using `pw.Document` with header, vehicle details, items table, cost summary, footer; opens system print/save dialog via `Printing.layoutPdf()`

### 5.6 — Share via WhatsApp

- `_shareWhatsApp()` in InvoiceScreen: builds a formatted WhatsApp message with invoice number, vehicle, date, total, footer text; opens `https://wa.me/<helpline_number>?text=<encoded_msg>` via `url_launcher`; helpline number comes from `OptionsProvider.helplineNumber`

### 5.7 — Wire Generate Invoice button in ServiceFormScreen

- `lib/features/service/screens/service_form_screen.dart` — added `_generateInvoice()` method:
  - Uses `_existingRecord?.id ?? widget.serviceId` to get the service record ID
  - If no saved record → shows SnackBar "Save the service record first"
  - Calls `POST /api/invoices` with `service_id` + `footer_text` from OptionsProvider
  - On success → navigates to `/invoice/$serviceId`
- Replaced Phase 4 placeholder `onPressed` with `onPressed: _generateInvoice`

### Backend

- `apps/backend/src/controllers/invoiceController.ts` — three endpoints:
  - `POST /api/invoices` — creates invoice (idempotent: returns existing if already created for that service); auto-generates `INV-<year>-<seq>` invoice number
  - `GET /api/invoices/service/:serviceId` — fetch by service ID (used by InvoiceScreen on load)
  - `GET /api/invoices/:id` — fetch by invoice ID
  - All responses include nested `service` with `items` + `vehicle` join
- `apps/backend/src/routes/invoices.routes.ts` — registered all 3 routes under `authMiddleware`
- `apps/backend/src/index.ts` — registered `/api/invoices` route

### Test checklist
1. Complete a service record → tap "Generate Invoice" → invoice created in DB → navigates to InvoiceScreen
2. InvoiceScreen shows: vehicle name/reg, service date, all service items with status badges, cost breakdown, footer text
3. Tap "Download PDF" → system print dialog opens with formatted A4 invoice
4. Tap "Share WhatsApp" → WhatsApp opens with pre-filled message containing invoice details
5. Navigate back to service form → tap "Generate Invoice" again → same invoice returned (idempotent), navigates to InvoiceScreen

---

## Phase 6 — Done ✅

### 6.1 — DB: Requests table

- `apps/backend/prisma/migrations/20260502000000_phase6_requests/migration.sql` — creates `requests` table: `id`, `type` (vehicle_access | service_center_join | customer_invite | partner_invite), `from_user_id`, `to_user_id` (nullable), `entity_type`, `entity_id`, `role`, `status` (pending | accepted | rejected | cancelled), `message`, timestamps; indexes on from_user, to_user, status, entity
- `apps/backend/prisma/schema.prisma` — added `Request` model with named relations `RequestsFrom` / `RequestsTo` on User; back-relations `requests_sent` + `requests_received` added to User model
- `npx prisma generate` run — client updated

### 6.2 — Flutter: RequestModel + enums

- `lib/core/models/request_model.dart` — `RequestType` enum (vehicleAccess, serviceCenterJoin, customerInvite, partnerInvite) with `value` + `label`; `RequestStatus` enum (pending, accepted, rejected, cancelled); `RequestUserInfo` helper; `RequestModel` with full `fromJson`

### 6.3 — Flutter: RequestProvider

- `lib/core/providers/request_provider.dart` — `fetchReceived()`, `fetchSent()`, `fetchPendingCount()`, `sendVehicleAccessRequest()`, `sendServiceCenterJoinRequest()`, `accept()`, `reject()`, `cancel()`; idempotent send (backend deduplicates pending requests)
- Registered in `lib/main.dart` MultiProvider

### 6.4 — Route: /requests

- `lib/core/utils/router.dart` — added `GoRoute(path: '/requests', builder: RequestsScreen())`

### 6.5 — RequestsScreen

- `lib/features/requests/screens/requests_screen.dart` — `TabController` with Received | Sent tabs; each tab is a `_RequestList` that watches `RequestProvider`; pull-to-refresh; empty state with inbox icon

### 6.6 — RequestCard widget

- `RequestCard` in same file — shows: entity icon (car/store), request type label, who sent/to, status badge (colour-coded), entity label + role, optional message, timestamp
- Received + pending → Accept (green) + Reject (red) buttons
- Sent + pending → Cancel Request button
- Accepted/Rejected/Cancelled → status badge only

### 6.7 — Wire "Send Request to Owner" in AddVehicleScreen

- `apps/backend/src/controllers/vehicleController.ts` — `lookupByReg` now includes `user_id` in select
- `lib/core/providers/vehicle_provider.dart` — `lookupByReg` now returns `ownerId` from response
- `lib/features/vehicles/screens/add_vehicle_screen.dart` — added `_existingVehicleId` + `_ownerId` state; `_onRegBlur` captures them; "Send Request to Owner" button calls `RequestProvider.sendVehicleAccessRequest(vehicleId, toUserId: ownerId)` and shows success/failure SnackBar

### 6.8 — Wire "Request to join service centre"

- `lib/shared/widgets/app_drawer.dart` — "Join Service Centre" drawer item opens `_JoinServiceCentreSheet` bottom sheet: fetches all service centres, shows dropdown + optional message field, sends `RequestProvider.sendServiceCenterJoinRequest()` on submit

### 6.9 — On accept → update VehicleUserMap / ServiceCenterUserMap

- `apps/backend/src/controllers/requestController.ts` — `accept()` handler: after updating request status to `accepted`, checks `entity_type`:
  - `vehicle` → `prisma.vehicleUserMap.upsert()` with `vehicle_id + from_user_id + role`
  - `service_center` → `prisma.serviceCenterUserMap.upsert()` with `service_center_id + from_user_id + role`

### 6.10 — Requests link in AppDrawer with pending badge

- `lib/shared/widgets/app_drawer.dart` — converted to `StatefulWidget`; `initState` calls `RequestProvider.fetchPendingCount()`; "Requests" item uses `_itemWithBadge()` which shows a red circle badge with count when `pendingCount > 0`; "Join Service Centre" item added below

### Backend

- `apps/backend/src/controllers/requestController.ts` — 6 endpoints: send (idempotent), listReceived, listSent, pendingCount, accept (+ map upsert), reject, cancel
- `apps/backend/src/routes/requests.routes.ts` — all routes under `authMiddleware`
- `apps/backend/src/index.ts` — registered `/api/requests`

### Test checklist
1. Add vehicle with existing reg number → "Send Request to Owner" button appears → tap → request sent → appears in owner's Received tab
2. Owner opens Requests → Received tab → sees pending request → tap Accept → VehicleUserMap updated → requester's vehicle list now includes the vehicle
3. Owner taps Reject → request status changes to Rejected
4. Requester opens Sent tab → sees their request with status badge
5. Requester taps Cancel on a pending sent request → status changes to Cancelled
6. AppDrawer → "Requests" item shows red badge with pending count
7. AppDrawer → "Join Service Centre" → select centre → send → request appears in Received tab of centre owner

---

## Phase 7 — Done ✅

### 7.1 — DB: Notifications table

- `apps/backend/prisma/migrations/20260503000000_phase7_notifications/migration.sql` — creates `notifications` table: `id`, `user_id` (FK → users), `type`, `title`, `body`, `request_id` (nullable FK → requests, SET NULL on delete), `entity_type`, `entity_id`, `is_read` (default false), `channel` (default 'app'), `sent_at`, `read_at`; indexes on user_id, (user_id, is_read), sent_at DESC
- `apps/backend/prisma/schema.prisma` — added `Notification` model; back-relations: `notifications Notification[]` on User, `notifications Notification[]` on Request
- `npx prisma generate` run — client updated

### 7.2 — Flutter: NotificationModel + NotificationType enum

- `lib/core/models/notification_model.dart` — `NotificationType` enum (request, serviceDue, bookingUpdate, serviceComplete, invoice, system) with `fromString`; `NotificationModel` with full `fromJson` + `copyWith`

### 7.3 — Flutter: NotificationProvider

- `lib/core/providers/notification_provider.dart` — `fetchNotifications()` (returns list + unread_count), `fetchUnreadCount()` (lightweight poll), `markRead(id)` (optimistic local update), `markAllRead()` (clears all locally + API call)
- Registered in `lib/main.dart` MultiProvider

### 7.4 — Route: /notifications

- `lib/core/utils/router.dart` — added `GoRoute(path: '/notifications', builder: NotificationsScreen())`

### 7.5 — NotificationsScreen

- `lib/features/notifications/screens/notifications_screen.dart` — full notifications list with:
  - "Mark all read" button in AppBar (only shown when unread > 0)
  - Pull-to-refresh via `RefreshIndicator`
  - Empty state with bell icon
  - `_NotificationTile` widget: icon (type-specific, colour-coded), title (bold if unread), body (2-line ellipsis), time-ago label, blue dot badge for unread, blue background tint for unread items

### 7.6 — Bell icon wired on HomeScreen

- `lib/features/home/screens/home_screen.dart` — added `NotificationProvider` import + watch; `initState` calls `fetchUnreadCount()`; bell icon replaced with `GestureDetector` → `context.push('/notifications')`; red circle badge shows unread count (capped at "9+") using `Stack` + `Positioned`

### 7.7 — Deep-link navigation on notification tap

- `_onTap()` in `NotificationsScreen`: marks notification as read, then navigates based on type:
  - `request` → `/requests`
  - `bookingUpdate` → `/bookings`
  - `serviceDue` / `serviceComplete` → `/service/detail/:entityId` (or `/services` fallback)
  - `invoice` → `/invoice/:entityId`
  - `system` → no navigation

### 7.8 — Backend notification triggers

- `apps/backend/src/services/notificationService.ts` — `createNotification()` helper: inserts a notification row, non-fatal (logs error but doesn't break main flow)
- **requestController**: on `send` → notify recipient ("New Access Request"); on `accept` → notify sender ("Request Accepted"); on `reject` → notify sender ("Request Rejected")
- **bookingController**: on `update` with status change → notify booking owner ("Booking Status Updated")
- **vehicleServiceController**: on `createService` with status=completed → notify mechanic ("Service Record Completed")
- **invoiceController**: on `create` → notify user ("Invoice Ready" with total amount)

### Test checklist
1. Send vehicle access request → recipient's bell badge increments → tap bell → NotificationsScreen shows "New Access Request" notification
2. Tap notification → navigates to RequestsScreen
3. Accept request → sender gets "Request Accepted" notification in bell
4. Update booking status → booking owner gets "Booking Status Updated" notification
5. Complete a service → "Service Record Completed" notification appears
6. Generate invoice → "Invoice Ready" notification appears → tap → navigates to InvoiceScreen
7. "Mark all read" button clears all unread badges
8. Pull-to-refresh reloads notification list

---

## Phase 8 — Done ✅

### 8.1 — Service screen: Amazon-style filter bottom sheet

- `lib/features/service/screens/service_screen.dart` — completely replaced the old date filter dialog + status chips row with a single `_FilterSheet` bottom sheet:
  - **Left sidebar**: vertical list of 4 filter categories (Service Status, Vehicle Type, Date Range, Sort By) — selected category has accent left border + bold text + blue dot if active
  - **Right panel**: scrollable chip-style options for the selected category; selected option shows blue highlight + check icon
  - **Filter categories**: Service Status (All/Due/Upcoming/Completed/No Service Yet), Vehicle Type (All/Car/Bike), Date Range (7 date presets), Sort By (5 sort options)
  - **Sticky bottom bar**: "Clear All" (outlined) + "Apply Filters" (filled) buttons
  - **Filter icon badge**: shows active filter count in blue circle on the tune icon in search bar
  - Sort is applied client-side on the filtered list (last serviced, next service, reg A-Z, total services)
  - Status chips row removed — everything consolidated into the filter sheet

### 8.2 — Brand & Model searchable dropdown in AddVehicleScreen

- `lib/features/vehicles/screens/add_vehicle_screen.dart` — replaced plain `AppTextField` for Brand and Model with `Autocomplete<String>` widgets:
  - Brand suggestions: distinct brands from `provider.vehicles` (existing vehicles in DB), sorted A-Z
  - Model suggestions: filtered by selected brand (if brand is filled), sorted A-Z
  - Free-text entry still allowed — user can type any value not in the list
  - `_autocompleteField()` helper renders a styled `TextFormField` with a dropdown overlay (max 200px height, elevation 4)

### 8.3 — Shared EmptyState widget

- `lib/shared/widgets/empty_state.dart` — `EmptyState` widget with: icon in rounded container, title (bold), optional subtitle, optional primary action button, optional retry button
- Applied to:
  - `VehiclesScreen` — "No vehicles added yet" (with Add Vehicle button) / "No vehicles match your search"
  - `BookingsScreen` — "No bookings yet" (with Book a Service button)

### 8.4 — Pull-to-refresh on VehiclesScreen

- `lib/features/vehicles/screens/vehicles_screen.dart` — wrapped `ListView.separated` in `RefreshIndicator` → calls `provider.fetchVehicles()` on pull
- `BookingsScreen` already had `RefreshIndicator` from Phase 3 — no change needed

### 8.5 — Error handling with retry on VehiclesScreen + BookingsScreen

- `VehiclesScreen` — checks `provider.error != null && provider.vehicles.isEmpty` → shows `EmptyState` with "Failed to load vehicles" + Retry button → calls `provider.fetchVehicles()`
- `BookingsScreen` — same pattern → "Failed to load bookings" + Retry → calls `provider.fetchBookings()`

### 8.6 — Role-based UI

- `lib/core/models/user_model.dart` — added role constants (roleAdmin=1, rolePartner=2, roleCustomer=3, roleMechanic=4, roleDriver=5); role-check getters (`isAdmin`, `isPartner`, `isCustomer`, `isMechanic`, `isDriver`); composite helpers (`canManageService`, `canManageBookings`, `isEndCustomer`)
- `lib/shared/widgets/app_drawer.dart` — "Services" and "Join Service Centre" items only shown when `user == null || user.canManageService` (Admin, Partner, Mechanic); customers and drivers see a simpler drawer

### 8.7 — Profile screen: edit profile

- `lib/features/profile/screens/profile_screen.dart` — converted to `StatefulWidget`; AppBar has edit icon (pencil) → enters edit mode; in edit mode shows editable `_editField` widgets for Display Name and Mobile Number (email is read-only); "Save" button in AppBar calls `PUT /api/users/profile` then refreshes `AuthProvider.init()`; "Cancel" button restores original values; loading spinner shown during save

### 8.8 — Profile screen: correct role label for all 5 roles

- `UserModel.roleLabel` getter returns: Admin / Partner / Customer / Mechanic / Driver (based on roleId 1–5, defaults to "User")
- `UserModel.roleDescription` getter returns human-readable description for each role
- `ProfileScreen` header card shows role label in a white semi-transparent badge below the user name
- Account section "Role" info card shows `roleLabel` as value + `roleDescription` as subtitle

### Test checklist
1. ServiceScreen → tap filter icon → Amazon-style sheet opens → select Service Status "Due" + Sort "Last Serviced (newest)" → Apply → list filtered + badge shows "2" on filter icon
2. ServiceScreen → Clear All → badge disappears, all vehicles shown
3. AddVehicleScreen → Brand field → type "M" → dropdown shows matching brands from existing vehicles
4. VehiclesScreen → pull down → list refreshes
5. VehiclesScreen → simulate API error → "Failed to load vehicles" empty state with Retry button
6. BookingsScreen → same error handling
7. Login as Customer → AppDrawer → "Services" and "Join Service Centre" items hidden
8. Login as Mechanic → both items visible
9. ProfileScreen → tap edit icon → name/phone fields become editable → save → profile updated
10. ProfileScreen → role badge shows correct label (Admin/Partner/Customer/Mechanic/Driver)
