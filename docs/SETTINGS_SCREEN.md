# Settings Screen Specification

## Overview

A Settings screen accessible from the app drawer, serving as a hub for user preferences (notification toggles, app behavior) and quick navigation shortcuts. Stored in a `user_preferences` table.

---

## Database: `user_preferences` Table

```prisma
model UserPreference {
  id                      String   @id @default(uuid())
  user_id                 String   @unique
  // Notification preferences
  notify_service_reminder Boolean  @default(true)
  notify_booking_updates  Boolean  @default(true)
  notify_parts_expiry     Boolean  @default(true)
  notify_join_requests    Boolean  @default(true)
  reminder_days_before    Int      @default(7) // 1, 3, 5, 7, 14
  // App preferences
  default_vehicle_type    String?  @db.VarChar(20) // "car" | "bike" | null (all)
  dark_mode               Boolean  @default(false)
  created_at              DateTime @default(now()) @db.Timestamp(6)
  updated_at              DateTime @default(now()) @updatedAt @db.Timestamp(6)

  user User @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@map("user_preferences")
}
```

**Separation of concerns:**
- `options` → global app config (admin-managed)
- `user_preferences` → personal settings (this table)
- `service_center_permissions` → per-centre staff access (future)

---

## Backend API

### Endpoints

| Method | Route | Description |
|--------|-------|-------------|
| GET | `/api/user-preferences` | Get preferences (auto-create defaults if first time) |
| PUT | `/api/user-preferences` | Partial update (only send changed fields) |

### Controller: `userPreferencesController.ts`

```typescript
export const getPreferences = async (req, res) => {
  const userId = req.user.id;
  let prefs = await prisma.userPreference.findUnique({ where: { user_id: userId } });
  if (!prefs) {
    prefs = await prisma.userPreference.create({ data: { user_id: userId } });
  }
  res.json(prefs);
};

export const updatePreferences = async (req, res) => {
  const userId = req.user.id;
  const prefs = await prisma.userPreference.upsert({
    where: { user_id: userId },
    update: { ...req.body, updated_at: new Date() },
    create: { user_id: userId, ...req.body },
  });
  res.json(prefs);
};
```

### Route: `userPreferences.routes.ts`

```typescript
router.get('/', authMiddleware, getPreferences);
router.put('/', authMiddleware, updatePreferences);
```

---

## Flutter Implementation

### File Structure

```
lib/features/settings/
├── screens/
│   └── settings_screen.dart
└── providers/
    └── settings_provider.dart
```

### Route

```dart
GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
```

### Drawer Entry (add before Profile item in `app_drawer.dart`)

```dart
_item(context, Icons.settings_outlined, 'Settings', () => context.push('/settings')),
```

---

## Screen Layout

```
┌─────────────────────────────────────┐
│  Settings                           │
├─────────────────────────────────────┤
│  ┌─ Profile Card ─────────────┐    │
│  │ 👤 Name / Email        →   │    │  → navigates to /profile
│  └─────────────────────────────┘    │
│                                     │
│  ┌─ Active Service Centre ────┐    │
│  │ 🏪 Centre Name    [Switch] │    │  → switch sheet
│  │     Edit Centre (if owner) │    │  → navigate to edit
│  └─────────────────────────────┘    │
│                                     │
│  NOTIFICATIONS                      │
│  │ Service Reminders      [✓]  │    │
│  │ Booking Updates        [✓]  │    │
│  │ Parts Expiry Alerts    [✓]  │    │
│  │ Join Requests          [✓]  │    │
│  │ Reminder Interval       ▼   │    │  → 1/3/5/7/14 days dropdown
│                                     │
│  PREFERENCES                        │
│  │ Default Vehicle Type    ▼   │    │  → car/bike/all
│  │ Dark Mode              [ ]  │    │
│                                     │
│  SUPPORT                            │
│  │ Help & Support          →   │    │  → opens email/link
│                                     │
│  ──────────────────────────────     │
│  │ Logout                  →   │    │  → confirmation dialog
│                                     │
│  App Version 1.0.0                  │
└─────────────────────────────────────┘
```

---

## SettingsProvider

```dart
class SettingsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  Map<String, dynamic> _prefs = {};
  bool _loading = false;

  bool get loading => _loading;
  bool get notifyServiceReminder => _prefs['notify_service_reminder'] ?? true;
  bool get notifyBookingUpdates => _prefs['notify_booking_updates'] ?? true;
  bool get notifyPartsExpiry => _prefs['notify_parts_expiry'] ?? true;
  bool get notifyJoinRequests => _prefs['notify_join_requests'] ?? true;
  int get reminderDaysBefore => _prefs['reminder_days_before'] ?? 7;
  String? get defaultVehicleType => _prefs['default_vehicle_type'];
  bool get darkMode => _prefs['dark_mode'] ?? false;

  Future<void> fetch() async { /* GET /api/user-preferences */ }
  Future<void> update(Map<String, dynamic> changes) async { /* PUT /api/user-preferences */ }
}
```

---

## What Does NOT Belong Here

| Feature | Belongs In | Reason |
|---------|-----------|--------|
| Change Password | Profile screen | Identity/account action |
| Delete Account | Profile screen | Destructive account action |
| Invoice Template | Service Centre (edit/detail) | Per-centre, owner-only |
| Team/Members | Service Centre card/screen | Per-centre, uses `service_center_user_map` |

See `PROFILE_AND_SERVICE_CENTRE_ENHANCEMENTS.md` for these features.

---

## Implementation Order

1. Prisma migration — add `UserPreference` model
2. Backend — controller + route + register
3. Flutter — `SettingsProvider` with fetch/update
4. Flutter — `SettingsScreen` UI
5. Router + Drawer — add `/settings` route and drawer item
6. Wire notifications — backend checks preferences before sending

---

## Key Decisions

- **Upsert pattern**: GET auto-creates defaults on first access, no onboarding needed.
- **Partial updates**: PUT accepts only changed fields.
- **Notification gating**: Backend checks `user_preferences` before inserting into `Notification` table.
- **Dark mode**: Stored here, applied via `ThemeMode` in `MaterialApp`.
- **Reminder interval**: Used by backend cron/scheduler to determine when to send service reminders.
- **No currency field for now**: Operating in ₹ only. Add when multi-country is needed.
