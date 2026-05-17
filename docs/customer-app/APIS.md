# 🔌 Customer App — API Documentation

> Base URL: Same backend (`apps/backend/`) — all APIs are role-aware  
> Auth: JWT Bearer token in `Authorization` header

---

## 1. Authentication APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/auth/register` | Register new customer |
| POST | `/auth/login` | Login with email/phone + password |
| POST | `/auth/send-otp` | Send OTP to phone |
| POST | `/auth/verify-otp` | Verify OTP & get token |
| POST | `/auth/forgot-password` | Request password reset |
| POST | `/auth/reset-password` | Reset password with token |
| PUT | `/auth/change-password` | Change password (authenticated) |
| DELETE | `/auth/account` | Delete account |

---

## 2. User / Profile APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/users/me` | Get current user profile |
| PUT | `/users/me` | Update profile (name, avatar, address, bio) |

---

## 3. Vehicle APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/vehicles` | List my vehicles |
| GET | `/vehicles/:id` | Get vehicle detail |
| POST | `/vehicles` | Add new vehicle |
| PUT | `/vehicles/:id` | Update vehicle |
| DELETE | `/vehicles/:id` | Delete vehicle |
| GET | `/vehicles/lookup?reg=XX00XX0000` | Lookup vehicle by registration |

---

## 4. Booking APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/bookings` | List my bookings |
| GET | `/bookings/:id` | Get booking detail |
| POST | `/bookings` | Create new booking |
| PUT | `/bookings/:id` | Update booking |
| DELETE | `/bookings/:id` | Cancel booking |

---

## 5. Service History APIs (Vehicle Services)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/vehicle-services?vehicleId=xxx` | List services for a vehicle |
| GET | `/vehicle-services/:id` | Get service detail with items |
| GET | `/vehicle-services/home-summary` | Home screen summary (due count, next date, latest) |

> **Note:** Customer can view services but cannot generate invoices. Service form submission is optional for personal tracking.

---

## 6. Invoice APIs (View Only)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/invoices/service/:serviceId` | Get invoice for a service |
| GET | `/invoices/:id` | Get invoice by ID |

> Customer does NOT call `POST /invoices` — only service centres generate invoices.

---

## 7. Service Centre APIs (Browse/Search)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/service-centers` | List/search service centres |
| GET | `/service-centers/:id` | Get centre detail |

**Query params for search:**
- `?search=name` — text search
- `?city=Mumbai` — filter by city
- `?vehicleTypes=car,bike` — filter by vehicle type
- `?serviceTypes=general,oil_change` — filter by service type

---

## 8. Request APIs (Vehicle Sharing & Invitations)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/requests` | Send vehicle access request |
| GET | `/requests/received` | List received requests |
| GET | `/requests/sent` | List sent requests |
| GET | `/requests/pending-count` | Get pending request count |
| PUT | `/requests/:id/accept` | Accept a request |
| PUT | `/requests/:id/reject` | Reject a request |
| PUT | `/requests/:id/cancel` | Cancel sent request |

**Request body for sending:**
```json
{
  "type": "vehicle_access",
  "entity_type": "vehicle",
  "entity_id": "<vehicle_id>",
  "to_user_id": "<target_user_id>",
  "role": "viewer",
  "message": "Please share access to your vehicle"
}
```

---

## 9. Notification APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/notifications` | List all notifications |
| GET | `/notifications/unread-count` | Get unread badge count |
| PUT | `/notifications/read-all` | Mark all as read |
| PUT | `/notifications/:id/read` | Mark single as read |

---

## 10. User Preferences APIs (Settings)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/user-preferences` | Get current preferences |
| PUT | `/user-preferences` | Update preferences |

**Preference fields:**
```json
{
  "notify_service_reminder": true,
  "notify_booking_updates": true,
  "notify_parts_expiry": true,
  "notify_join_requests": true,
  "reminder_days_before": 7,
  "default_vehicle_type": "car",
  "dark_mode": false
}
```

---

## 11. Options API

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/options` | Get app config (helpline number, WhatsApp link, etc.) |

---

## 🆕 New APIs Needed for Customer App

These APIs may need to be added to the backend:

| # | Endpoint | Purpose | Priority |
|---|----------|---------|----------|
| 1 | `GET /vehicles/shared` | List vehicles shared with me | High |
| 2 | `GET /service-centers/nearby?lat=x&lng=y` | Nearby centres by location | Medium |
| 3 | `GET /invoices/my` | List all invoices for my vehicles | High |
| 4 | `POST /vehicle-services` (limited) | Customer self-service form (no invoice) | Low |

---

## 🔐 Auth Flow

```
1. Customer opens app
2. Check SharedPreferences for JWT token
3. If token exists → validate → go to Home
4. If no token → show Login screen
5. After login/register → save token → navigate to Home
6. No service centre gateway (unlike partner app)
```
