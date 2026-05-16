# Request & Notification System

**Status:** ✅ Complete

---

## Architecture

```
Flutter App → HTTP + JWT → Backend API → PostgreSQL (Supabase)
                                      → NotificationService (auto-triggers)
```

---

## Request System

### Purpose
Allows users to send/receive access requests (vehicle access, service centre join, invites).

### Request Types
| Type | Description |
|------|-------------|
| `vehicle_access` | Request access to manage someone's vehicle |
| `service_center_join` | Request to join a service centre team |
| `customer_invite` | Invite a customer to the platform |
| `partner_invite` | Invite a partner/mechanic |

### Request Statuses
`pending` → `accepted` / `rejected` / `cancelled`

### Backend API — `/api/requests`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | Send a new request |
| GET | `/received` | List requests received by current user |
| GET | `/sent` | List requests sent by current user |
| GET | `/pending-count` | Get count of pending received requests |
| PUT | `/:id/accept` | Accept a request |
| PUT | `/:id/reject` | Reject a request |
| PUT | `/:id/cancel` | Cancel a sent request |

### Flutter Files
- Model: `lib/core/models/request_model.dart`
- Provider: `lib/core/providers/request_provider.dart`
- Screen: `lib/features/requests/screens/requests_screen.dart`
- Route: `/requests`

### Screen Features
- Tab view: Received / Sent
- Each card shows: type, from/to user, status badge, message, date
- Actions: Accept/Reject (received pending), Cancel (sent pending)
- Pull to refresh

---

## Notification System

### Purpose
In-app notifications triggered by system events (requests, service due, bookings, invoices).

### Notification Types
| Type | Icon | Navigates To |
|------|------|-------------|
| `request` | swap_horiz | `/requests` |
| `service_due` | build | `/service/detail/:entityId` or `/services` |
| `booking_update` | calendar | `/bookings` |
| `service_complete` | check_circle | `/service/detail/:entityId` or `/services` |
| `invoice` | receipt_long | `/invoice/:entityId` |
| `system` | info | No navigation |

### Backend API — `/api/notifications`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | List all notifications for current user |
| GET | `/unread-count` | Get unread notification count |
| PUT | `/read-all` | Mark all notifications as read |
| PUT | `/:id/read` | Mark single notification as read |

### Notification Service (Backend)
File: `apps/backend/src/services/notificationService.ts`

Auto-creates notifications when:
- A request is sent (notifies recipient)
- A request is accepted/rejected (notifies sender)
- Service is due (scheduled/triggered)
- Service is completed
- Invoice is generated
- Booking status changes

### Flutter Files
- Model: `lib/core/models/notification_model.dart`
- Provider: `lib/core/providers/notification_provider.dart`
- Screen: `lib/features/notifications/screens/notifications_screen.dart`
- Route: `/notifications`

### Screen Features
- List view with unread highlight (blue background)
- "Mark all read" button in app bar
- Each tile: icon (color-coded by type), title, body, time ago
- Tap → deep-link navigation based on type + entityId
- Unread dot indicator
- Pull to refresh
- Empty state

---

## Data Models

### NotificationModel
```dart
id, userId, type, title, body, requestId?, entityType?, entityId?,
isRead, channel, sentAt?, readAt?
```

### RequestModel
```dart
id, type, fromUserId, toUserId?, entityType, entityId, role,
status, message?, createdAt?, updatedAt?, fromUser?, toUser?
```

---

## Integration Points

1. **Bottom Nav Badge** — unread notification count shown on bell icon
2. **Request → Notification** — accepting/rejecting triggers notification to other party
3. **Service → Notification** — service due/complete triggers notification
4. **Deep Linking** — notification tap navigates to relevant screen

---

## File Structure

```
apps/flutter-app/lib/
├── core/
│   ├── models/
│   │   ├── notification_model.dart
│   │   └── request_model.dart
│   └── providers/
│       ├── notification_provider.dart
│       └── request_provider.dart
├── features/
│   ├── notifications/screens/notifications_screen.dart
│   └── requests/screens/requests_screen.dart

apps/backend/src/
├── controllers/
│   ├── notificationController.ts
│   └── requestController.ts
├── routes/
│   ├── notifications.routes.ts
│   └── requests.routes.ts
└── services/
    └── notificationService.ts
```

---

*Last updated: May 2026*
