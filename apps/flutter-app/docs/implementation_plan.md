Before starting any task tell the agent:

"Read the current state of [file], then implement only [specific task]. Do not modify anything else."

Phase 0 — Foundation

0.1 DB: Add chassis_number column to vehicles table
0.2 DB: Create ServiceCenterUserMap table
0.3 DB: Create VehicleUserMap table
0.4 DB: Create options table + seed initial entries
(helpline_number, booking_advance_days, service_due_alert_days)
0.5 Flutter: Save user_id + service_center_id in shared_preferences on login
→ update AuthProvider.loginWithEmail + verifyOtp
0.6 Flutter: Create OptionsProvider — fetch on app start, cache locally
→ replace hardcoded WhatsApp number in HomeScreen
→ replace hardcoded 90 days in CreateBookingScreen

Test after Phase 0: Login → check shared_preferences has user_id + service_center_id. HomeScreen contact button uses number from options table.

---

Phase 1 — Code Quality & Shared Widgets (Do Before Any UI Work)
Fix the technical debt first so every new screen you build uses the clean shared components.

1.1 Extract shared AppDrawer widget → shared/widgets/app_drawer.dart
→ replace \_buildDrawer in HomeScreen + VehiclesScreen
1.2 Fix router.dart — add missing routes:
/service-centers, /vehicles/edit/:vehicleId
1.3 Fix bottom nav AppBottomNavBar index mapping audit
1.4 Build shared VehicleCard widget → shared/widgets/vehicle_card.dart
→ asset image + service status badge + 3-dot options menu
→ accepts optional serviceStatus param (null = no badge)
→ replace card in VehiclesScreen + ServiceScreen

Test after Phase 1: All nav links work. Both screens show identical vehicle cards. No duplicate drawer code.

Phase 2 — Vehicle Flow Fixes (Core User Journey)
2.1 AddVehicleScreen: registration number lookup on blur
→ if exists in DB → show "Already registered" + Send Request button (button wired in Phase 5)
→ if not exists → show remaining fields
2.2 AddVehicleScreen: add chassis_number optional field
2.3 AddVehicleScreen: vehicle type pre-selection via route query param
→ fix Home screen "Add Four-Wheeler" / "Add Two-Wheeler" buttons to pass ?type=car / ?type=bike
2.4 VehiclesScreen: add Edit option to 3-dot menu → route to /vehicles/edit/:vehicleId
→ EditVehicleScreen reuses AddVehicleScreen form pre-filled
2.5 VehiclesScreen: fix Book Service → pass vehicleId as query param
→ /bookings/create?vehicleId=xxx

Test after Phase 2: Add fresh vehicle → works. Add duplicate reg number → shows message. Edit vehicle → pre-filled form. Book Service from vehicle → vehicle pre-selected in booking form.

---

Phase 3 — Booking Flow Fixes
3.1 CreateBookingScreen: accept vehicleId query param → pre-select vehicle dropdown
3.2 CreateBookingScreen: auto-fill service centre from shared_preferences service_center_id
→ remove manual service centre dropdown for mechanic/partner role
3.3 CreateBookingScreen: unify service type list with VehicleServiceModel.serviceTypes
3.4 BookingsScreen: scope fetch by service_center_id (from local storage)
3.5 BookingsScreen: add update booking option on each card
→ update status, service type, date/time, notes
3.6 BookingsScreen: add "Go to Service Form" button on each card
→ route to /service/form/:vehicleId
3.7 BookingCard: show vehicle name (join vehicle data on fetch or add vehicleDisplayName)

Test after Phase 3: Full booking flow — vehicle pre-selected, service centre auto-filled, submit → appears in bookings list scoped to service centre, update status works, jump to service form works.

---

Phase 4 — Service Form & Home Screen Fixes
4.1 ServiceFormScreen: show service centre name + submitted by user name in header
4.2 ServiceFormScreen: unify service types (already done in 3.3, just verify)
4.3 ServiceFormScreen: add Generate Invoice button after cost summary (routes to Phase 6)
4.4 HomeScreen: wire Due Services count from VehicleServiceProvider
4.5 HomeScreen: wire Next Service date from VehicleServiceProvider
4.6 HomeScreen: Service Update section → show latest service record summary
4.7 HomeScreen: "Update Service" button → route to service form for most recent vehicle

Test after Phase 4: Home screen shows real data. Service form shows centre name and user. Invoice button visible (can be placeholder route until Phase 6).

---

Phase 5 — Invoice Feature
5.1 DB: Create invoice table
5.2 Flutter: InvoiceModel in core/models/invoice_model.dart
5.3 Add /invoice/:serviceId route in router.dart
5.4 Build InvoiceScreen — vehicle details, service date, centre name,
itemised list, cost breakdown, footer from options table
5.5 Add Download PDF action (use printing or pdf package)
5.6 Add Share via WhatsApp action (url_launcher with wa.me link)
5.7 Wire Generate Invoice button in ServiceFormScreen → creates invoice record → navigates to InvoiceScreen

Test after Phase 5: Complete a service → tap Generate Invoice → invoice screen shows correct data → share via WhatsApp opens correct link.

---

Phase 6 — Request / Invite System
6.1 DB: Create requests table (schema from need_fix.md)
6.2 Flutter: RequestModel + RequestType + RequestStatus enums
6.3 Flutter: RequestProvider — send, fetch received/sent, accept/reject/cancel
6.4 Add /requests route in router.dart
6.5 Build RequestsScreen — two tabs: Received | Sent
6.6 Build RequestCard widget
6.7 Wire "Send Request to Owner" button in AddVehicleScreen (from Phase 2.1)
6.8 Wire "Request to join service centre" flow
6.9 On accept → update VehicleUserMap or ServiceCenterUserMap
6.10 Add Requests link in AppDrawer with pending count badge

Test after Phase 6: Send vehicle access request → appears in recipient's Received tab → accept → vehicle appears in requester's list. Cancel sent request works.

---

Phase 7 — Notifications
7.1 DB: Create notifications table (schema from need_fix.md)
7.2 Flutter: NotificationModel + NotificationType enum
7.3 Flutter: NotificationProvider — fetch, mark read, mark all read, unread count
7.4 Add /notifications route in router.dart
7.5 Build NotificationsScreen — list with read/unread state, pull-to-refresh
7.6 Wire bell icon on HomeScreen → NotificationsScreen with unread badge
7.7 Implement deep-link navigation on notification tap
(request → RequestsScreen, booking → BookingsScreen, service → ServiceScreen, invoice → InvoiceScreen)
7.8 Trigger notifications from backend on: request sent/accepted/rejected,
booking status change, service complete, invoice ready

## Test after Phase 7: Accept a request → sender gets notification in bell. Tap notification → navigates to correct screen. Bell badge shows correct unread count.

Phase 8 — UI / UX Polish (Last, Not First)
8.1 Service screen: replace date filter dialog with Amazon-style filter bottom sheet
8.2 Brand & Model searchable dropdown in AddVehicleScreen
8.3 Empty state illustrations across all list screens
8.4 Pull-to-refresh on VehiclesScreen + BookingsScreen
8.5 Error handling with retry button on VehiclesScreen + BookingsScreen
8.6 Role-based UI — show/hide features based on user roleId
8.7 Profile screen — edit profile (name, phone, avatar)
8.8 Profile screen — show correct role label for all 5 roles

---

Summary Table
Phase What Depends On
0 Foundation — DB tables + session storage + OptionsProvider nothing
1 Shared widgets + routing fixes Phase 0
2 Vehicle flow fixes Phase 1
3 Booking flow fixes Phase 0, 2
4 Service form + home screen real data Phase 3
5 Invoice Phase 4
6 Requests / Invites Phase 0, 2
7 Notifications Phase 5, 6
8 UI/UX polish All above

One task per message. Never ask for multiple phases in one prompt — that's what caused the previous chat crashes.
