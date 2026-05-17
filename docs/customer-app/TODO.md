# ✅ Customer App — Implementation TODO Checklist

---

## Phase 0: Project Setup ✅
- [x] Create Flutter project at `apps/customer_app/`
- [x] Setup `pubspec.yaml` (same dependencies as flutter-app)
- [x] Copy `assets/` folder (images, fonts, jsons)
- [x] Setup `.env` and `.env.example`
- [x] Create `lib/` folder structure (core, features, shared)
- [x] Setup `analysis_options.yaml`
- [ ] Setup Android config (`android/app/build.gradle` — package name: `com.autolab.customer`)
- [ ] Setup web config (`web/index.html`)
- [x] Create `run.sh` script

---

## Phase 1: Core Layer ✅
- [x] `lib/core/api/api_client.dart` — HTTP client
- [x] `lib/core/models/user_model.dart`
- [x] `lib/core/models/vehicle_model.dart`
- [x] `lib/core/models/booking_model.dart`
- [x] `lib/core/models/vehicle_service_model.dart`
- [x] `lib/core/models/service_item_model.dart`
- [x] `lib/core/models/invoice_model.dart`
- [x] `lib/core/models/service_center_model.dart`
- [x] `lib/core/models/notification_model.dart`
- [x] `lib/core/models/request_model.dart`
- [x] `lib/core/providers/auth_provider.dart`
- [x] `lib/core/providers/vehicle_provider.dart`
- [x] `lib/core/providers/booking_provider.dart`
- [x] `lib/core/providers/vehicle_service_provider.dart`
- [x] `lib/core/providers/notification_provider.dart`
- [x] `lib/core/providers/request_provider.dart`
- [x] `lib/core/providers/options_provider.dart`
- [x] `lib/core/utils/router.dart` — GoRouter setup (customer routes)

---

## Phase 2: Shared Layer ✅
- [x] `lib/shared/theme/app_theme.dart` — Design system compliant
- [x] `lib/shared/widgets/app_button.dart`
- [x] `lib/shared/widgets/app_text_field.dart`
- [x] `lib/shared/widgets/app_drawer.dart` — Customer drawer menu
- [x] `lib/shared/widgets/bottom_nav_bar.dart` — Customer bottom nav (Home, Vehicles, Book, Alerts)
- [ ] `lib/shared/widgets/vehicle_card.dart`
- [x] `lib/shared/widgets/empty_state.dart`
- [x] `lib/shared/widgets/status_badge.dart`
- [ ] `lib/shared/widgets/section_header.dart`

---

## Phase 3: Auth Feature ✅
- [x] `lib/features/auth/screens/login_screen.dart`
- [x] `lib/features/auth/screens/register_screen.dart`
- [x] `lib/features/auth/screens/otp_screen.dart`
- [x] `lib/features/auth/screens/forgot_password_screen.dart`
- [ ] Test: login → home flow
- [ ] Test: register → OTP → home flow
- [ ] Test: forgot password flow

---

## Phase 4: Home Feature ✅
- [x] `lib/features/home/screens/home_screen.dart`
- [x] Greeting section with user name
- [x] Vehicle summary card (active vehicle)
- [x] Quick actions grid (4 icons)
- [x] Upcoming services section
- [x] Recent services section
- [ ] Nearby service centres (horizontal scroll)
- [x] Contact/support card
- [x] Integration: fetch home summary API
- [x] Integration: fetch unread notification count

---

## Phase 5: Vehicles Feature ✅
- [x] `lib/features/vehicles/screens/vehicles_screen.dart` — List
- [x] `lib/features/vehicles/screens/add_vehicle_screen.dart` — Add/Edit
- [x] `lib/features/vehicles/screens/vehicle_detail_screen.dart` — Detail + shared users
- [x] Vehicle card widget with type icon
- [x] Add vehicle form with validation
- [x] Edit vehicle (pre-fill form)
- [x] Delete vehicle with confirmation
- [x] Share vehicle button → send request
- [ ] Show shared vehicles section (vehicles shared with me)

---

## Phase 6: Bookings Feature ✅
- [x] `lib/features/bookings/screens/bookings_screen.dart` — List with tabs
- [x] `lib/features/bookings/screens/create_booking_screen.dart`
- [x] `lib/features/bookings/screens/booking_detail_screen.dart`
- [x] Booking list with status tabs (Upcoming/Completed/Cancelled)
- [x] Create booking form (vehicle selector, centre search, date picker)
- [x] Booking detail with status timeline
- [x] Cancel booking action

---

## Phase 7: Service History Feature ✅
- [x] `lib/features/service_history/screens/service_history_screen.dart` — List
- [x] `lib/features/service_history/screens/service_detail_screen.dart` — View only
- [x] Service history grouped by vehicle
- [ ] Filter by vehicle / date range
- [x] Service detail view (items, costs, next date)
- [x] "View Invoice" button on detail

---

## Phase 8: Invoices Feature ✅
- [x] `lib/features/invoices/screens/invoices_screen.dart` — List
- [x] `lib/features/invoices/screens/invoice_detail_screen.dart` — View + PDF
- [ ] Invoice list with vehicle filter
- [x] Invoice detail view (header, items, totals, footer)
- [x] Download PDF button (using `pdf` + `printing` packages)
- [x] Share invoice button

---

## Phase 9: Search / Discover Service Centres ✅
- [x] `lib/features/search/screens/search_screen.dart`
- [x] `lib/features/search/screens/service_centre_detail_screen.dart`
- [x] Search bar with debounce
- [x] Filter chips (vehicle type, service type)
- [x] Results list with centre cards
- [x] Centre detail (info, services, "Book Service" CTA)
- [x] Maps link integration

---

## Phase 10: Requests Feature ✅
- [x] `lib/features/requests/screens/requests_screen.dart`
- [x] Tabs: Received / Sent
- [x] Accept / Reject actions for received
- [x] Cancel action for sent
- [x] Request card widget

---

## Phase 11: Notifications Feature ✅
- [x] `lib/features/notifications/screens/notifications_screen.dart`
- [x] Notification list (grouped by date)
- [x] Unread highlight
- [x] Tap → navigate to relevant screen
- [x] Mark all read button
- [x] Pull to refresh

---

## Phase 12: Profile Feature ✅
- [x] `lib/features/profile/screens/profile_screen.dart`
- [x] Display user info (avatar, name, phone, email, address)
- [x] Edit mode toggle
- [x] Update profile API integration
- [x] Change password link
- [x] Delete account (danger zone)

---

## Phase 13: Settings Feature ✅
- [x] `lib/features/settings/screens/settings_screen.dart`
- [x] `lib/features/settings/providers/settings_provider.dart`
- [x] Notification toggles (service reminder, booking, parts, requests)
- [x] Reminder days selector
- [ ] Default vehicle type selector
- [ ] Dark mode toggle (future)
- [x] Logout button
- [x] Delete account button

---

## Phase 14: Backend Additions ✅
- [ ] `GET /vehicles/shared` — vehicles shared with current user via VehicleUserMap
- [x] `GET /invoices/my` — all invoices for user's vehicles
- [ ] `GET /service-centers/nearby?lat=x&lng=y` — location-based search (optional)
- [x] Ensure all existing APIs work for customer role (no service centre ownership required)

---

## Phase 15: Polish & Testing
- [ ] Test all navigation flows
- [ ] Test auth token expiry handling
- [ ] Test empty states for all lists
- [ ] Test error states (network failure, API errors)
- [ ] Responsive layout testing (mobile + web)
- [ ] Loading states / shimmer effects
- [x] Pull-to-refresh on all list screens
- [x] Verify PDF generation for invoices
- [ ] Cross-check with partner app for UI consistency

---

## Phase 16: Deployment
- [ ] Android build configuration
- [x] Web deployment config (web/index.html, manifest.json)
- [ ] Update `docker-compose.yml` if needed
- [ ] Update root `README.md` with customer app info
- [ ] Play Store listing preparation

---

## 📋 Implementation Order (Recommended)

```
Phase 0 → Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5
    ↓
Phase 6 → Phase 7 → Phase 8 → Phase 9 → Phase 10
    ↓
Phase 11 → Phase 12 → Phase 13 → Phase 14 → Phase 15 → Phase 16
```

**Estimated screens:** ~20 screens  
**Estimated files:** ~50 dart files  
**Reusable from flutter-app:** ~60% (models, API client, theme, auth logic)
