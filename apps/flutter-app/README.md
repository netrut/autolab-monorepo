# 📱 AutoLab Flutter App

Mobile app for AutoLab - Vehicle Service Management.

## 🏗️ Architecture

```
lib/
├── core/
│   ├── api/
│   │   └── api_client.dart        ← Dio HTTP client + JWT interceptor
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── booking_model.dart
│   │   └── service_center_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart     ← Login, register, OTP, logout
│   │   ├── vehicle_provider.dart  ← Vehicle CRUD
│   │   └── booking_provider.dart  ← Booking CRUD
│   └── utils/
│       └── router.dart            ← go_router with auth guard
├── features/
│   ├── auth/screens/              ← Login, Register, OTP, ForgotPassword
│   ├── home/screens/              ← Home dashboard
│   ├── vehicles/screens/          ← Vehicle list + add
│   ├── bookings/screens/          ← Booking list + create
│   ├── profile/screens/           ← User profile
│   └── service_centers/screens/   ← Service center list
├── shared/
│   ├── theme/app_theme.dart       ← Colors, typography
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── bottom_nav_bar.dart
└── main.dart
```

## 🚀 Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure API URL

Edit `lib/core/api/api_client.dart`:

```dart
// For Android emulator → localhost
defaultValue: 'http://10.0.2.2:3000'

// For physical device → your machine IP
defaultValue: 'http://192.168.x.x:3000'

// For production
defaultValue: 'https://your-api.vercel.app'
```

Or pass at build time:

```bash
flutter run --dart-define=API_URL=https://autolab-api.vercel.app
```

### 3. Run the app

```bash
# Start backend first
cd ../backend && npm run dev

# Run Flutter app
flutter run
```

## 🔌 API Endpoints Used

| Feature         | Endpoint                            |
| --------------- | ----------------------------------- |
| Login           | `POST /api/auth/login`              |
| Register        | `POST /api/auth/register`           |
| Send OTP        | `POST /api/auth/send-otp`           |
| Verify OTP      | `POST /api/auth/verify-otp`         |
| Forgot Password | `POST /api/auth/forgot-password`    |
| Profile         | `GET /api/users/profile`            |
| Vehicles        | `GET/POST/PUT/DELETE /api/vehicles` |
| Bookings        | `GET/POST/DELETE /api/bookings`     |
| Service Centers | `GET /api/service-centers`          |

## 📦 Key Dependencies

| Package              | Purpose                     |
| -------------------- | --------------------------- |
| `dio`                | HTTP client                 |
| `provider`           | State management            |
| `go_router`          | Navigation                  |
| `shared_preferences` | JWT token storage           |
| `google_fonts`       | Poppins / Inter Tight fonts |
| `intl`               | Date formatting             |
| `url_launcher`       | Phone calls / WhatsApp      |

## 🔐 Auth Flow

```
App Start
  └─ AuthProvider.init()
       ├─ No token → /auth/login
       └─ Has token → GET /api/users/profile
            ├─ Success → /home
            └─ 401 → clear token → /auth/login
```

## 🎨 Design System

Colors from old app preserved:

- Primary: `#1B1F26` (near-black)
- Background: `#F3F3F3`
- Surface: `#FFFFFF`
- Error: `#FF5963`
- Success: `#249689`

Fonts: Poppins (body) + Inter Tight (headings)

# run app

cd apps/flutter-app

# Run on web (open port 8080 in browser / Ports tab)

bash run.sh

# Build debug APK for Android testing

bash run.sh build-debug

# Build release APK

bash run.sh build

# To build build/web for deployment, run this single command:

cd /workspaces/autolab-monorepo/apps/flutter-app && \
export PATH="$PATH:/home/node/flutter-sdk/flutter/bin" && \
flutter build web --release \
 --dart-define=API_URL=https://autolab-api.vercel.app

## GitHub commit/push to deploye on verce

cd /workspaces/autolab-monorepo/apps/flutter-app
git add -f build/web
git commit -m "Add Flutter web build for Vercel deployment3"
git push
