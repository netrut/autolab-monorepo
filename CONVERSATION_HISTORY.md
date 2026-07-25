# Autolab Monorepo - Conversation History

---

## Issues Fixed

### 1. HTTP 404 on Codespace URL
- Both servers (port 3002 backend, 8080 Flutter) were running fine locally (200 OK)
- 404 was from GitHub Codespaces tunnel proxy requiring browser session/cookie
- **Fix**: Use Ports tab → Open in Browser, or set ports to Public

### 2. OTP Login 404 Error
- `verifyOTP` backend was calling `bcryptjs.hash(password, 10)` unconditionally — crashed when `password` was undefined (existing user login sends only phone+otp)
- **Fix**: Moved hash inside `if (!user)` block. Also fixed response field names (`name`→`display_name`, `phone`→`phone_number`) to match `UserModel.fromJson`

### 3. Duplicate Account + Wrong role_id on OTP Login
- `verifyOTP` was creating new users when phone not found (format mismatch `9876543210` vs `+919876543210`)
- **Fix**: `verifyOTP` now only logs in existing users, returns 404 if not found. `sendOTP` also checks phone existence before sending

### 4. Phone Not Found Dialog
- Replaced generic DioException snackbar with proper dialog
- Fixed stale `auth` reference by reading provider after await
- `sendOTP` backend now checks phone existence first, returning 404 immediately

### 5. DioException Raw Error Message
- **Fix**: `_parseError` reads from `e.response?.data` map directly instead of calling `.toString()` on the exception

### 6. Registration Flow Fixes
- Added `+91` prefix to phone fields in both apps' register screens
- Fixed `login` response field names
- Added `role_id: 2` (flutter-app) and `role_id: 3` (customer_app) hardcoded in register calls

### 7. Wrong-App Login Detection
- Added `_wrongApp` flag to both apps' `AuthProvider`
- Email login checks `role_id` before saving token
- `verifyOtp` checks role before saving token
- Shows appropriate dialog for wrong-role users

### 8. Flutter Compile Error
- Missing `}` closing the `else` block in `_submit()` of flutter-app `login_screen.dart` caused all subsequent classes to appear nested
- Also removed non-existent `auth.lastAttemptedUser` reference

### 9. Phone OTP Wrong-App Dialog Not Showing (Most Recent)
- `sendOtp` never checked role. A customer (role 3) with a registered phone would pass `sendOTP` successfully → navigate to OTP screen → only `verifyOtp` would catch wrong role. Dialog never showed during phone login flow.
- **Fix**:
  1. Backend `sendOTP` (`authController.ts`): Added `role_id: user.role_id` to success response
  2. flutter-app `sendOtp` (`auth_provider.dart`): Reads `role_id` from response; if `== 3` sets `_wrongApp = true`, returns false
  3. customer_app `sendOtp` (`auth_provider.dart`): Same pattern, checks `role_id == 2`
  4. flutter-app `login_screen.dart`: Added `wrongApp` dialog check in `sendOtp` failure path alongside existing `phoneNotFound` check

---

## Files Modified

### `apps/backend/src/controllers/authController.ts`
- `sendOTP`: checks phone existence, returns 404 if not found; returns `role_id` in success response `{ message, role_id }`
- `verifyOTP`: only logs in existing users (no user creation); returns 404 if phone not found; response uses `display_name`, `phone_number`, `role_id`, `is_active`
- `login`: response fixed to use `display_name`, `phone_number`, `role_id`, `is_active`
- `register`: accepts `role_id` from request body, uses `normalizeRoleId` defaulting to 3

### `apps/flutter-app/lib/core/providers/auth_provider.dart`
- Flags: `_emailNotVerified`, `_phoneNotFound`, `_wrongApp`
- `register()`: hardcodes `role_id: 2`
- `loginWithEmail()`: checks `user.roleId == 3` sets `_wrongApp`, returns false without saving token
- `sendOtp()`: checks `role_id == 3` from response sets `_wrongApp`; checks 404 sets `_phoneNotFound`
- `verifyOtp()`: checks `user.roleId == 3` sets `_wrongApp`; simplified params (only phone+otp)
- `_parseError()`: reads from `e.response?.data` map directly

### `apps/flutter-app/lib/features/auth/screens/login_screen.dart`
- `_submit()`: wrongApp dialog check added for both email and phone paths; missing `}` was fixed
- Added `_WrongAppDialog`, `_PhoneNotFoundDialog` widgets at bottom
- `_WrongAppDialog`: no `user` parameter, `const` constructor

### `apps/flutter-app/lib/features/auth/screens/otp_screen.dart`
- `_verify()`: reads auth after await; checks `phoneNotFound` then `wrongApp` then snackbar
- Added `_WrongAppDialog`, `_PhoneNotFoundDialog` widgets at bottom

### `apps/flutter-app/lib/features/auth/screens/register_screen.dart`
- Phone field has `prefixText: '+91 '`
- Submits `'+91${_phoneCtrl.text.trim()}'`

### `apps/customer_app/lib/core/providers/auth_provider.dart`
- Same pattern as flutter-app but checks `role_id == 2` for wrong-app
- `register()`: hardcodes `role_id: 3`
- `sendOtp()`: checks `role_id == 2` from response
- `verifyOtp()`: checks `user.roleId == 2`; simplified params

### `apps/customer_app/lib/features/auth/screens/login_screen.dart`
- Phone field has `prefixText: '+91 '`; `+91` prepended on submit
- wrongApp and phoneNotFound dialog checks added
- Added `_WrongAppDialog` (store icon, blue), `_PhoneNotFoundDialog` widgets

### `apps/customer_app/lib/features/auth/screens/register_screen.dart`
- Phone field has `prefixText: '+91 '`; submits with `+91` prefix

### `apps/customer_app/lib/features/auth/screens/otp_screen.dart`
- `_verify()`: reads auth after await; checks wrongApp and phoneNotFound
- Added `_WrongAppDialog`, `_PhoneNotFoundDialog` widgets

---

## Key Insights

| Topic | Detail |
|-------|--------|
| Monorepo structure | `/workspaces/autolab-monorepo/apps/` contains `backend/`, `flutter-app/`, `customer_app/`, `dashboard/`, `website/` |
| Role IDs | 1=Admin, 2=Partner/ServiceCentreOwner, 3=Customer, 4=Mechanic, 5=Driver |
| Phone format | All phone numbers stored and transmitted as `+91XXXXXXXXXX` (10 digits with +91 prefix) |
| UserModel.fromJson keys | expects `id`, `email`, `display_name`, `phone_number`, `role_id`, `is_active` |
| OTP store | In-memory `Map` in backend (not Redis) — OTPs lost on server restart |
| Auth pattern | Both apps use same backend. Wrong-app detection is client-side by checking `role_id` in login/OTP responses |
| Dialog style | flutter-app uses hardcoded colors (`0xFF1B1F26`, `0xFF7A7A7A`); customer_app uses `AppTheme` constants |
| README note | "do not change anything other than this requirement and do it with minimum code change" |

---

## App Purpose

AUTOLAB provides a centralized digital vehicle service history and reminder system for both customers and service centres.

### Customers (role_id: 3) — `customer_app`
- Track vehicle service history
- See due & upcoming services
- Maintain oil change details, parts replaced, etc.
- Receive reminders
- Add four-wheeler and two-wheeler

### Service Centres / Partners (role_id: 2) — `flutter-app`
- Search vehicle by number
- Update service details
- Mark parts replaced
- Enter oil & service details
- Set next service date
- Notify customer

---

## Useful Commands

```bash
# Kill backend
lsof -ti:3002 | xargs kill -9 2>/dev/null

# Start backend
cd apps/backend && npm run dev

# Start flutter-app (partner)
cd apps/flutter-app && ./run.sh

# Start customer_app
cd apps/customer_app && ./run.sh

# Check today's changed files
git diff --name-only HEAD | xargs -I{} stat -c "%y {}" {} | grep "^$(date +%Y-%m-%d)" | awk '{print $NF}'
```
