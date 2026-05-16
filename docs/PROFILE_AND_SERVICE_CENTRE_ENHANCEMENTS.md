# Profile & Service Centre Enhancements

Features that belong in Profile and Service Centre screens (not Settings).

---

## 1. Profile Screen Enhancements

**File:** `lib/features/profile/screens/profile_screen.dart`

### Current State
- Displays user info (name, email, phone, avatar)
- Edit profile fields

### Additions

#### A. Change Password

- Show only for email-registered users (not OTP-only users)
- Fields: Current Password, New Password, Confirm Password
- Backend: `PUT /api/auth/change-password`

```typescript
// authController.ts
export const changePassword = async (req, res) => {
  const { current_password, new_password } = req.body;
  const user = await prisma.user.findUnique({ where: { id: req.user.id } });
  if (!user?.password_hash) return res.status(400).json({ error: 'No password set' });
  const valid = await bcrypt.compare(current_password, user.password_hash);
  if (!valid) return res.status(400).json({ error: 'Current password is incorrect' });
  const hash = await bcrypt.hash(new_password, 10);
  await prisma.user.update({ where: { id: req.user.id }, data: { password_hash: hash } });
  res.json({ message: 'Password updated' });
};
```

**UI placement:** Section at bottom of profile, before Delete Account.

---

#### B. Delete Account

- Danger zone section (red text, bottom of profile)
- Flow:
  1. Tap "Delete Account"
  2. Confirmation dialog: "This will permanently delete your account and all data. This cannot be undone."
  3. Require password entry (or OTP for phone-only users) to confirm
  4. Backend soft-deletes: sets `is_active = false`, clears personal data after 30 days via cron
- Backend: `DELETE /api/auth/account`

```typescript
// authController.ts
export const deleteAccount = async (req, res) => {
  const { password } = req.body;
  const user = await prisma.user.findUnique({ where: { id: req.user.id } });
  if (user?.password_hash) {
    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) return res.status(400).json({ error: 'Incorrect password' });
  }
  // Soft delete — mark inactive, cron purges after 30 days
  await prisma.user.update({
    where: { id: req.user.id },
    data: { is_active: false, updated_at: new Date() },
  });
  res.json({ message: 'Account scheduled for deletion' });
};
```

**UI placement:** Very bottom of profile screen, separated by divider, red styling.

---

### Revised Profile Screen Layout

```
┌─────────────────────────────────────┐
│  ← Profile                          │
├─────────────────────────────────────┤
│  [Avatar]                           │
│  Name                               │
│  Email                              │
│  Phone                              │
│  [Save Changes]                     │
│                                     │
│  ── SECURITY ──────────────────     │
│  │ Change Password         →   │    │  (email users only)
│                                     │
│  ── DANGER ZONE ───────────────     │
│  │ 🗑 Delete Account       →   │    │  (red, confirmation flow)
└─────────────────────────────────────┘
```

---

## 2. Service Centre Enhancements

**Files:**
- `lib/features/service_centers/screens/service_centers_screen.dart`
- `lib/features/service_centers/screens/add_service_center_screen.dart` (edit mode)

---

### A. Invoice Template Customization

**Why here:** Invoice templates are per-centre (different branding/GST/address per centre). Only owners should configure this.

**Where:** Inside the Service Centre edit screen (`add_service_center_screen.dart` in edit mode) as a section, OR a separate sub-screen accessible from the centre card.

**Approach:** Add an "Invoice Settings" section in the edit centre form:

```
┌─ Edit Service Centre ──────────────┐
│  Name: [...]                        │
│  Address: [...]                     │
│  Phone: [...]                       │
│  GST Number: [...]                  │
│                                     │
│  ── INVOICE SETTINGS ──────────     │
│  │ Business Name (on invoice)  │    │
│  │ Logo URL                    │    │
│  │ Footer Text                 │    │
│  │ GST %                       │    │
│  │ Terms & Conditions          │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

**Database:** Add fields to `ServiceCenterDetails` model (already exists for extended centre info):

```prisma
// Add to ServiceCenterDetails
invoice_business_name  String?  @db.VarChar(255)
invoice_logo_url       String?  @db.VarChar(500)
invoice_footer         String?
invoice_gst_percent    Decimal? @db.Decimal(5, 2)
invoice_terms          String?
```

**Access:** Owner-only (check role before showing section).

---

### B. Team / Members Screen

**Why here:** Members are per-centre (`service_center_user_map`), so they belong in the service centre context.

**Where:** A "Team" button on each service centre card (visible to owners), navigating to a members sub-screen.

**Route:** `/service-centers/:id/members`

**UI on Service Centres Screen:**

```
┌─ Service Centre Card ──────────────┐
│  🏪 AutoLab Pune                    │
│  Owner • Pune                       │
│  ┌──────┐ ┌──────┐ ┌──────┐       │
│  │ Edit │ │ Team │ │ ...  │       │  (owner-only actions)
│  └──────┘ └──────┘ └──────┘       │
└─────────────────────────────────────┘
```

**Team/Members Screen Layout:**

```
┌─────────────────────────────────────┐
│  ← Team • AutoLab Pune             │
├─────────────────────────────────────┤
│  [Invite Member]                    │
│                                     │
│  ┌─ Member Card ──────────────┐    │
│  │ 👤 John Doe                │    │
│  │    Mechanic • Joined 3mo   │    │
│  │    [Change Role] [Remove]  │    │  (owner-only)
│  └─────────────────────────────┘    │
│                                     │
│  ┌─ Member Card ──────────────┐    │
│  │ 👤 Jane Smith              │    │
│  │    Partner • Joined 1yr    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

**Backend endpoints:**

| Method | Route | Description |
|--------|-------|-------------|
| GET | `/api/service-centers/:id/members` | List members of a centre |
| PUT | `/api/service-centers/:id/members/:userId` | Update member role |
| DELETE | `/api/service-centers/:id/members/:userId` | Remove member |

**Access:** Owner can manage all. Members can view list only.

---

## Implementation Priority

| # | Feature | Effort | Priority |
|---|---------|--------|----------|
| 1 | Change Password | Low | High (security basic) |
| 2 | Delete Account | Medium | High (compliance/legal) |
| 3 | Team/Members | Medium | High (core workflow) |
| 4 | Invoice Template | Medium | Medium (after service form is done) |

---

## Summary

| Feature | Screen | Reason |
|---------|--------|--------|
| Change Password | Profile | Identity action |
| Delete Account | Profile | Destructive account action |
| Invoice Template | Service Centre Edit | Per-centre, owner-only |
| Team/Members | Service Centre Card → Sub-screen | Per-centre, uses `service_center_user_map` |
