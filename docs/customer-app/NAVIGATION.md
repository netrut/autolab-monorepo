# 🧭 Customer App — Navigation & Routes

---

## Route Map

```
/auth/login              → LoginScreen
/auth/register           → RegisterScreen
/auth/otp?phone=xxx      → OtpScreen
/auth/forgot-password    → ForgotPasswordScreen

/home                    → HomeScreen (default)
/vehicles                → VehiclesScreen (list)
/vehicles/add?type=car   → AddVehicleScreen
/vehicles/edit/:id       → AddVehicleScreen (edit mode)
/vehicles/:id            → VehicleDetailScreen

/bookings                → BookingsScreen (list)
/bookings/create         → CreateBookingScreen
/bookings/:id            → BookingDetailScreen

/service-history         → ServiceHistoryScreen (all vehicles)
/service-history/:vehicleId → ServiceHistoryScreen (filtered)
/service-detail/:serviceId  → ServiceDetailScreen (view only)

/invoices                → InvoicesListScreen
/invoices/:id            → InvoiceDetailScreen

/search                  → SearchServiceCentresScreen
/search/:centreId        → ServiceCentreDetailScreen

/requests                → RequestsScreen
/notifications           → NotificationsScreen
/profile                 → ProfileScreen
/settings                → SettingsScreen
```

---

## Auth Redirect Logic

```dart
redirect: (context, state) {
  final isLoggedIn = authProvider.isLoggedIn;
  final isAuthRoute = state.matchedLocation.startsWith('/auth');

  // Not logged in → force to login (except auth routes)
  if (!isLoggedIn && !isAuthRoute) return '/auth/login';
  
  // Logged in but on auth route → go home
  if (isLoggedIn && isAuthRoute) return '/home';

  // No service centre gateway needed for customers!
  return null;
}
```

---

## Bottom Nav Mapping

| Tab | Route | Screen |
|-----|-------|--------|
| Home | `/home` | HomeScreen |
| Vehicles | `/vehicles` | VehiclesScreen |
| Book | `/bookings` | BookingsScreen |
| Alerts | `/notifications` | NotificationsScreen |

---

## Drawer → Route Mapping

| Menu Item | Route |
|-----------|-------|
| Home | `/home` |
| My Vehicles | `/vehicles` |
| Bookings | `/bookings` |
| Service History | `/service-history` |
| Invoices | `/invoices` |
| Find Service Centre | `/search` |
| Requests | `/requests` |
| Notifications | `/notifications` |
| Profile | `/profile` |
| Settings | `/settings` |

---

## Deep Link Flows

### From Notification → Target Screen
| Notification Type | Navigate To |
|-------------------|-------------|
| `service_due` | `/service-history/:vehicleId` |
| `booking_update` | `/bookings/:id` |
| `request` | `/requests` |
| `invoice` | `/invoices/:id` |
| `system` | `/notifications` |

### From Home Quick Actions
| Action | Navigate To |
|--------|-------------|
| My Vehicles | `/vehicles` |
| Book Service | `/bookings/create` |
| Service History | `/service-history` |
| Invoices | `/invoices` |
| Upcoming "Book Now" | `/bookings/create?vehicleId=xxx&type=oil_change` |
| Recent service tap | `/service-detail/:serviceId` |
| Nearby centre tap | `/search/:centreId` |
